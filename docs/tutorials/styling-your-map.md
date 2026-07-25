# 4. Styles and presets

Everything the map draws itself with lives in one asset: a **Map Style Preset**.
Palette, node shape, per-state emphasis, edge stroke, backdrop, typography, motion, and
where the map sits on screen.

Two consequences worth stating plainly:

- You do not edit a prefab to restyle the map, because the map has no prefabs. Nodes and
  edges are drawn from the style at runtime.
- A style cannot change a map. Styles are presentation-only and never enter a graph, a
  save envelope, or a fingerprint.

---

## The five-minute version

1. **Tools > BranchWeaver > Style Browser**.
2. Pick a shipped style. The preview uses the real shader, so what you see is what
   ships.
3. **Create editable copy...** and save it into your own folder.
4. Select the new asset. Edit fields; the inspector preview updates live.
5. Assign it to your presenter's **Style Preset** field, or press **Apply to maps in
   open scenes** in the browser.

That is the whole authoring loop.

## Shipped styles

| Style | Character |
| --- | --- |
| **Slate Nocturne** | Dark slate, cyan routes, amber focus ring, soft glow. The default. |
| **Parchment Atlas** | Warm paper, inked circular nodes, dashed routes, sepia labels. No glow. |
| **Neon Circuit** | Deep indigo, hexagonal neon nodes, routes that flow toward reachable destinations. |
| **Minimal Mono** | Light neutral, hairline routes, no glow or gradients. |

These are defined **in code** (`MapStyleDefaults`), not as assets. That is deliberate:

- The map always has a complete, valid look even when no style is assigned, so the
  package never renders as untreated squares.
- No font, texture, or material is redistributed. Every look is drawn procedurally.

Use **Create editable copy** to turn any of them into an asset you own.

---

## What you can change

### Palette

Semantic roles assigned once and reused. Change `Accent` and the glow, highlights, and
available-route colour all follow.

Backdrop (top and bottom), grid, four edge roles (default, available, traversed,
locked), focus ring, accent, and three text roles.

Note the **four edge roles**: a route already walked reads differently from one leading
somewhere you can reach right now. That single distinction does more for map legibility
than any other setting here.

### Nodes

`Node.Shape` picks the silhouette. Every one of these is the same shader evaluating a
different distance field, so they stay crisp at any zoom:

<div class="grid-2" markdown>

<figure markdown>
  ![Rounded rect](../assets/images/node-shape-rounded-rect.png){ .shot }
  <figcaption><code>RoundedRect</code> &mdash; honours <code>CornerRadius</code>.</figcaption>
</figure>

<figure markdown>
  ![Circle](../assets/images/node-shape-circle.png){ .shot }
  <figcaption><code>Circle</code></figcaption>
</figure>

<figure markdown>
  ![Hexagon](../assets/images/node-shape-hexagon.png){ .shot }
  <figcaption><code>Hexagon</code></figcaption>
</figure>

<figure markdown>
  ![Diamond](../assets/images/node-shape-diamond.png){ .shot }
  <figcaption><code>Diamond</code></figcaption>
</figure>

<figure markdown>
  ![Capsule](../assets/images/node-shape-capsule.png){ .shot }
  <figcaption><code>Capsule</code> &mdash; fully rounded on the shorter axis.</figcaption>
</figure>

</div>

Plus size, corner radius, and a surface with fill mode, gradient spread and angle, stroke
width and colour, glow radius and intensity, and drop shadow.

**Stroke colour with zero alpha means "derive it from the node's own state colour".**
That is the default, and it is why every node type stays coherent without the style
hardcoding a border per type.

**Glow is drawn inside the shader.** It is not post-processing. This is why BranchWeaver
depends on no post-processing package and why enabling glow cannot conflict with your
existing volumes or renderer features.

### Per-state emphasis

Six states, each with brightness, opacity, scale, glow multiplier, ring toggle and
width, and label visibility:

This is what the shipped defaults look like. The node type supplies the colour; the
state style decides how it is presented:

