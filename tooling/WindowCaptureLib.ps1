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
#>

Add-Type -AssemblyName System.Drawing

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
  Captures a window and optionally crops to a sub-rect given in ABSOLUTE SCREEN
  coordinates. Screen coordinates are used because the caller (Unity) knows where its
  panel sits on screen while this code knows where the window sits; subtracting one
  from the other needs no shared assumption about title-bar height or DPI scaling.

  Returns a hashtable: Ok, Reason, Width, Height, ContentRatio.
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
        [double]$MinContentRatio = 0.02
    )

    $handle = Get-TargetWindowHandle -TitleMatch $TitleMatch -ProcessId $ProcessId
    if ($handle -eq [IntPtr]::Zero) {
        return @{ Ok = $false; Reason = 'NO_WINDOW' }
    }

    # Restore rather than focus: PrintWindow does not need foreground, and stealing
    # focus from whatever the user is doing is rude. A minimized window has no surface.
    [void][DocsWindowCapture]::ShowWindow($handle, [DocsWindowCapture]::SW_RESTORE)
    Start-Sleep -Milliseconds 500

    $bitmap = [DocsWindowCapture]::Capture($handle)
    if (-not $bitmap) {
        return @{ Ok = $false; Reason = 'PRINTWINDOW_FAILED' }
    }

    try {
        $windowRect = [DocsWindowCapture]::WindowRect($handle)

        if ($RegionWidth -gt 8 -and $RegionHeight -gt 8) {
            $x = $RegionX - $windowRect.X - $Pad
            $y = $RegionY - $windowRect.Y - $Pad + $TopChrome
            $w = $RegionWidth + ($Pad * 2)
            $h = $RegionHeight + ($Pad * 2) - $TopChrome

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
            return @{ Ok = $false; Reason = ("BLANK ratio={0:N4}" -f $ratio) }
        }

        $dir = Split-Path -Parent $OutFile
        if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }

        $w = $bitmap.Width
        $h = $bitmap.Height
        $bitmap.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
        return @{ Ok = $true; Reason = ''; Width = $w; Height = $h; ContentRatio = $ratio }
    }
    finally {
        if ($bitmap) { $bitmap.Dispose() }
    }
}
