# Updating these docs

This site is the documentation a buyer learns from. It is written for a designer who does
not read C#, and for a teenager who follows tutorials by looking at the pictures. Both of
those readers are the point, not a nice-to-have.

## Where things live

```
docs/
  index.md
  tutorials/     numbered, start to finish, a picture under every step
  how-to/        one task, assumes the reader already has a map
  explanation/   why it works this way; no steps
  reference/     GENERATED. Do not hand-edit. See "The API reference" below.
  assets/images/ every PNG the site embeds
mkdocs.yml       nav, theme, and the validation settings that make --strict mean something
tooling/         a vendored copy of the shared capture and reference generators
```

The Diataxis split is load-bearing. A tutorial that stops to explain a design decision loses
the reader it was written for; put the decision in `explanation/` and link to it.

There is a second documentation set inside the package itself, at
`Assets/BranchWeaver/Documentation/*.md`. That one ships offline and is reference-shaped: API
catalogue, field reference, compatibility, troubleshooting. It links out here for the
illustrated walkthroughs. Do not duplicate tutorials into it, and do not move tutorials out
of here. `../DOCUMENTATION-HOME.md` in the AssetStore working tree records why.

## Publishing

Push to `main`. The workflow runs `mkdocs build --strict` and only deploys if it passes, so a
broken internal link or a missing image cannot reach the published site. Check it locally
first:

```bash
python -m mkdocs build --strict
```

`mkdocs.yml` promotes nav and link problems from INFO to WARNING on purpose. Without that,
`--strict` would happily pass a page dropped from the nav or a dead `#anchor`.

## Rules that will bite you

**ASCII only, in this repo and in the package.** The package's documentation gate test fails
the Unity build on a single non-ASCII byte, because Windows PowerShell and offline viewers
misdecode UTF-8. No em dashes, no smart quotes, no arrows. Write `-`, `'`, `"`, `->`.

**Never claim support you do not have evidence for.** Unity 2022.3.62f1 is the only verified
editor and Built-in the only verified pipeline. Everything else is pending, not assumed. A
page that says "2022.3 or newer" or "URP and HDRP work" is a defect, and one shipped that way
for weeks.

**Never tell a reader to write C# for something the editor does.** If a how-to says "call
`MapTraversalController.Initialize`", check whether `BranchWeaverMapHost` now does it. This
is the single most common way these pages go stale.

**Never show a designer a stable ID.** Map Studio names a node `Route - L1 / S1`. Generated
fingerprints like `g2.acc12fab180dffc5.l0.n0` identify a node perfectly and tell the reader
nothing.

## Pictures

Screenshots are the reason this site exists in the shape it does, so they have their own
pipeline. Full detail is in `tooling/README.md`; this is the short version.

### Before anything: sync the ImportHost

`BranchWeaver-ImportHost` holds a **byte-for-byte copy** of `Assets/BranchWeaver`, not a
symlink. A change you made in the product is invisible to a capture run until it is mirrored,
which is how a fix can appear not to work when it was simply never copied.

```powershell
BranchWeaver/Internal/Release/Sync-BranchWeaverImportHost.ps1          # mirror
BranchWeaver/Internal/Release/Sync-BranchWeaverImportHost.ps1 -VerifyOnly   # check only
```

It must report `missing=0 extra=0 mismatch=0`. Do not hand-copy files: that leaves `.meta`
GUID drift that fails the release audit later.

### Maps, styles, and rendered content: headless, reproducible

```bash
DOCS_IMAGE_DIR=<this repo>/docs/assets/images \
DOCS_DOC_IMAGE_DIR=<product>/Assets/BranchWeaver/Documentation/Images \
Unity.exe -batchmode -quit -projectPath <BranchWeaver-ImportHost> \
  -executeMethod DocsCapture.MapDocSet.CaptureAll
```

`DOCS_DOC_IMAGE_DIR` is optional. When set, the pictures the offline documentation embeds are
copied into the package and `Images/manifest.json` is rewritten with per-image hashes.