| | State | Shipped default |
| --- | --- | --- |
| ![Locked](../assets/images/node-state-locked.png){ width="80" } | **Locked** | Dimmed to 72%, slightly shrunk |
| ![Available](../assets/images/node-state-available.png){ width="80" } | **Available** | Full brightness, soft glow |
| ![Current](../assets/images/node-state-current.png){ width="80" } | **Current** | Brightest, 1.16x scale, ringed, strongest glow |
| ![Visited](../assets/images/node-state-visited.png){ width="80" } | **Visited** | Slightly receded |
| ![Completed](../assets/images/node-state-completed.png){ width="80" } | **Completed** | Settled, no glow |

`Hidden` is fully transparent, so there is nothing to show. Note it keeps its label
object at zero opacity rather than destroying it, so revealing a node rebuilds nothing.

!!! tip "Read the hierarchy, not the colours"
    Scanning that column top to bottom is the test that matters: the node the player can
    act on must be the most prominent. If `Available` is not pulling your eye first, the
    palette is fighting the state styles &mdash; that exact fault is why the shipped
    Minimal Mono accent is a saturated blue rather than the near-black used for text.

Hidden nodes keep their label object at zero opacity rather than destroying it, so
revealing a node does not rebuild anything.

### Edges

Width, cap (`Butt`, `Round`, `Arrow`), arrow length, node clearance, dash length and
gap, flow speed, glow, and a width multiplier for routes leading to reachable nodes.

| | Setting | Effect |
| --- | --- | --- |
| ![Round cap](../assets/images/edge-solid-round.png){ width="150" } | `Cap = Round` | **The default.** Hides the joints between segments on a curve. |
| ![Butt cap](../assets/images/edge-butt.png){ width="150" } | `Cap = Butt` | Flat cut. Cheapest, but shows seams where segments meet. |
| ![Arrow cap](../assets/images/edge-arrow.png){ width="150" } | `Cap = Arrow` | Points at the destination. Good for one-way routes. |
| ![Dashed](../assets/images/edge-dashed.png){ width="150" } | `DashLength` + `DashGap` | Breaks the line into dashes. |

`Round` caps are the default because they hide the joints between segments on a curve.
Set `FlowSpeed` above zero **and** give the dashes a length to make available routes
animate toward their destination -- the single most effective way to show a player where
they can go next. Flow with no dash length does nothing visible, because there are no
dashes to move.

### Backdrop

Fill mode, vignette strength and softness, grid spacing and line width. Set
`Visible = false` to show your own scene art through the map instead.

![Backdrop with vignette and grid](../assets/images/backdrop-vignette-grid.png){ .shot }

/// caption
A vertical gradient, a vignette darkening the corners, and a grid at the style's spacing.
All three are the same shader that draws the nodes, so the backdrop costs one more quad and
needs no texture.
///

The vignette is what stops a large map from reading as a flat rectangle: it pulls the eye
to the centre where the route is. Turn it down to zero for a diagram-like look, or up for
something closer to a lit table.

### Typography

Optional font (left empty, Unity's built-in runtime font is used, so no font is
redistributed), label size or size-as-fraction-of-node, offset, and a contrast outline.

### Motion

Every duration passes through `MotionScale`. Two shortcuts:

- `MotionScale = 0` snaps every transition instantly.
- `ReduceMotion = true` does the same and skips decorative motion. Wire this to a player
  accessibility setting.

Focus responds on the same frame it is requested and then settles from a slight
overshoot, so selection feels immediate rather than laggy.

### Framing -- putting the map where you want it

This is how you make the map adjustable on screen:

| Token | Effect |
| --- | --- |
| `FlowDirection` | `BottomToTop`, `TopToBottom`, `LeftToRight`, `RightToLeft` |
| `FitMode` | `Fit`, `Fill`, `FixedScale`, `Stretch` |
| `MarginLeft/Right/Top/Bottom` | Fractions of the area reserved for **your** interface |
| `RespectSafeArea` | Inset into the device safe area, for notches and home indicators |
| `ContentPadding` | Space kept around the map content when fitting |
| `AllowPan` / `AllowZoom` | Whether the player may move the map |
| `ClampPanToContent` | Stops the map being dragged off-screen |
| `PanOverscroll` | How far past the edge panning may rubber-band |

Margins are fractions, so one style works across resolutions.

#### Which way the map runs

