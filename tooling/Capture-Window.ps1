<#
.SYNOPSIS
  Captures a window's own surface to a PNG, even when the window is occluded.

.DESCRIPTION
  Unity's InternalEditorUtility.ReadScreenPixel reads the LITERAL SCREEN, so any
  window overlapping the target ends up in the image. An unattended run on a
  machine in use captures whatever happens to be in front.

  PrintWindow asks the window to render itself into a device context instead, so
  the result is that window's content regardless of what is on top of it. The
  PW_RENDERFULLCONTENT flag is what makes it work for DWM-composited and
  hardware-accelerated windows; without it, GPU-rendered content comes back black.

  Some renderers still return a blank surface. The script therefore reports the
  fraction of non-uniform pixels so a caller can reject a blank capture instead of
  shipping it.

.PARAMETER TitleMatch
  Substring matched against window titles (case-insensitive).

.PARAMETER ProcessName
  Optional process name filter, e.g. Unity.

.PARAMETER OutFile
  Destination PNG path.

.PARAMETER MinContentRatio
  Minimum fraction of pixels that must differ from the dominant colour for the
  capture to be considered real. Defaults to 0.02.

.PARAMETER RegionScreen
  Optional "x,y,width,height" in ABSOLUTE SCREEN PHYSICAL PIXELS, cropping the
  capture to one region. Documentation shots should be focused on the thing being
  explained; a whole-editor shot is only right when the point is the whole editor.

  Screen coordinates are used rather than window-relative ones because the caller
  (Unity) knows where a panel or a single UI element sits on screen, while this
  script knows where the captured window sits. Subtracting one from the other is
  exact and needs no shared assumption about title-bar height.

  Physical, not logical: this script opts out of DPI virtualisation (see below), so
  a caller working in logical points must multiply by the display scale first.

.PARAMETER Pad
  Pixels of margin added around the region, so a focused shot does not clip the
  border of what it is showing. Defaults to 8.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$TitleMatch,
    [string]$ProcessName,
    [Parameter(Mandatory = $true)][string]$OutFile,
    [double]$MinContentRatio = 0.02,
    [string]$RegionScreen,
    [int]$Pad = 8
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

# Opt out of DPI virtualisation BEFORE any window is measured. PowerShell is DPI-unaware
# by default, and an unaware process is told a 150%-scaled window is two-thirds of its
# real size while PrintWindow still renders it full size -- so the bitmap gets sized for
# the small number and keeps only the top-left of what was drawn. That is not a visible
# failure: the result is a plausible window missing its right-hand side, and it shipped
# eight cropped screenshots to two documentation sites. The library owns the opt-out so
# both capture scripts get the same behaviour from one place.
$here = Split-Path -Parent $PSCommandPath
$captureLib = Join-Path $here 'WindowCaptureLib.ps1'
if (-not (Test-Path $captureLib)) { throw "Missing $captureLib" }
. $captureLib
Write-Output ("dpi awareness: {0}" -f [DocsDpiAwareness]::Describe())

$signature = @'
using System;
using System.Drawing;
using System.Runtime.InteropServices;

public static class WindowCapture
{
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool PrintWindow(IntPtr hwnd, IntPtr hdcBlt, uint flags);

    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hwnd, out RECT rect);

    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hwnd);

    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hwnd, int cmd);

    public delegate bool EnumWindowsProc(IntPtr hwnd, IntPtr param);

    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc callback, IntPtr param);

    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int GetWindowText(IntPtr hwnd, System.Text.StringBuilder text, int count);

    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hwnd, out uint processId);

    [StructLayout(LayoutKind.Sequential)]
    public struct RECT { public int Left, Top, Right, Bottom; }

    /// Every visible top-level window whose title contains `match`.
    ///
    /// Process.MainWindowTitle only sees a process's primary window, so a floating
    /// Unity panel -- which is what a utility EditorWindow becomes -- is invisible to
    /// it. Enumerating top-level windows is the only way to find those.
    public static System.Collections.Generic.List<IntPtr> Find(string match, int processId)
    {
        var found = new System.Collections.Generic.List<IntPtr>();
        string needle = match.ToLowerInvariant();

        EnumWindows(delegate(IntPtr hwnd, IntPtr param)
        {
            if (!IsWindowVisible(hwnd)) return true;

            var builder = new System.Text.StringBuilder(512);
            if (GetWindowText(hwnd, builder, builder.Capacity) == 0) return true;

            string title = builder.ToString();
            if (title.ToLowerInvariant().IndexOf(needle, StringComparison.Ordinal) < 0) return true;

            if (processId > 0)
            {
                uint owner;
                GetWindowThreadProcessId(hwnd, out owner);
                if ((int)owner != processId) return true;
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

    // Render the full window content, including hardware-accelerated surfaces.
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
                if (!PrintWindow(hwnd, hdc, PW_RENDERFULLCONTENT))
                {
                    return null;
                }
            }
            finally
            {
                graphics.ReleaseHdc(hdc);
            }
        }

        return bitmap;
    }

    /// Fraction of pixels differing from the most common colour. A blank or
    /// failed capture scores near zero.
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
}
'@

