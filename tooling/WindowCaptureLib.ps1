<#
  Occlusion-proof window capture, shared by Capture-Window.ps1 and
  Capture-EditorWindows.ps1.

  PrintWindow asks a window to render itself into a device context, so the result is
  that window's content whatever is stacked on top of it. PW_RENDERFULLCONTENT is what
  makes it work for DWM-composited and hardware-accelerated surfaces; without it,
  GPU-rendered content comes back black.

  Nothing here reads the screen. That is deliberate: reading screen pixels captures
  whatever happens to be in front, which on a machine in use means unrelated windows
  and possibly their contents.

  DPI AWARENESS IS LOAD-BEARING HERE, and getting it wrong is silent.

  PowerShell is DPI-unaware by default, so Windows lies to it: GetWindowRect returns
  LOGICAL points (physical divided by the display scale) while PrintWindow renders the
  window at its true PHYSICAL pixel size. Capture() sizes its bitmap from GetWindowRect,
  so on a 150% display a 940-point window produced a 953-pixel bitmap holding the
  top-left ~646 points of a window that had rendered 1410 pixels wide. The right-hand
  and bottom thirds were rendered by Unity and thrown away.

  That shipped eight cropped screenshots to two documentation sites without one
  failure, because a cropped window is not a broken image: it is a plausible-looking
  window that is simply missing its right-hand side, and the only check in place --
  ContentRatio -- scores a crop as perfectly healthy.

  Enable-CaptureDpiAwareness is therefore called at dot-source time, before any window
  is measured. Once the process is per-monitor aware, GetWindowRect returns physical
  pixels, the bitmap matches what PrintWindow draws, and no scaling guesswork is needed.
#>

Add-Type -AssemblyName System.Drawing

