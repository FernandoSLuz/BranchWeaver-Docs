# Style, theme, and the presenter boundary

Three assets decide what a map looks like, and none of them decides what the map *is*.
After this page you can place any appearance setting in the theme, the style, or the node
type, and you will know why nothing on the drawing side is ever asked a question.

## The presenter draws and nothing else

`MapPresenterBase` is handed a `MapGraph`, a `MapProgressionState`, the compiled
`MapRuntimeContent`, and a derived state snapshot. From those it creates, binds, and
releases views. It holds no rules, no legality check, and no traversal history of its own.

| Presenter | Space | Use when |
| --- | --- | --- |
| `CanvasMapPresenter` | Screen-space uGUI | The map is an overlay or a menu screen |
| `WorldMapPresenter` | World-space | The map lives in the scene, with a camera |

Both are driven by the same session, the same compiled content, and the same style, so
swapping one for the other changes where the map is drawn and nothing else.

The two presentation-only methods make the boundary concrete. `ApplyStyle` replaces the
look of a live map and repaints every view; `TickStyle` advances focus easing, the pulse on
the current node, and edge flow. Neither can reach a graph, a save envelope, or a
fingerprint, which is why the Style Browser can preview a look while the game runs.

!!! warning "A dimmed node is a consequence, not a source of truth"
    The presenter dims a node because the session said it was locked. Legality questions go
    to `MapSession` &mdash; see [Core concepts](architecture.md).

## Fog state versus visual state

Every node carries two values that answer different questions. The visual state says what
the player *can do*. The fog state says what the player *knows*.

| Enum | Values |
| --- | --- |
| `MapNodeVisualState` | `Hidden`, `Locked`, `Available`, `Current`, `Visited`, `Completed` |
| `MapFogState` | `Hidden`, `Dimmed`, `Visible` |

### State precedence

`MapRuntimeStateDeriver` resolves each node once, taking the first row that matches:

| Order | State | When |
| --- | --- | --- |
| 1 | `Completed` | The progression state lists the node as completed |
| 2 | `Current` | The traveller occupies it |
| 3 | `Available` | The progression state lists it as available |
| 4 | `Visited` | It was entered earlier in the run |
| 5 | `Locked` | It was discovered within the reveal depth, or Reveal All is on |
| 6 | `Hidden` | Nothing above matched |

So completed beats current, and available beats visited: a node the player may act on never
reads as history. Before the first visit, every node with no incoming edge is discovered, so
a fresh map shows its entry points rather than an empty screen.

### Derived, never stored

Fog follows from the resolved visual state. `Hidden` becomes `Hidden`, `Locked` becomes
`Dimmed`, and everything else becomes `Visible`. An edge takes the more hidden of its two
endpoints, so no route is drawn into a node the player cannot see.

Neither value is written to a save. Both are recomputed from the graph, the progression
state, and the fog settings on `MapTraversalController`, which is why widening Reveal Depth
re-reveals an existing save correctly instead of needing a migration.

Fog and style then compose rather than fight: the per-state treatment resolves first, and
fog multiplies the node's opacity by 0.75 for `Dimmed` and by 0 for `Hidden`. See
[Control what the player can see](../how-to/reveal-and-fog.md).

## Style versus theme

Both exist, and they are not redundant.

| Asset | Owns | Reaches the map through | Compiled |
| --- | --- | --- | --- |
| `MapThemeAsset` | Spacing, orientation, edge geometry, zoom limits, transition duration | `MapRuntimeContent`, passed to `MapTraversalController.Initialize` | **Yes** |
| `MapStylePreset` | Palette, node shape and surface, per-state emphasis, edge stroke, backdrop, typography, motion, framing | The presenter's **Style Preset** field | No |

Theme values participate in producing presentation positions, so they are compiled and
validated: spacing out of range, or a maximum zoom below the minimum, fails compilation with
a `bw.authoring.theme-*` diagnostic. Style values are clamped instead of rejected, so a
half-edited style still draws.

Some settings belong to neither asset:

| Setting | Owner |
| --- | --- |
| Per-state node colour, icon, label, prefab, payload | The node type &mdash; see [Create node types](../how-to/create-node-types.md) |
| How far ahead the map is revealed | `MapTraversalController` |
| Which maps are possible, and which move is legal | The rules asset and `MapSession` |

Two settings pair across the boundary, which is worth knowing before searching the wrong
asset:

- **Direction.** The theme's Orientation picks the axis layers advance along; the style's
  Flow Direction picks which way along it. Both are presentation-only, so a run saved under
  one direction reopens as the same run drawn the other way round.
- **Zoom.** The style's Allow Zoom decides whether the player may zoom at all; the theme's
  Minimum Zoom and Maximum Zoom decide how far.

## What the theme owns

Create one with **Assets > Create > BranchWeaver > Map Theme**. The Setup Wizard takes it in
its **Runtime Theme** field.

| Field | Default | What it changes |
| --- | --- | --- |
| **Stable Id** | `theme.default` | Theme identity. Renaming the asset does not change it. |
| **Orientation** | `Vertical` | Which axis layers advance along. |
| **Layer Spacing** | 100 | Distance between successive layers, in presentation units. |
| **Node Spacing** | 80 | Distance between nodes within a layer. Node size is half of it, never below 16. |
| **Background Color** | Dark slate | Flat backdrop colour, for a view that reads no style. |
| **Edge Color** | Grey-blue | Flat route colour, for a view that reads no style. |
| **Edge Geometry** | `Bezier` | Route shape: `Straight`, `Polyline`, or `Bezier`. |
| **Bezier Segments** | 16 | Segments per curved route. Higher is smoother. |
| **Bezier Control Offset** | 2500 | How far a curve bows, normalised 0-10000. |
| **Minimum Zoom** | 0.5 | Lowest zoom factor the view allows. |
| **Maximum Zoom** | 2.5 | Highest zoom factor the view allows. At most 20. |
| **State Transition Seconds** | 0.15 | How long a node takes to cross-fade between states. At most 60. |

Spacing is capped at 100000 in each direction, and the graph and spacing together must stay
within the supported presentation extent, so a very wide map with very large spacing is
refused rather than silently overflowing.

!!! note "Compiled does not mean part of the map's identity"
    The theme is compiled content because layout needs it, but it takes no part in the
    generation fingerprint. Changing spacing, orientation, or zoom limits redraws the same
    graph &mdash; see [Determinism, seeds, and fingerprints](determinism.md).

## Next

- **[Shape and colour nodes](../how-to/style-nodes.md)** &mdash; silhouette, fill, stroke, glow, and which palette role drives which part.
- **[Control what the player can see](../how-to/reveal-and-fog.md)** &mdash; reveal depth, backtracking, and revealing single nodes.
- **[Place the map on screen](../how-to/place-the-map-on-screen.md)** &mdash; direction, fit, and space reserved for your own interface.
