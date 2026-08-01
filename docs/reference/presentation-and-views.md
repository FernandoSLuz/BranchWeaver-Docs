# Presentation and views

52 types in this area.

!!! abstract "On this page"
    [CanvasMapEdgeView](#canvasmapedgeview) &middot; [CanvasMapNodeView](#canvasmapnodeview) &middot; [CanvasMapPresenter](#canvasmappresenter) &middot; [DefaultMapNodeHitTester](#defaultmapnodehittester) &middot; [IMapAudioCueAdapter](#imapaudiocueadapter) &middot; [IMapBackgroundPresenter](#imapbackgroundpresenter) &middot; [IMapDevelopmentHost](#imapdevelopmenthost) &middot; [IMapEdgeAvailabilityView](#imapedgeavailabilityview) &middot; [IMapEdgeTransitionView](#imapedgetransitionview) &middot; [IMapEdgeView](#imapedgeview) &middot; [IMapEdgeViewFactory](#imapedgeviewfactory) &middot; [IMapFocusIndicatorPresenter](#imapfocusindicatorpresenter) &middot; [IMapFocusView](#imapfocusview) &middot; [IMapInputSource](#imapinputsource) &middot; [IMapLocalizationAdapter](#imaplocalizationadapter) &middot; [IMapNodeHitState](#imapnodehitstate) &middot; [IMapNodeHitTester](#imapnodehittester) &middot; [IMapNodeTransitionView](#imapnodetransitionview) &middot; [IMapNodeView](#imapnodeview) &middot; [IMapNodeViewFactory](#imapnodeviewfactory) &middot; [IMapPresentationTransitionAdapter](#imappresentationtransitionadapter) &middot; [IMapRoutePawnPresenter](#imaproutepawnpresenter) &middot; [IMapViewFactoryLifetime](#imapviewfactorylifetime) &middot; [IPlayerPawnPresenter](#iplayerpawnpresenter) &middot; [IRouteMarkerPresenter](#iroutemarkerpresenter) &middot; [InputSystemSignalAdapter](#inputsystemsignaladapter) &middot; [LegacyMapInputSource](#legacymapinputsource) &middot; [MapCameraBloom](#mapcamerabloom) &middot; [MapDevelopmentCommandResult](#mapdevelopmentcommandresult) &middot; [MapDevelopmentFailureKind](#mapdevelopmentfailurekind) &middot; [MapEdgeViewData](#mapedgeviewdata) &middot; [MapFogSettings](#mapfogsettings) &middot; [MapFogState](#mapfogstate) &middot; [MapInputController](#mapinputcontroller) &middot; [MapInputFrame](#mapinputframe) &middot; [MapNavigationDirection](#mapnavigationdirection) &middot; [MapNavigationModel](#mapnavigationmodel) &middot; [MapNodeRuntimeState](#mapnoderuntimestate) &middot; [MapNodeViewData](#mapnodeviewdata) &middot; [MapNodeVisualState](#mapnodevisualstate) &middot; [MapPresenterBase](#mappresenterbase) &middot; [MapRuntimeContent](#mapruntimecontent) &middot; [MapRuntimeStateDeriver](#mapruntimestatederiver) &middot; [MapRuntimeStateSnapshot](#mapruntimestatesnapshot) &middot; [MapSelectionResult](#mapselectionresult) &middot; [MapSetupHierarchyBinding](#mapsetuphierarchybinding) &middot; [MapSurfaceStyling](#mapsurfacestyling) &middot; [MapTraversalController](#maptraversalcontroller) &middot; [PassthroughLocalizationAdapter](#passthroughlocalizationadapter) &middot; [WorldMapEdgeView](#worldmapedgeview) &middot; [WorldMapNodeView](#worldmapnodeview) &middot; [WorldMapPresenter](#worldmappresenter)

## CanvasMapEdgeView

```csharp
public sealed class CanvasMapEdgeView : MonoBehaviour, IMapEdgeView, IMapEdgeTransitionView, IMapStyledView, IMapEdgeAvailabilityView
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

Draws one edge between two map nodes as a chain of uGUI images, and is the
edge view the Canvas presentation builds by default.

An edge is rendered as a run of straight segments through its points rather
than as a single stretched sprite, so curved and elbowed connections keep an
even thickness. Fog dims or hides the edge, and edges leading to an available
node can animate a flow along their length to draw the eye forward.

**Properties**

`public StableId EdgeId`

:   The edge this view currently stands for, taken from the last `Bind`. Informational: the presenter tracks edges by its own bookkeeping and never reads it back.

`public bool IsTransitioning`

:   Whether a fog cross-fade started by `BeginTransition` is still running. The dash flow is not counted, so a settled edge reports false while it goes on flowing.

`public IReadOnlyList<NormalizedMapPosition> Points`

:   The path last bound, in normalized layout space, running from the edge's source endpoint to its target. Read-only and owned by the bind data, so it does not change until the next bind.

`public IReadOnlyList<Vector2> RenderedPoints`

:   The same path in the anchored positions the segments were actually laid out along, so anything you place on the route -- a traveller, a label, a marker -- can follow the drawn line without repeating the conversion. This is the view's own buffer rather than a copy, and it is rebuilt on every bind, so take a copy of it if you need it to outlive one.

`public Transform Transform`

:   The edge's own transform. The factory parents it under the edge root and pushes it to the front of the sibling order, which in uGUI draws it first and so keeps routes behind the nodes they connect.

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   Advances a fog cross-fade in flight and, when one that ends hidden lands, deactivates the edge. The presenter drives this once a frame on an unscaled delta, so pausing the game does not strand an edge mid-fade. A negative delta counts as none.
    - `deltaSeconds` &mdash; Seconds since the previous advance.

`public void ApplyStyle(CompiledMapStyle style)`

:   Supplies the style this edge draws with.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void BeginTransition(MapFogState fromFog, MapFogState toFog, float durationSeconds)`

:   Cross-fades the edge into the fog state it has just been bound in, and owns its own visibility while doing so. The edge is kept active for the whole fade even when it is on its way to hidden, and deactivated only once the fade lands, so a route fading out is never cut off part-way. A duration of zero or less, or two fog states that resolve to the same colour, applies the destination and its visibility at once.
    - `fromFog` &mdash; Input from Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `toFog` &mdash; Input to Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `durationSeconds` &mdash; Fade time in seconds; zero or less applies the destination immediately.

`public void Bind(MapEdgeViewData data)`

:   Updates bind state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `data` &mdash; Input data consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void CancelTransition(bool applyTerminalState)`

:   Abandons a fog cross-fade in flight, before the edge is bound again or handed back to its factory.
    - `applyTerminalState` &mdash; True to finish by applying the destination colour together with the visibility that belongs to it, which for an edge on its way to hidden means deactivating it; false to leave the edge exactly as it is, because another fade is about to start from there.

`public void PrepareForBind()`

:   Records the colour the segments are showing right now, immediately before a bind that changes fog state, so the fade that follows can carry on from a fade already in flight. An edge with no segments yet -- the state it is in before its first bind -- records fully transparent.

`public void RestoreAfterUnchangedBind()`

:   Re-activates the edge and puts back the colour `PrepareForBind` captured, for a bind that turned out not to change fog state, so a fade in flight is not cut short. Safe to call with nothing captured and with nothing fading, in which case it only clears the capture.

`public void SetActive(bool active)`

:   Shows or hides the edge's whole GameObject. Because this view animates its own fog changes, the presenter stops toggling it on a fog change and leaves visibility to the transition, so in practice this is the pooling switch. It has to be reversible: the same instance is handed back out later.
    - `active` &mdash; False to park the edge, typically because its factory has taken it back.

`public void SetLeadsToAvailable(bool value)`

:   Marks this route as leading to a reachable node. Routes to reachable nodes are drawn thicker and, when the style asks for it, flow toward the destination so the next choice reads at a glance.
    - `value` &mdash; Whether value; false selects the documented conservative behavior.

`public void TickStyle(float presentationDeltaSeconds)`

:   Advances dash flow by a presentation delta.
    - `presentationDeltaSeconds` &mdash; Input presentation Delta Seconds consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

---

## CanvasMapNodeView

```csharp
public sealed class CanvasMapNodeView : MonoBehaviour, IMapNodeView, IMapNodeHitState, IMapNodeTransitionView, IMapFocusView, IMapStyledView
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

Draws one map node as a uGUI element inside a Canvas, and is the node view
the Canvas presentation builds by default.

It owns everything about a node the player can see: position, size, colour,
icon, label, fog, and the focus and transition animations. Sizes and colours
come from the compiled style rather than from the caller, so a current node
can read larger and brighter than a locked one without anyone computing that.

Replace it by supplying your own `IMapNodeView` when you want a
different look; see the World2D counterpart `World2D.WorldMapNodeView`
for the sprite-based equivalent.

**Properties**

`public string DisplayLabel`

:   The label last bound, already through the localization adapter. Empty when the node type declares none; the label is also left undrawn when the style's treatment for the current visual state suppresses it.

`public MapFogState FogState`

:   How fog is treating the node. A dimmed node is drawn at three quarters of its colour's alpha and a hidden one at zero, so a hidden node is transparent rather than deactivated: it stops being clickable instead.

`public bool IsHitTestVisible`

:   Whether a click on the node should count. False while fog hides it and false while its graphic is not a raycast target, so a node the player cannot see cannot be selected by accident.

`public bool IsTransitioning`

:   Whether a colour cross-fade started by `BeginTransition` is still running. Focus easing and the current-node pulse are not counted, so a settled node reports false while it goes on pulsing.

`public StableId NodeId`

:   The node this view currently stands for, taken from the last `Bind`. Empty until the first bind, which is what keeps an unbound pooled instance out of hit testing.

`public NormalizedMapPosition NormalizedPosition`

:   Where the presenter laid the node out, in normalized layout space: the layout-space coordinate rather than the pixels the node ended up at. The shipped presenters resolve the placement themselves and send it with the bind, and the node is drawn at that; this value is only converted against the parent rect when the bind data carries no presentation position.

`public string Tooltip`

:   The tooltip last bound, already localized. Kept for a host that draws its own tooltips; this view never renders it.

`public Transform Transform`

:   The node's own transform. Input resolves a click to this node through it, and the factory parents and orders the node by it, so it stays valid for the component's whole lifetime.

`public MapNodeVisualState VisualState`

:   The traversal state the node was last bound in: hidden, locked, available, current, visited or completed. It is the destination of a state change, not what is on screen: the bind runs before the cross-fade, so this already reads the new state while the colour is still travelling towards it.

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   Advances a colour cross-fade in flight, interpolating straight from the captured start colour to the destination. The presenter drives this once a frame on an unscaled delta, so pausing the game does not strand a node mid-fade. A negative delta counts as none, and the fade stops the moment it reaches the destination.
    - `deltaSeconds` &mdash; Seconds since the previous advance.

`public void ApplyStyle(CompiledMapStyle style)`

:   Supplies the style this node draws with. Optional: without a style the node still renders a flat tinted shape, which is what the headless tests assert against.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void BeginTransition(MapNodeVisualState fromVisual, MapFogState fromFog,)`

:   Cross-fades the node's colour into the state it has just been bound in, carrying the icon and label alpha along with it. The bind has already applied the destination colour, so the fade works by putting the starting colour back and easing forward from there. A fade interrupted part-way resumes from the colour `PrepareForBind` captured, which is what stops states that change in quick succession from jumping. A duration of zero or less, or two states that resolve to the same colour, applies the destination at once and leaves `IsTransitioning` false.
    - `fromVisual` &mdash; Input from Visual consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `fromFog` &mdash; Input from Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `toVisual` &mdash; Input to Visual consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `toFog` &mdash; Input to Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `durationSeconds` &mdash; Fade time in seconds; zero or less applies the destination immediately.

`public void Bind(MapNodeViewData data)`

:   Updates bind state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `data` &mdash; Input data consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void CancelTransition(bool applyTerminalState)`

:   Abandons a cross-fade in flight, before the node is bound again or handed back to its factory. Focus scale and the pulse are left alone.
    - `applyTerminalState` &mdash; True to finish by applying the destination colour, which is what the shipped factory does when it pools a node so the next reuse starts from a settled look; false to leave the node showing the colour the fade had reached, because another fade is about to start from there.

`public void PrepareForBind()`

:   Records the colour on screen right now, immediately before a bind that changes state, so the cross-fade that follows can carry on from a fade already in flight instead of snapping back to the old state. Does nothing on a node that has no graphic yet.

`public void RestoreAfterUnchangedBind()`

:   Puts back the colour `PrepareForBind` captured, for a bind that turned out not to change state, so a fade in flight is not cut short. Safe to call with nothing captured and with nothing fading, in which case it only clears the capture.

`public void SetActive(bool active)`

:   Shows or hides the node's whole GameObject. This is not how fog is applied: the presenter activates a node after every bind, a fogged one included, and hiding is done with alpha instead. In practice this is the pooling switch, so it has to be reversible -- the same instance is handed back out later.
    - `active` &mdash; False to park the node, typically because its factory has taken it back.

`public void SetFocused(bool focused)`

:   Shows or clears the keyboard and gamepad focus treatment, by scaling the node to `FocusScale`. The scale jumps past its destination by `FocusOvershoot` on the frame focus changes and eases back over the style's focus time, so selection reads as immediate instead of as a slow grow. Being told the value it already has re-applies the settled scale without restarting that motion, and with no style, or a focus time of zero, the new scale is simply applied at once.
    - `focused` &mdash; True while this is the focused node.

`public void TickStyle(float deltaSeconds)`

:   Advances focus tweening and the current-node pulse. Driven by the presenter's visual clock so pausing the game pauses the map, and so tests can step it deterministically.
    - `deltaSeconds` &mdash; Input delta Seconds consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

---

## CanvasMapPresenter

:material-star: **Start here**

```csharp
public sealed class CanvasMapPresenter : MapPresenterBase
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/CanvasMapPresenter.cs</small>

Draws a map inside a uGUI Canvas. Nodes become Image-backed views pooled per node type, routes
become chains of thin rotated rects drawn from a pool of their own, and both are parented to
the node and edge roots, so a map takes part in the same hierarchy, batching, and sorting as
the rest of your interface. A node type carrying a Canvas prefab is instantiated instead of
the built-in view, which is how a project replaces the look without replacing the presenter.

It also sizes the two roots. Whenever the graph's topology changes, the node and edge
RectTransforms are resized to the extent the graph and theme produce, which is what lets a
ScrollRect or layout group above them pan and clamp against the real size of the map. A root
that is not a RectTransform is left alone rather than treated as a mistake, so the presenter
still works when both roots are the presenter's own transform.

Everything else -- binding to the traversal controller, fog and visual state, transitions,
focus, and styles -- comes from `MapPresenterBase`. Use
`BranchWeaver.Presentation.World2D.WorldMapPresenter` instead for a map drawn in
the scene rather than on a Canvas.

---

## DefaultMapNodeHitTester

```csharp
public sealed class DefaultMapNodeHitTester : MonoBehaviour, IMapNodeHitTester
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

The shipped hit tester. It considers the active `IMapNodeView`
components on this object and its children, and covers both presentation styles:
Canvas views by rectangle, World2D views by renderer bounds. Candidates are
visited topmost first, so an overlapping node cannot steal a press. A view that
also implements `IMapNodeHitState` decides its own eligibility;
otherwise a view whose renderers are all disabled is skipped.

**Properties**

`public Camera EventCamera`

:   The camera screen positions are interpreted through. When it is null the tester resolves one itself: `Camera.main`, else the first active camera in a stable order.

**Methods**

`public void BindCamera(Camera value)`

:   Sets the camera used for non-overlay Canvas and World2D hit conversion.
    - `value` &mdash; The explicit event camera, or null to use deterministic automatic resolution on each hit.

`public bool TryHit(Vector2 screenPosition, out StableId nodeId)`

:   Finds the topmost node view containing a screen position. It allocates a candidate list and queries the hierarchy per call, which is why the controller only calls it on frames that carry a press.
    - `screenPosition` &mdash; Pointer position in screen pixels.
    - `nodeId` &mdash; Receives the topmost eligible node, or an empty ID when no active view contains the point.
    - **Returns** &mdash; True when a node was hit.

---

## IMapAudioCueAdapter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapAudioCueAdapter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Plays the cue ids authored on node types, so the package never has to know which
audio system a project uses.

The traversal controller calls it while dispatching a transition: once when a
node is entered and once when it is completed, and only for a node type that
declares a cue id which parses as a stable id. An exception is caught and
surfaced as a callback-failed warning instead of rolling the transition back,
and driving traversal from inside the call is refused as a nested operation.

---

## IMapBackgroundPresenter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapBackgroundPresenter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional hook for drawing whatever sits behind the map: a backdrop image, a
parallax layer, a shader quad.

Called once at the end of every presented pass, not every frame, and always
with the theme currently in force - so an implementation must tolerate being
handed the same theme repeatedly and should do nothing when it has not changed.
A background presenter that also implements `IMapStyledView`
receives the map's style the same way views do.

---

## IMapDevelopmentHost

```csharp
public interface IMapDevelopmentHost
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The command surface behind the development overlay: reveal, unlock, teleport,
reset, force a result, regenerate, and copy the generation manifest.

Every command here mutates a run outside the normal traversal rules, so it is for
authoring and debugging only, never gameplay. The whole interface exists only in
a build that defines BRANCHWEAVER_DEVTOOLS, which is what keeps it out of a
shipping build. Commands report a refusal through their result rather than by
throwing, and one command cannot run while another is dispatching callbacks.

---

## IMapEdgeAvailabilityView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeAvailabilityView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapStyledViewContracts.cs</small>

Implemented by an edge view that can emphasize routes leading to a
reachable node.

Separate from `IMapStyledView` so a custom edge view can adopt
styling without also having to reason about availability, and vice versa.

---

## IMapEdgeTransitionView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeTransitionView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `IMapEdgeView`: the edge counterpart of
`IMapNodeTransitionView`, driven in the same order and under the same
condition that no `IMapPresentationTransitionAdapter` is installed.

An edge only ever transitions between fog states. When one is implemented the
presenter stops toggling the edge active on a fog change and leaves visibility to
the animation, so a transition to hidden must end with the edge invisible.

---

## IMapEdgeView

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The contract for anything that draws a single map edge. Implement it to draw
routes your own way - a line renderer, a UI mesh, a chain of sprites - and hand
instances to the presenter through an `IMapEdgeViewFactory`.

Unlike a node view, an edge view really is deactivated when fog hides it, so
`SetActive` must be reversible rather than a teardown.

---

## IMapEdgeViewFactory

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeViewFactory
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Creates and reclaims edge views for a presenter. A factory may pool instances;
returning null intentionally omits an edge for the current pass.

---

## IMapFocusIndicatorPresenter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapFocusIndicatorPresenter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional hook for one shared focus indicator drawn at the focused node, as an
alternative to every node styling its own focus.

Called when focus moves, once per presented pass, and once more when the
presenter clears the map - that last call arrives with an empty node id and a
null layout and means "hide yourself", so an implementation must handle it.

---

## IMapFocusView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapFocusView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `IMapNodeView`: lets a view show keyboard or gamepad
focus.

The presenter drives it when focus moves and again on each presented pass for
nodes that did not otherwise change, so an implementation must be cheap and
must tolerate being told the same value repeatedly. A node hidden by fog is
never reported as focused.

---

## IMapInputSource

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

Supplies the map with input frames. Implement this to drive a map from any input
stack - legacy Input, Input System, a recorded replay, a test - without the
package taking a dependency on it.

---

## IMapLocalizationAdapter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapLocalizationAdapter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Bridges node labels and tooltips to whatever localization system a project
already uses. Without one, the text authored on the node type is shown as-is.

`Resolve` is called twice for every node the presenter binds, so it
must be cheap, and nothing guards it: an exception thrown from it abandons the
presentation pass part-way through.

---

## IMapNodeHitState

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapNodeHitState
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `IMapNodeView`: lets the view decide for itself
whether it can be clicked.

Implementing it replaces the default hit tester's own guess, which is drawn
from the view's rect or renderers. That cuts both ways: a view that reports
true for a node hidden by fog makes that node clickable, so the usual rule is
to report false for anything the player must not be able to reach.

---

## IMapNodeHitTester

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapNodeHitTester
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

Resolves a screen position to a map node. Implement this when node views are
drawn in a way the shipped tester cannot see, such as a custom mesh or an
off-hierarchy renderer.

---

## IMapNodeTransitionView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapNodeTransitionView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `IMapNodeView`: lets a view animate its own state
changes, which is how the shipped node views cross-fade.

Consulted only while no `IMapPresentationTransitionAdapter` is
installed. The presenter drives it in a fixed order:
`PrepareForBind` before a bind that changes state, then
`BeginTransition` after that bind, then
`AdvanceTransition` once a frame on an unscaled delta so that
pausing the game does not freeze the map. Reaching the destination is the
view's own responsibility; nothing polls it to check that it got there.

---

## IMapNodeView

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapNodeView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The contract for anything that draws a single map node. Implement it to render
nodes your own way - a prefab, a sprite, a UI element - and hand instances to
the presenter through an `IMapNodeViewFactory`.

An implementation must report `NodeId` from the data it was bound
with and keep `Transform` non-null for its lifetime: input
resolves a click to a node through those two members and nothing else. Beyond
them the presenter never inspects the object, so a view is free to render
however it likes.

---

## IMapNodeViewFactory

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapNodeViewFactory
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Creates and reclaims node views for a presenter. Implementations may instantiate,
pool, or adapt existing objects; returning null intentionally omits that node
without changing map state.

---

## IMapPresentationTransitionAdapter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapPresentationTransitionAdapter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Takes over every node and edge state transition for the whole map, as an
alternative to letting each view animate itself.

Installing one switches the per-view path off completely: the presenter then
never calls `IMapNodeTransitionView` or
`IMapEdgeTransitionView`, and never advances a view's animation. The
adapter therefore owns its own clock and must carry its animations to completion
itself. Durations come from the theme and can be zero, which means "apply the
destination immediately".

---

## IMapRoutePawnPresenter

```csharp
public interface IMapRoutePawnPresenter : IPlayerPawnPresenter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

An `IPlayerPawnPresenter` that also wants to know how the traveller
arrived, which is what a pawn needs in order to walk the route instead of sliding
across the map in a straight line.

The presenter calls this overload instead of the shorter one whenever the pawn
implements it, so a pawn that only cares about the route can forward the shorter
one to this one and be done. The edge id is empty for the first node of a run,
while the traveller is between nodes, and whenever no drawn route joins the two
nodes; hand it to `MapPresenterBase.TryGetEdgePath` to get the path the edge
is actually drawn along.

---

## IMapViewFactoryLifetime

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapViewFactoryLifetime : IDisposable
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional lifetime contract used only for factories created and owned by a presenter.

---

## IPlayerPawnPresenter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IPlayerPawnPresenter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional hook for drawing the traveller's own marker on the map.

Called once at the end of every presented pass. The current node is empty
whenever the traveller is between nodes - before the first node is entered, and
again after each one is completed - so an implementation needs an answer for
"nowhere", usually hiding the pawn.

---

## IRouteMarkerPresenter

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IRouteMarkerPresenter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional hook for marking the route already walked: footprints, a trail, a drawn
line.

Called once at the end of every presented pass with the whole visited list, so
an implementation must render the entire route each time rather than assuming
only the last step is new.

---

## InputSystemSignalAdapter

```csharp
public sealed class InputSystemSignalAdapter : MonoBehaviour, IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

Package-neutral bridge for Input System PlayerInput UnityEvents. Wire public signal
methods from PlayerInput without adding a BranchWeaver compile-time package dependency.

**Methods**

`public MapInputFrame Capture()`

:   Returns the currently held navigation/pointer state plus accumulated edge and delta signals, then clears submit, press, pan, and zoom for the next update.
    - **Returns** &mdash; A one-update value snapshot; held navigation, pointer position, and pinch state remain latched.

`public void EndPinch()`

:   Ends the pinch so pointer presses activate nodes again. Nothing else clears the flag: without this call the map keeps ignoring taps.

`public void SignalNavigate(Vector2 value)`

:   Latches directional intent across captures, matching a held Input System action; send zero when the action is canceled to stop navigation repeats.
    - `value` &mdash; Usually a normalized stick, d-pad, or keyboard vector in the range -1 to 1 per axis.

`public void SignalPan(Vector2 delta)`

:   Accumulates pan movement until the next `Capture` consumes it.
    - `delta` &mdash; Incremental movement in the input action's units; repeated events in one update are summed.

`public void SignalPinch(float scaleDelta)`

:   Reports an in-progress pinch. It marks the pinch active and drops any pending pointer press, so pinching never selects a node; call `EndPinch` when the gesture finishes.
    - `scaleDelta` &mdash; Pinch scale factor for this event: 1 leaves the zoom alone, 1.1 zooms in a tenth. The adapter accumulates `scaleDelta - 1` into the frame's zoom delta.

`public void SignalPointer(Vector2 value)`

:   Records the pointer position in screen pixels and marks the frame as having a pointer. The position persists between frames; only the press is an edge.
    - `value` &mdash; The current pointer position in screen pixels.

`public void SignalPointerPress()`

:   Marks a pointer press for the next captured frame. Ignored while a pinch is running, so a second finger cannot select a node.

`public void SignalSubmit()`

:   Requests activation of the focused node on the next captured frame. `Capture` clears it, so one call is one submit.

`public void SignalZoom(float delta)`

:   Accumulates wheel/axis zoom movement until the next `Capture` consumes it.
    - `delta` &mdash; Signed incremental zoom movement; positive values zoom in after controller sensitivity is applied.

---

## LegacyMapInputSource

```csharp
public sealed class LegacyMapInputSource : IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

Input source for Unity's legacy Input Manager: axes for navigation, Return, Space
or the Submit button for activation, the mouse for pointing, middle-drag to pan
and the wheel to zoom, with touches folded in as tap, drag-pan and pinch-zoom.
`MapInputController` falls back to this when no other source is bound,
so the project needs the legacy input backend enabled and the "Horizontal",
"Vertical", "Submit", "Mouse X" and "Mouse Y" entries present in its input
settings.

**Methods**

`public MapInputFrame Capture()`

:   Reads one frame from `Input`. While any finger is down the touch pointer replaces the mouse pointer and touch pan and zoom add to the mouse values; with no touches the gesture state is cleared, so a lifted finger cannot leak a delta into the next frame.
    - **Returns** &mdash; The current legacy-input snapshot; button presses are one-frame edges and touch deltas are measured from prior captured samples.

---

## MapCameraBloom

```csharp
public sealed class MapCameraBloom : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapCameraBloom.cs</small>

Optional map bloom and vignette. **Off by default and never required.**

The shipped map look needs no post-processing: node glow, edge glow and
state rings are drawn inside the SDF map surface shader. That is why
BranchWeaver depends on no post-processing package, and why a project's
existing volumes, renderer features and profiles cannot collide with it.

This component exists only for a project that wants a softer bloom across
the whole map and is not already running its own post stack. It is a
self-contained image effect with no package dependency.

Built-in render pipeline only. Under URP or HDRP, `OnRenderImage` is
never called, so rather than silently doing nothing this component detects
the active pipeline, logs one explanatory warning, and disables itself.
Use that pipeline's own Bloom volume override instead.

To enable: add it to the camera that draws the map and enable the
component. Nothing in the package adds it for you.

**Properties**

`public bool IsSupportedPipeline`

:   True when this effect can run in the active pipeline, which means the Built-in pipeline. Under a Scriptable Render Pipeline the image-effect callback is never invoked, so the component turns itself off instead.

---

## MapDevelopmentCommandResult

```csharp
public sealed class MapDevelopmentCommandResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The outcome of one development command: success, optionally carrying a value, or
a refusal with a reason fit to show in a debug overlay. Exists only in a build
that defines BRANCHWEAVER_DEVTOOLS.

**Properties**

`public MapDevelopmentFailureKind FailureKind`

:   Why the command was refused, or `MapDevelopmentFailureKind.None` on success.

`public string Message`

:   The reason to show the operator. Never null; empty on success.

`public bool Succeeded`

:   Whether the command ran. A refusal is reported here rather than thrown, so an overlay can offer every command and simply show `Message` when one is turned down.

`public string Value`

:   Data returned by the commands that produce some - today the copied generation manifest. Never null; empty for every other success and for all failures.

**Methods**

`public static MapDevelopmentCommandResult Failure(MapDevelopmentFailureKind kind, string message)`

:   Records a refusal, with the reason to show the operator.

`public static MapDevelopmentCommandResult Success(string value = null)`

:   Records a success, optionally carrying data in `Value`.

---

## MapDevelopmentFailureKind

```csharp
public enum MapDevelopmentFailureKind
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Why a development command was refused. Exists only in a build that defines
BRANCHWEAVER_DEVTOOLS.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `NotInitialized` | &mdash; |
| `InvalidNode` | &mdash; |
| `RejectedTransition` | &mdash; |
| `Unsupported` | The host cannot service this command at all, such as a regeneration request when no regeneration handler is registered. |
| `InvalidPayload` | &mdash; |

---

## MapEdgeViewData

:material-star: **Start here**

```csharp
public readonly struct MapEdgeViewData
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Everything an edge view needs to draw one route in one presented state: the
graph edge, the sampled path along it, the colour to draw it in, and its fog
state.

Immutable and passed by value. Both point lists are wrapped read-only on
construction - copied unless they are already a
`ReadOnlyCollection{T}` - so a caller may keep reusing its own
buffers without a bound view seeing them change underneath it.

**Constructors**

`public MapEdgeViewData(MapEdge edge, IReadOnlyList<NormalizedMapPosition> points, Color color)`

:   Creates edge data from normalized points only. The point sequence is copied into a read-only collection so later caller mutations cannot alter the bound path.
    - `edge` &mdash; The immutable graph edge represented by the view.
    - `points` &mdash; Source-to-target samples in normalized map space; null remains null.
    - `color` &mdash; The already resolved route color for this presentation pass.

`public MapEdgeViewData()`

:   The full form the presenter builds, with the path already converted to presentation units.
    - `edge` &mdash; The immutable graph edge represented by the view.
    - `points` &mdash; Source-to-target samples in normalized map space; copied when non-null.
    - `presentationPoints` &mdash; The same samples after viewport conversion, in presenter units; copied when non-null.
    - `color` &mdash; The route color already selected from style/theme and progression state.
    - `fogState` &mdash; The visibility state the edge view must honor.

**Properties**

`public Color Color`

:   The colour to draw the route in, already resolved for the role it plays this pass: walked, leading to a node the traveller may enter next, or dimmed by fog. It comes from the map's style, falling back to the theme's single edge colour when no style is assigned, so a view should draw with it rather than choose a colour of its own.

`public MapEdge Edge`

:   The graph edge being drawn, carrying its id and the two nodes it joins.

`public MapFogState FogState`

:   How visible the route is: the more hidden of its two endpoints' fog states, and `MapFogState.Hidden` when either endpoint has no state. A view that animates its own fog transitions is not deactivated for it, and so must end a transition to hidden invisible by itself.

`public IReadOnlyList<NormalizedMapPosition> Points`

:   The sampled path in normalized layout space, running from the edge's source endpoint to its target.

`public IReadOnlyList<Vector2> PresentationPoints`

:   The same path in presentation units, one entry per `Points` entry, or null when it was not supplied. A view given null converts `Points` itself.

---

## MapFogSettings

```csharp
public struct MapFogSettings
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

How far ahead of the traveller the map is revealed.

Fog is derived, never stored, so changing these values re-reveals an existing
save correctly instead of needing a migration.

**Properties**

`public static MapFogSettings Default`

:   The classic behaviour: one step of look-ahead, forwards only.

`public static MapFogSettings Revealed`

:   Every node visible.

**Fields**

`public bool RevealAll`

:   Reveal every node regardless of progress.

`public int RevealDepth`

:   How many edges ahead of a reached node stay visible, as dimmed "locked" nodes. 0 shows only what the traveller has reached and what is immediately available. 1 also shows the next choices, which is the classic run-based-map behaviour and the default. 2 shows the choice after that, and so on. A value at or above the layer count effectively reveals the whole map.

`public bool RevealIncoming`

:   Also reveal nodes that lead INTO a reached node, not just out of it. Useful for maps a traveller can move back through.

**Methods**

`public MapFogSettings Sanitized()`

:   Clamps the settings into their supported range.
    - **Returns** &mdash; The complete map Fog Settings outcome; inspect its typed status or diagnostics before consuming payload data.

---

## MapFogState

```csharp
public enum MapFogState
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

How visible a node is, derived from its `MapNodeVisualState`: a hidden
node reports `MapFogState.Hidden`, a locked one
`MapFogState.Dimmed`, and anything the traveller has reached or can reach
`MapFogState.Visible`. The built-in presenters give a route the more
hidden of its two endpoints' states.

| Value | Meaning |
| --- | --- |
| `Hidden` | Not shown. |
| `Dimmed` | Shown, but held back; the built-in views draw it at reduced opacity. |
| `Visible` | Shown at full strength. |

---

## MapInputController

:material-star: **Start here**

```csharp
public sealed class MapInputController : MonoBehaviour, ISerializationCallbackReceiver
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

The component that turns input frames into map interaction: it moves focus between
nodes, submits the focused or pressed node to a `MapTraversalController`,
and pans and zooms the content transform inside the theme's zoom limits while
keeping the focused node in view. Frames come from any `IMapInputSource`
and presses are resolved by any `IMapNodeHitTester`, so a project can
change input stack or presentation style without touching the map. It stays inert
until a traversal controller is initialized and a layout is available: ticks before
that are dropped, not queued.

**Properties**

`public MapLayout CurrentLayout`

:   The layout spatial navigation and framing currently work from, or null before one is set. With a presenter bound it follows that presenter's layout; otherwise it is whatever `SetLayout` or `Configure` last supplied. Input frames are dropped while it is null.

`public DefaultMapNodeHitTester DefaultHitTester`

:   The serialized hit tester, kept in a field so the binding survives a domain reload. It is not necessarily the tester in use: one passed to `Configure` takes precedence without being stored here, while `BindPresenter` does store one it is given when it happens to be a `DefaultMapNodeHitTester`.

`public Camera EventCamera`

:   The camera screen positions are interpreted through for zoom anchoring and world-space viewport maths, or null to let the controller resolve one itself: `Camera.main`, else the first active camera in a stable order. A camera resolved that way is cached and is looked for again only once it goes inactive or the scene's camera count changes, so an empty scene does not re-scan every frame.

`public InputSystemSignalAdapter InputSignals`

:   The serialized Input System adapter, which acts as the fallback source: when no source has been bound the update loop captures from this, and when this is null too it falls back to `LegacyMapInputSource`.

`public MapNavigationModel Navigation`

:   The focus model this controller drives. Read it to learn which node is focused, or move focus yourself between ticks. Focus is presentation state: moving it neither enters a node nor touches progression, and a change made directly on the model is not announced through `FocusChanged` until the next tick publishes it.

`public Vector2 Pan`

:   Current pan offset, already clamped so the map cannot be dragged out of reach. A Canvas map measures it in the content parent's local units; a world map in hundredths of them, matching the anchored-position and world scales the component writes.

`public MapPresenterBase Presenter`

:   The presenter supplying the layout and receiving focus updates, or null when the controller was pointed at a layout directly. Only a bound presenter keeps the layout current, and only while the component is enabled -- the subscription is dropped on disable and taken again on enable.

`public MapTraversalController TraversalController`

:   The traversal controller node selections are submitted to, or null before one is bound. The component stays inert until this is set and initialized: frames arriving before then are dropped rather than queued.

`public Transform ViewportContent`

:   The transform pan and zoom are written to, or null when the map is not to be moved at all. A `RectTransform` receives the pan as its anchored position; any other transform receives it as a local position in hundredths of the same units, which is why `Pan` is measured differently for the two presentation styles.

`public float Zoom`

:   Current zoom multiplier written to the content transform's scale. It starts at 1 and every tick clamps it into the theme's minimum and maximum zoom.

**Events**

`public event Action<StableId> FocusChanged`

:   Raised when the focused node changes, including when focus is lost - the argument is then an empty `StableId`. The presenter has already been told about the new focus by the time handlers run.

**Methods**

`public void BindCamera(Camera value)`

:   Sets and immediately caches the camera used for pointer-to-world conversion and pointer-anchored zoom.
    - `value` &mdash; The explicit camera, or null to clear the cache and enable deterministic scene resolution.

`public void BindDefaultHitTester(DefaultMapNodeHitTester hitTester)`

:   Makes this tester resolve pointer presses and stores it in the serialized field, so the binding survives a domain reload. It replaces any tester passed to `Configure` or `BindPresenter`.
    - `hitTester` &mdash; The serialized shipped tester to use for subsequent pointer presses; null disables this fallback.

`public void BindInputSignals(InputSystemSignalAdapter signals)`

:   Makes this signal adapter the input source and stores it in the serialized field. The directional hold-repeat state is reset, so a direction held on the previous source cannot repeat straight into the new one.
    - `signals` &mdash; The PlayerInput-compatible signal accumulator to capture each update, or null to restore legacy-input fallback.

`public void BindPresenter()`

:   Binds the controller to a presenter and follows it: the presenter's current layout is adopted, later layout changes are tracked, and focus is published back to the presenter. The layout subscription is released when the component is disabled and taken again when it is enabled, so a presenter swapped while disabled needs re-binding.
    - `presenter` &mdash; Supplies the layout and receives focus updates.
    - `contentTransform` &mdash; The transform whose local position and scale receive pan/zoom, or null to track state without moving content.
    - `source` &mdash; Where frames come from. Null leaves the component to fall back to its serialized signal adapter, or to legacy Input, on the next update.
    - `hitTester` &mdash; Resolves pointer presses to nodes. Null falls back to the serialized `DefaultMapNodeHitTester`, then to one found among the children.
    - `controller` &mdash; The initialized traversal controller that supplies availability and receives node requests.

`public void Configure()`

:   Wires the controller to a layout directly, with no presenter: it drops any presenter binding and its layout-change subscription, recovers focus from the traversal state, and applies the current pan and zoom to the content transform. Prefer `BindPresenter` when a `MapPresenterBase` owns the layout, because only that path follows later layout changes.
    - `layout` &mdash; The immutable graph layout used for spatial navigation and focused-node zoom anchoring; null leaves input inert.
    - `source` &mdash; Where frames come from. Null leaves the component to fall back to its serialized signal adapter, or to legacy Input, on the next update.
    - `hitTester` &mdash; Resolves pointer presses to nodes. Null leaves pointer selection off until a tester is bound or the component is re-enabled.
    - `contentTransform` &mdash; The transform whose local position and scale receive pan/zoom, or null to track state without moving content.
    - `controller` &mdash; The initialized traversal controller that supplies availability and receives node requests.

`public void ConfigureNavigationRepeat(float initialDelaySeconds, float intervalSeconds)`

:   Replaces the configure Navigation Repeat settings used by future operations; existing immutable graphs and saves are not rewritten.
    - `initialDelaySeconds` &mdash; Seconds a direction is held before it starts repeating. Negative values are clamped to zero.
    - `intervalSeconds` &mdash; Seconds between repeats once repeating starts. Values below 0.01 are raised to 0.01.

`public void OnAfterDeserialize()`

:   Unity serialization callback. It rebuilds the cached source and hit tester from the serialized fields and forgets any automatically resolved camera, so a domain reload cannot leave the controller pointing at dead references. Unity calls it; you should not.

`public void OnBeforeSerialize()`

:   Unity serialization callback. It does nothing: the controller has no runtime state worth flattening.

`public void SetLayout(MapLayout layout)`

:   Swaps the layout that spatial navigation and framing work from, then recovers focus, brings it into view, and re-applies the transform. A null layout clears focus and leaves the controller inert until a layout is set again.
    - `layout` &mdash; The replacement immutable node layout, or null to clear navigation focus and suspend input handling.

`public void SetSource(IMapInputSource source)`

:   Replaces the input source, cancels the current directional hold, and re-checks focus. Passing null makes the next update fall back to the serialized signal adapter, or to legacy Input when there is none.
    - `source` &mdash; The source captured once per update, or null to use the serialized signal adapter/legacy-input fallback.

`public void Tick(MapInputFrame frame)`

:   Applies one input frame using an automatically resolved zoom anchor and `Time.unscaledDeltaTime` for directional repeat timing. It is a no-op until both traversal and layout are ready.
    - `frame` &mdash; The one-update input snapshot; submitting the same value twice repeats its edge actions and deltas.

`public void Tick(MapInputFrame frame, Vector2 anchorLocal)`

:   Applies one frame with a caller-selected local-space zoom anchor and the engine's unscaled frame delta.
    - `anchorLocal` &mdash; The point in `ViewportContent` local units that must remain visually fixed while zoom changes.
    - `frame` &mdash; The one-update input snapshot; submitting the same value twice repeats its edge actions and deltas.

`public void Tick(MapInputFrame frame, Vector2 anchorLocal, float deltaSeconds)`

:   Applies one frame with explicit anchor and elapsed time, enabling deterministic tests or a custom update loop without reading Unity's clock.
    - `anchorLocal` &mdash; The point in `ViewportContent` local units that must remain visually fixed while zoom changes.
    - `deltaSeconds` &mdash; Time since the previous tick. It advances the directional hold-repeat clock only; pan and zoom come from the frame's deltas, so the step never scales movement.
    - `frame` &mdash; The one-update input snapshot; submitting the same value twice repeats its edge actions and deltas.

---

## MapInputFrame

```csharp
public readonly struct MapInputFrame
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

One update's worth of map input, reduced to the six signals the controller acts
on: a directional axis, a submit request, a pointer, pan and zoom deltas, and a
pinch flag. Everything here describes that update alone, so a frame is meant to
be applied once - feeding the same frame twice pans, zooms, and submits twice.

**Constructors**

`public MapInputFrame()`

:   Captures one update of navigation, pointer, pan, zoom, and pinch input. This convenience overload infers pointer availability from pointer/gesture activity.
    - `navigation` &mdash; Directional intent; see `Navigation` for the threshold applied.
    - `pointerPosition` &mdash; Pointer position in screen pixels.
    - `panDelta` &mdash; Pan movement for this frame, not an absolute offset.
    - `zoomDelta` &mdash; Zoom change for this frame, not an absolute zoom.
    - `submit` &mdash; True only on the update that activates the focused node.
    - `pointerPressed` &mdash; True only on the update that should hit-test and activate at `pointerPosition`.
    - `pinchActive` &mdash; True while a multi-touch pinch is active, suppressing pointer activation.

`public MapInputFrame()`

:   Captures one update of map input with an explicit pointer-presence flag. The value object performs no clamping; the controller applies its own thresholds and sensitivity settings when the frame is consumed.
    - `navigation` &mdash; Directional intent; see `Navigation` for the threshold applied.
    - `pointerPosition` &mdash; Pointer position in screen pixels.
    - `panDelta` &mdash; Pan movement for this frame, not an absolute offset.
    - `zoomDelta` &mdash; Zoom change for this frame, not an absolute zoom.
    - `hasPointerPosition` &mdash; False when no pointer exists, which makes the controller anchor zoom on the focused node instead.
    - `submit` &mdash; True only on the update that activates the focused node.
    - `pointerPressed` &mdash; True only on the update that should hit-test and activate at `pointerPosition`.
    - `pinchActive` &mdash; True while a multi-touch pinch is active, suppressing pointer activation.

**Properties**

`public bool HasPointerPosition`

:   Whether `PointerPosition` is usable this frame. It decides the zoom anchor: with a pointer the map zooms around it, without one it zooms around the focused node.

`public Vector2 Navigation`

:   Directional intent, normally -1..1 per axis. The controller follows the dominant axis and ignores both axes below 0.5, so a stick, a d-pad, and key axes all behave the same.

`public Vector2 PanDelta`

:   Pan movement for this frame in the source's own units; the controller scales it by its pan sensitivity and adds it to `MapInputController.Pan`.

`public bool PinchActive`

:   True while a two-finger pinch is in progress. The controller suppresses pointer activation on those frames, so a pinch cannot select a node.

`public Vector2 PointerPosition`

:   Pointer position in screen pixels, meaningful only while `HasPointerPosition` is set.

`public bool PointerPressed`

:   Set for the one frame the source reports a press or tap. The controller hit-tests at `PointerPosition` and submits the node it finds.

`public bool Submit`

:   Set for the one frame activation was requested; the controller then submits the focused node. Ignored when a pointer press already activated a node in the same frame, so a tap never selects twice.

`public float ZoomDelta`

:   Zoom change for this frame, added to the current zoom after the controller's zoom sensitivity. Wheel sources report the wheel delta, pinch sources the scale factor minus one.

---

## MapNavigationDirection

```csharp
public enum MapNavigationDirection
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapNavigation.cs</small>

A directional focus step, named in normalized layout space: Up is increasing Y and Right is
increasing X, whatever the presenter later does with those axes on screen.

| Value | Meaning |
| --- | --- |
| `Left` | Choosing left configures `MapNavigationDirection`; the serialized numeric value is part of the compatibility contract. |
| `Right` | Choosing right configures `MapNavigationDirection`; the serialized numeric value is part of the compatibility contract. |
| `Up` | Choosing up configures `MapNavigationDirection`; the serialized numeric value is part of the compatibility contract. |
| `Down` | Choosing down configures `MapNavigationDirection`; the serialized numeric value is part of the compatibility contract. |

---

## MapNavigationModel

```csharp
public sealed class MapNavigationModel
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapNavigation.cs</small>

Keyboard and gamepad focus for a map. It holds nothing but the focused node and derives every
choice from the progression, layout, and runtime state handed in, so the same inputs over the
same map always land on the same node.

Focus is presentation state: moving it neither enters a node nor changes progression, and a
node hidden by fog is never chosen.

**Properties**

`public StableId FocusedNodeId`

:   The focused node, or an empty id when nothing is focused.

**Methods**

`public void ClearFocus()`

:   Drops focus, leaving `FocusedNodeId` empty.

`public bool Move(MapNavigationDirection direction, MapLayout layout, MapRuntimeStateSnapshot runtimeState)`

:   Steps focus to the nearest visible node in one direction. A node counts as a candidate only when that direction is the dominant axis of the offset to it; the nearest by squared distance then wins, ties break by the offset across the direction, and remaining ties by the lower node id, which is what makes the step deterministic. Distances come from the layout, not from where the presenter draws the nodes.
    - `direction` &mdash; Input direction consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `layout` &mdash; Input layout consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `runtimeState` &mdash; Input runtime State consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; True when focus moved. With nothing focused yet, no focused position in the layout, or no qualifying candidate, focus is left untouched and this returns false.

`public StableId RecoverFocus(MapProgressionState progression, MapLayout layout, MapRuntimeStateSnapshot runtimeState)`

:   Re-picks focus after the map changes, keeping the focused node when it is still visible. Otherwise it prefers the node being played, then the first visible available node, then the first visible visited node, then any visible node, and clears focus if the map has nothing visible at all.
    - `runtimeState` &mdash; Per-node fog state; a node it does not contain cannot be focused.
    - `progression` &mdash; Input progression consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `layout` &mdash; Input layout consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The focused node after recovery, or an empty id when nothing could be focused.

`public bool TrySetFocus(StableId nodeId, MapRuntimeStateSnapshot runtimeState)`

:   Focuses a node directly, as a pointer tap does. Nothing changes when the node is unknown to `runtimeState` or hidden by fog, so a tap on a hidden node cannot take focus away from a visible one.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - `runtimeState` &mdash; Input runtime State consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; True when focus moved to the node.

---

## MapNodeRuntimeState

```csharp
public readonly struct MapNodeRuntimeState : IComparable<MapNodeRuntimeState>
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

One node's derived display state: the visual state a presenter styles it with, plus
the fog state that decides whether it can be seen at all. An immutable value read
out of a `MapRuntimeStateSnapshot`; it is never updated in place, so a
copy keeps reporting the revision it was taken from.

**Constructors**

`public MapNodeRuntimeState(StableId nodeId, MapNodeVisualState visualState, MapFogState fogState)`

:   Pairs a node with the visual and fog state derived for it.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - `visualState` &mdash; Input visual State consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `fogState` &mdash; Input fog State consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public MapFogState FogState`

:   How visible the node is, derived from `VisualState` and never independent of it: hidden nodes report `MapFogState.Hidden`, locked ones `MapFogState.Dimmed`, and everything else `MapFogState.Visible`. It is the field to test before drawing or hit-testing, since a concealed node is present in the snapshot rather than absent from it.

`public StableId NodeId`

:   The node these two states were derived for; also the key it is stored and sorted under.

`public MapNodeVisualState VisualState`

:   How the node reads to the player, and what a presenter styles it as. A node can satisfy several conditions at once, so this is already the winner of a fixed precedence and not a set to interpret further.

**Methods**

`public int CompareTo(MapNodeRuntimeState other)`

:   Orders by `NodeId` alone, ignoring both states. This is what gives a snapshot's node list an order that depends on the graph and not on progress.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete int outcome; inspect its typed status or diagnostics before consuming payload data.

---

## MapNodeViewData

:material-star: **Start here**

```csharp
public readonly struct MapNodeViewData
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Everything a node view needs to draw one node in one presented state: the
graph node, where it sits, its compiled type, and its visual and fog state.

Immutable and passed by value, so a view may keep a copy but must not expect
that copy to change. The presenter rebuilds the data and calls
`IMapNodeView.Bind` again when the node's presented state changes,
which is why a view never has to poll the graph or the traversal state.

**Constructors**

`public MapNodeViewData()`

:   Creates view data in normalized layout space for a custom view that performs its own framing. The constructor does not validate or clone the referenced graph/type objects.
    - `node` &mdash; The immutable graph node represented by the view.
    - `position` &mdash; The node's normalized layout position, normally in the zero-to-one map frame.
    - `nodeType` &mdash; Compiled presentation metadata; null produces empty label and tooltip fallbacks.
    - `visualState` &mdash; The progression-derived visual role to draw.
    - `fogState` &mdash; The visibility state the view must honor.

`public MapNodeViewData()`

:   The full form the presenter builds: placement and size are already resolved into presentation units, and the label and tooltip have already been through the localization adapter.
    - `presentationPosition` &mdash; Where to draw the node, in presentation units.
    - `nodeSize` &mdash; Unstyled node size, in the same units as `presentationPosition`.
    - `hasPresentationPosition` &mdash; False to tell the view that `presentationPosition` and `nodeSize` are not authoritative and it should place and size the node itself.
    - `displayLabel` &mdash; Localized label; null is stored as an empty string, which asks the view to draw no label.
    - `tooltip` &mdash; Localized tooltip; null is stored as an empty string.
    - `node` &mdash; The immutable graph node represented by the view.
    - `position` &mdash; The original normalized layout position retained for custom view logic.
    - `nodeType` &mdash; Compiled type metadata used for art, cues, and authored fallback text.
    - `visualState` &mdash; The progression-derived visual role at bind time.
    - `fogState` &mdash; The derived visibility state at bind time.

**Properties**

`public string DisplayLabel`

:   Node label, already localized. Never null; empty asks the view to draw no label.

`public MapFogState FogState`

:   How visible the node is, derived from `VisualState`. The presenter binds and activates a node view even when this is `MapFogState.Hidden`, so drawing nothing in that state is the view's own responsibility.

`public bool HasPresentationPosition`

:   False when this data was built without presentation metrics, in which case the view must place and size the node from `Position` itself instead of trusting `PresentationPosition`.

`public MapNode Node`

:   The graph node being drawn, carrying its id, its node-type reference, and its authored payload.

`public float NodeSize`

:   Node size in the same presentation units as `PresentationPosition`. This is the unstyled base size: a style scales it per visual state, so it is not necessarily the size drawn.

`public CompiledMapNodeType NodeType`

:   The compiled node type this node draws as, and where a view finds its art, colours, and cue ids. The shipped presenter skips a node whose type the content does not declare, so it never binds a null here, but the short constructor allows one.

`public NormalizedMapPosition Position`

:   Where the node sits in normalized layout space, before any framing or scaling. This is the placement to work from when `HasPresentationPosition` is false, and it stays meaningful even when it is true.

`public Vector2 PresentationPosition`

:   Where to draw the node, in presentation units. Meaningful only when `HasPresentationPosition` is true.

`public string Tooltip`

:   Node tooltip, already localized. Never null; empty when the node type declares none.

`public MapNodeVisualState VisualState`

:   How the node reads to the player - hidden, locked, available, current, visited, or completed. Derived from progression rather than stored with the node, so it cannot disagree with the run it came from.

---

## MapNodeVisualState

```csharp
public enum MapNodeVisualState
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

How one node reads to the player, and the state a presenter styles that node with.

A node can satisfy several of these at once, so the state that wins is the first
match in a fixed order: completed, current, available, visited, locked, hidden.
Like fog, this is derived from progression rather than stored, so it can never
disagree with the save it came from.

| Value | Meaning |
| --- | --- |
| `Hidden` | Not discovered yet: not drawn, and skipped by focus and hit-testing. |
| `Locked` | Discovered but not reachable yet, so it is drawn dimmed rather than hidden. |
| `Available` | Reachable now: the traveller may enter this node. |
| `Current` | The node the traveller is on, entered but not yet completed. |
| `Visited` | Reached earlier with no completion recorded; a completed node reports `Completed`. |
| `Completed` | Reached and finished, with its completion result recorded in the progression. |

---

## MapPresenterBase

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public abstract class MapPresenterBase : MonoBehaviour, IMapPresentationHost
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapPresenterBase.cs</small>

Turns a traversal controller's graph, progression and compiled content into live
node and edge views, and keeps them in step for the rest of the run. The shipped
`CanvasMapPresenter` and `WorldMapPresenter` both derive from it; a
subclass supplies the two default view factories and otherwise inherits the whole
presentation pass.

Presenting is incremental rather than a rebuild. The layout, the metrics and the
view instances are reused for as long as the graph and content instances stay the
same, and a pass only re-binds the nodes and edges whose derived state actually
changed. That is what makes an ordinary state change cheap, and it is why a view
has to treat `IMapNodeView.Bind` as idempotent rather than as a fresh
start.

Nothing here writes to the graph or to progression: everything the presenter
derives is display state, so a save reopened later is the same run however it was
last drawn.

**Properties**

`public int ActiveEdgeCount`

:   How many edge views the presenter is holding, counted the same way as `ActiveNodeCount`. An edge hidden by fog is deactivated rather than released, so it still counts.

`public int ActiveNodeCount`

:   How many node views the presenter is holding. Nodes hidden by fog are counted: they are still bound and left active, and drawing them as invisible is the view's own job. Views handed back to a pooling factory are not counted, so this reports what is on the map rather than what has been allocated.

`public IMapBackgroundPresenter BackgroundPresenter`

:   The hook that draws whatever sits behind the map. Assigning one draws it immediately, with the map's style already pushed to it; null draws no backdrop.

`public MapLayout CurrentLayout`

:   The node positions the map is currently drawn from, or null before the first pass and after `Clear`. Rebuilt only when the graph or the compiled content instance changes, so the same instance is handed back across ordinary state changes.

`public IMapFocusIndicatorPresenter FocusIndicator`

:   The shared focus indicator drawn at the focused node. Assigning one places it on whichever node has focus right now; null leaves focus to the node views.

`public StableId FocusedNodeId`

:   The node currently shown as focused, or an empty id when nothing is. The presenter clears it by itself if that node becomes hidden by fog, so it can change without anyone calling `SetFocusedNode`.

`public IMapLayoutStrategy LayoutStrategy`

:   The layout that decides where the nodes sit. Assigning one lays the map out again and re-binds the views that survive; null puts the shipped layered layout back. Unlike `Configure` it keeps the view factories, so nothing is disposed and no pooled view is thrown away.

`public IMapLocalizationAdapter Localization`

:   The adapter that turns node labels and tooltips into the player's language. Assigning one re-binds every node so the new text appears at once; null puts the pass-through adapter back, which shows the authored text as-is. The Localization Adapter Component slot fills this in from the inspector while nothing has been installed from code.

`public IPlayerPawnPresenter PawnPresenter`

:   The hook that draws the traveller's own marker. Assigning one places it immediately; null draws no pawn. A pawn that also implements `IMapRoutePawnPresenter` is told which edge was crossed as well, so it can walk the route with `TryGetEdgePath`.

`public Vector2 PresentationContentSize`

:   The extent the laid-out map occupies in presentation units, derived from the theme's spacing and the busiest layer of the graph rather than from the views themselves. Zero until the first pass has run. Viewport framing, panning and clamping are all measured against it.

`public float PresentationNodeSize`

:   The unstyled node size in the same units as `PresentationContentSize`, or zero until the first pass has run. This is the base size a style then scales per visual state, so it is not necessarily the size drawn; it is used as the margin when keeping a focused node inside the viewport.

`public IRouteMarkerPresenter RouteMarker`

:   The hook that marks the route already walked. Assigning one draws the whole visited route immediately; null marks nothing.

`public BranchWeaver.Authoring.CompiledMapStyle Style`

:   The resolved style this map draws with. Never null: with no preset assigned it returns the shipped default, so the map is never unstyled.

`public IMapPresentationTransitionAdapter Transitions`

:   The adapter that takes over every node and edge transition. Assigning one switches the per-view animation path off; null hands the animations back to the views themselves. The Transition Adapter Component slot fills this in from the inspector while nothing has been installed from code.

`public MapTraversalController TraversalController`

:   The controller being drawn, whether it was assigned in the inspector or through `SetTraversalController` or `Configure`. Null until one is assigned, and a presenter without one draws nothing.

**Events**

`public event Action<MapLayout> LayoutChanged`

:   Raised at the end of a pass that rebuilt the layout, carrying the new positions, and again with null when `Clear` throws the layout away. It does not fire for an ordinary state change, because the layout is only rebuilt when the graph or the compiled content instance changes. Anything that tracks node positions - a viewport, a minimap, a decoration layer - should listen here instead of polling `CurrentLayout` every frame.

**Methods**

`public void AdvanceTransitions(float deltaSeconds)`

:   Advances the state-change animations that node and edge views run for themselves. Driven once a frame from Update on an unscaled delta, so pausing the game does not freeze the map; call it yourself only when you want the map on a clock of your own. It returns without doing anything while an `IMapPresentationTransitionAdapter` is installed, because that adapter owns every transition and its own timing.
    - `deltaSeconds` &mdash; Seconds elapsed since the last advance. Views have to cope with zero and with a very large value after a stall.

`public void ApplyStyle(BranchWeaver.Authoring.MapStylePreset preset)`

:   Replaces the style and pushes it to every live view. Safe at runtime, which is what lets the Style Browser preview a look live.
    - `preset` &mdash; Input preset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void Clear()`

:   Empties the map: every node and edge view goes back to its factory, the layout, metrics and cached geometry are dropped, and focus is released. The factories and adapters themselves are kept, so a later `Refresh` or `Present` rebuilds the map with the same setup. A focus indicator is told to hide itself, and `LayoutChanged` is raised with null if there was a layout to throw away. Calling it twice is harmless.

`public void Configure()`

:   Replaces the whole presentation setup in one call - the controller, the view factories, and every optional adapter - then clears the map and draws it again from scratch. This is the seam for bringing your own art and your own behaviour. The two factories, the localization adapter and the layout strategy fall back to the shipped defaults when left null; the rest are extra hooks that are simply not installed, so a map configured without a route marker or a pawn presenter draws neither. Each call discards the previous setup, disposing any factory the presenter had created for itself, which is why this is a setup call rather than something to run per frame. To swap a single adapter without that teardown - the localization adapter, the pawn, the layout - assign the matching property instead; only the two view factories have to come through here.
    - `controller` &mdash; Input controller consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `nodeFactory` &mdash; Supplies node views. Null falls back to the subclass's default factory, which the presenter then owns and disposes with itself.
    - `edgeFactory` &mdash; Supplies edge views, on the same terms as `nodeFactory`.
    - `background` &mdash; Optional backdrop hook, called once at the end of every pass.
    - `route` &mdash; Optional hook for marking the route already walked.
    - `pawn` &mdash; Optional hook for the traveller's own marker.
    - `transitions` &mdash; Optional adapter that takes over every node and edge transition. Installing one switches the per-view animation path off entirely.
    - `localization` &mdash; Optional adapter for node labels and tooltips. Null shows the authored text as-is.
    - `layoutStrategy` &mdash; Optional replacement for the shipped layered layout.
    - `focusIndicator` &mdash; Optional shared focus indicator, as an alternative to each view styling its own focus.

`public void Present(MapGraph graph, MapProgressionState progression, MapRuntimeContent content, bool revealAll)`

:   Draws an explicit graph, progression and content, bypassing the traversal controller. Intended for a map with no live run behind it: a preview, a save slot thumbnail, an editor tool. Display state is derived here from the arguments with the default fog look-ahead, not with an attached controller's own fog settings, so the two paths can disagree about what is hidden. Nothing is written back - drawing a progression cannot advance it - and the next state change from an attached controller redraws over whatever was presented this way.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `progression` &mdash; Input progression consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `content` &mdash; Compiled content supplying the theme and the node types. A node whose type is missing from it is skipped.
    - `revealAll` &mdash; True to leave nothing hidden by fog: an undiscovered node reads as locked instead.

`public void PushStyleToViews()`

:   Pushes the current style to every live node and edge view.

`public void Refresh()`

:   Draws the controller's current graph and progression again, or clears the map when there is no initialized controller to draw. The presenter already redraws itself whenever the controller reports a state change, so this is for the cases nothing signals: a controller initialized while the presenter was disabled, or a change made to the map from outside the controller's own events.

`public void SetFocusedNode(StableId nodeId)`

:   Moves the keyboard or gamepad focus treatment to a node, clearing it from whichever node had it. The input controller drives this as focus moves, so a caller only needs it to place focus itself. Focus is display-only: it never selects the node or advances the run. A node hidden by fog is deliberately not shown as focused, and the presenter drops focus by itself if the focused node later becomes hidden.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.

`public void SetTraversalController(MapTraversalController controller)`

:   Points the presenter at a different controller, unsubscribing from the previous one and drawing the new one straight away. Factories and adapters installed through `Configure` are kept, so this is the call for swapping which run is on screen rather than how it is drawn. Passing the controller already assigned does nothing at all, so it is safe to call repeatedly.
    - `controller` &mdash; Input controller consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void TickStyle(float presentationDeltaSeconds)`

:   Advances style animation: focus easing, the current-node pulse, and edge flow. Presentation only; nothing advanced here can reach a graph, a save envelope, or a fingerprint.
    - `presentationDeltaSeconds` &mdash; Input presentation Delta Seconds consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public bool TryGetDrawnNodePosition(StableId nodeId, out Vector2 position)`

:   Looks up where a node is actually drawn, in presentation units: the same position `TryGetPresentationPosition` reports, but with the style's flow direction applied, so a marker placed by it lands on the node whichever way the map runs. This is the position the node view was bound with, so it is what a pawn, a tooltip or a camera target should follow. It still comes from the layout rather than from the view's transform, so no transition or focus scaling in flight can move it.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - `position` &mdash; Where the node is drawn, or zero when there is nothing to report.
    - **Returns** &mdash; False before the first pass has run and for a node the current layout does not hold.

`public bool TryGetEdgePath(StableId edgeId, out IReadOnlyList<Vector2> points)`

:   Hands back the path one edge is drawn along, in presentation units, so a caller can walk something of its own down the route - a pawn, a caravan, a trail of dust - instead of sliding it across the map in a straight line. These are the very points the edge view was bound with: sampled from the theme's edge geometry and converted with the style's flow direction applied, so unlike `TryGetPresentationPosition` they match what is drawn under every flow direction. The first point sits on the edge's source node and the last on its target, so the last point is where a pawn crossing that edge comes to rest. The list is read-only and is replaced rather than rewritten when the layout is rebuilt, so a caller that kept one can tell it went stale by comparing instances.
    - `edgeId` &mdash; Stable identifier for the edge; an empty or unknown ID simply misses.
    - `points` &mdash; The path from source to target, or null when the edge has not been presented.
    - **Returns** &mdash; False before the first pass has run and for an edge the current layout does not hold.

`public bool TryGetPresentationPosition(StableId nodeId, out Vector2 position)`

:   Looks up a node's laid-out position in presentation units, so a caller can place something of its own beside it - a tooltip, a marker, a camera target - without reaching into the view. The position comes from the layout and the metrics, not from the view's transform, so it is unaffected by any transition or focus scaling in flight. It is the layout position scaled by the content size, with the style's flow direction not applied, so it matches where the node is actually drawn only while that direction runs along the theme's axis unflipped - bottom-to-top for a vertical theme, left-to-right for a horizontal one, which is what the shipped default style uses. Under any other flow direction the drawn node is mirrored or transposed against this value, so use `TryGetDrawnNodePosition` when you need where the node really is. It stays as it is because code written against it already places things by it.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - `position` &mdash; Input position consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; False before the first pass has run and for a node the current layout does not hold.

---

## MapRuntimeContent

:material-star: **Start here**

```csharp
public sealed class MapRuntimeContent
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContent.cs</small>

Everything needed to draw a map that the graph itself does not carry: the node types its type
IDs resolve to, and the theme they are laid out and styled with. A graph names its node types
by `StableId` and never reaches for their prefabs, icons, or colors, so this is
the side of the split that decides how a map looks and the graph is the side that decides
what it is -- swapping in different content restyles a map without changing it.

It is immutable and holds nothing scene-specific, so one instance can be shared by the
traversal controller, the presenter, and any custom view at once, and reused across every map
generated against the same rules. Build it once per theme and content revision rather than
per map: the lookup index is built up front, so rebuilding it costs more than keeping it.

**Constructors**

`public MapRuntimeContent(IEnumerable<CompiledMapNodeType> nodeTypes, CompiledMapTheme theme)`

:   Snapshots the node types and theme, copying the types, sorting them by ID, and indexing them for lookup, so the caller's collection may be changed afterwards without reaching the content.
    - `nodeTypes` &mdash; Every node type a graph drawn with this content may name. The sequence may be in any order, but each entry needs a non-empty ID and no two may share one.
    - `theme` &mdash; Input theme consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public IReadOnlyList<CompiledMapNodeType> NodeTypes`

:   Every node type this content can resolve, ordered by ID rather than by the order they were supplied in. Read-only, and the natural source for a legend or a type picker; resolving one node's type is what `TryGetNodeType` is for.

`public CompiledMapTheme Theme`

:   The theme this content is drawn with: spacing, orientation, edge shape, the backdrop and edge colors, the zoom range, and the state transition duration. Never null, and fixed for the life of the instance -- change the look by building new content, not by mutating this.

**Methods**

`public bool TryGetNodeType(StableId typeId, out CompiledMapNodeType nodeType)`

:   Resolves a graph node's `MapNode.TypeId` to the content it should be drawn with, through the index built at construction rather than by scanning `NodeTypes`.
    - `typeId` &mdash; Stable identifier for type; invalid or empty IDs are rejected before mutation.
    - `nodeType` &mdash; Input node Type consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; False when the graph names a type this content has no entry for, which is how a graph built against a different rules asset shows itself; the view is then responsible for choosing a fallback.

---

## MapRuntimeStateDeriver

```csharp
public static class MapRuntimeStateDeriver
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

Turns a graph plus the traveller's progression into the per-node fog and
visual states a view needs, and is what decides how much of the map the
player can currently see.

Discovery walks outward from the nodes actually visited, up to
`MapFogSettings.RevealDepth` edges - so depth 1 shows only the
immediate next choices, and larger depths reveal further ahead. The result is
derived fresh from progression rather than stored, so it can never drift out
of sync with a loaded save.

**Methods**

`public static MapRuntimeStateSnapshot Derive()`

:   Derives fog and visual state with the default one-step look-ahead. Kept so existing callers and saves behave exactly as before.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `progression` &mdash; Input progression consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `revealAll` &mdash; Whether reveal All; false selects the documented conservative behavior.
    - `unlockedNodeIds` &mdash; Ordered unlocked Node Ids input; implementations copy or enumerate it without taking caller ownership.
    - **Returns** &mdash; The complete map Runtime State Snapshot outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapRuntimeStateSnapshot Derive()`

:   Derives fog and visual state with explicit fog settings, so a project can choose how far ahead the map is revealed.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `progression` &mdash; Input progression consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `fogSettings` &mdash; Input fog Settings consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `unlockedNodeIds` &mdash; Ordered unlocked Node Ids input; implementations copy or enumerate it without taking caller ownership.
    - **Returns** &mdash; The complete map Runtime State Snapshot outcome; inspect its typed status or diagnostics before consuming payload data.

---

## MapRuntimeStateSnapshot

```csharp
public sealed class MapRuntimeStateSnapshot
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

The whole map's derived display state for one progression revision: one entry per
node, sorted by node ID and addressable by ID.

Immutable once built, so reading it cannot advance traversal or change what the
player sees; a move, an unlock, or a change of fog settings needs a newly derived
snapshot.

**Constructors**

`public MapRuntimeStateSnapshot(long revision, IEnumerable<MapNodeRuntimeState> nodes)`

:   Copies and sorts the supplied states; a null sequence yields an empty snapshot.
    - `revision` &mdash; Input revision consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `nodes` &mdash; One state per node, in any order.

**Properties**

`public IReadOnlyList<MapNodeRuntimeState> Nodes`

:   Every node's state, sorted by node ID rather than by progress or layout.

`public long Revision`

:   The progression revision this state was derived from. It tracks progression only, so two snapshots can carry the same revision and still differ, for instance when the fog settings changed between them.

**Methods**

`public bool TryGet(StableId id, out MapNodeRuntimeState state)`

:   Looks one node's state up by ID instead of scanning `Nodes`.
    - `state` &mdash; Input state consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `id` &mdash; Input id consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; True when the snapshot holds that node. A node missing here is one the snapshot was not derived for, not a concealed one: concealed nodes are present and report `MapFogState.Hidden`.

---

## MapSelectionResult

```csharp
public sealed class MapSelectionResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The outcome of asking the controller to move to a node.

It separates a request that never reached the traversal session - an unknown
node, a node that is not available, or a controller already dispatching
callbacks - from one that did, where `Transition` carries the
session's accept or reject.

**Properties**

`public StableId NodeId`

:   The node the request named, echoed back whatever became of it - including for a request that was dropped, and for an id the graph does not hold. It lets a caller match a result to the click that produced it without keeping the id itself.

`public bool Succeeded`

:   True only when a move was attempted and the session accepted it, so an ignored request never reads as a success.

`public MapTransitionResult Transition`

:   The session's result for the move, or null when the request never reached the session.

`public bool WasAvailable`

:   Whether the node was available when the request arrived. False on a request that was dropped without being attempted.

**Methods**

`public static MapSelectionResult Attempted(StableId nodeId, bool wasAvailable, MapTransitionResult transition)`

:   Records a request that reached the session, carrying the result it produced.
    - `transition` &mdash; The immutable session result. Null is permitted to represent a request that reached controller routing but produced no session transition.
    - `nodeId` &mdash; The node named by the request, preserved unchanged for correlation.
    - `wasAvailable` &mdash; Whether the node passed the controller's availability check when the request was handled.
    - **Returns** &mdash; A result that distinguishes availability from the transition's own typed success or failure.

`public static MapSelectionResult Ignored(StableId nodeId)`

:   Records a request that was dropped before the session saw it: `Transition` stays null and `Succeeded` is false.
    - `nodeId` &mdash; The requested node, including an unknown ID; it is echoed for input/result correlation and is not validated here.
    - **Returns** &mdash; A failed result with `WasAvailable` false and no transition.

---

## MapSetupHierarchyBinding

```csharp
public sealed class MapSetupHierarchyBinding : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapSetupHierarchyBinding.cs</small>

Durable identity for scene objects created and owned by the BranchWeaver setup wizard.

**Properties**

`public Transform Content`

:   The transform the presenter sits on and node and edge views are parented to -- under `SafeArea` on a Canvas setup, directly under this object otherwise. It is owned by setup on the same terms as the safe area, so unrecognized components or children on it block repair rather than being deleted.

`public bool IsCanvas`

:   True when the recorded hierarchy is the Canvas shape -- a safe-area rect with the map content beneath it -- and false when it is the world-space one. Running setup for the other shape destroys the recorded objects and rebuilds them, so this is what tells the wizard the two do not match.

`public Component OptionalInputBridge`

:   The Input System bridge component setup added, or null when setup ran without Input System support. It is typed as `Component` so this assembly never has to reference the Input System package; the concrete type is resolved by name at setup time and is absent from builds that do not have the package installed.

`public InputSystemSignalAdapter OptionalInputSignals`

:   The signal adapter setup wired to the bridge, or null when the optional input path was not installed. Recording it is what lets a later run remove exactly the components setup created instead of stripping ones you added by hand.

`public RectTransform SafeArea`

:   The safe-area rect the wizard created under this object, or null on a world-space setup. Setup owns it and may delete it, so anything of yours parented into it stops setup: it reports the hierarchy as holding customer content rather than removing your objects.

**Methods**

`public void Configure(bool usesCanvas, RectTransform ownedSafeArea, Transform ownedContent)`

:   Records which objects setup owns, replacing whatever was recorded before. This is bookkeeping only: it creates, reparents, and destroys nothing, so passing nulls is how setup clears the record after it has already destroyed those objects itself.
    - `usesCanvas` &mdash; True for the Canvas hierarchy, false for the world-space one.
    - `ownedSafeArea` &mdash; Input owned Safe Area consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `ownedContent` &mdash; Input owned Content consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void ConfigureOptionalInput(Component ownedBridge, InputSystemSignalAdapter ownedSignals)`

:   Records the optional Input System components setup owns, replacing whatever was recorded before. Like `Configure` it only writes the record; passing nulls is how setup clears it after removing those components, which is what happens when setup is re-run with Input System support switched off or the package is not installed.
    - `ownedBridge` &mdash; Input owned Bridge consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `ownedSignals` &mdash; Input owned Signals consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

---

## MapSurfaceStyling

```csharp
public static class MapSurfaceStyling
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapSurfaceStyling.cs</small>

Turns a node's compiled type, visual state, and fog state into the surface
request that draws it.

Keeping this a pure function of its inputs means the same mapping drives the
runtime views, the Map Studio graph, and the Style Browser previews, so what
an author sees while editing is what ships. It also makes the mapping
directly testable without a canvas.

It lives in the shared runtime assembly rather than beside the Canvas views
on purpose: a style has nothing to do with uGUI, and putting the mapping here
is what lets the Canvas and World2D presentations agree on what a node of a
given state should look like instead of each deciding separately.

**Methods**

`public static MapSurfaceRequest BuildBackdrop(CompiledMapStyle style)`

:   Constructs build Backdrop from validated inputs and returns an independently usable result without transferring caller ownership.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A new independently usable result; caller-owned inputs are not transferred.

`public static MapSurfaceRequest BuildEdgeSegment()`

:   Constructs build Edge Segment from validated inputs and returns an independently usable result without transferring caller ownership.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `edgeColor` &mdash; Input edge Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `segmentLength` &mdash; Input segment Length consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `leadsToAvailable` &mdash; Whether leads To Available; false selects the documented conservative behavior.
    - `isLastSegment` &mdash; Whether is Last Segment; false selects the documented conservative behavior.
    - `dashOffset` &mdash; Input dash Offset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A new independently usable result; caller-owned inputs are not transferred.

`public static MapSurfaceRequest BuildNode()`

:   Constructs build Node from validated inputs and returns an independently usable result without transferring caller ownership.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `stateColor` &mdash; Input state Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `visualState` &mdash; Input visual State consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `fogState` &mdash; Input fog State consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `pulsePhase` &mdash; Input pulse Phase consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A new independently usable result; caller-owned inputs are not transferred.

---

## MapTraversalController

:material-star: **Start here**

```csharp
public sealed class MapTraversalController : MonoBehaviour, IMapDevelopmentHost
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapTraversalController.cs</small>

The scene component that owns one traversal run: it holds the graph, the
progression, and the compiled content, applies every move through a
`MapSession`, and reports what happened as C# events, as
inspector-wired UnityEvents, and as a derived per-node display snapshot.

One operation runs at a time. A selection, a completion, an initialize, or a
development command issued from inside a callback the controller is already
dispatching is refused rather than nested, because a nested call would commit
progression on top of state the outer call is still reporting. A refusal comes
back as a result value rather than an exception, so a view may call in straight
from a click handler without guarding. The single exception is the regenerate
command in a build that defines BRANCHWEAVER_DEVTOOLS, which deliberately opens
one nested initialize for its handler and closes it again afterwards.

Listeners are isolated from one another: one that throws is caught, the
remaining listeners still run, the committed transition still stands, and the
failure is appended as a warning to `LastControllerValidation`. That
warning is only recorded, not announced: a throwing C# listener or UnityEvent
slot does not raise `ValidationFailed`, so read the property after a
dispatch when a failing listener has to be noticed. A throwing
`AudioCueAdapter` is the one callback whose warning is published.

In a build that defines BRANCHWEAVER_DEVTOOLS the component additionally
implements IMapDevelopmentHost, which is the surface the development overlay
drives.

**Properties**

`public IMapAudioCueAdapter AudioCueAdapter`

:   The hook that plays the enter and complete cue ids authored on node types. Leaving it null plays nothing; the controller has no audio of its own. It is called from inside a transition dispatch, and only when the node's compiled type declares a cue id that parses as a stable id. An exception thrown from it is recorded as a callback-failed warning rather than undoing the transition, and driving traversal from inside it is refused as a nested operation. The Audio Cue Adapter Component slot answers this from the inspector while nothing has been installed from code, so a scene can be wired up without writing any.

`public MapUnityEvent AvailabilityChangedUnityEvent`

:   The first serialized slot for `AvailabilityChanged`. It takes no argument, so a slot that needs the new set reads it back from `State`. Never null.

`public MapRuntimeContent Content`

:   The compiled node types and theme this run was initialized with, or null before the first successful initialize. The controller reads it to confirm every node in the graph has a compiled type, and to look up the cue ids it hands to `AudioCueAdapter`.

`public MapFogSettings FogSettings`

:   How far ahead of the traveller the map is revealed. Fog is derived rather than stored, so changing this re-reveals an existing save correctly with no migration.

`public MapGraph Graph`

:   The graph currently being traversed, or null before the first successful initialize. A refused initialize leaves the previous graph in place.

`public bool IsInitialized`

:   Whether a traversal session exists. It stays true once a run has finished, so the final state can still be read, and it keeps reporting the previous run when an initialize is refused.

`public ValidationReport LastControllerValidation`

:   The most recent report the controller recorded: never null, and emptied by a successful initialize. It also collects the callback failures that are never announced through `ValidationFailed`, so read it whenever a call returns false or a refusal - and after a dispatch when a throwing listener matters - since problems are recorded here rather than logged or thrown.

`public MapUnityEvent MapCompletedUnityEvent`

:   The first serialized slot for `MapCompleted`, the usual place to wire an end-of-run screen from the inspector. Never null.

`public MapUnityEvent MapGeneratedUnityEvent`

:   The first serialized slot for `MapGenerated`, which is the one the inspector shows. Never null: an empty or cleared slot list is repopulated on access, so a listener added from code always has somewhere to attach.

`public MapStringUnityEvent NodeCompletedUnityEvent`

:   The first serialized slot for `NodeCompleted`, invoked with the completed node's id as text. The result payload is not carried; read it from the C# event when it matters. Never null.

`public MapStringUnityEvent NodeEnteredUnityEvent`

:   The first serialized slot for `NodeEntered`, invoked with the entered node's id as text. The rest of the transition event is not carried, so use the C# event when a listener needs the revision or the available set. Never null.

`public MapStringUnityEvent NodeSelectionRequestedUnityEvent`

:   The first serialized slot for `NodeSelectionRequested`, invoked with the node's id as text rather than as a `StableId`, because a UnityEvent argument has to be a type the inspector can serialize. Never null.

`public bool RevealAll`

:   Whether the development reveal-all override is on. Only the development command sets it, and an initialize or a development reset clears it, so it is always false in a build that does not define BRANCHWEAVER_DEVTOOLS. To reveal a map in a shipping build set `MapFogSettings.RevealAll` through `FogSettings` instead.

`public MapUnityEvent SaveRequestedUnityEvent`

:   The first serialized slot for `SaveRequested`. It carries neither the graph nor the progression, so a slot wired here has to read them back from `Graph` and `State`. Never null.

`public MapSerializedEventBridge SerializedEvents`

:   The inspector-wired UnityEvent hooks, for scenes that wire behaviour up without writing code. Each hook is a list of independent slots, invoked one at a time behind an exception guard so a misbehaving slot cannot stop the rest. They fire only while the component's Invoke Serialized Events flag is on; the C# events are the surface to prefer from code.

`public MapProgressionState State`

:   The progression committed so far, or null before the first successful initialize. Each accepted transition replaces the whole value instead of mutating it, so a stored reference keeps reporting the revision it was read at.

`public MapUnityEvent ValidationFailedUnityEvent`

:   The first serialized slot for `ValidationFailed`. The report itself is not carried; a slot wired here reads `LastControllerValidation` to see what was recorded. Never null.

**Events**

`public event Action<MapTransitionEvent> AvailabilityChanged`

:   Raised when the set of choosable nodes changed, with the new set on `MapTransitionEvent.AvailableNodeIds` and an empty `MapTransitionEvent.NodeId`, because the change concerns the map rather than one node. Entering a node also raises it, with an empty set: nothing else is choosable until that node is completed.

`public event Action<uint> DevelopmentRegenerateRequested`

:   Raised by `DevelopmentRegenerate` with the seed to build from. The handler is expected to generate the replacement map and initialize the controller before it returns: exactly one nested initialize is opened for the duration of the call, and the command reports failure if it does not happen. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.

`public event Action<MapTransitionEvent> MapCompleted`

:   Raised when the completed node had no outgoing edges and the run is therefore over. It follows `NodeCompleted` for the same node rather than replacing it, so an end-of-run screen belongs here and not on the last completion.

`public event Action<MapGraph> MapGenerated`

:   Raised when an initialize succeeds, carrying the graph now being traversed. It fires for a restored save exactly as it does for a freshly generated map, so read it as "the map was replaced" rather than "a map was generated". It arrives before the first `StateChanged` of the new run.

`public event Action<MapTransitionEvent> NodeCompleted`

:   Raised when the current node has been finished, carrying the completion data it was given on `MapTransitionEvent.ResultPayload`.

`public event Action<MapTransitionEvent> NodeEntered`

:   Raised once the traveller has moved onto a node. The move is already committed by the time it arrives, so a listener reacts to it rather than vetoing it.

`public event Action<StableId> NodeSelectionRequested`

:   Raised for each `RequestNodeSelection` naming a node that exists in the graph, before availability is tested - so it also fires for a node the traveller cannot enter, which is where a "locked" click response belongs. A request naming an unknown id raises nothing at all.

`public event Action<MapGraph, MapProgressionState> SaveRequested`

:   Raised by `RequestSave` with the graph and the progression to persist. The controller writes nothing itself, so nothing is saved until a listener does it; both values are immutable snapshots, so a handler may hold them while it serializes.

`public event Action<MapRuntimeStateSnapshot> StateChanged`

:   Raised after every committed change with a freshly derived `MapRuntimeStateSnapshot` for the whole map. This is what a presenter redraws from: fog and any development overrides are already folded in, so a view never has to combine the graph and the progression itself.

`public event Action<ValidationReport> ValidationFailed`

:   Raised whenever the controller publishes a report: a refused initialize, a transition the session turned down, a transition that carried warnings, or an `AudioCueAdapter` that threw. A C# listener or UnityEvent slot that throws does not raise it - that failure is only appended to `LastControllerValidation`. Not every report is fatal - a callback failure arrives as a warning-only report - so check `ValidationReport.IsValid` rather than assuming the run has stopped.

**Methods**

`public MapTransitionResult CompleteCurrent()`

:   Finishes the node the traveller is on and records an empty result, which is what an encounter with no outcome data to hand back calls.
    - **Returns** &mdash; Whatever the payload overload returns: null when the controller is not initialized, a refusal carrying `MapTransitionFailureKind.TransitionInProgress` when the call came from inside a callback the controller is already dispatching, and otherwise the session's result.

`public MapTransitionResult CompleteCurrent(MapDataPayload result)`

:   Finishes the node the traveller is on and records `result` against it, so later branching and a reloaded save can both read what happened there. Completing is what makes the next nodes choosable: it raises `NodeCompleted` followed by `AvailabilityChanged`, or by `MapCompleted` instead when the node had no outgoing edges.
    - `result` &mdash; Completion data to record. A null or non-canonical payload is refused rather than stored.
    - **Returns** &mdash; The session's result; null when the controller is not initialized, and a refusal carrying `MapTransitionFailureKind.TransitionInProgress` when the call came from inside a callback the controller is already dispatching.

`public MapDevelopmentCommandResult CopyGenerationManifest()`

:   Collects the fields that identify how this map was generated - generator and graph format versions, seed, rules and graph fingerprints, and generation key - as semicolon-separated key=value text, which is what makes a bug report against a procedural map reproducible. Despite the name it does not touch the system clipboard: the text comes back on `MapDevelopmentCommandResult.Value` and the caller decides what to do with it. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.NotInitialized` when there is no run to describe.

`public MapDevelopmentCommandResult DevelopmentCompleteCurrent()`

:   Completes the node the traveller is on with an empty result, as if its encounter had finished normally - so it goes through the ordinary transition rules and raises the ordinary events rather than going around them. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.RejectedTransition` when there is no run, no current node to complete, or the transition was otherwise turned down.

`public MapDevelopmentCommandResult DevelopmentForceResult(MapDataPayload result)`

:   Completes the current node with a chosen result payload, which is how branching that keys off an outcome gets exercised without playing the encounter that produces it. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - `result` &mdash; The completion data to record. It must be canonical.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.InvalidPayload` when `result` is null, or `MapDevelopmentFailureKind.RejectedTransition` when the payload is not canonical or there is no current node to complete.

`public MapDevelopmentCommandResult DevelopmentRegenerate(uint seed)`

:   Asks the registered `DevelopmentRegenerateRequested` handler for a fresh map built from `seed`. The handler has to generate the map and initialize the controller before it returns. A single nested initialize is opened for the duration of the call and closed again afterwards, and the command reports failure when that initialize did not happen - which is what stops an asynchronous handler from leaving the overlay claiming a success it never got. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - `seed` &mdash; The generation seed to rebuild from.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.Unsupported` when no handler is registered, or `MapDevelopmentFailureKind.RejectedTransition` when the handler did not synchronously initialize a replacement map.

`public MapDevelopmentCommandResult DevelopmentReset()`

:   Restarts the run on the same graph: progression goes back to the beginning, and the development unlocks and the reveal-all override are dropped. The compiled content is kept, so this is cheaper than re-initializing and cannot fail on content. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.NotInitialized` when there is no run to reset.

`public MapDevelopmentCommandResult DevelopmentRevealAll(bool reveal)`

:   Turns the reveal-all override on or off and republishes the map's display state, without touching progression. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - `reveal` &mdash; True to show every node; false to go back to derived fog.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.NotInitialized` when there is no run, or `MapDevelopmentFailureKind.RejectedTransition` when another operation is already dispatching.

`public MapDevelopmentCommandResult DevelopmentTeleport(StableId nodeId)`

:   Moves the traveller straight to a node, fabricating the route and the completions it would have taken to get there. A breadth-first search from the graph's start nodes supplies the path, and every node along it bar the destination is recorded as completed with an empty result, so the rebuilt progression is still a legal route and can still be saved. Those completions are invented, so branching that keys off a real result payload will not find one. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - `nodeId` &mdash; The node to stand the traveller on. It must be reachable from a start node.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.InvalidNode` when the id is empty or unreachable, or `MapDevelopmentFailureKind.RejectedTransition` when the revision cannot advance or the fabricated progression is turned down.

`public MapDevelopmentCommandResult DevelopmentUnlock(StableId nodeId)`

:   Makes one node display as available whatever the progression says, so a branch can be inspected without walking to it. It changes derived display state only. Traversal still consults the session, so `RequestNodeSelection` goes on refusing the node. The unlock is remembered until the next initialize or development reset. Exists only in a build that defines BRANCHWEAVER_DEVTOOLS.
    - `nodeId` &mdash; The node to show as available.
    - **Returns** &mdash; A refusal carrying `MapDevelopmentFailureKind.InvalidNode` when the id is empty or names no node in the graph.

`public MapRuntimeStateSnapshot GetRuntimeState()`

:   Returns the derived display state of every node - the visual state a presenter styles it with, and how far fog conceals it - for the progression as it now stands. The snapshot is derived rather than stored, then cached until something invalidates it, which a transition, a replaced session, and a change to `FogSettings` all do. Because it is derived it can never disagree with the save it came from, so changing how far ahead the map is revealed needs no migration.
    - **Returns** &mdash; The current snapshot, or an empty one at revision 0 when the controller is not initialized.

`public bool Initialize(MapGraph graph, MapRuntimeContent content)`

:   Starts a fresh run at the beginning of `graph`, with no progression restored.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `content` &mdash; Compiled node types and theme. Every node type the graph uses must be present.
    - **Returns** &mdash; False when the map was refused - the previous run is untouched and `LastControllerValidation` explains why - and also false when the call arrived from inside a callback the controller is already dispatching, which is turned down without recording a report.

`public bool Initialize(MapGraph graph, MapProgressionState restoredState, MapRuntimeContent content)`

:   Adopts a graph together with progression read back from a save, replacing whatever run was in progress. The graph is refused when a node names a type `content` does not compile, and the progression is refused when it does not describe one legal ordered route through that graph - which is what stops a tampered or mismatched save from standing the traveller somewhere unreachable. Nothing is replaced on a refusal. On success the reveal-all override and any development unlocks are dropped, `LastControllerValidation` is emptied, and `MapGenerated` is raised before the first `StateChanged`.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `restoredState` &mdash; Progression to resume from; null starts at the beginning of the graph.
    - `content` &mdash; Compiled node types and theme. Every node type the graph uses must be present.
    - **Returns** &mdash; False when the graph or the progression was refused, or when the call arrived from inside a callback the controller is already dispatching.

`public MapSelectionResult RequestNodeSelection(StableId nodeId)`

:   Asks to move the traveller onto a node, which is what a click on the map should call. The request never reaches the session when the controller is not initialized, when another operation is already dispatching, when the id names no node in the graph, or when the node is not currently available. That last case still raises `NodeSelectionRequested` first, so an unavailable node can be answered with feedback. Anything else goes to `MapSession.TryEnter`, which may still turn it down.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - **Returns** &mdash; A result that tells a dropped request apart from an attempted one. Check `MapSelectionResult.Succeeded` rather than assuming the move happened.

`public void RequestSave()`

:   Asks whoever is listening to persist the run, by raising `SaveRequested` with the current graph and progression. The controller stores nothing itself, so this does nothing until a save adapter is wired up, and nothing at all before the first successful initialize. Unlike the other operations it may be called from inside a controller callback, which is what lets a project save on `NodeCompleted`: it only reads state, so nothing can be committed underneath the outer call. A call made from inside a `SaveRequested` handler is ignored, so a handler cannot drive itself in a loop.

---

## PassthroughLocalizationAdapter

```csharp
public sealed class PassthroughLocalizationAdapter : IMapLocalizationAdapter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The `IMapLocalizationAdapter` used when a project has no
localization system wired up: it returns the authored fallback text
unchanged, falling back to the key itself when no text was authored.

Returning the key rather than an empty string is deliberate - a missing
string shows up on screen as a visible identifier you can search for,
instead of a blank label that looks like a layout bug.

**Methods**

`public string Resolve(string key, string fallback)`

:   Returns `fallback` when it has text, otherwise `key`, never null.
    - `key` &mdash; The authored localization key, used only when no fallback text was supplied; null is treated as empty.
    - `fallback` &mdash; The authored display text; any non-empty value is returned unchanged.
    - **Returns** &mdash; The fallback when present, otherwise the key; never null.

---

## WorldMapEdgeView

```csharp
public sealed class WorldMapEdgeView : MonoBehaviour, IMapEdgeView, IMapEdgeTransitionView
```

`BranchWeaver.Presentation.World2D` &middot; <small>BranchWeaver/Runtime/Presentation/World2D/WorldMapViews.cs</small>

Draws one edge between two map nodes as a world-space line, and is the edge
view the World2D presentation builds by default.

It uses a `LineRenderer` rather than the SDF surface its Canvas
counterpart draws with, so it carries colour and fog but not shape, stroke,
glow or dash flow. That is the current limit of World2D styling rather than
a choice about how a world-space map should look; see
`Canvas.CanvasMapEdgeView` for the styled equivalent.

**Properties**

`public StableId EdgeId`

:   Gets or sets the stable identifier used for ordinal lookup, fingerprints, and persisted compatibility checks.

`public bool IsTransitioning`

:   Gets whether is Transitioning; the value reflects validated world Map Edge View state.

`public Material OwnedMaterial`

:   Gets owned Material captured by `WorldMapEdgeView`; the value is immutable after construction.

`public IReadOnlyList<NormalizedMapPosition> Points`

:   Gets or sets a read-only points collection in deterministic order; callers receive no mutation access to the owner's backing state.

`public Transform Transform`

:   Gets transform captured by `WorldMapEdgeView`; the value is immutable after construction.

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   Updates advance Transition state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `deltaSeconds` &mdash; Input delta Seconds consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void BeginTransition(MapFogState fromFog, MapFogState toFog, float durationSeconds)`

:   Updates begin Transition state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `fromFog` &mdash; Input from Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `toFog` &mdash; Input to Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `durationSeconds` &mdash; Input duration Seconds consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void Bind(MapEdgeViewData data)`

:   Updates bind state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `data` &mdash; Input data consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void CancelTransition(bool applyTerminalState)`

:   Updates cancel Transition state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `applyTerminalState` &mdash; Whether apply Terminal State; false selects the documented conservative behavior.

`public void ConfigureOwnedDefaultMaterial()`

:   Replaces the configure Owned Default Material settings used by future operations; existing immutable graphs and saves are not rewritten.

`public void DisposeOwnedResources()`

:   Updates dispose Owned Resources state only after validating supplied inputs, preserving the owning type's deterministic invariants.

`public void PrepareForBind()`

:   Updates prepare For Bind state only after validating supplied inputs, preserving the owning type's deterministic invariants.

`public void RestoreAfterUnchangedBind()`

:   Updates restore After Unchanged Bind state only after validating supplied inputs, preserving the owning type's deterministic invariants.

`public void SetActive(bool active)`

:   Replaces the set Active settings used by future operations; existing immutable graphs and saves are not rewritten.
    - `active` &mdash; Whether active; false selects the documented conservative behavior.

---

## WorldMapNodeView

```csharp
public sealed class WorldMapNodeView : MonoBehaviour, IMapNodeView, IMapNodeHitState, IMapNodeTransitionView, IMapFocusView, IMapStyledView
```

`BranchWeaver.Presentation.World2D` &middot; <small>BranchWeaver/Runtime/Presentation/World2D/WorldMapViews.cs</small>

Draws one map node as a world-space sprite, and is the node view the World2D
presentation builds by default.

Use this instead of `CanvasMapNodeView` when the map lives
in the scene alongside other 2D content - so it sorts, lights and parallaxes
with the rest of the world - rather than on a screen-space overlay. Labels are
drawn with `TextMesh` plus a shadow so they stay legible over busy art.

**Properties**

`public string DisplayLabel`

:   The label last bound, already through the localization adapter. Empty when the node type declares none, in which case the label object is deactivated rather than drawn blank.

`public MapFogState FogState`

:   How fog is treating the node. A dimmed node is drawn at three quarters of its colour's alpha; a hidden one has its `SpriteRenderer` disabled outright as well as being given zero alpha, so it costs nothing to draw while it is out of sight.

`public bool IsHitTestVisible`

:   Whether a click on the node should count. False while fog hides it and false while its renderer is disabled, so a node the player cannot see cannot be selected by accident. It follows the bound fog state, not the fade: a node on its way out stops accepting clicks as soon as it is bound to hidden, while it is still visibly fading away.

`public bool IsTransitioning`

:   Whether a colour cross-fade started by `BeginTransition` is still running. The focus scale is applied instantly and is not counted here.

`public StableId NodeId`

:   The node this view currently stands for, taken from the last `Bind`. Empty until the first bind, which is what keeps an unbound pooled instance out of hit testing.

`public NormalizedMapPosition NormalizedPosition`

:   Where the presenter laid the node out, in normalized layout space. The drawn world position is derived from it, so this is the layout coordinate rather than the world units the node ended up at.

`public string Tooltip`

:   The tooltip last bound, already localized. Kept for a host that draws its own tooltips; this view never renders it.

`public Transform Transform`

:   The node's own transform. Input resolves a click to this node through it, and the factory parents the node by it, so it stays valid for the component's whole lifetime. Its local scale carries the focus treatment, so it is not a reliable place to read the node's size from.

`public MapNodeVisualState VisualState`

:   The traversal state the node was last bound in: hidden, locked, available, current, visited or completed. An undiscovered node is bound as hidden rather than left out of the pass, so this reads hidden for most of a fogged map. It is the destination of a state change rather than what is on screen: the bind runs before the cross-fade, so this already reads the new state while the colour is still travelling towards it.

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   Advances a colour cross-fade in flight, interpolating straight from the captured start colour to the destination. The presenter drives this once a frame on an unscaled delta, so pausing the game does not strand a node mid-fade. A negative delta counts as none, and the frame the fade lands on is also the frame the renderer returns to the visibility the last bind asked for.
    - `deltaSeconds` &mdash; Seconds since the previous advance.

`public void ApplyStyle(CompiledMapStyle style)`

:   Adopts a compiled style and redraws. Passing null returns the node to the unstyled sprite it drew before styling existed, rather than leaving the last style stuck on it.
    - `style` &mdash; Input style consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void BeginTransition(MapNodeVisualState fromVisual, MapFogState fromFog,)`

:   Cross-fades the node's sprite into the state it has just been bound in, taking the label and its shadow along with it. The bind has already applied the destination colour, so the fade works by putting the starting colour back and easing forward from there. A fade interrupted part-way resumes from the colour `PrepareForBind` captured, which is what stops states that change in quick succession from jumping. The renderer is switched on for the duration even when the destination is hidden - so a node fades out rather than vanishing - and switched off again once the fade lands. A duration of zero or less, or two states that resolve to the same colour, applies the destination at once and leaves `IsTransitioning` false.
    - `fromVisual` &mdash; Input from Visual consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `fromFog` &mdash; Input from Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `toVisual` &mdash; Input to Visual consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `toFog` &mdash; Input to Fog consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `durationSeconds` &mdash; Fade time in seconds; zero or less applies the destination immediately.

`public void Bind(MapNodeViewData data)`

:   Updates bind state only after validating supplied inputs, preserving the owning type's deterministic invariants.
    - `data` &mdash; Input data consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void CancelTransition(bool applyTerminalState)`

:   Abandons a cross-fade in flight, before the node is bound again or handed back to its factory. The focus scale is left alone.
    - `applyTerminalState` &mdash; True to finish by applying the destination colour and the visibility the last bind asked for, which for a hidden node means switching the renderer off; false to leave the node exactly where the fade stopped, because a new fade is about to start from there.

`public void PrepareForBind()`

:   Records the colour on screen right now, immediately before a bind that changes state, so the cross-fade that follows can carry on from a fade already in flight instead of snapping back to the old state. Does nothing on a node that has not been bound yet and so has no renderer resolved.

`public void RestoreAfterUnchangedBind()`

:   Puts back the colour `PrepareForBind` captured and switches the renderer on again, for a bind that turned out not to change state, so a fade in flight is not cut short. Safe to call with nothing captured and with nothing fading, in which case it only clears the capture.

`public void SetActive(bool active)`

:   Shows or hides the node's whole GameObject. This is not how fog is applied: the presenter activates a node after every bind, a fogged one included, and a hidden node is dealt with by disabling its renderer instead. In practice this is the pooling switch, so it has to be reversible - the same instance is handed back out later.
    - `active` &mdash; False to park the node, typically because its factory has taken it back.

`public void SetFocused(bool focused)`

:   Shows or clears the keyboard and gamepad focus treatment, by drawing the node at 115% of the size it was bound at. The scale is applied at once with no easing, and being told the value it already has re-applies the same scale, so the presenter can drive it on every pass without anything restarting or accumulating.
    - `focused` &mdash; True while this is the focused node.

`public void TickStyle(float presentationDeltaSeconds)`

:   Advances the current node's pulse. Only the current node pulses, and only when the style asks for it, so a map at rest does nothing here. The phase is supplied by the caller's visual clock, so it never reads a global time source and never affects state.
    - `presentationDeltaSeconds` &mdash; Elapsed presentation seconds; zero or less does nothing.

---

## WorldMapPresenter

:material-star: **Start here**

```csharp
public sealed class WorldMapPresenter : MapPresenterBase
```

`BranchWeaver.Presentation.World2D` &middot; <small>BranchWeaver/Runtime/Presentation/World2D/WorldMapPresenter.cs</small>

Draws a map as ordinary scene objects rather than UI. Nodes become SpriteRenderer-backed views
pooled per node type, routes become LineRenderers drawn from a pool of their own, and both are
parented to the node and edge roots, so the map sits in world space alongside your other 2D
content and is seen by the same cameras, sorting layers, and post-processing. A node type
carrying a world prefab is instantiated instead of the built-in view.

Unlike `BranchWeaver.Presentation.Canvas.CanvasMapPresenter` it resizes nothing:
world roots have no rect to fit, so how large the map appears is a matter of the roots' own
scale and the camera. Everything else -- binding to the traversal controller, fog and visual
state, transitions, focus, and styles -- comes from `MapPresenterBase`.

---