if (-not ('DocsDpiAwareness' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class DocsDpiAwareness
{
    // Windows 10 1703+. -4 is DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2.
    [DllImport("user32.dll", SetLastError = true)]
    private static extern bool SetProcessDpiAwarenessContext(IntPtr context);

    // Windows 8.1+. 2 is PROCESS_PER_MONITOR_DPI_AWARE.
    [DllImport("shcore.dll")]
    private static extern int SetProcessDpiAwareness(int value);

    // Vista+. System-aware only, but better than virtualised.
    [DllImport("user32.dll")]
    private static extern bool SetProcessDPIAware();

    [DllImport("user32.dll")]
    private static extern IntPtr GetThreadDpiAwarenessContext();

    [DllImport("user32.dll")]
    private static extern int GetAwarenessFromDpiAwarenessContext(IntPtr context);

    /// Opts the process out of DPI virtualisation, newest API first. Returns the
    /// awareness actually in force afterwards so a caller can report it rather than
    /// assume it: on a host that is already marked aware by its manifest these calls
    /// fail with ACCESS_DENIED, which is harmless but must not be mistaken for success.
    public static string Enable()
    {
        try { if (SetProcessDpiAwarenessContext(new IntPtr(-4))) return Describe(); } catch { }
        try { if (SetProcessDpiAwareness(2) == 0) return Describe(); } catch { }
        try { SetProcessDPIAware(); } catch { }
        return Describe();
    }

    public static string Describe()
    {
        try
        {
            switch (GetAwarenessFromDpiAwarenessContext(GetThreadDpiAwarenessContext()))
            {
                case 0: return "UNAWARE";
                case 1: return "SYSTEM_AWARE";
                case 2: return "PER_MONITOR_AWARE";
                default: return "UNKNOWN";
            }
        }
        catch { return "UNKNOWN"; }
    }
}
'@
}

<#
  Opts this process out of DPI virtualisation. Must run before any window is measured.
  Returns the awareness in force afterwards ("PER_MONITOR_AWARE" when it worked).
#>
function Enable-CaptureDpiAwareness {
    return [DocsDpiAwareness]::Enable()
}

$script:DocsCaptureDpiAwareness = Enable-CaptureDpiAwareness
if ($script:DocsCaptureDpiAwareness -eq 'UNAWARE') {
    Write-Warning ("window capture is DPI-UNAWARE; captures will be cropped on a scaled " +
        "display. Every measurement below is in virtualised coordinates.")
}

if (-not ('DocsWindowCapture' -as [type])) {
    Add-Type -ReferencedAssemblies System.Drawing, System.Collections -TypeDefinition @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;

public static class DocsWindowCapture
{
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool PrintWindow(IntPtr hwnd, IntPtr hdcBlt, uint flags);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hwnd, out RECT rect);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hwnd, int cmd);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hwnd);

    public delegate bool EnumWindowsProc(IntPtr hwnd, IntPtr param);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc callback, IntPtr param);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hwnd, System.Text.StringBuilder text, int count);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hwnd, out uint processId);

    // Windows 10 1607+. Reports the DPI of the display the window is on, independent of
    // the caller's own awareness, which is what makes it usable as a cross-check.
    [DllImport("user32.dll")]
    private static extern uint GetDpiForWindow(IntPtr hwnd);

    /// Display scale for a window: 1.0 at 96 DPI, 1.5 at 150%. Returns 0 when the OS
    /// cannot say, so a caller reports "unknown" rather than silently assuming 1.0.
    public static double ScaleOf(IntPtr hwnd)
    {
        try
        {
            uint dpi = GetDpiForWindow(hwnd);
            return dpi == 0 ? 0.0 : dpi / 96.0;
        }
        catch { return 0.0; }
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left, Top, Right, Bottom; }

    /// Visible top-level windows belonging to ONE process whose title contains `match`.
    ///
    /// Filtering by process id first is a privacy requirement, not an optimisation: this
    /// must never reach a window belonging to another application, and window titles on a
    /// developer machine can contain secrets. Titles outside the target process are never
    /// read.
    public static System.Collections.Generic.List<IntPtr> FindInProcess(int processId, string match)
    {
        var found = new System.Collections.Generic.List<IntPtr>();
        string needle = (match ?? string.Empty).ToLowerInvariant();

        EnumWindows(delegate(IntPtr hwnd, IntPtr param)
        {
            if (!IsWindowVisible(hwnd)) return true;

            uint owner;
            GetWindowThreadProcessId(hwnd, out owner);
            if ((int)owner != processId) return true;

            var builder = new System.Text.StringBuilder(512);
            if (GetWindowText(hwnd, builder, builder.Capacity) == 0) return true;

            if (needle.Length > 0 &&
                builder.ToString().ToLowerInvariant().IndexOf(needle, StringComparison.Ordinal) < 0)
            {
                return true;
            }

            found.Add(hwnd);
            return true;
        }, IntPtr.Zero);

        return found;
    }

    public static string TitleOf(IntPtr hwnd)
    {
        var builder = new System.Text.StringBuilder(512);
        GetWindowText(hwnd, builder, builder.Capacity);
        return builder.ToString();
    }

    public const uint PW_RENDERFULLCONTENT = 0x00000002;
    public const int SW_RESTORE = 9;

    public static Bitmap Capture(IntPtr hwnd)
    {
        RECT rect;
        if (!GetWindowRect(hwnd, out rect)) return null;

        int width = rect.Right - rect.Left;
        int height = rect.Bottom - rect.Top;
        if (width <= 0 || height <= 0) return null;

        Bitmap bitmap = new Bitmap(width, height);
        using (Graphics graphics = Graphics.FromImage(bitmap))
        {
            IntPtr hdc = graphics.GetHdc();
            try
            {
                if (!PrintWindow(hwnd, hdc, PW_RENDERFULLCONTENT)) return null;
            }
            finally
            {
                graphics.ReleaseHdc(hdc);
            }
        }

        return bitmap;
    }

    /// Fraction of sampled pixels differing from the most common colour. A blank or
    /// failed capture scores near zero, which is how a caller rejects one instead of
    /// shipping it.
    public static double ContentRatio(Bitmap bitmap)
    {
        int step = Math.Max(1, Math.Min(bitmap.Width, bitmap.Height) / 120);
        var counts = new System.Collections.Generic.Dictionary<int, int>();
        int sampled = 0;
        for (int y = 0; y < bitmap.Height; y += step)
        {
            for (int x = 0; x < bitmap.Width; x += step)
            {
                int argb = bitmap.GetPixel(x, y).ToArgb();
                int existing;
                counts.TryGetValue(argb, out existing);
                counts[argb] = existing + 1;
                sampled++;
            }
        }

        if (sampled == 0) return 0.0;
        int dominant = 0;
        foreach (var pair in counts) if (pair.Value > dominant) dominant = pair.Value;
        return 1.0 - ((double)dominant / sampled);
    }

    /// Fraction of an outermost row/column that departs from that line's own median
    /// colour by more than `tolerance` per channel.
    ///
    /// A correctly captured window ends in its own frame, which is a near-constant line
    /// and scores near zero. A capture sliced through the middle of the window ends in
    /// arbitrary interface and scores high.
    ///
    /// The tolerance is not optional: DWM and PNG round-tripping put three shades of
    /// (243,243,24x) along a single title-bar line, so an exact-equality version of this
    /// reports a healthy frame as 57% "content".
    ///
    /// This is a backstop, not the primary check. It is blind to a crop whose cut happens
    /// to land in an empty panel -- measured at 0.04 on two genuinely cropped shots,
    /// against 0.02 for a correct one. Size verification is what actually catches those.
    public static double EdgeBusyRatio(Bitmap bitmap, int cornerInset, int tolerance)
    {
        int w = bitmap.Width, h = bitmap.Height;
        if (w < (cornerInset * 2) + 8 || h < (cornerInset * 2) + 8) return 0.0;

        var right = new System.Collections.Generic.List<Color>();
        for (int y = cornerInset; y < h - cornerInset; y++) right.Add(bitmap.GetPixel(w - 1, y));

        var bottom = new System.Collections.Generic.List<Color>();
        for (int x = cornerInset; x < w - cornerInset; x++) bottom.Add(bitmap.GetPixel(x, h - 1));

        return Math.Max(LineBusy(right, tolerance), LineBusy(bottom, tolerance));
    }

    private static double LineBusy(System.Collections.Generic.List<Color> line, int tolerance)
    {
        if (line.Count == 0) return 0.0;

        int r = Median(line, 0), g = Median(line, 1), b = Median(line, 2);
        int off = 0;
        foreach (var c in line)
        {
            int delta = Math.Max(Math.Abs(c.R - r), Math.Max(Math.Abs(c.G - g), Math.Abs(c.B - b)));
            if (delta > tolerance) off++;
        }

        return (double)off / line.Count;
    }

    private static int Median(System.Collections.Generic.List<Color> line, int channel)
    {
        var values = new System.Collections.Generic.List<int>(line.Count);
        foreach (var c in line) values.Add(channel == 0 ? c.R : (channel == 1 ? c.G : c.B));
        values.Sort();
        return values[values.Count / 2];
    }

    public static Rectangle WindowRect(IntPtr hwnd)
    {
        RECT r;
        if (!GetWindowRect(hwnd, out r)) return Rectangle.Empty;
        return new Rectangle(r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top);
    }
}
'@
}

