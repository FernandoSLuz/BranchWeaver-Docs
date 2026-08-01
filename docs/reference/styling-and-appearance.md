# Styling and appearance

21 types in this area.

!!! abstract "On this page"
    [CompiledMapStyle](#compiledmapstyle) &middot; [IMapStyledView](#imapstyledview) &middot; [MapBackdropTokens](#mapbackdroptokens) &middot; [MapEasing](#mapeasing) &middot; [MapEdgeCap](#mapedgecap) &middot; [MapEdgeStyleTokens](#mapedgestyletokens) &middot; [MapFillMode](#mapfillmode) &middot; [MapFitMode](#mapfitmode) &middot; [MapFramingTokens](#mapframingtokens) &middot; [MapMotionTokens](#mapmotiontokens) &middot; [MapNodeShape](#mapnodeshape) &middot; [MapNodeStateStyle](#mapnodestatestyle) &middot; [MapNodeStyleTokens](#mapnodestyletokens) &middot; [MapPaletteTokens](#mappalettetokens) &middot; [MapStyleDefaults](#mapstyledefaults) &middot; [MapStylePreset](#mapstylepreset) &middot; [MapStyleRuntime](#mapstyleruntime) &middot; [MapSurfaceGraphic](#mapsurfacegraphic) &middot; [MapSurfaceRequest](#mapsurfacerequest) &middot; [MapSurfaceTokens](#mapsurfacetokens) &middot; [MapTypographyTokens](#maptypographytokens)

## CompiledMapStyle

```csharp
public sealed class CompiledMapStyle
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStylePreset.cs</small>

The immutable style the views read. Built either from a
`MapStylePreset` asset or from `MapStyleDefaults`,
so the map always has a complete, valid look even when no asset is
assigned.

**Constructors**

`public CompiledMapStyle()`

:   Assembles a style from token values that are already in range. Nothing is clamped or defaulted here beyond the text fields, so prefer `MapStylePreset.Compile` or `MapStyleDefaults` over building one from raw authored values.
    - `stableIdText` &mdash; Stable identifier for stable; invalid or empty IDs are rejected before mutation.
    - `displayName` &mdash; Input display Name consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `description` &mdash; Input description consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `palette` &mdash; Input palette consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `typography` &mdash; Input typography consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `node` &mdash; Input node consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `states` &mdash; Input states consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `edge` &mdash; Input edge consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `backdrop` &mdash; Input backdrop consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `motion` &mdash; Input motion consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `framing` &mdash; Input framing consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public MapBackdropTokens Backdrop`

:   The surface drawn behind the map. It can be switched off in the preset, which leaves your own scene art visible instead.

`public string Description`

:   The line or two describing the look, shown beside the name in the Style Browser. Empty rather than null when none was authored.

`public string DisplayName`

:   Name to show wherever styles are listed, such as the Style Browser. Empty rather than null when none was supplied.

`public MapEdgeStyleTokens Edge`

:   How routes between nodes are stroked: width, caps, dashes, and clearance. The stroke colour is not here; ask `EdgeColor` for it, since it depends on traversal.

`public MapFramingTokens Framing`

:   Where the map sits on screen and how far the player may pan and zoom around it.

`public MapMotionTokens Motion`

:   Transition timings for focus moves and the current-node pulse. A motion scale of zero, or the reduce-motion flag, makes every transition snap instead.

`public MapNodeStyleTokens Node`

:   Shape, size, and surface treatment shared by every node, before the per-state emphasis in `States` is applied on top.

`public MapPaletteTokens Palette`

:   The semantic colour roles the rest of the style refers to. Elements name a role rather than a colour, so recolouring a role moves everything drawn with it at once.

`public string StableIdText`

:   Identity carried over from the preset this was compiled from, or the shipped style's own ID when it came from `MapStyleDefaults`, which names every look it builds. Empty rather than null when the style was built without one, such as a preset whose ID field was cleared.

`public CompiledMapNodeStates States`

:   Per-state emphasis for hidden, locked, available, current, visited, and completed nodes. Never null: the constructor rejects a style without it, so a view can index it without a guard.

`public MapTypographyTokens Typography`

:   Label sizing and treatment. Its font may be unset, so draw with `ResolveFont` rather than reading the font from here.

**Methods**

`public Color EdgeColor(bool traversed, bool leadsToAvailable, bool locked)`

:   The edge colour for a route, chosen from the traversal roles so an available route reads differently from one already walked.
    - `traversed` &mdash; Whether traversed; false selects the documented conservative behavior.
    - `leadsToAvailable` &mdash; Whether leads To Available; false selects the documented conservative behavior.
    - `locked` &mdash; Whether locked; false selects the documented conservative behavior.
    - **Returns** &mdash; The palette role for the strongest state that applies: locked wins over leads-to-available, which wins over traversed.

`public Font ResolveFont()`

:   The font labels are drawn with, falling back to Unity's built-in runtime font so no third-party font ships with the package.
    - **Returns** &mdash; The complete font outcome; inspect its typed status or diagnostics before consuming payload data.

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

:   The grid line thickness in presentation pixels.

`public float GridSpacing`

:   The distance between grid lines in presentation pixels. Zero hides the grid, and the shipped styles set it to zero whenever `MapPaletteTokens.GridColor` is effectively transparent.

`public MapSurfaceTokens Surface`

:   The surface treatment the backdrop is drawn with. Only `MapSurfaceTokens.FillMode` and `MapSurfaceTokens.GradientAngleDegrees` reach it; a backdrop's stroke, glow, and shadow are forced off. Its gradient stops come from `MapPaletteTokens.BackgroundTop` and `MapPaletteTokens.BackgroundBottom` rather than from the surface itself, so recolouring the palette recolours the backdrop.

`public float VignetteSoftness`

:   Where the vignette begins, measured outward from the centre. Higher values keep more of the middle clear and squeeze the darkening into the edges.

`public float VignetteStrength`

:   How strongly the corners of the backdrop are darkened. Zero leaves it evenly lit.

`public bool Visible`

:   Whether a backdrop is meant to be drawn. Nothing reads it today: the built-in presenters draw no backdrop of their own, and the editor style preview draws these tokens unconditionally. Test it from whatever object supplies your backdrop if you want a style able to switch it off.

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

:   The arrowhead's length in presentation pixels. It is read only while `Cap` is `MapEdgeCap.Arrow`.

`public float AvailableWidthScale`

:   Multiplies `Width` for a route leading to a node the player can reach now. Zero or less becomes 1 when the tokens are sanitized, so this can thicken an available route but never erase one.

`public MapEdgeCap Cap`

:   How the end of a route is finished. A curved route is drawn as a chain of straight segments: `MapEdgeCap.Butt` and `MapEdgeCap.Round` shape every segment in the chain, which is how a round cap hides the joints, while the `MapEdgeCap.Arrow` head is drawn only on the segment meeting the target node, so an arrow appears once at the destination rather than on every joint.

`public float DashGap`

:   The empty space between dashes in presentation pixels. Added to `DashLength` it gives the pattern the period the flow animation scrolls by.

`public float DashLength`

:   The length of one dash in presentation pixels. Zero draws a solid line, and also stops the flow animation, which has no pattern to scroll.

`public float FlowSpeed`

:   How fast the dash pattern scrolls, in whole dash periods per second, with negative values running it backwards. Only a route leading to an available node flows; a static route with a crawling pattern would read as noise. The animation also stops while `MapMotionTokens.ReduceMotion` is set.

`public float GlowIntensity`

:   The route's glow strength. A route that does not lead to an available node glows at a fraction of this, so the reachable path stands out without a second set of edge tokens being authored for it.

`public float GlowRadius`

:   The route's glow radius in presentation pixels.

`public float NodeClearance`

:   The gap intended between a route's end and the node it touches, in presentation pixels. Authored and clamped, but not applied: the built-in views run every route from node centre to node centre, so changing it does not move an edge end. Read it from your own edge view if you want endpoints inset.

`public float Width`

:   The stroke thickness of a route, in presentation pixels.

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

:   Whether the player may pan the map. With it off the pan limits collapse to zero and the map stays centred in its area.

`public bool AllowZoom`

:   Whether the player's zoom multiplier is applied over the fitted scale. With it off the map draws at the fitted scale whatever zoom is set.

`public bool ClampPanToContent`

:   Keeps panning within the map's own bounds, widened by `PanOverscroll`. Turning it off allows a full area's worth of travel in each direction instead, which lets a player drag the map out of sight.

`public float ContentPadding`

:   Extra breathing space kept around the map's content, in presentation pixels. It is added on both sides of each axis before the fit is worked out, so raising it also draws the map slightly smaller.

`public MapFitMode FitMode`

:   How the map is scaled into the area left after margins and padding. Note that `MapFitMode.Stretch` resolves to the same uniform scale as `MapFitMode.Fit`, because a single scale cannot stretch one axis without distorting node shapes.

`public float FixedScale`

:   The scale used when `FitMode` is `MapFitMode.FixedScale`, ignoring how large the area is. Zero or less becomes 1 when the tokens are sanitized.

`public MapFlowDirection FlowDirection`

:   Which way along the theme's layout axis the map's progress runs, applied by `Orient`. It is presentation-only, so reversing it redraws an existing save the other way round rather than regenerating anything.

`public float MarginBottom`

:   The share of the area's height reserved at the bottom.

`public float MarginLeft`

:   The share of the area's width reserved on the left for your own interface. Margins are fractions rather than pixel counts so one style holds up across resolutions.

`public float MarginRight`

:   The share of the area's width reserved on the right.

`public float MarginTop`

:   The share of the area's height reserved at the top.

`public float PanOverscroll`

:   How far past the content's edge a pan may run, as a fraction of the area. It is ignored while `ClampPanToContent` is off, which instead grants at least a full area's travel in each direction.

`public bool RespectSafeArea`

:   Insets the map into the device safe area before the margins are taken, so a notch or a rounded corner cannot sit over a node. The safe area only ever shrinks the area the map may use; it never widens it.

**Methods**

`public Vector2 Orient(Vector2 normalized, bool progressIsVertical)`

:   Transforms a normalized position for display in this flow direction. `progressIsVertical` comes from the theme's orientation: it says which axis the layout advanced layers along. The result is a normalized position in screen terms, where y increases upward.
    - `normalized` &mdash; Input normalized consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `progressIsVertical` &mdash; Whether progress Is Vertical; false selects the documented conservative behavior.
    - **Returns** &mdash; The complete vector2 outcome; inspect its typed status or diagnostics before consuming payload data.

`public MapFramingTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. A fixed scale of zero or less becomes 1, and the direction, fit mode, and pan and zoom switches are carried across untouched.

---

## MapMotionTokens

```csharp
public struct MapMotionTokens
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Transition timings. Every duration scales by `MotionScale`.

**Fields**

`public float CurrentPulseAmount`

:   Whether the current node pulses at all: any value above zero turns the pulse on, and zero holds the node steady, so a style can keep a pulse duration authored and still present a still map. The magnitude is not read. The built-in views pulse the node's glow intensity by a fixed amount rather than swelling its size, so raising this past zero does not widen the swing.

`public float CurrentPulseSeconds`

:   The length of one pulse cycle on the node the player occupies, before `MotionScale` is applied. Zero stops the pulse, and no state other than the current one ever pulses.

`public MapEasing Easing`

:   The curve a focus settle follows. It is the only thing eased: a node's state cross-fade interpolates its colour linearly whatever is set here. Note that `MapEasing.BackOut` overshoots, so a node passes its target size before settling back onto it.

`public float FocusSeconds`

:   How long a node takes to settle after gaining or losing focus, before `MotionScale` is applied. A resolved duration of zero applies the focused size on the same frame it is requested.

`public float MotionScale`

:   Multiplies every duration in the style, through `Scale`. Zero snaps every transition, so a map can be stripped of motion with one value rather than by zeroing each timing in turn.

`public bool ReduceMotion`

:   Skips decorative motion outright: `Scale` reports zero for every duration while it is set, and flowing edges hold still. Drive it from your game's own accessibility setting.

**Methods**

`public static float Ease(MapEasing easing, float t)`

:   Runs ease against validated inputs and returns a complete result rather than exposing partially updated state.
    - `t` &mdash; Normalized time. Clamped into 0-1 before evaluating.
    - `easing` &mdash; Input easing consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The eased fraction: 0 at the start and exactly 1 at the end. `MapEasing.BackOut` rises above 1 in between, so a caller interpolating with it must tolerate overshoot.

`public MapMotionTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. `ReduceMotion` and `Easing` are carried across untouched.

`public float Scale(float seconds)`

:   The effective duration for `seconds` under this style.
    - `seconds` &mdash; Input seconds consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; Zero while `ReduceMotion` is set, otherwise `seconds` times `MotionScale`. Never negative.

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

:   Multiplies the node type's colour for this state, channel by channel, and clamps each channel at 1: below 1 darkens it, above 1 lifts it until its channels saturate. It scales the colour rather than blending it towards white, so a channel already at zero stays at zero. The node type keeps owning the hue, so a style can dim or lift every type at once.

`public float GlowScale`

:   Multiplies the node surface's glow intensity for this state. Zero drops the glow entirely, which is how a quiet state stays quiet without a second set of surface tokens.

`public float Opacity`

:   The node's opacity in this state. Fog multiplies on top of it rather than replacing it, so a concealed node in an already-faded state ends up fainter than either would make it alone.

`public float RingWidth`

:   The ring's thickness in presentation pixels. It has no effect while `ShowRing` is off.

`public float Scale`

:   Multiplies the node's drawn size in this state; 1 is the authored size. The icon inset is taken from the scaled size, so a node grows without its icon crowding the border. Zero or less becomes 1 when the tokens are sanitized, so a state cannot shrink a node out of existence.

`public bool ShowLabel`

:   Whether the node's label is drawn in this state. Only the text is suppressed; the node itself still draws, so a concealed node can keep its silhouette without naming what it holds.

`public bool ShowRing`

:   Draws a ring around the node in this state, in `MapPaletteTokens.FocusRing`. Every shipped style rings the current node and nothing else, which is what makes the player's position findable at a glance.

**Methods**

`public static MapNodeStateStyle Plain(bool showLabel)`

:   A plain state treatment at full brightness and opacity.
    - `showLabel` &mdash; Whether show Label; false selects the documented conservative behavior.
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

:   The corner rounding in presentation pixels. It applies only to `MapNodeShape.RoundedRect`; the other silhouettes derive their own curvature and ignore it.

`public float IconInset`

:   How far a node type's icon is inset inside the node, as a fraction of the node's drawn size. It is a fraction rather than a pixel count so the margin holds when a state scales the node up or down.

`public MapNodeShape Shape`

:   The silhouette every node is drawn with. Shape is a style-wide decision, not a per-node-type one: a node type asset contributes colour and icon, so one style restyles a whole map's geometry.

`public float Size`

:   The intended node edge length in presentation pixels; nodes are square, so the one value covers both axes. The built-in views do not read it. They take a node's size from the presenter's metrics, which derive it from the theme's node spacing, and then apply the per-state `MapNodeStateStyle.Scale` on top, so resizing nodes means editing the theme rather than this value.

`public MapSurfaceTokens Surface`

:   The fill, stroke, glow, and shadow every node shares before its per-state treatment is layered on.

`public bool TintIcon`

:   Recolours a node type's icon with `MapPaletteTokens.TextPrimary` instead of leaving the sprite as authored. Suits single-colour icon sets; leave it off for artwork that carries its own palette.

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

:   The colour of the glow around nodes. Its opacity follows the node's resolved opacity, so the glow recedes with fog and with per-state fading rather than staying lit over a dimmed node.

`public Color BackgroundBottom`

:   The backdrop's second gradient stop. Unlike a node's second stop, which is derived from the node's own colour, this one is taken straight from the palette. It goes unused while the backdrop fill is `MapFillMode.Flat`.

`public Color BackgroundTop`

:   The backdrop's main colour, and the first stop when the backdrop is filled with a gradient.

`public Color EdgeAvailable`

:   The colour of a route leading to a node the player can reach now. These are also the only routes that scroll their dash pattern, take `MapEdgeStyleTokens.AvailableWidthScale`, and glow at full intensity.

`public Color EdgeDefault`

:   The colour of a route none of the other edge roles claim: not walked, not leading anywhere reachable, and not locked.

`public Color EdgeLocked`

:   The colour of a route that cannot be taken. It wins over every other edge role, so a locked route still reads as locked when it also leads to an available node.

`public Color EdgeTraversed`

:   The colour of a route the player has already walked.

`public Color FocusRing`

:   The ring colour drawn around a node whose state treatment sets `MapNodeStateStyle.ShowRing` -- in the shipped styles, the node the player currently occupies. The ring takes the node's own opacity, so it fades with the node instead of floating over a concealed one.

`public Color GridColor`

:   The colour of the optional grid ruled over the backdrop. A fully transparent colour hides the grid whatever `MapBackdropTokens.GridSpacing` is set to.

`public Color TextMuted`

:   The label colour for a locked or hidden node, so the reachable part of the map reads first.

`public Color TextPrimary`

:   The label colour for a node in an ordinary state, and the icon tint when `MapNodeStyleTokens.TintIcon` is enabled.

`public Color TextSecondary`

:   The label colour for a node the player has already visited.

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
`MapStylePreset` asset via "Create editable copy".

**Fields**

`public float CornerRadius`

:   Corner rounding in presentation pixels; only `MapNodeShape.RoundedRect` reads it.

`public float DashGap`

:   Gap between dashes in presentation pixels; only meaningful with a non-zero `DashLength`.

`public float DashLength`

:   Dash length in presentation pixels. Zero draws routes as solid lines.

`public MapEdgeCap EdgeCap`

:   End treatment for a route. Choosing `MapEdgeCap.Arrow` is what gives the recipe a non-zero arrowhead length; the other caps leave it at zero.

`public float EdgeWidth`

:   Route thickness in presentation pixels, before the available-route width multiplier.

`public MapFillMode FillMode`

:   How a node fills its silhouette. It governs nodes only; the backdrop is always built as a linear gradient between the palette's two background colours.

`public float FlowSpeed`

:   Dash scroll speed in whole dash periods -- one `DashLength` plus one `DashGap` -- per second, with negative values running the pattern backwards. It is applied only to routes leading to an available node, so motion marks where the player may go next rather than animating the whole map. Zero holds every route still, as does a zero `DashLength`, which leaves no pattern to scroll.

`public float GlowIntensity`

:   Node glow strength; above 1 reads as bloom with no post-processing stack. It doubles as the look's "how bright is this" signal: routes take half of it, a value above 1 deepens the backdrop vignette, and a value of zero on a palette with dark label text flips the label outline from black to white.

`public float GlowRadius`

:   Node glow radius in presentation pixels. Routes reuse it at half strength, so edge glow stays in proportion to node glow without a second number to keep in step.

`public float GradientSpread`

:   Gradient spread over the node fill, from -1 to 1: negative darkens the second stop and positive lightens it. Ignored while `FillMode` is `MapFillMode.Flat`.

`public float ShadowRadius`

:   Drop-shadow softness in presentation pixels. Zero also zeroes the shadow colour's alpha, so a look with no shadow radius casts nothing rather than a hard black edge.

`public MapNodeShape Shape`

:   Silhouette every node in the style is drawn with.

`public float StrokeWidth`

:   Node border thickness in presentation pixels. The recipe pairs it with a stroke colour of alpha zero, which means "derive the border from the node's own state colour", so a look sets border weight without committing every node type to one border colour.

**Methods**

`public static IReadOnlyList<CompiledMapStyle> All()`

:   Every shipped style, in browser order.
    - **Returns** &mdash; The complete i Read Only List outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapNodeStateStyle AvailableState()`

:   An available node: full brightness with a soft glow.
    - **Returns** &mdash; The complete map Node State Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapNodeStateStyle CompletedState()`

:   A completed node: settled, no glow.
    - **Returns** &mdash; The complete map Node State Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapNodeStateStyle CurrentState()`

:   The current node: largest, ringed, and brightest.
    - **Returns** &mdash; The complete map Node State Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static CompiledMapStyle Default()`

:   The style used when a scene assigns none.
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapFramingTokens DefaultFraming()`

:   On-screen framing shared by every shipped style.
    - **Returns** &mdash; The complete map Framing Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapMotionTokens DefaultMotion()`

:   Transition timings shared by every shipped style.
    - **Returns** &mdash; The complete map Motion Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapTypographyTokens DefaultTypography()`

:   Label sizing shared by every shipped style.
    - **Returns** &mdash; The complete map Typography Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapNodeStateStyle HiddenState()`

:   A hidden node: fully transparent rather than absent. The label object is kept (at zero opacity) instead of being destroyed, so revealing a node does not have to rebuild its label, and so callers can still inspect it. Visibility comes from opacity alone.
    - **Returns** &mdash; The complete map Node State Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapNodeStateStyle LockedState()`

:   A locked node: dimmed and slightly smaller.
    - **Returns** &mdash; The complete map Node State Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static CompiledMapStyle MinimalMono()`

:   Light, flat, glowless; the neutral base to customize from.
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapPaletteTokens MinimalMonoPalette()`

:   Light, flat, glowless. The neutral base to customize from. The accent is a saturated blue rather than the near-black used for text and borders. On a light backdrop an almost-black accent makes a reachable node darker than a locked one, which inverts the reading order: the node the player can actually use must be the most prominent, not the least.
    - **Returns** &mdash; The complete map Palette Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static CompiledMapStyle NeonCircuit()`

:   Deep indigo with neon hex nodes and flowing routes.
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapPaletteTokens NeonCircuitPalette()`

:   Deep indigo with saturated neon rims. The loudest look.
    - **Returns** &mdash; The complete map Palette Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static CompiledMapStyle ParchmentAtlas()`

:   Warm paper with inked circular nodes and dashed routes.
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapPaletteTokens ParchmentAtlasPalette()`

:   Warm paper and ink. Suits adventure and campaign framing.
    - **Returns** &mdash; The complete map Palette Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static CompiledMapStyle Resolve(MapStylePreset preset)`

:   Resolves the style a view should draw with: the assigned asset when present, otherwise the shipped default. Never returns null, so callers need no null branch.
    - `preset` &mdash; Input preset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static CompiledMapStyle SlateNocturne()`

:   Dark slate with cyan routes and an amber focus ring.
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapBackdropTokens SlateNocturneBackdrop()`

:   The default backdrop, used to seed a new preset asset.
    - **Returns** &mdash; The complete map Backdrop Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapEdgeStyleTokens SlateNocturneEdge()`

:   The default edge style, used to seed a new preset asset.
    - **Returns** &mdash; The complete map Edge Style Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapNodeStyleTokens SlateNocturneNode()`

:   The default node style, used to seed a new preset asset.
    - **Returns** &mdash; The complete map Node Style Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapPaletteTokens SlateNocturnePalette()`

:   Dark slate with cyan and amber accents. The default look.
    - **Returns** &mdash; The complete map Palette Tokens outcome; inspect its typed status or diagnostics before consuming payload data.

`public static bool TryFind(string stableId, out CompiledMapStyle style)`

:   Finds a shipped style by its stable id.
    - `stableId` &mdash; Stable identifier for stable; invalid or empty IDs are rejected before mutation.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public static MapNodeStateStyle VisitedState()`

:   A visited node: present but receded.
    - **Returns** &mdash; The complete map Node State Style outcome; inspect its typed status or diagnostics before consuming payload data.

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

This sits alongside `MapThemeAsset` rather than replacing it.
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
    - **Returns** &mdash; The complete compiled Map Style outcome; inspect its typed status or diagnostics before consuming payload data.

`public void CopyFrom(CompiledMapStyle source, string newStableId, string newDisplayName)`

:   Overwrites every field from `source`. Used by "Create editable copy" in the Style Browser; it is the supported way to author a style from code.
    - `source` &mdash; Input source consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `newStableId` &mdash; Identity for this asset. Leave null or empty to keep the source's identity, which produces two assets sharing one style ID.
    - `newDisplayName` &mdash; Name shown in the Style Browser. Leave null or empty to keep the source's name.

---

## MapStyleRuntime

```csharp
public static class MapStyleRuntime
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapStyleRuntime.cs</small>

Bridges an authored `CompiledMapStyle` to runtime visual state.

The visual-state enum belongs to this assembly, so the mapping lives here
rather than on the style itself; that keeps BranchWeaver.Authoring free of
any dependency on the runtime assembly.

**Methods**

`public static float FogOpacity(MapFogState fog)`

:   The opacity multiplier a fog state contributes, layered on top of the per-state opacity so fog and state emphasis compose rather than fight.
    - `fog` &mdash; The derived visibility role to convert.
    - **Returns** &mdash; Zero for hidden, 0.75 for dimmed, and one for visible or unknown values.

`public static void ResolveNodeColors()`

:   Resolves the final node colours for a state: the node type's identity colour adjusted by the style's brightness and opacity, plus the second gradient stop derived from the style's spread.
    - `style` &mdash; The compiled surface style; null disables authored gradient spread and stroke override.
    - `stateColor` &mdash; The node type's identity color before brightness, opacity, and fog are applied.
    - `stateStyle` &mdash; The current state's brightness and opacity treatment.
    - `fog` &mdash; The visibility multiplier layered over state opacity.
    - `primary` &mdash; Receives the clamped identity color with final alpha.
    - `secondary` &mdash; Receives the primary color shifted by authored gradient spread.
    - `stroke` &mdash; Receives the authored stroke with composed alpha, or a brightened identity-derived stroke when authored alpha is zero.

`public static Color Shift(Color value, float amount)`

:   Lightens (positive) or darkens (negative) without changing alpha.
    - `value` &mdash; The source RGBA color; alpha is copied unchanged.
    - `amount` &mdash; RGB interpolation amount: positive moves toward white, negative toward black; values outside -1 to 1 follow `Mathf.Lerp(float,float,float)` extrapolation.
    - **Returns** &mdash; A new color with shifted RGB channels and the original alpha.

`public static MapNodeStateStyle StateStyle(CompiledMapStyle style, MapNodeVisualState state)`

:   The per-state treatment for one runtime visual state.
    - `style` &mdash; The compiled style to query; null selects an opaque plain fallback.
    - `state` &mdash; The progression-derived node role whose fill/scale/opacity treatment is required.
    - **Returns** &mdash; The matching state treatment; unknown enum values use the hidden treatment.

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
`RectTransform` for hit-testing purposes.

It derives from `Image` rather than `MaskableGraphic`
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

:   Updates apply state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `request` &mdash; Input request consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public static float ComputePadding(MapSurfaceRequest request)`

:   The padding a request needs for its glow, ring, and shadow.
    - `request` &mdash; Input request consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete float outcome; inspect its typed status or diagnostics before consuming payload data.

`public void SetDashOffset(float offset)`

:   Updates only the dash scroll offset. Separate from `Apply` so an animated flowing edge does not rebuild its mesh every frame.
    - `offset` &mdash; Input offset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

---

## MapSurfaceRequest

```csharp
public struct MapSurfaceRequest
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapStyleRuntime.cs</small>

The complete parameter set for one map surface material. Two surfaces with
identical parameters share a material and therefore batch together, which
keeps a map of many same-looking nodes cheap.

**Fields**

`public float ArrowLength`

:   Exposes arrow Length as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public bool CapEnd`

:   Exposes cap End as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float CornerRadius`

:   Rounded-corner radius in the surface's local presentation units.

`public float DashGap`

:   Exposes dash Gap as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float DashLength`

:   Exposes dash Length as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float DashOffset`

:   Exposes dash Offset as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public MapEdgeCap EdgeCap`

:   Exposes edge Cap as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float EdgeLength`

:   Exposes edge Length as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float EdgeWidth`

:   Exposes edge Width as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public Vector2 Extent`

:   Shape half-extents used by the signed-distance calculation.

`public MapFillMode FillMode`

:   Selects solid, linear, or radial fill evaluation.

`public Color FillPrimary`

:   Solid color or first gradient stop, including final presentation alpha.

`public Color FillSecondary`

:   Second gradient stop; ignored by a solid fill.

`public Color GlowColor`

:   Color and alpha of the optional outer glow.

`public float GlowIntensity`

:   Multiplier applied to the glow color contribution.

`public float GlowRadius`

:   Soft glow falloff distance outside the shape, in local units.

`public float GradientAngleDegrees`

:   Clockwise orientation of a linear gradient in degrees.

`public Color GridColor`

:   Exposes grid Color as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float GridLineWidth`

:   Exposes grid Line Width as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float GridSpacing`

:   Exposes grid Spacing as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public MapSurfaceMode Mode`

:   Selects node/backdrop shape rendering or edge-segment rendering.

`public Color RingColor`

:   Color used for the optional outer state ring.

`public float RingGap`

:   Clear space between the shape boundary and outer ring, in local units.

`public float RingWidth`

:   Outer state-ring thickness in local presentation units; zero disables it.

`public Color ShadowColor`

:   Color and alpha of the optional shadow.

`public Vector2 ShadowOffset`

:   Shadow displacement from the surface origin in local units.

`public float ShadowRadius`

:   Soft shadow falloff distance in local presentation units.

`public MapNodeShape Shape`

:   Signed-distance shape used when `Mode` is `MapSurfaceMode.Shape`.

`public Vector2 Size`

:   Full material surface width and height in local presentation units.

`public Color StrokeColor`

:   Premultiplier-ready outline color.

`public float StrokeWidth`

:   Outline thickness in local presentation units; zero disables the stroke.

`public float VignetteSoftness`

:   Exposes vignette Softness as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

`public float VignetteStrength`

:   Exposes vignette Strength as part of the map Surface Request data contract; validation rejects values outside the owning type's documented bounds.

**Methods**

`public void ApplyTo(Material material)`

:   Writes every request value onto a material.
    - `material` &mdash; Input material consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public string Key()`

:   A stable key over every value that reaches the material. Lengths and sizes quantize to whole pixels and the dash offset to 1/4 pixel, so a flowing edge does not allocate a new material every frame.
    - **Returns** &mdash; The complete string outcome; inspect its typed status or diagnostics before consuming payload data.

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

:   Whether the surface is a single colour or a two-stop gradient, and which kind of gradient. Where the second stop comes from depends on the surface: the backdrop takes it from the palette, a node derives it from its own colour through `GradientSpread`.

`public float GlowIntensity`

:   The strength of the outer glow. A node's per-state `MapNodeStateStyle.GlowScale` multiplies this, so a state scaled to zero shows no glow however bright the surface is authored.

`public float GlowRadius`

:   How far the outer glow reaches, in presentation pixels. The glow is part of the map surface shader, so it costs no post-processing stack and no second camera.

`public float GradientAngleDegrees`

:   The direction a linear gradient runs, in degrees, with 0 pointing right and 90 pointing up. Values outside 0-360 wrap rather than clamp when the tokens are sanitized.

`public float GradientSpread`

:   How far a node's second gradient stop is pushed from the first: positive lightens it, negative darkens it, zero leaves the two identical. The stop is derived from the node type's own colour rather than authored here, so a single style gradients every node type coherently without a second colour being picked per type.

`public Color ShadowColor`

:   The drop shadow's colour. Its alpha is scaled by the surface's resolved opacity, so a node that fades under fog takes its shadow with it.

`public Vector2 ShadowOffset`

:   How far the drop shadow is displaced from the surface, in presentation pixels.

`public float ShadowRadius`

:   The drop shadow's softness in presentation pixels. Zero draws no shadow.

`public Color StrokeColor`

:   The border colour. A fully transparent colour does not mean "no border": it means derive the border from the surface's own fill, lightened, so every node type keeps a matching outline without the style naming a colour per type.

`public float StrokeWidth`

:   The border thickness in presentation pixels. Zero is how a border is removed; clearing `StrokeColor` does something else.

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

:   The font labels are drawn with. Left empty, Unity's built-in runtime font is used, which is why no font file ships with the package.

`public float LabelOffset`

:   How far the label sits below the node, in presentation pixels. Negative values lift it back up over the node.

`public int LabelSize`

:   The label size in presentation pixels, used when `LabelSizeFromNode` is left at zero. Call `ResolveLabelSize` for the size a view will actually apply.

`public float LabelSizeFromNode`

:   The label size expressed as a fraction of the node's size, so labels stay in proportion as node sizes change. Zero falls back to `LabelSize` unchanged.

`public Color OutlineColor`

:   The outline colour, read only while `UseOutline` is enabled. The shipped styles pick a light or dark outline to oppose the palette's text colour.

`public bool UseOutline`

:   Draws a contrast outline behind labels instead of a drop shadow, which keeps small text legible over both light and dark artwork. The built-in canvas view attaches one effect or the other when a node's label is first created, so changing this at runtime does not restyle labels that already exist.

**Methods**

`public int ResolveLabelSize(float nodeSize)`

:   The label size for a node of `nodeSize` pixels.
    - `nodeSize` &mdash; Node edge length in presentation pixels.
    - **Returns** &mdash; `LabelSize` when `LabelSizeFromNode` is zero or less, otherwise that fraction of `nodeSize` rounded to the nearest pixel. Never below 6 either way.

`public MapTypographyTokens Sanitized()`

:   Clamps every token into its supported range.
    - **Returns** &mdash; A clamped copy; this instance is left as it was. The font reference is carried across untouched, empty or not.

---