Add-Type -TypeDefinition $signature -ReferencedAssemblies System.Drawing, System.Collections

$processId = 0
if ($ProcessName) {
    $owner = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($owner) { $processId = $owner.Id }
}

$handles = [WindowCapture]::Find($TitleMatch, $processId)
$handle = [IntPtr]::Zero

if ($handles -and $handles.Count -gt 0) {
    $handle = $handles[0]
}
else {
    # EnumWindows only reports windows on the caller's desktop, and a restricted or
    # differently-sessioned shell sees almost nothing. Process.MainWindowHandle is
    # resolved by the OS on our behalf and still works there, so it is the fallback.
    # The cost is that only a process's MAIN window is reachable this way, not
    # floating child panels -- which is why the Unity side maximizes the panel it
    # wants captured instead of floating it.
    $match = Get-Process | Where-Object {
        $_.MainWindowHandle -ne 0 -and
        $_.MainWindowTitle -and
        $_.MainWindowTitle.ToLower().Contains($TitleMatch.ToLower()) -and
        (-not $ProcessName -or $_.ProcessName -eq $ProcessName)
    } | Select-Object -First 1

    if ($match) {
        $handle = $match.MainWindowHandle
        Write-Output ("target (main window): " + $match.MainWindowTitle)
    }
}

if ($handle -eq [IntPtr]::Zero) {
    Write-Output "NO_WINDOW"
    Write-Output "Candidate main windows:"
    Get-Process | Where-Object { $_.MainWindowHandle -ne 0 -and $_.MainWindowTitle } |
        ForEach-Object { "  [$($_.ProcessName)] $($_.MainWindowTitle)" }
    exit 2
}

# Restoring (not focusing) is enough for PrintWindow, and avoids stealing focus
# from whatever the user is doing. A minimized window has no surface to render.
[void][WindowCapture]::ShowWindow($handle, [WindowCapture]::SW_RESTORE)
Start-Sleep -Milliseconds 700

$bitmap = [WindowCapture]::Capture($handle)
if (-not $bitmap) {
    Write-Output "CAPTURE_FAILED"
    exit 3
}

# Crop to the region of interest, if one was given. Documentation shots should
# show the thing being explained, not the whole application around it.
if ($RegionScreen) {
    $parts = $RegionScreen.Split(',')
    if ($parts.Count -ne 4) {
        $bitmap.Dispose()
        Write-Output "BAD_REGION expected x,y,width,height"
        exit 5
    }

    [WindowCapture+RECT]$windowRect = New-Object 'WindowCapture+RECT'
    [void][WindowCapture]::GetWindowRect($handle, [ref]$windowRect)

    # Screen space -> bitmap space, then grow by the padding and clamp to the image.
    $x = [int]$parts[0] - $windowRect.Left - $Pad
    $y = [int]$parts[1] - $windowRect.Top - $Pad
    $w = [int]$parts[2] + ($Pad * 2)
    $h = [int]$parts[3] + ($Pad * 2)

    if ($x -lt 0) { $w += $x; $x = 0 }
    if ($y -lt 0) { $h += $y; $y = 0 }
    if ($x + $w -gt $bitmap.Width)  { $w = $bitmap.Width  - $x }
    if ($y + $h -gt $bitmap.Height) { $h = $bitmap.Height - $y }

    if ($w -lt 8 -or $h -lt 8) {
        $bitmap.Dispose()
        Write-Output ("REGION_OFF_WINDOW x={0} y={1} w={2} h={3}" -f $x, $y, $w, $h)
        exit 6
    }

    $cropRect = New-Object System.Drawing.Rectangle $x, $y, $w, $h
    $cropped = $bitmap.Clone($cropRect, $bitmap.PixelFormat)
    $bitmap.Dispose()
    $bitmap = $cropped
    Write-Output ("cropped to {0}x{1} at {2},{3}" -f $w, $h, $x, $y)
}

$ratio = [WindowCapture]::ContentRatio($bitmap)
$directory = Split-Path -Parent $OutFile
if ($directory -and -not (Test-Path $directory)) {
    New-Item -ItemType Directory -Force -Path $directory | Out-Null
}

if ($ratio -lt $MinContentRatio) {
    $bitmap.Dispose()
    Write-Output ("BLANK ratio={0:N4} threshold={1:N4}" -f $ratio, $MinContentRatio)
    exit 4
}

$width = $bitmap.Width
$height = $bitmap.Height
$bitmap.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
$size = (Get-Item $OutFile).Length
Write-Output ("OK {0} {1}x{2} ratio={3:N4} bytes={4}" -f `
    $OutFile, $width, $height, $ratio, $size)
