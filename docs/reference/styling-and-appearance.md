# Styling and appearance

28 types in this area.

!!! abstract "On this page"
    [CanvasMapNodeStyling](#canvasmapnodestyling) &middot; [CompiledMapNodeStates](#compiledmapnodestates) &middot; [CompiledMapStyle](#compiledmapstyle) &middot; [IMapStyledView](#imapstyledview) &middot; [MapBackdropTokens](#mapbackdroptokens) &middot; [MapEasing](#mapeasing) &middot; [MapEdgeCap](#mapedgecap) &middot; [MapEdgeStyleTokens](#mapedgestyletokens) &middot; [MapFillMode](#mapfillmode) &middot; [MapFitMode](#mapfitmode) &middot; [MapFramingTokens](#mapframingtokens) &middot; [MapMaterialPool](#mapmaterialpool) &middot; [MapMotionTokens](#mapmotiontokens) &middot; [MapNodeShape](#mapnodeshape) &middot; [MapNodeStateStyle](#mapnodestatestyle) &middot; [MapNodeStyleTokens](#mapnodestyletokens) &middot; [MapPaletteTokens](#mappalettetokens) &middot; [MapStyleBrowserWindow](#mapstylebrowserwindow) &middot; [MapStyleDefaults](#mapstyledefaults) &middot; [MapStylePreset](#mapstylepreset) &middot; [MapStylePresetEditor](#mapstylepreseteditor) &middot; [MapStylePreviewRenderer](#mapstylepreviewrenderer) &middot; [MapStyleRuntime](#mapstyleruntime) &middot; [MapSurfaceGraphic](#mapsurfacegraphic) &middot; [MapSurfaceMode](#mapsurfacemode) &middot; [MapSurfaceRequest](#mapsurfacerequest) &middot; [MapSurfaceTokens](#mapsurfacetokens) &middot; [MapTypographyTokens](#maptypographytokens)

## CanvasMapNodeStyling

```csharp
public static class CanvasMapNodeStyling
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapNodeStyling.cs</small>

Turns a node's compiled type, visual state, and fog state into the surface
request that draws it.

Keeping this a pure function of its inputs means the same mapping drives the
runtime views, the Map Studio graph, and the Style Browser previews, so what
an author sees while editing is what ships. It also makes the mapping
directly testable without a canvas.

**Methods**

`public static MapSurfaceRequest BuildBackdrop(CompiledMapStyle style)`

:   Builds the surface request for the map backdrop.

`public static MapSurfaceRequest BuildEdgeSegment()`

:   Builds the surface request for one straight edge segment.

`public static MapSurfaceRequest BuildNode()`

:   Builds the surface request for one node.

---

## CompiledMapNodeStates

```csharp
public sealed class CompiledMapNodeStates
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStylePreset.cs</small>

The resolved per-state node treatments for one style.

**Constructors**

`public CompiledMapNodeStates()`

:   &mdash;

**Properties**

`public MapNodeStateStyle Available`

:   &mdash;

`public MapNodeStateStyle Completed`

:   &mdash;

`public MapNodeStateStyle Current`

:   &mdash;

`public MapNodeStateStyle Hidden`

:   &mdash;

`public MapNodeStateStyle Locked`

:   &mdash;

`public MapNodeStateStyle Visited`

:   &mdash;

---

## CompiledMapStyle

```csharp
public sealed class CompiledMapStyle
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStylePreset.cs</small>

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

```csharp
public interface IMapStyledView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapStyledViewContracts.cs</small>

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

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

---

## MapEasing

```csharp
public enum MapEasing
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

---

## MapFillMode

```csharp
public enum MapFillMode
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

Where the map sits inside the area it is given, and how far the player may
pan and zoom.

This is the surface behind making a map adjustable on screen: reserve space
for your own interface with the margins, choose how the map fits, and clamp
the camera so a player cannot lose the map off-screen.

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

`public MapFramingTokens Sanitized()`

:   Clamps every token into its supported range.

---

## MapMaterialPool

```csharp
public sealed class MapMaterialPool : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapStyleRuntime.cs</small>

Reference-counted material pool for map surfaces, owned by a component
rather than by static state.

A static cache would survive a domain reload and a scene unload and then
hand out destroyed materials. Anchoring the pool to the presenter's
hierarchy gives every material a real owner: when the map goes away, so do
its materials.

The shader is loaded from Resources rather than found by name so it
survives build shader stripping without the buyer editing Always Included
Shaders. If it cannot load, callers fall back to their default material,
which draws a plain quad instead of a magenta error surface.

**Properties**

`public int CachedMaterialCount`

:   Live cached material count; useful in tests and profiling.

`public bool IsShaderAvailable`

:   True when the map surface shader is available.

**Methods**

`public Material Acquire(MapSurfaceRequest request)`

:   Returns a material for `request`, sharing an existing one when the parameters match exactly.

`public void Clear()`

:   Destroys every pooled material. Safe to call repeatedly.

`public static MapMaterialPool EnsureFor(Component owner)`

:   Finds the pool owning `owner`, creating one on the nearest canvas root, or on the owner's own root, when absent.

`public void Release(Material material)`

:   Drops one reference to a pooled material.

---

## MapMotionTokens

```csharp
public struct MapMotionTokens
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`public MapMotionTokens Sanitized()`

:   Clamps every token into its supported range.

`public float Scale(float seconds)`

:   The effective duration for `seconds` under this style.

---

## MapNodeShape

```csharp
public enum MapNodeShape
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`public MapNodeStateStyle Sanitized()`

:   Clamps every token into its supported range.

---

## MapNodeStyleTokens

```csharp
public struct MapNodeStyleTokens
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

---

## MapPaletteTokens

```csharp
public struct MapPaletteTokens
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

## MapStyleBrowserWindow

```csharp
public sealed class MapStyleBrowserWindow : EditorWindow
```

`BranchWeaver.Editor.Styles` &middot; <small>Editor/Styles/MapStyleBrowserWindow.cs</small>

Browse the shipped map styles, preview them with the real shader, and turn
any of them into an editable asset in one click.

This window exists because the package previously offered no way to discover
or create a look: an author had to create a blank theme and fill in two
colour fields with no preview. "Create editable copy" is the intended entry
point for authoring a custom style.

**Fields**

`public MapStylePreset Asset`

:   &mdash;

`public bool IsShipped`

:   &mdash;

`public CompiledMapStyle Style`

:   &mdash;

**Methods**

`public static void Open()`

:   &mdash;

`public void Refresh()`

:   Rebuilds the list from shipped styles plus project assets.

---

## MapStyleDefaults

```csharp
public static class MapStyleDefaults
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleDefaults.cs</small>

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

```csharp
public sealed class MapStylePreset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStylePreset.cs</small>

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

## MapStylePresetEditor

```csharp
public sealed class MapStylePresetEditor : UnityEditor.Editor
```

`BranchWeaver.Editor.Styles` &middot; <small>Editor/Styles/MapStylePresetEditor.cs</small>

Inspector for `apStylePreset` with a live preview above the
fields.

Editing a colour or a corner radius and seeing the result immediately is the
difference between a customization surface an author will actually use and a
wall of numbers they will not. The preview is drawn with the shipped shader
through the shipped token mapping, so what is shown here is what ships.

**Methods**

`public override bool HasPreviewGUI()`

:   &mdash;

`public override void OnInspectorGUI()`

:   &mdash;

`public override void OnPreviewGUI(Rect rect, GUIStyle background)`

:   &mdash;

---

## MapStylePreviewRenderer

```csharp
public sealed class MapStylePreviewRenderer : IDisposable
```

`BranchWeaver.Editor.Styles` &middot; <small>Editor/Styles/MapStylePreviewRenderer.cs</small>

Draws map style previews in editor windows and inspectors using the same
shader and the same token mapping the runtime views use.

Reusing the real shader matters: a preview drawn with editor primitives
would drift from the shipped look, and an author who picks a style from a
lying thumbnail has been misled. Node colours, shapes, glow, rings, edge
caps, and dashes all come from `anvasMapNodeStyling`, so the
preview and the running map cannot diverge.

This is an instance type rather than a static helper so its material has a
real owner: a static material would survive a reload with Domain Reload
disabled and then be handed out destroyed. Owners create one in
`OnEnable` and `ispose` it in `OnDisable`.

**Properties**

`public bool CanRenderSurfaces`

:   True when the map surface shader is available.

**Methods**

`public void Dispose()`

:   Releases the preview material.

`public void DrawMapPreview(Rect rect, CompiledMapStyle style)`

:   Draws a small sample map: backdrop, a branching set of routes, and one node per visual state. Enough to judge a style without entering play mode.

`public void DrawNode()`

:   Draws one node in a given visual state.

`public void DrawPalette(Rect rect, MapPaletteTokens palette)`

:   Draws the palette as a row of swatches.

`public void DrawSurface(Rect rect, MapSurfaceRequest request)`

:   Draws one surface request into `rect`.

---

## MapStyleRuntime

```csharp
public static class MapStyleRuntime
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapStyleRuntime.cs</small>

Bridges an authored `ompiledMapStyle` to runtime visual state.

The visual-state enum belongs to this assembly, so the mapping lives here
rather than on the style itself; that keeps BranchWeaver.Authoring free of
any dependency on the runtime assembly.

**Methods**

`public static float FogOpacity(MapFogState fog)`

:   The opacity multiplier a fog state contributes, layered on top of the per-state opacity so fog and state emphasis compose rather than fight.

`public static void ResolveNodeColors()`

:   Resolves the final node colours for a state: the node type's identity colour adjusted by the style's brightness and opacity, plus the second gradient stop derived from the style's spread.

`public static Color Shift(Color value, float amount)`

:   Lightens (positive) or darkens (negative) without changing alpha.

`public static MapNodeStateStyle StateStyle(CompiledMapStyle style, MapNodeVisualState state)`

:   The per-state treatment for one runtime visual state.

---

## MapSurfaceGraphic

```csharp
public sealed class MapSurfaceGraphic : Image
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/MapSurfaceGraphic.cs</small>

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

## MapSurfaceMode

```csharp
public enum MapSurfaceMode
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapStyleRuntime.cs</small>

What a map surface material draws.

| Value | Meaning |
| --- | --- |
| `Shape` | A node, ring, or backdrop shape. |
| `Edge` | One straight edge segment with caps and optional dashes. |

---

## MapSurfaceRequest

```csharp
public struct MapSurfaceRequest
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapStyleRuntime.cs</small>

The complete parameter set for one map surface material. Two surfaces with
identical parameters share a material and therefore batch together, which
keeps a map of many same-looking nodes cheap.

**Fields**

`public float ArrowLength`

:   &mdash;

`public bool CapEnd`

:   &mdash;

`public float CornerRadius`

:   &mdash;

`public float DashGap`

:   &mdash;

`public float DashLength`

:   &mdash;

`public float DashOffset`

:   &mdash;

`public MapEdgeCap EdgeCap`

:   &mdash;

`public float EdgeLength`

:   &mdash;

`public float EdgeWidth`

:   &mdash;

`public Vector2 Extent`

:   &mdash;

`public MapFillMode FillMode`

:   &mdash;

`public Color FillPrimary`

:   &mdash;

`public Color FillSecondary`

:   &mdash;

`public Color GlowColor`

:   &mdash;

`public float GlowIntensity`

:   &mdash;

`public float GlowRadius`

:   &mdash;

`public float GradientAngleDegrees`

:   &mdash;

`public Color GridColor`

:   &mdash;

`public float GridLineWidth`

:   &mdash;

`public float GridSpacing`

:   &mdash;

`public MapSurfaceMode Mode`

:   &mdash;

`public Color RingColor`

:   &mdash;

`public float RingGap`

:   &mdash;

`public float RingWidth`

:   &mdash;

`public Color ShadowColor`

:   &mdash;

`public Vector2 ShadowOffset`

:   &mdash;

`public float ShadowRadius`

:   &mdash;

`public MapNodeShape Shape`

:   &mdash;

`public Vector2 Size`

:   &mdash;

`public Color StrokeColor`

:   &mdash;

`public float StrokeWidth`

:   &mdash;

`public float VignetteSoftness`

:   &mdash;

`public float VignetteStrength`

:   &mdash;

**Methods**

`public void ApplyTo(Material material)`

:   Writes every request value onto a material.

`public string Key()`

:   A stable key over every value that reaches the material. Lengths and sizes quantize to whole pixels and the dash offset to 1/4 pixel, so a flowing edge does not allocate a new material every frame.

---

## MapSurfaceTokens

```csharp
public struct MapSurfaceTokens
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

---

## MapTypographyTokens

```csharp
public struct MapTypographyTokens
```

`BranchWeaver.Authoring` &middot; <small>Runtime/Authoring/MapStyleTokens.cs</small>

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

`public MapTypographyTokens Sanitized()`

:   Clamps every token into its supported range.

---