<#
  Resolves a window handle for a process. Only a process's MAIN window is reachable
  this way, which is why callers arrange the panel they want INSIDE the main window
  rather than floating it: EnumWindows reports almost nothing from a restricted shell,
  so MainWindowHandle is the only dependable route.
#>
function Get-TargetWindowHandle {
    param(
        [Parameter(Mandatory = $true)][string]$TitleMatch,
        [int]$ProcessId = 0,
        [switch]$MainWindowOnly
    )

    # Preferred route: enumerate the target process's own top-level windows. This reaches
    # floating panels, which MainWindowHandle cannot, and lets a caller photograph one
    # panel with no cropping at all.
    if ($ProcessId -gt 0 -and -not $MainWindowOnly) {
        $handles = [DocsWindowCapture]::FindInProcess($ProcessId, $TitleMatch)
        if ($handles -and $handles.Count -gt 0) { return $handles[0] }
    }

    $candidates = if ($ProcessId -gt 0) {
        Get-Process -Id $ProcessId -ErrorAction SilentlyContinue
    }
    else {
        Get-Process | Where-Object {
            $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle -and
            $_.MainWindowTitle.ToLower().Contains($TitleMatch.ToLower())
        }
    }

    foreach ($c in $candidates) {
        if ($c.MainWindowHandle -ne 0) { return $c.MainWindowHandle }
    }

    return [IntPtr]::Zero
}

