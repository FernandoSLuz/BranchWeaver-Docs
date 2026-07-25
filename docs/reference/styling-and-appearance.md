# Styling and appearance

19 types in this area.

!!! abstract "On this page"
    [CompiledMapStyle](#compiledmapstyle) &middot; [IMapStyledView](#imapstyledview) &middot; [MapBackdropTokens](#mapbackdroptokens) &middot; [MapEasing](#mapeasing) &middot; [MapEdgeCap](#mapedgecap) &middot; [MapEdgeStyleTokens](#mapedgestyletokens) &middot; [MapFillMode](#mapfillmode) &middot; [MapFitMode](#mapfitmode) &middot; [MapFramingTokens](#mapframingtokens) &middot; [MapMotionTokens](#mapmotiontokens) &middot; [MapNodeShape](#mapnodeshape) &middot; [MapNodeStateStyle](#mapnodestatestyle) &middot; [MapNodeStyleTokens](#mapnodestyletokens) &middot; [MapPaletteTokens](#mappalettetokens) &middot; [MapStyleDefaults](#mapstyledefaults) &middot; [MapStylePreset](#mapstylepreset) &middot; [MapSurfaceGraphic](#mapsurfacegraphic) &middot; [MapSurfaceTokens](#mapsurfacetokens) &middot; [MapTypographyTokens](#maptypographytokens)

## CompiledMapStyle

```csharp
public sealed class CompiledMapStyle
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStylePreset.cs</small>

The immutable style the views read. Built either from a
`apStylePreset` asset or from `apStyleDefaults`,
so the map always has a complete, valid look even when no asset is
assigned.

**Constructors**

`public CompiledMapStyle()`

:   &mdash;

**Properties**

`public MapBackdropTokens Backdrop`

:   &mdash;

`public string Description`

:   &mdash;

`public string DisplayName`

:   &mdash;

`public MapEdgeStyleTokens Edge`

:   &mdash;

`public MapFramingTokens Framing`

:   &mdash;

`public MapMotionTokens Motion`

:   &mdash;

`public MapNodeStyleTokens Node`

:   &mdash;

`public MapPaletteTokens Palette`

:   &mdash;

`public string StableIdText`

:   &mdash;

`public CompiledMapNodeStates States`

:   &mdash;

`public MapTypographyTokens Typography`

:   &mdash;

**Methods**

`public Color EdgeColor(bool traversed, bool leadsToAvailable, bool locked)`

:   The edge colour for a route, chosen from the traversal roles so an available route reads differently from one already walked.

`public Font ResolveFont()`

:   The font labels are drawn with, falling back to Unity's built-in runtime font so no third-party font ships with the package.

---

## IMapStyledView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapStyledView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapStyledViewContracts.cs</small>

Implemented by a view that can be dressed by a map style and advanced by a
visual clock.

The presenter discovers this optionally, so a customer's own view
implementation keeps working without it. A view that does not implement it
simply renders unstyled, exactly as before styles existed.

---

## MapBackdropTokens

```csharp
public struct MapBackdropTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

The backdrop drawn behind the map.

**Fields**

`public float GridLineWidth`

:   &mdash;

`public float GridSpacing`

:   &mdash;

`public MapSurfaceTokens Surface`

:   &mdash;

`public float VignetteSoftness`

:   &mdash;

`public float VignetteStrength`

:   &mdash;

`public bool Visible`

:   &mdash;

**Methods**

`public MapBackdropTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. The nested surface tokens are sanitized with it.

---

## MapEasing

```csharp
public enum MapEasing
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Easing curve for a styled transition.

| Value | Meaning |
| --- | --- |
| `Linear` | Constant rate. |
| `EaseIn` | Accelerates from rest. |
| `EaseOut` | Decelerates into rest. |
| `EaseInOut` | Accelerates then decelerates. |
| `BackOut` | Overshoots slightly then settles. |

---

## MapEdgeCap

```csharp
public enum MapEdgeCap
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

End treatment for a drawn edge.

| Value | Meaning |
| --- | --- |
| `Butt` | Flat cut at the endpoint. |
| `Round` | Semicircular cap. |
| `Arrow` | Arrowhead pointing at the target node. |

---

## MapEdgeStyleTokens

```csharp
public struct MapEdgeStyleTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

How routes between nodes are drawn.

The previous renderer chained flat rectangles, which showed hard seams on
every curve and could not taper, cap, or animate. These tokens drive a
distance-field stroke instead.

**Fields**

`public float ArrowLength`

:   &mdash;

`public float AvailableWidthScale`

:   &mdash;

`public MapEdgeCap Cap`

:   &mdash;

`public float DashGap`

:   &mdash;

`public float DashLength`

:   &mdash;

`public float FlowSpeed`

:   &mdash;

`public float GlowIntensity`

:   &mdash;

`public float GlowRadius`

:   &mdash;

`public float NodeClearance`

:   &mdash;

`public float Width`

:   &mdash;

**Methods**

`public MapEdgeStyleTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. An available width scale of zero or less becomes 1.

---

## MapFillMode

```csharp
public enum MapFillMode
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

How a surface fills its area.

| Value | Meaning |
| --- | --- |
| `Flat` | A single flat colour. |
| `LinearGradient` | Two-stop linear gradient. |
| `RadialGradient` | Two-stop radial gradient from the centre. |

---

## MapFitMode

```csharp
public enum MapFitMode
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

How the map is fitted into the area it is given.

| Value | Meaning |
| --- | --- |
| `Fit` | Scale so the whole map is visible, preserving aspect. |
| `Fill` | Scale so the area is covered, cropping the overflow. |
| `FixedScale` | Use an explicit scale and ignore the area size. |
| `Stretch` | Stretch to the area, ignoring aspect. |

---

## MapFramingTokens

```csharp
public struct MapFramingTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Where the map sits inside the area it is given, and how far the player may
pan and zoom.

This is the surface behind making a map adjustable on screen: reserve space
for your own interface with the margins, choose how the map fits, and clamp
the camera so a player cannot lose the map off-screen.

**Properties**

`public bool IsHorizontalFlow`

:   True when this direction lays progress out horizontally.

**Fields**

`public bool AllowPan`

:   &mdash;

`public bool AllowZoom`

:   &mdash;

`public bool ClampPanToContent`

:   &mdash;

`public float ContentPadding`

:   &mdash;

`public MapFitMode FitMode`

:   &mdash;

`public float FixedScale`

:   &mdash;

`public MapFlowDirection FlowDirection`

:   &mdash;

`public float MarginBottom`

:   &mdash;

`public float MarginLeft`

:   &mdash;

`public float MarginRight`

:   &mdash;

`public float MarginTop`

:   &mdash;

`public float PanOverscroll`

:   &mdash;

`public bool RespectSafeArea`

:   &mdash;

**Methods**

`public Vector2 Orient(Vector2 normalized, bool progressIsVertical)`

:   Transforms a normalized position for display in this flow direction. `progressIsVertical` comes from the theme's orientation: it says which axis the layout advanced layers along. The result is a normalized position in screen terms, where y increases upward.

`public MapFramingTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. A fixed scale of zero or less becomes 1, and the direction, fit mode, and pan and zoom switches are carried across untouched.

---

## MapMotionTokens

```csharp
public struct MapMotionTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Transition timings. Every duration scales by `otionScale`.

**Fields**

`public float CurrentPulseAmount`

:   &mdash;

`public float CurrentPulseSeconds`

:   &mdash;

`public MapEasing Easing`

:   &mdash;

`public float FocusSeconds`

:   &mdash;

`public float MotionScale`

:   &mdash;

`public bool ReduceMotion`

:   &mdash;

**Methods**

`public static float Ease(MapEasing easing, float t)`

:   Evaluates `easing` at normalized time.
    - `t` &mdash; Normalized time. Clamped into 0-1 before evaluating.
    - **Returns** &mdash; The eased fraction: 0 at the start and exactly 1 at the end. `apEasing.BackOut` rises above 1 in between, so a caller interpolating with it must tolerate overshoot.

`public MapMotionTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. `educeMotion` and `asing` are carried across untouched.

`public float Scale(float seconds)`

:   The effective duration for `seconds` under this style.
    - **Returns** &mdash; Zero while `educeMotion` is set, otherwise `seconds` times `otionScale`. Never negative.

---

## MapNodeShape

```csharp
public enum MapNodeShape
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Silhouette drawn for a map node.

| Value | Meaning |
| --- | --- |
| `RoundedRect` | Rounded rectangle honouring the corner radius. |
| `Circle` | Circle inscribed in the node box. |
| `Hexagon` | Hexagon inscribed in the node box. |
| `Diamond` | Diamond inscribed in the node box. |
| `Capsule` | Capsule: fully rounded on the shorter axis. |

---

## MapNodeStateStyle

```csharp
public struct MapNodeStateStyle
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Per-state treatment layered over the shared node style.

The node type asset still owns each state's identity colour; this controls
how that colour is presented, so one style restyles every node type at once
without touching a single node type asset.

**Fields**

`public float FillBrightness`

:   &mdash;

`public float GlowScale`

:   &mdash;

`public float Opacity`

:   &mdash;

`public float RingWidth`

:   &mdash;

`public float Scale`

:   &mdash;

`public bool ShowLabel`

:   &mdash;

`public bool ShowRing`

:   &mdash;

**Methods**

`public static MapNodeStateStyle Plain(bool showLabel)`

:   A plain state treatment at full brightness and opacity.
    - **Returns** &mdash; A treatment at the authored size with no glow and no ring, showing the label only when `showLabel` is set.

`public MapNodeStateStyle Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. A scale of zero or less becomes 1, so zeroing the scale does not shrink a node away.

---

## MapNodeStyleTokens

```csharp
public struct MapNodeStyleTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Shape and size shared by every node before per-state treatment.

**Fields**

`public float CornerRadius`

:   &mdash;

`public float IconInset`

:   &mdash;

`public MapNodeShape Shape`

:   &mdash;

`public float Size`

:   &mdash;

`public MapSurfaceTokens Surface`

:   &mdash;

`public bool TintIcon`

:   &mdash;

**Methods**

`public MapNodeStyleTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. The nested surface tokens are sanitized with it.

---

## MapPaletteTokens

```csharp
public struct MapPaletteTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

The semantic colour roles a style assigns once and reuses everywhere.

Node type assets keep owning their own per-state identity colours; these
roles cover everything around them, so changing an accent restyles edges,
focus rings, and labels together.

**Fields**

`public Color Accent`

:   &mdash;

`public Color BackgroundBottom`

:   &mdash;

`public Color BackgroundTop`

:   &mdash;

`public Color EdgeAvailable`

:   &mdash;

`public Color EdgeDefault`

:   &mdash;

`public Color EdgeLocked`

:   &mdash;

`public Color EdgeTraversed`

:   &mdash;

`public Color FocusRing`

:   &mdash;

`public Color GridColor`

:   &mdash;

`public Color TextMuted`

:   &mdash;

`public Color TextPrimary`

:   &mdash;

`public Color TextSecondary`

:   &mdash;

---

## MapStyleDefaults

```csharp
public static class MapStyleDefaults
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleDefaults.cs</small>

The shipped map styles, defined in code rather than as serialized assets.

Two reasons. First, the map always has a complete, valid look even when a
scene assigns no style asset, so the package never renders as flat
untreated squares. Second, no texture, font, or material is redistributed,
which keeps the provenance audit clean; every look is drawn procedurally
from these numbers.

The Style Browser turns any of these into an editable
`apStylePreset` asset via "Create editable copy".

**Fields**

`public float CornerRadius`

:   &mdash;

`public float DashGap`

:   &mdash;

`public float DashLength`

:   &mdash;

`public MapEdgeCap EdgeCap`

:   &mdash;

`public float EdgeWidth`

:   &mdash;

`public MapFillMode FillMode`

:   &mdash;

`public float FlowSpeed`

:   &mdash;

`public float GlowIntensity`

:   &mdash;

`public float GlowRadius`

:   &mdash;

`public float GradientSpread`

:   &mdash;

`public float ShadowRadius`

:   &mdash;

`public MapNodeShape Shape`

:   &mdash;

`public float StrokeWidth`

:   &mdash;

**Methods**

`public static IReadOnlyList<CompiledMapStyle> All()`

:   Every shipped style, in browser order.

`public static MapNodeStateStyle AvailableState()`

:   An available node: full brightness with a soft glow.

`public static MapNodeStateStyle CompletedState()`

:   A completed node: settled, no glow.

`public static MapNodeStateStyle CurrentState()`

:   The current node: largest, ringed, and brightest.

`public static CompiledMapStyle Default()`

:   The style used when a scene assigns none.

`public static MapFramingTokens DefaultFraming()`

:   On-screen framing shared by every shipped style.

`public static MapMotionTokens DefaultMotion()`

:   Transition timings shared by every shipped style.

`public static MapTypographyTokens DefaultTypography()`

:   Label sizing shared by every shipped style.

`public static MapNodeStateStyle HiddenState()`

:   A hidden node: fully transparent rather than absent. The label object is kept (at zero opacity) instead of being destroyed, so revealing a node does not have to rebuild its label, and so callers can still inspect it. Visibility comes from opacity alone.

`public static MapNodeStateStyle LockedState()`

:   A locked node: dimmed and slightly smaller.

`public static CompiledMapStyle MinimalMono()`

:   Light, flat, glowless; the neutral base to customize from.

`public static MapPaletteTokens MinimalMonoPalette()`

:   Light, flat, glowless. The neutral base to customize from. The accent is a saturated blue rather than the near-black used for text and borders. On a light backdrop an almost-black accent makes a reachable node darker than a locked one, which inverts the reading order: the node the player can actually use must be the most prominent, not the least.

`public static CompiledMapStyle NeonCircuit()`

:   Deep indigo with neon hex nodes and flowing routes.

`public static MapPaletteTokens NeonCircuitPalette()`

:   Deep indigo with saturated neon rims. The loudest look.

`public static CompiledMapStyle ParchmentAtlas()`

:   Warm paper with inked circular nodes and dashed routes.

`public static MapPaletteTokens ParchmentAtlasPalette()`

:   Warm paper and ink. Suits adventure and campaign framing.

`public static CompiledMapStyle Resolve(MapStylePreset preset)`

:   Resolves the style a view should draw with: the assigned asset when present, otherwise the shipped default. Never returns null, so callers need no null branch.

`public static CompiledMapStyle SlateNocturne()`

:   Dark slate with cyan routes and an amber focus ring.

`public static MapBackdropTokens SlateNocturneBackdrop()`

:   The default backdrop, used to seed a new preset asset.

`public static MapEdgeStyleTokens SlateNocturneEdge()`

:   The default edge style, used to seed a new preset asset.

`public static MapNodeStyleTokens SlateNocturneNode()`

:   The default node style, used to seed a new preset asset.

`public static MapPaletteTokens SlateNocturnePalette()`

:   Dark slate with cyan and amber accents. The default look.

`public static bool TryFind(string stableId, out CompiledMapStyle style)`

:   Finds a shipped style by its stable id.

`public static MapNodeStateStyle VisitedState()`

:   A visited node: present but receded.

---

## MapStylePreset

:material-star: **Start here**

```csharp
public sealed class MapStylePreset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStylePreset.cs</small>

Everything the map draws itself with, in one asset: palette, node shape and
treatment, per-state emphasis, edge stroke, backdrop, typography, motion,
and on-screen framing.

A style is presentation-only. It never enters a graph, a save envelope, a
fingerprint, or a generation result, so switching styles can never change a
generated map or invalidate a save.

This sits alongside `apThemeAsset` rather than replacing it.
The theme keeps owning layout spacing, orientation, edge geometry, and zoom
limits, because those values participate in compilation. Existing themes and
saved blueprints keep working untouched.

**Properties**

`public string Description`

:   Description shown in the Style Browser.

`public string DisplayName`

:   Name shown in the Style Browser.

`public string StableIdText`

:   Persistent style identity.

**Methods**

`public CompiledMapStyle Compile()`

:   Resolves this asset into the immutable value set the views consume. Out-of-range authored values are clamped rather than rejected, so a half-edited style still renders instead of throwing at runtime.

`public void CopyFrom(CompiledMapStyle source, string newStableId, string newDisplayName)`

:   Overwrites every field from `source`. Used by "Create editable copy" in the Style Browser; it is the supported way to author a style from code.

---

## MapSurfaceGraphic

```csharp
public sealed class MapSurfaceGraphic : Image
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/MapSurfaceGraphic.cs</small>

Draws one styled map surface as a uGUI graphic through the BranchWeaver map
surface shader. Nodes, focus rings, edge strokes, and the backdrop are all
one of these, so restyling the map means changing token values rather than
swapping prefabs or textures.

The mesh is padded beyond the layout rect so glow, ring, and shadow can
bleed outside the shape without being clipped. Padding is excluded from
layout, so a glowing node still occupies exactly its
`ectTransform` for hit-testing purposes.

It derives from `mage` rather than `askableGraphic`
so that anything already written against the built-in image component --
including `GetComponent()` and `color` -- keeps
working unchanged. The mesh and material are fully overridden, so no image
sprite, type, or border behaviour is inherited.

**Properties**

`public float Padding`

:   Padding in presentation pixels added around the rect so glow, ring, and shadow are not clipped by the quad.

`public MapSurfaceRequest Request`

:   The parameter set this graphic draws.

**Methods**

`public void Apply(MapSurfaceRequest request)`

:   Applies a parameter set and rebuilds the material and mesh.

`public static float ComputePadding(MapSurfaceRequest request)`

:   The padding a request needs for its glow, ring, and shadow.

`public void SetDashOffset(float offset)`

:   Updates only the dash scroll offset. Separate from `pply` so an animated flowing edge does not rebuild its mesh every frame.

---

## MapSurfaceTokens

```csharp
public struct MapSurfaceTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Fill, stroke, glow, and shadow for a drawn surface. Nodes and the backdrop
both resolve to one of these.

**Fields**

`public MapFillMode FillMode`

:   &mdash;

`public float GlowIntensity`

:   &mdash;

`public float GlowRadius`

:   &mdash;

`public float GradientAngleDegrees`

:   &mdash;

`public float GradientSpread`

:   &mdash;

`public Color ShadowColor`

:   &mdash;

`public Vector2 ShadowOffset`

:   &mdash;

`public float ShadowRadius`

:   &mdash;

`public Color StrokeColor`

:   &mdash;

`public float StrokeWidth`

:   &mdash;

**Methods**

`public MapSurfaceTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. The gradient angle wraps into 0-360 rather than clamping, so 370 degrees becomes 10.

---

## MapTypographyTokens

```csharp
public struct MapTypographyTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Label sizing and treatment. Fonts stay optional so none is redistributed.

**Fields**

`public Font Font`

:   &mdash;

`public float LabelOffset`

:   &mdash;

`public int LabelSize`

:   &mdash;

`public float LabelSizeFromNode`

:   &mdash;

`public Color OutlineColor`

:   &mdash;

`public bool UseOutline`

:   &mdash;

**Methods**

`public int ResolveLabelSize(float nodeSize)`

:   The label size for a node of `nodeSize` pixels.
    - `nodeSize` &mdash; Node edge length in presentation pixels.
    - **Returns** &mdash; `abelSize` when `abelSizeFromNode` is zero or less, otherwise that fraction of `nodeSize` rounded to the nearest pixel. Never below 6 either way.

`public MapTypographyTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. The font reference is carried across untouched, empty or not.

---

