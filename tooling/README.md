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

## 2. Editor windows -- needs a GUI session, and it works

`EditorWindowShots` (in each ImportHost) plus `Capture-EditorWindows.ps1`.

```powershell
Capture-EditorWindows.ps1 `
  -ProjectPath <ImportHost> -UnityExe <Unity.exe> -OutDir <docs>/docs/assets/images `
  -Targets @('BattleWorkbenchWindow|editor-workbench|1300|860|workbench')
```

A target is `TypeName|file-stem|width|height|fixture`, everything after the stem optional.

### How it is triggered

Not by `-executeMethod`. A domain-load hook in the editor watches for a request file and
drives the run from `EditorApplication.update`, with progress in `SessionState` so a domain
reload resumes rather than restarts. The handshake is files, not pipes: `request.json` ->
`ready.json` -> `done-N.marker` -> `finished.marker`.

Each panel is opened through **its own static opener** -- the method behind its Tools menu
item -- so the shot matches what a user sees and the window keeps the title it sets for
itself. It is then floated at an explicit size and photographed as its own top-level OS
window: no cropping, no surrounding editor chrome, and the same size on every run whatever
editor layout is saved.

### Fixtures matter more than the capture

A freshly opened Workbench has no catalog assigned and photographs as an empty shell with
every button disabled -- honest and useless. `EditorWindowFixtures` assigns the shipped
starter content through `SerializedObject`, which is the supported way to reach a
`[SerializeField] private` field, then runs the window's own action. The Workbench shot
shows a compiled session with its state chain hash; without the fixture it shows nothing.

### Why PrintWindow and not a screen read

`InternalEditorUtility.ReadScreenPixel` reads the **literal screen**. An automated run on a
machine in use captured a web browser that happened to overlap the Unity window, and nothing
in the Editor could detect it. A window title on a developer machine can also contain a
credential.

`PrintWindow` with `PW_RENDERFULLCONTENT` asks the window to render itself, so the result is
that window's content even when covered. Window enumeration is filtered by process id
**first**, so this can never reach another application's window.

### Two false conclusions recorded here previously

Both were wrong, and both were symptoms of one bug. `Start-Process -ArgumentList` joins its
elements **without quoting**, so a project path containing a space arrived at Unity as two
arguments. Unity logged `Couldn't set project path`, changed to the truncated string, opened
nothing, and exited 0.

- *"`-executeMethod` never fires in a GUI session."* It was never reached. Quote the path.
- *"`EnumWindows` returns nothing from a restricted shell."* It returns 17 windows here.
  There was no Unity window to find.

The lesson generalises: when a launcher reports success and the child did nothing, read the
child's own log before concluding anything about the API.

### Known limitations

- `MinContentRatio` rejects a blank capture. Treat a non-zero exit as "no screenshot", never
  as "good enough".
- A fixture that fails logs and continues, so a sparse shot is possible. Check the content
  ratio in the output: a value near 0.1 usually means the panel had nothing to draw.

## 3. The API reference surface

`extract_docs.py` reads the source, `generate_api.py` renders it. The third input is a
**tiers** file (`tf-tiers.json`, `bw-tiers.json`):

```bash
python tooling/extract_docs.py <package>/Assets api.json
python tooling/generate_api.py api.json tooling/tf-groups.json     TempoForge-Docs/docs/reference TempoForge tooling/tf-tiers.json
```

Listing every public type lists the wrong things. Most of a Unity package's public surface is
public only because `internal` is per-assembly and the package spans several assemblies. The
tiers file separates that plumbing from the API:

| Tier | Effect |
| --- | --- |
| `headline` | Listed first under **Start here**, and badged on its page |
| `extensionPoints` | Badged as something a buyer implements themselves |
| `hidden` | Left out of the reference; carries `[EditorBrowsable(Never)]` in source |
| `internal` | No longer public at all |

The index states how many types are excluded and why, and coverage is measured over the
**published** surface. A reference that hides its own omissions is worse than one that admits
them.

### Regenerating the tiers

The tiers were decided by reading every type and, for each proposed removal, having a second
pass try to refute it. That refutation is the valuable part: of 258 types that looked
single-assembly and unreferenced, only **6** could actually be made `internal`. The rest
failed on one of two things worth remembering:

- BranchWeaver has **no `[InternalsVisibleTo]` anywhere**, so any test usage of a
  BranchWeaver type blocks `internal`.
- Inconsistent accessibility cascades. Internalising a type that appears in a still-public
  signature is CS0050/CS0051/CS0053, and internalising its container in turn breaks the tests
  that use *that*.

So `hidden` is where nearly everything lands, and that is the honest answer rather than a
compromise.
