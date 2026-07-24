---
hide:
  - navigation
---

<div class="hero" markdown>

# BranchWeaver

<p class="tagline">Deterministic branching maps for Unity. Generate route maps, overworld
webs, and chapter gates from rules &mdash; then traverse, save, and present them without
writing rendering code.</p>

</div>

![The Wayfarer sample rendered with the Slate Nocturne style](assets/images/hero-wayfarer.png){ .shot }

/// caption
The Wayfarer sample, Slate Nocturne style. Nodes, routes, rings, and glow are drawn by a
signed-distance-field shader &mdash; no textures ship with the package.
///

---

## Choose your path

<div class="cards" markdown>

<div markdown>

### :material-rocket-launch: I want to see it work

Open a sample, walk a map, generate your own from rules. No code.

[Your first map :material-arrow-right:](tutorials/first-map.md)

</div>

<div markdown>

### :material-palette: I want it to match my game

Pick a style, make it yours, put the map exactly where you want it on screen.

[Styling your map :material-arrow-right:](tutorials/styling-your-map.md)

</div>

<div markdown>

### :material-code-braces: I want to wire it up

Traversal events, payloads, saving, and generating without the controller.

[Integrate at runtime :material-arrow-right:](how-to/runtime-integration.md)

</div>

<div markdown>

### :material-book-open-variant: I need to look something up

244 public types, grouped by what they are for and filterable as you type.

[API reference :material-arrow-right:](reference/index.md)

</div>

</div>

---

## What it does

You give BranchWeaver **rules** &mdash; how many layers, how wide, which node types may
connect to which. It gives you a **graph**, deterministic from a seed. A **session** owns
traversal; a **presenter** draws it; a **style** decides how it looks.

The same `(rules, seed)` pair always produces the same map, on every machine and platform.
That is structural rather than promised: `BranchWeaver.Core` is compiled with
`noEngineReferences: true`, so it cannot reach `UnityEngine.Random`, `Time`, or a
`GameObject` even by accident.

=== "Rules to graph"

    ```csharp
    var compiler = new MapAuthoringCompiler();
    MapRulesCompilation rules = compiler.CompileRules(rulesAsset);

    var generator = new LayeredMapGenerator();
    MapGenerationResult result = generator.Generate(
        new MapGenerationRequest(rules.Value, seed: 12345u));

    MapGraph graph = result.Graph;   // same seed, same graph, always
    ```

=== "Walking it"

    ```csharp
    MapTransitionResult move = session.TryEnter(nodeId);
    if (!move.Succeeded)
    {
        // Illegal moves are data, not exceptions.
        return;
    }

    session.CompleteCurrent();   // content finished
    ```

=== "Restyling it"

    ```csharp
    presenter.ApplyStyle(nightStyle);   // rebuilds every live view

    // A style can never change the map. It is presentation only.
    ```

---

## Four shipped styles

Every look is drawn procedurally from numbers in a `MapStylePreset`. None of them ship a
texture or a font, and any of them becomes yours with one click in the Style Browser.

<div class="grid-2" markdown>

<figure markdown>
  ![Slate Nocturne](assets/images/style-slate-nocturne.png){ .shot }
  <figcaption><strong>Slate Nocturne</strong> &mdash; the default. Dark slate, cyan routes, amber focus ring.</figcaption>
</figure>

<figure markdown>
  ![Parchment Atlas](assets/images/style-parchment-atlas.png){ .shot }
  <figcaption><strong>Parchment Atlas</strong> &mdash; warm paper, inked circles, dashed routes.</figcaption>
</figure>

<figure markdown>
  ![Neon Circuit](assets/images/style-neon-circuit.png){ .shot }
  <figcaption><strong>Neon Circuit</strong> &mdash; hex nodes, heavy halos, routes that flow toward reachable nodes.</figcaption>
</figure>

<figure markdown>
  ![Minimal Mono](assets/images/style-minimal-mono.png){ .shot }
  <figcaption><strong>Minimal Mono</strong> &mdash; light, flat, hairline routes. The neutral base.</figcaption>
</figure>

</div>

---

## Requirements

- Unity **2022.3 LTS** or newer
- Built-in render pipeline, URP, or HDRP &mdash; no render-pipeline package required
- No third-party dependencies, no DRM, no telemetry, no online activation

!!! info "Documentation only"
    This site documents BranchWeaver. The product source is not published here.
