<#
.SYNOPSIS
  Captures Unity editor-window screenshots from a real GUI editor session.

.DESCRIPTION
  Batch mode cannot do this: an EditorWindow has no surface to photograph without a
  GUI, and `-executeMethod` never fires in a GUI session, which is what defeated
  three earlier attempts.

  So the editor arms itself instead. This script:

    1. writes a request file listing the windows to shoot,
    2. launches a normal GUI editor on the project,
    3. waits for the editor to report a window as arranged (ready.json),
    4. photographs Unity's MAIN window with PrintWindow and crops to the reported rect,
    5. writes a done marker so the editor advances to the next window,
    6. repeats, then closes the editor.

  PrintWindow asks the window to render itself into a device context, so the result is
  Unity's own content regardless of what is on top of it. This matters beyond
  reliability: an earlier screen-reading attempt captured an unrelated window that
  happened to be in front, and a window title on this machine has contained a
  credential. Nothing here reads the screen.

.PARAMETER ProjectPath
  The Unity project to open. Use an ImportHost, never a product repo.

.PARAMETER UnityExe
  Full path to Unity.exe.

.PARAMETER OutDir
  Where the PNGs go.

.PARAMETER Targets
  One entry per window: "TypeName|file-stem|Menu/Path".

.PARAMETER TimeoutSeconds
  How long to wait for any single window to be arranged before giving up.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$ProjectPath,
    [Parameter(Mandatory = $true)][string]$UnityExe,
    [Parameter(Mandatory = $true)][string]$OutDir,
    [Parameter(Mandatory = $true)][string[]]$Targets,
    [int]$TimeoutSeconds = 420,
    [int]$TopChrome = 0,
    [switch]$KeepEditorOpen
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$here = Split-Path -Parent $PSCommandPath
$captureLib = Join-Path $here 'WindowCaptureLib.ps1'
if (-not (Test-Path $captureLib)) { throw "Missing $captureLib" }
. $captureLib

$handshake = Join-Path $ProjectPath 'Temp\docs-window-capture'
if (Test-Path $handshake) { Remove-Item -Recurse -Force $handshake }
New-Item -ItemType Directory -Force -Path $handshake | Out-Null
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$requestPath = Join-Path $handshake 'request.json'
Set-Content -Path $requestPath -Value $Targets -Encoding utf8
Write-Output ("request: {0} target(s)" -f $Targets.Count)

$logPath = Join-Path $handshake 'editor.log'

# Start-Process joins -ArgumentList with spaces and does NOT quote the elements, so a
# path containing a space arrives at the process as two separate arguments. That is
# what defeated the previous attempt at this: Unity silently "changed project path" to
# the truncated string, opened nothing, and exited 0 -- which reads exactly like
# "-executeMethod never fired". Quote every path explicitly.
$argumentLine = @(
    '-projectPath', ('"{0}"' -f $ProjectPath),
    '-logFile', ('"{0}"' -f $logPath)
) -join ' '

$proc = Start-Process -FilePath $UnityExe -PassThru -ArgumentList $argumentLine
Write-Output ("launched editor pid=$($proc.Id)")

$readyPath = Join-Path $handshake 'ready.json'
$finished = Join-Path $handshake 'finished.marker'
$errorPath = Join-Path $handshake 'error.txt'

$captured = @()
$failed = @()

try {
    while ($true) {
        if (Test-Path $finished) { Write-Output 'editor reports finished'; break }
        if (Test-Path $errorPath) {
            Write-Output ('editor reported an error: ' + (Get-Content -Raw $errorPath))
            break
        }

        # Wait for the next arranged window.
        $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
        while (-not (Test-Path $readyPath)) {
            if (Test-Path $finished) { break }
            if ($proc.HasExited) { throw "the editor exited early (code $($proc.ExitCode)); see $logPath" }
            if ((Get-Date) -gt $deadline) { throw "timed out waiting for a window to be arranged; see $logPath" }
            Start-Sleep -Milliseconds 900
        }
        if (Test-Path $finished) { Write-Output 'editor reports finished'; break }

        $info = @{}
        foreach ($line in (Get-Content $readyPath)) {
            if ($line -match '^(\w+)=(.*)$') { $info[$Matches[1]] = $Matches[2] }
        }
        $index = [int]$info['index']
        $stem = $info['stem']
        $title = $info['title']
        Write-Output ("arranged [{0}] {1} title='{2}' {3}x{4}" -f `
            $index, $stem, $title, $info['width'], $info['height'])

        # Let the compositor settle after the editor's own repaint loop.
        Start-Sleep -Milliseconds 1200

        # Photograph the panel's OWN window, found by title within this editor process, so
        # the image is exactly the panel with no cropping and no editor chrome. Falls back
        # to the whole editor window if the panel is docked rather than floating.
        $outFile = Join-Path $OutDir ($stem + '.png')
        $result = Save-WindowRegion -TitleMatch $title -ProcessId $proc.Id -OutFile $outFile
        if (-not $result.Ok -and $result.Reason -eq 'NO_WINDOW') {
            Write-Output ("  panel window '{0}' not found; falling back to the editor window" -f $title)
            $result = Save-WindowRegion `
                -TitleMatch 'Unity' -ProcessId $proc.Id -OutFile $outFile -MainWindowOnly `
                -RegionX ([int]$info['x']) -RegionY ([int]$info['y']) `
                -RegionWidth ([int]$info['width']) -RegionHeight ([int]$info['height']) `
                -TopChrome $TopChrome
        }

        if ($result.Ok) {
            Write-Output ("  OK  {0}  {1}x{2}  content={3:N3}" -f `
                (Split-Path -Leaf $outFile), $result.Width, $result.Height, $result.ContentRatio)
            $captured += $stem
        }
        else {
            Write-Output ("  FAILED {0}: {1}" -f $stem, $result.Reason)
            $failed += ("{0} ({1})" -f $stem, $result.Reason)
        }

        Remove-Item -Force $readyPath
        Set-Content -Path (Join-Path $handshake ("done-$index.marker")) -Value 'ok' -Encoding utf8
    }
}
finally {
    if (-not $KeepEditorOpen) {
        if (-not $proc.HasExited) {
            Write-Output 'closing editor'
            try { $proc.CloseMainWindow() | Out-Null } catch {}
            Start-Sleep -Seconds 6
            if (-not $proc.HasExited) { try { Stop-Process -Id $proc.Id -Force } catch {} }
        }
    }
}

Write-Output ''
Write-Output ("captured {0}: {1}" -f $captured.Count, ($captured -join ', '))
if ($failed.Count -gt 0) {
    Write-Output ("failed {0}: {1}" -f $failed.Count, ($failed -join '; '))
    exit 3
}
if ($captured.Count -eq 0) { Write-Output 'nothing captured'; exit 4 }