<#
  Returns $null when a bitmap is at least as large as the window it claims to show, and
  a reason string when it is not.

  The rule is arithmetic, not a heuristic: a window of W points on a display at scale S
  renders W*S pixels, so a bitmap narrower than that is a photograph of part of it. Frame
  and shadow only ever add pixels, so the comparison is one-sided; the slack absorbs
  rounding, nothing more.

  Split out of Save-WindowRegion so it can be tested without a window. The defect it
  exists to catch reached two published documentation sites, so "it looks right" is not
  evidence about this one.
#>
function Test-CaptureCropped {
    param(
        [Parameter(Mandatory = $true)][int]$BitmapWidth,
        [Parameter(Mandatory = $true)][int]$BitmapHeight,
        [Parameter(Mandatory = $true)][int]$PointsWidth,
        [Parameter(Mandatory = $true)][int]$PointsHeight,
        [Parameter(Mandatory = $true)][double]$Scale,
        [int]$Slack = 2
    )

    if ($PointsWidth -le 0 -or $PointsHeight -le 0) { return $null }
    if ($Scale -le 0) { return 'SCALE_UNKNOWN (cannot verify the capture is uncropped)' }

    $needW = [int][Math]::Floor(($PointsWidth * $Scale) - $Slack)
    $needH = [int][Math]::Floor(($PointsHeight * $Scale) - $Slack)
    if ($BitmapWidth -lt $needW -or $BitmapHeight -lt $needH) {
        return ("CROPPED got={0}x{1} need>={2}x{3} points={4}x{5} scale={6:N2}" -f `
            $BitmapWidth, $BitmapHeight, $needW, $needH, $PointsWidth, $PointsHeight, $Scale)
    }

    return $null
}

<#
  Captures a window and optionally crops to a sub-rect.

  UNITS. The process is DPI-aware (see the header), so everything this function measures
  -- GetWindowRect, the bitmap, the returned Width/Height -- is in PHYSICAL PIXELS.
  The region parameters are in the caller's LOGICAL POINTS, because the caller is Unity
  and Unity's EditorWindow.position is in points. They are converted here using the
  window's own scale factor. Mixing the two is exactly the defect this file now guards
  against, so the boundary is stated rather than assumed.

  Two independent checks reject a bad capture:

    ExpectPoints{Width,Height}  the deterministic one. The bitmap must be at least the
                                requested points times the display scale. This is what
                                catches a DPI crop, in every case, by arithmetic.
    MaxEdgeBusy                 the backstop. The outermost row and column must look
                                like a window frame rather than sliced-through content.
                                Catches crops from other causes; misses a crop that
                                lands in an empty panel, which is why it is not alone.

  Returns a hashtable: Ok, Reason, Width, Height, ContentRatio, EdgeBusy, Scale.
#>
function Save-WindowRegion {
    param(
        [Parameter(Mandatory = $true)][string]$TitleMatch,
        [Parameter(Mandatory = $true)][string]$OutFile,
        [int]$ProcessId = 0,
        [int]$RegionX = 0,
        [int]$RegionY = 0,
        [int]$RegionWidth = 0,
        [int]$RegionHeight = 0,
        [int]$TopChrome = 0,
        [int]$Pad = 0,
        [double]$MinContentRatio = 0.02,
        [int]$ExpectPointsWidth = 0,
        [int]$ExpectPointsHeight = 0,
        [double]$MaxEdgeBusy = 0.15,
        [int]$EdgeCornerInset = 12,
        [int]$EdgeTolerance = 10
    )

    $handle = Get-TargetWindowHandle -TitleMatch $TitleMatch -ProcessId $ProcessId
    if ($handle -eq [IntPtr]::Zero) {
        return @{ Ok = $false; Reason = 'NO_WINDOW' }
    }

    # Restore rather than focus: PrintWindow does not need foreground, and stealing
    # focus from whatever the user is doing is rude. A minimized window has no surface.
    [void][DocsWindowCapture]::ShowWindow($handle, [DocsWindowCapture]::SW_RESTORE)
    Start-Sleep -Milliseconds 500

    $scale = [DocsWindowCapture]::ScaleOf($handle)

    $bitmap = [DocsWindowCapture]::Capture($handle)
    if (-not $bitmap) {
        return @{ Ok = $false; Reason = 'PRINTWINDOW_FAILED'; Scale = $scale }
    }

    try {
        $windowRect = [DocsWindowCapture]::WindowRect($handle)

        # Verify BEFORE cropping: the check is about the whole window having been
        # photographed, and a deliberate crop would otherwise mask the failure.
        if ($ExpectPointsWidth -gt 0 -and $ExpectPointsHeight -gt 0) {
            $cropped = Test-CaptureCropped `
                -BitmapWidth $bitmap.Width -BitmapHeight $bitmap.Height `
                -PointsWidth $ExpectPointsWidth -PointsHeight $ExpectPointsHeight -Scale $scale
            if ($cropped) {
                return @{
                    Ok = $false; Reason = $cropped
                    Width = $bitmap.Width; Height = $bitmap.Height; Scale = $scale
                }
            }
        }

        if ($RegionWidth -gt 8 -and $RegionHeight -gt 8) {
            # Points -> physical pixels. Both the region and the window origin have to be
            # in the same space before they can be subtracted.
            $s = if ($scale -gt 0) { $scale } else { 1.0 }
            $rx = [int][Math]::Round($RegionX * $s)
            $ry = [int][Math]::Round($RegionY * $s)
            $rw = [int][Math]::Round($RegionWidth * $s)
            $rh = [int][Math]::Round($RegionHeight * $s)
            $chrome = [int][Math]::Round($TopChrome * $s)
            $pad = [int][Math]::Round($Pad * $s)

            $x = $rx - $windowRect.X - $pad
            $y = $ry - $windowRect.Y - $pad + $chrome
            $w = $rw + ($pad * 2)
            $h = $rh + ($pad * 2) - $chrome

            if ($x -lt 0) { $w += $x; $x = 0 }
            if ($y -lt 0) { $h += $y; $y = 0 }
            if ($x + $w -gt $bitmap.Width) { $w = $bitmap.Width - $x }
            if ($y + $h -gt $bitmap.Height) { $h = $bitmap.Height - $y }

            if ($w -ge 64 -and $h -ge 64) {
                $rect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
                $cropped = $bitmap.Clone($rect, $bitmap.PixelFormat)
                $bitmap.Dispose()
                $bitmap = $cropped
            }
            # If the reported rect does not land inside the window, keep the whole
            # window rather than failing: a full-editor shot is still usable, and a
            # silent zero-size crop is not.
        }

        $ratio = [DocsWindowCapture]::ContentRatio($bitmap)
        if ($ratio -lt $MinContentRatio) {
            return @{ Ok = $false; Reason = ("BLANK ratio={0:N4}" -f $ratio); Scale = $scale }
        }

        $edge = [DocsWindowCapture]::EdgeBusyRatio($bitmap, $EdgeCornerInset, $EdgeTolerance)
        if ($MaxEdgeBusy -gt 0 -and $edge -gt $MaxEdgeBusy) {
            return @{
                Ok = $false
                Reason = ("EDGE_BUSY {0:N3} > {1:N3} (content reaches the image edge)" -f $edge, $MaxEdgeBusy)
                Width = $bitmap.Width; Height = $bitmap.Height
                ContentRatio = $ratio; EdgeBusy = $edge; Scale = $scale
            }
        }

        $dir = Split-Path -Parent $OutFile
        if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

        $w = $bitmap.Width
        $h = $bitmap.Height
        $bitmap.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
        return @{
            Ok = $true; Reason = ''; Width = $w; Height = $h
            ContentRatio = $ratio; EdgeBusy = $edge; Scale = $scale
        }
    }
    finally {
        if ($bitmap) { $bitmap.Dispose() }
    }
}
