# BranchWeaver

**Deterministic branching maps for Unity.** Generate Slay-the-Spire-style route maps,
overworld webs, and chapter gates from rules; author them by hand when you want to;
traverse, save, and present them without writing rendering code.

> Documentation only. The product source is not in this repository.

---

## Learn it from scratch

Read these in order. Each one ends where the next begins.

| # | Guide | You will be able to |
| --- | --- | --- |
| 1 | **[Getting started](docs/01-getting-started.md)** | Open the samples, generate a map, walk it |
| 2 | **[Core concepts](docs/02-core-concepts.md)** | Explain rules, graph, session, presenter, and why they are separate |
| 3 | **[Authoring maps](docs/03-authoring-maps.md)** | Create node types, rules, and hand-authored blueprints |
| 4 | **[Styles and presets](docs/04-styles-and-presets.md)** | Make the map look like *your* game |
| 5 | **[Runtime integration](docs/05-runtime-integration.md)** | Drive it from your own code and save progress |
| 6 | **[Troubleshooting](docs/06-troubleshooting.md)** | Fix the errors you are most likely to hit |
| - | **[API reference](docs/api-reference.md)** | Look up any public type or member |

**If you have 10 minutes:** guide 1, then the "five-minute" section of guide 4.

---

## What it actually does

You give BranchWeaver **rules** (how many layers, how wide, which node types may
connect to which). It gives you a **graph**: nodes, edges, layers, all deterministic
from a seed. The same seed and rules always produce the same map, on every machine
and every platform.

A **session** then owns traversal: where the traveller is, which nodes are legal to
enter next, what has been completed. A **presenter** draws it. Those three stay
separate on purpose, and the separation is enforced by tests rather than convention:

- `BranchWeaver.Core` is compiled with `noEngineReferences: true`. It cannot touch a
  `GameObject`, a `Transform`, or `UnityEngine.Random` even by accident. That is what
  makes the determinism auditable instead of aspirational.
- The presenter reads state and draws. It never decides what is legal.
- Styles are presentation-only. Restyling a map can never change the map.

## What ships

- Rule-driven generation with a preflight that tells you *why* a rule set is
  unsatisfiable, instead of hanging or returning a broken map.
- Hand-authoring and hybrid authoring: pin nodes, lock regions, regenerate the rest.
- **Map Studio**, an editor window for previewing and editing maps without touching
  your project's assets.
- Traversal with fog of war, save/load with schema migrations, and stable IDs treated
  as compatibility contracts.
- Two presenters: uGUI (screen space) and World2D (in scene).
- Four shipped visual styles, plus a Style Browser that turns any of them into an
  asset you own.
- No third-party dependencies. No DRM, no telemetry, no online activation.

## Requirements

- Unity **2022.3 LTS** or newer.
- Built-in render pipeline, URP, or HDRP. No render-pipeline package required.

The visuals are drawn with a signed-distance-field shader and procedural geometry, so
they stay crisp at any zoom and ship no textures.

## Support

Open an issue on this repository for documentation problems. For product issues,
include your Unity version, render pipeline, and the seed plus rules asset that
reproduces it -- determinism means a seed is usually enough to reproduce exactly.