`FlowDirection` gives all four. The same map, the same style, the same seed &mdash; only
the direction token differs. Green nodes are the start, `Summit` is the single boss:

<div class="grid-2" markdown>

<figure markdown>
  ![Bottom to top](../assets/images/direction-bottom-to-top.png){ .shot }
  <figcaption><code>BottomToTop</code> &mdash; climbing. The default.</figcaption>
</figure>

<figure markdown>
  ![Top to bottom](../assets/images/direction-top-to-bottom.png){ .shot }
  <figcaption><code>TopToBottom</code> &mdash; a descent.</figcaption>
</figure>

<figure markdown>
  ![Left to right](../assets/images/direction-left-to-right.png){ .shot }
  <figcaption><code>LeftToRight</code> &mdash; a journey across.</figcaption>
</figure>

<figure markdown>
  ![Right to left](../assets/images/direction-right-to-left.png){ .shot }
  <figcaption><code>RightToLeft</code> &mdash; right-to-left reading order.</figcaption>
</figure>

</div>

| Direction | Reads as |
| --- | --- |
| `BottomToTop` | Climbing. The classic run-map direction, and the default. |
| `TopToBottom` | Descending. |
| `LeftToRight` | A journey across, western reading order. |
| `RightToLeft` | A journey across, right-to-left reading order. |

```csharp
var framing = style.Framing;
framing.FlowDirection = MapFlowDirection.TopToBottom;
```

The **theme** picks which axis layers advance along; the **style** picks which way along
it. Direction is applied when normalized positions are converted for display, so it is
presentation-only: flipping a map cannot change the generated graph, a save, or a
fingerprint. A run saved climbing and reopened descending is still the same run, drawn
the other way round.

#### Offsets and padding

Three separate controls, easy to confuse:

| Control | Units | What it does |
| --- | --- | --- |
| `MarginLeft/Right/Top/Bottom` | Fraction of the area | Reserves screen space for **your** interface. The map never draws there. |
| `ContentPadding` | Presentation pixels | Breathing room **around the map content** when fitting, so nodes at the edge are not flush against it. |
| `MapViewportFrame.Pan` | Pixels | An explicit offset of the map inside its area, clamped by the pan limits. |

So: margins push the *area* in, padding pushes the *content* in, and pan slides the
content within what is left.

```csharp
var framing = style.Framing;          // read the resolved values
frame.Pan = new Vector2(-120f, 40f);  // nudge, clamped automatically
frame.FrameAll();                     // reset pan and zoom, refit
```

Add **BranchWeaver > Map Viewport Frame** to the map hierarchy to apply them, then:

```csharp
frame.FrameAll();          // refit the whole map
frame.FocusOn(nodeId);     // centre on a node, clamped
frame.Zoom = 1.5f;         // clamped to the theme's zoom limits
```

---

## Applying a style from code

```csharp
[SerializeField] private MapPresenterBase presenter;
[SerializeField] private MapStylePreset nightStyle;

void EnterNightMode()
{
    presenter.ApplyStyle(nightStyle);   // rebuilds and repaints every live view
}
```

To read resolved values without an asset:

```csharp
CompiledMapStyle style = presenter.Style;   // never null
Color accent = style.Palette.Accent;
float nodeSize = style.Node.Size;
```

`MapStyleDefaults.Resolve(preset)` also never returns null -- it falls back to Slate
Nocturne -- so you never need a null branch.

## Custom node art

If you would rather ship your own node art than have BranchWeaver draw it, assign a
**Canvas Prefab** or **World Prefab** on the node type. BranchWeaver detects that the
prefab supplies its own graphic and honours it, falling back to a rounded sprite rather
than overwriting your art.

You keep state colours and transitions; you lose the shader's shape, glow, and ring.

## Performance

Materials are pooled per unique parameter set by a pool component created on the canvas
root. Identical nodes share one material and batch together; an animating edge quantizes
its dash offset so it does not allocate a new material per frame.

The pool is owned by a component, not by static state, so its materials are destroyed
with the map rather than surviving a scene unload.

## If the map looks flat

See [Troubleshooting](../how-to/troubleshooting.md#the-map-looks-flat).

## Next

- **[Runtime integration](../how-to/runtime-integration.md)** -- drive traversal from code.
