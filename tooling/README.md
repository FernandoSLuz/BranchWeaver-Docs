# Documentation capture tooling

Two capture paths, because Unity has two very different rendering surfaces.

## 1. Scene, map, and interface content -- reliable and headless

`DocsCapture.MapStyleGallery` (BranchWeaver-ImportHost) and
`DocsCapture.BattleSkinGallery` (TempoForge-ImportHost) render through a throwaway
camera into a `RenderTexture`.

```bash
DOCS_IMAGE_DIR=<docs>/docs/assets/images \
Unity.exe -batchmode -quit -projectPath <ImportHost> \
  -executeMethod DocsCapture.MapStyleGallery.CaptureAll
```

Notes learned the hard way:

- **Do not pass `-nographics`.** There is no GPU, so `camera.Render()` produces a
  uniformly blank image and every style comes out byte-identical.
- Capture at the skin's or style's **reference resolution** (1920x1080). At smaller
  logical sizes, regions anchored to different corners overlap.
- Surfaces sized by a content-size fitter have a **zero rect** until a layout pass
  runs. Force layout, then re-apply each surface, or the shader receives a zero
  half-extent and draws nothing.

## 2. Editor windows -- needs a GUI session

`EditorWindowCapture` opens a panel, maximizes it, then invokes
`Capture-Window.ps1`.

```powershell
Capture-Window.ps1 -TitleMatch "<project>" -ProcessName Unity `
  -OutFile shot.png -RegionScreen "x,y,w,h"
```

### Why PrintWindow and not a screen read

`InternalEditorUtility.ReadScreenPixel` reads the **literal screen**. An
automated run on a machine in use captured a web browser that happened to overlap
the Unity window, and nothing in the Editor could detect it.

`PrintWindow` with `PW_RENDERFULLCONTENT` asks the window to render itself, so the
result is that window's content even when it is covered. This is verified working
against a real Unity editor.

### Focused regions

Pass `-RegionScreen "x,y,w,h"` in **absolute screen pixels** to crop to the thing
being explained. Whole-window shots are for when the point *is* the whole window.

Screen coordinates are used because Unity knows where a panel or element sits on
screen while the script knows where the captured window sits; subtracting one from
the other needs no shared assumption about title-bar height or DPI scaling.

### Known limitations

- Only a process's **main** window is reachable. `EnumWindows` returns nothing from
  a restricted shell, so floating utility panels cannot be targeted; the Unity side
  maximizes the panel instead.
- **Title matching is ambiguous on a busy desktop.** If two windows match, the
  wrong one may be captured, and the window that matched can change between calls.
  Run against a dedicated Unity instance and match on the project name.
- A region that falls outside the window is reported as `REGION_OFF_WINDOW` and the
  script exits non-zero. It never writes a partial or misleading image.
- `MinContentRatio` rejects a blank capture. Treat a non-zero exit as "no
  screenshot", never as "good enough".