**Do not pass `-nographics`.** With no GPU every render comes back a byte-identical blank
image and the whole run looks like it worked.

Capture at the style's reference resolution, 1920x1080. At smaller logical sizes, regions
anchored to different corners overlap. A surface sized by a `ContentSizeFitter` has a zero
rect until a layout pass runs, so force layout and re-apply every surface, or the shader gets
a zero half-extent and draws nothing.

If the subject is portrait-shaped, give the shot a `Crop`. Fitting a tall map into a 16:9
frame is arithmetically correct and produces an image that is two-thirds black.

### Editor windows: needs a real GUI session, and it works

```powershell
tooling/Capture-EditorWindows.ps1 `
  -ProjectPath <BranchWeaver-ImportHost> -UnityExe <Unity.exe> `
  -OutDir <this repo>/docs/assets/images `
  -Targets @('MapStudioWindow|editor-map-studio|1300|860')
```

A target is `TypeName|file-stem|width|height|fixture`. Sizes are logical points; the PNG comes
out at points times the display scale, so output size is machine-dependent by design.

Two things this pipeline learned the hard way and still guards:

- The first line of output reports the DPI awareness it achieved. If it ever says `UNAWARE`,
  **every image in that run is cropped** and must be discarded. PowerShell is DPI-unaware by
  default, and eight images shipped for weeks with their right-hand third missing before
  anyone noticed, because a cropped window looks like a window.
- A freshly opened window has no content assigned and photographs as an empty shell with every
  button greyed out: honest and useless. `EditorWindowFixtures` assigns shipped content first.
  A content ratio near 0.1 in the output means the panel had nothing to draw.

### Then look at the picture

Open every new PNG and look at it. The render pipeline's own checks catch a blank image and a
crop; they do not catch a legible image that shows the wrong thing, is badly framed, or
photographs a button whose label changed. Five shipped presentation defects on this product
were found this way while more than a thousand assertions passed.

### Then check both directions

```bash
python - <<'EOF'
# every referenced image exists, and every existing image is referenced
EOF
```

A referenced-but-missing image fails `--strict`. An existing-but-unreferenced image is almost
always a section someone left un-illustrated, or a capture that was superseded and should be
deleted rather than left around to be reused by mistake.

## The API reference

`docs/reference/` is generated. Editing it by hand is wasted work.

```bash
python tooling/extract_docs.py <product>/Assets api.json
python tooling/generate_api.py api.json tooling/api-groups.json docs/reference BranchWeaver tooling/api-tiers.json
```

Read `generate_api.py` for the exact argument order before running it.

`api-tiers.json` is the gate that decides what the reference publishes -- **not** the
`[EditorBrowsable]` attributes in the source. Update it *before* regenerating:

| Tier | Effect |
| --- | --- |
| `headline` | Listed first under **Start here**, and badged on its page |
| `extensionPoints` | Badged as something a buyer implements themselves |
| `hidden` | Left out of the reference entirely |
| `internal` | No longer public at all |

Most of a Unity package's public surface is public only because `internal` is per-assembly.
Listing all of it lists the wrong things. `BranchWeaverMapHost` belongs in `headline`: it is
the first type a designer meets, and it spent a release filed as an ordinary type where nobody
would find it.

The tiers file and the source attributes drift independently, so after any tier change check
that every `hidden` type still carries `[EditorBrowsable(Never)]` and no published type does.

## Gates in the package that fail when the docs fall behind

These live in the Unity test suite, not here, and they will fail the product build:

- `M6DocumentationGateTests.EveryRelativeMarkdownLinkResolvesInsideDocumentation` requires
  every relative link in the package docs to resolve **inside** `Documentation/`. Reference a
  source file as a backticked path, never as a `../` link: folder layout changes on import.
- `M6DocumentationGateTests.OfflineDocumentationSetIsCompleteAsciiAndFreeOfMojibake` holds a
  hardcoded list of required files. Adding a page to the package means adding it there too.

Adding public API without documenting it is what these catch. That is the intended workflow,
not an obstacle to route around.
