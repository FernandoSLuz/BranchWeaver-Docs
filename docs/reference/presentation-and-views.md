# Presentation and views

48 types in this area.

!!! abstract "On this page"
    [CanvasMapEdgeView](#canvasmapedgeview) &middot; [CanvasMapNodeView](#canvasmapnodeview) &middot; [CanvasMapPresenter](#canvasmappresenter) &middot; [DefaultMapNodeHitTester](#defaultmapnodehittester) &middot; [IMapAudioCueAdapter](#imapaudiocueadapter) &middot; [IMapBackgroundPresenter](#imapbackgroundpresenter) &middot; [IMapDevelopmentHost](#imapdevelopmenthost) &middot; [IMapEdgeAvailabilityView](#imapedgeavailabilityview) &middot; [IMapEdgeTransitionView](#imapedgetransitionview) &middot; [IMapEdgeView](#imapedgeview) &middot; [IMapEdgeViewFactory](#imapedgeviewfactory) &middot; [IMapFocusIndicatorPresenter](#imapfocusindicatorpresenter) &middot; [IMapFocusView](#imapfocusview) &middot; [IMapInputSource](#imapinputsource) &middot; [IMapLocalizationAdapter](#imaplocalizationadapter) &middot; [IMapNodeHitState](#imapnodehitstate) &middot; [IMapNodeHitTester](#imapnodehittester) &middot; [IMapNodeTransitionView](#imapnodetransitionview) &middot; [IMapNodeView](#imapnodeview) &middot; [IMapNodeViewFactory](#imapnodeviewfactory) &middot; [IMapPresentationTransitionAdapter](#imappresentationtransitionadapter) &middot; [IMapViewFactoryLifetime](#imapviewfactorylifetime) &middot; [IPlayerPawnPresenter](#iplayerpawnpresenter) &middot; [IRouteMarkerPresenter](#iroutemarkerpresenter) &middot; [InputSystemSignalAdapter](#inputsystemsignaladapter) &middot; [LegacyMapInputSource](#legacymapinputsource) &middot; [MapDevelopmentCommandResult](#mapdevelopmentcommandresult) &middot; [MapDevelopmentFailureKind](#mapdevelopmentfailurekind) &middot; [MapEdgeViewData](#mapedgeviewdata) &middot; [MapFogSettings](#mapfogsettings) &middot; [MapFogState](#mapfogstate) &middot; [MapInputController](#mapinputcontroller) &middot; [MapInputFrame](#mapinputframe) &middot; [MapNavigationDirection](#mapnavigationdirection) &middot; [MapNavigationModel](#mapnavigationmodel) &middot; [MapNodeRuntimeState](#mapnoderuntimestate) &middot; [MapNodeViewData](#mapnodeviewdata) &middot; [MapNodeVisualState](#mapnodevisualstate) &middot; [MapPresenterBase](#mappresenterbase) &middot; [MapRuntimeContent](#mapruntimecontent) &middot; [MapRuntimeStateDeriver](#mapruntimestatederiver) &middot; [MapRuntimeStateSnapshot](#mapruntimestatesnapshot) &middot; [MapSelectionResult](#mapselectionresult) &middot; [MapSetupHierarchyBinding](#mapsetuphierarchybinding) &middot; [MapTraversalController](#maptraversalcontroller) &middot; [PassthroughLocalizationAdapter](#passthroughlocalizationadapter) &middot; [WorldMapNodeView](#worldmapnodeview) &middot; [WorldMapPresenter](#worldmappresenter)

## CanvasMapEdgeView

```csharp
public sealed class CanvasMapEdgeView : MonoBehaviour, IMapEdgeView, IMapEdgeTransitionView, IMapStyledView, IMapEdgeAvailabilityView
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public StableId EdgeId`

:   &mdash;

`public bool IsTransitioning`

:   &mdash;

`public IReadOnlyList<NormalizedMapPosition> Points`

:   &mdash;

`public IReadOnlyList<Vector2> RenderedPoints`

:   &mdash;

`public Transform Transform`

:   &mdash;

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   &mdash;

`public void ApplyStyle(CompiledMapStyle style)`

:   Supplies the style this edge draws with.

`public void BeginTransition(MapFogState fromFog, MapFogState toFog, float durationSeconds)`

:   &mdash;

`public void Bind(MapEdgeViewData data)`

:   &mdash;

`public void CancelTransition(bool applyTerminalState)`

:   &mdash;

`public void PrepareForBind()`

:   &mdash;

`public void RestoreAfterUnchangedBind()`

:   &mdash;

`public void SetActive(bool active)`

:   &mdash;

`public void SetLeadsToAvailable(bool value)`

:   Marks this route as leading to a reachable node. Routes to reachable nodes are drawn thicker and, when the style asks for it, flow toward the destination so the next choice reads at a glance.

`public void TickStyle(float presentationDeltaSeconds)`

:   Advances dash flow by a presentation delta.

---

## CanvasMapNodeView

```csharp
public sealed class CanvasMapNodeView : MonoBehaviour, IMapNodeView, IMapNodeHitState, IMapNodeTransitionView, IMapFocusView, IMapStyledView
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public string DisplayLabel`

:   &mdash;

`public MapFogState FogState`

:   &mdash;

`public bool IsHitTestVisible`

:   &mdash;

`public bool IsTransitioning`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public NormalizedMapPosition NormalizedPosition`

:   &mdash;

`public string Tooltip`

:   &mdash;

`public Transform Transform`

:   &mdash;

`public MapNodeVisualState VisualState`

:   &mdash;

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   &mdash;

`public void ApplyStyle(CompiledMapStyle style)`

:   Supplies the style this node draws with. Optional: without a style the node still renders a flat tinted shape, which is what the headless tests assert against.

`public void BeginTransition(MapNodeVisualState fromVisual, MapFogState fromFog,)`

:   &mdash;

`public void Bind(MapNodeViewData data)`

:   &mdash;

`public void CancelTransition(bool applyTerminalState)`

:   &mdash;

`public void PrepareForBind()`

:   &mdash;

`public void RestoreAfterUnchangedBind()`

:   &mdash;

`public void SetActive(bool active)`

:   &mdash;

`public void SetFocused(bool focused)`

:   &mdash;

`public void TickStyle(float deltaSeconds)`

:   Advances focus tweening and the current-node pulse. Driven by the presenter's visual clock so pausing the game pauses the map, and so tests can step it deterministically.

---

## CanvasMapPresenter

:material-star: **Start here**

```csharp
public sealed class CanvasMapPresenter : MapPresenterBase
```

`BranchWeaver.Presentation.Canvas` &middot; <small>BranchWeaver/Runtime/Presentation/Canvas/CanvasMapPresenter.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## DefaultMapNodeHitTester

```csharp
public sealed class DefaultMapNodeHitTester : MonoBehaviour, IMapNodeHitTester
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

The shipped hit tester. It considers the active `MapNodeView`
components on this object and its children, and covers both presentation styles:
Canvas views by rectangle, World2D views by renderer bounds. Candidates are
visited topmost first, so an overlapping node cannot steal a press. A view that
also implements `MapNodeHitState` decides its own eligibility;
otherwise a view whose renderers are all disabled is skipped.

**Properties**

`public Camera EventCamera`

:   The camera screen positions are interpreted through. When it is null the tester resolves one itself: `amera.main`, else the first active camera in a stable order.

**Methods**

`public void BindCamera(Camera value)`

:   Sets the camera used for World2D views and for canvases that render through a camera. Screen-space-overlay canvases never need one. Pass null to return to automatic resolution.

`public bool TryHit(Vector2 screenPosition, out StableId nodeId)`

:   Finds the topmost node view containing a screen position. It allocates a candidate list and queries the hierarchy per call, which is why the controller only calls it on frames that carry a press.
    - `screenPosition` &mdash; Pointer position in screen pixels.
    - `nodeId` &mdash; The node hit, or `default` when nothing was hit.
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
with the theme currently in force — so an implementation must tolerate being
handed the same theme repeatedly and should do nothing when it has not changed.
A background presenter that also implements `MapStyledView`
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
shipping build. Each command answers with a result rather than throwing, and one
command cannot run while another is dispatching callbacks.

---

## IMapEdgeAvailabilityView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeAvailabilityView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapStyledViewContracts.cs</small>

Implemented by an edge view that can emphasize routes leading to a
reachable node.

Separate from `MapStyledView` so a custom edge view can adopt
styling without also having to reason about availability, and vice versa.

---

## IMapEdgeTransitionView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeTransitionView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `MapEdgeView`: the edge counterpart of
`MapNodeTransitionView`, driven in the same order and under the same
condition that no `MapPresentationTransitionAdapter` is installed.

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
routes your own way — a line renderer, a UI mesh, a chain of sprites — and hand
instances to the presenter through an `MapEdgeViewFactory`.

Unlike a node view, an edge view really is deactivated when fog hides it, so
`etActive` must be reversible rather than a teardown.

---

## IMapEdgeViewFactory

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapEdgeViewFactory
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Creates and recycles the edge views a presenter draws with — the same seam as
`MapNodeViewFactory`, for routes instead of nodes. Edges have no
per-type art, so one factory serves every edge on the map.

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
presenter clears the map — that last call arrives with an empty node id and a
null layout and means "hide yourself", so an implementation must handle it.

---

## IMapFocusView

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapFocusView
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `MapNodeView`: lets a view show keyboard or gamepad
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
stack — legacy Input, Input System, a recorded replay, a test — without the
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

`esolve` is called twice for every node the presenter binds, so it
must be cheap, and nothing guards it: an exception thrown from it abandons the
presentation pass part-way through.

---

## IMapNodeHitState

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapNodeHitState
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional on an `MapNodeView`: lets the view decide for itself
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

Optional on an `MapNodeView`: lets a view animate its own state
changes, which is how the shipped node views cross-fade.

Consulted only while no `MapPresentationTransitionAdapter` is
installed. The presenter drives it in a fixed order:
`repareForBind` before a bind that changes state, then
`eginTransition` after that bind, then
`dvanceTransition` once a frame on an unscaled delta so that
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
nodes your own way — a prefab, a sprite, a UI element — and hand instances to
the presenter through an `MapNodeViewFactory`.

An implementation must report `odeId` from the data it was bound
with and keep `ransform` non-null for its lifetime: input
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

Creates and recycles the node views a presenter draws with. This is the main
seam for bringing your own art: pass a factory to
`apPresenterBase.Configure` and the presenter never constructs a
node view itself.

`reate` must return a view already parented under the transform it
was given, because the presenter does not reparent it, and one that is safe to
bind immediately. Pooling is expected rather than exceptional: the presenter
releases views it no longer needs, and asks for a replacement view for the same
node when that node's compiled type changes enough to need different art.

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
never calls `MapNodeTransitionView` or
`MapEdgeTransitionView`, and never advances a view's animation. The
adapter therefore owns its own clock and must carry its animations to completion
itself. Durations come from the theme and can be zero, which means "apply the
destination immediately".

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
whenever the traveller is between nodes — before the first node is entered, and
again after each one is completed — so an implementation needs an answer for
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

:   Builds the frame from the signals received since the last call and clears the one-shot ones: submit, pointer press, pan and zoom. Navigation, pointer position and pinch state survive, because they describe a held control rather than an event.

`public void EndPinch()`

:   Ends the pinch so pointer presses activate nodes again. Nothing else clears the flag: without this call the map keeps ignoring taps.

`public void SignalNavigate(Vector2 value)`

:   Sets the directional axis. It persists until changed, so send `ector2.zero` when the control is released or focus keeps repeating in that direction.

`public void SignalPan(Vector2 delta)`

:   Adds to the pan delta accumulated for the next captured frame. Pass a per-event delta, never an absolute position.

`public void SignalPinch(float scaleDelta)`

:   Reports an in-progress pinch. It marks the pinch active and drops any pending pointer press, so pinching never selects a node; call `ndPinch` when the gesture finishes.
    - `scaleDelta` &mdash; Pinch scale factor for this event: 1 leaves the zoom alone, 1.1 zooms in a tenth. The adapter accumulates `scaleDelta - 1` into the frame's zoom delta.

`public void SignalPointer(Vector2 value)`

:   Records the pointer position in screen pixels and marks the frame as having a pointer. The position persists between frames; only the press is an edge.

`public void SignalPointerPress()`

:   Marks a pointer press for the next captured frame. Ignored while a pinch is running, so a second finger cannot select a node.

`public void SignalSubmit()`

:   Requests activation of the focused node on the next captured frame. `apture` clears it, so one call is one submit.

`public void SignalZoom(float delta)`

:   Adds to the zoom delta accumulated for the next captured frame.

---

## LegacyMapInputSource

```csharp
public sealed class LegacyMapInputSource : IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

Input source for Unity's legacy Input Manager: axes for navigation, Return, Space
or the Submit button for activation, the mouse for pointing, middle-drag to pan
and the wheel to zoom, with touches folded in as tap, drag-pan and pinch-zoom.
`apInputController` falls back to this when no other source is bound,
so the project needs the legacy input backend enabled and the "Horizontal",
"Vertical", "Submit", "Mouse X" and "Mouse Y" entries present in its input
settings.

**Methods**

`public MapInputFrame Capture()`

:   Reads one frame from `nput`. While any finger is down the touch pointer replaces the mouse pointer and touch pan and zoom add to the mouse values; with no touches the gesture state is cleared, so a lifted finger cannot leak a delta into the next frame.

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

:   Why the command was refused, or `apDevelopmentFailureKind.None` on success.

`public string Message`

:   The reason to show the operator. Never null; empty on success.

`public bool Succeeded`

:   &mdash;

`public string Value`

:   Data returned by the commands that produce some — today the copied generation manifest. Never null; empty for every other success and for all failures.

**Methods**

`public static MapDevelopmentCommandResult Failure(MapDevelopmentFailureKind kind, string message)`

:   Records a refusal, with the reason to show the operator.

`public static MapDevelopmentCommandResult Success(string value = null)`

:   Records a success, optionally carrying data in `alue`.

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
construction — copied unless they are already a
`eadOnlyCollection{T}` — so a caller may keep reusing its own
buffers without a bound view seeing them change underneath it.

**Constructors**

`public MapEdgeViewData(MapEdge edge, IReadOnlyList<NormalizedMapPosition> points, Color color)`

:   Builds edge data with no presentation-space path: the view converts `points` itself, and the edge is treated as fully visible rather than fogged.

`public MapEdgeViewData()`

:   The full form the presenter builds, with the path already converted to presentation units.
    - `points` &mdash; The path in normalized layout space, source endpoint first.
    - `presentationPoints` &mdash; The same path in presentation units, one entry per `points` entry. Pass null to leave the conversion to the view.

**Properties**

`public Color Color`

:   &mdash;

`public MapEdge Edge`

:   &mdash;

`public MapFogState FogState`

:   &mdash;

`public IReadOnlyList<NormalizedMapPosition> Points`

:   The sampled path in normalized layout space, running from the edge's source endpoint to its target.

`public IReadOnlyList<Vector2> PresentationPoints`

:   The same path in presentation units, one entry per `oints` entry, or null when it was not supplied. A view given null converts `oints` itself.

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

---

## MapFogState

```csharp
public enum MapFogState
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

How visible a node is, derived from its `apNodeVisualState`: a hidden
node reports `idden`, a locked one `immed`, and anything
the traveller has reached or can reach `isible`. The built-in
presenters give a route the more hidden of its two endpoints' states.

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
nodes, submits the focused or pressed node to a `apTraversalController`,
and pans and zooms the content transform inside the theme's zoom limits while
keeping the focused node in view. Frames come from any `MapInputSource`
and presses are resolved by any `MapNodeHitTester`, so a project can
change input stack or presentation style without touching the map. It stays inert
until a traversal controller is initialized and a layout is available: ticks before
that are dropped, not queued.

**Properties**

`public MapLayout CurrentLayout`

:   &mdash;

`public DefaultMapNodeHitTester DefaultHitTester`

:   &mdash;

`public Camera EventCamera`

:   &mdash;

`public InputSystemSignalAdapter InputSignals`

:   &mdash;

`public MapNavigationModel Navigation`

:   &mdash;

`public Vector2 Pan`

:   Current pan offset, already clamped so the map cannot be dragged out of reach. A Canvas map measures it in the content parent's local units; a world map in hundredths of them, matching the anchored-position and world scales the component writes.

`public MapPresenterBase Presenter`

:   &mdash;

`public MapTraversalController TraversalController`

:   &mdash;

`public Transform ViewportContent`

:   &mdash;

`public float Zoom`

:   Current zoom multiplier written to the content transform's scale. It starts at 1 and every tick clamps it into the theme's minimum and maximum zoom.

**Events**

`public event Action<StableId> FocusChanged`

:   Raised when the focused node changes, including when focus is lost — the argument is then an empty `tableId`. The presenter has already been told about the new focus by the time handlers run.

**Methods**

`public void BindCamera(Camera value)`

:   Sets the camera used to interpret screen positions for zoom anchoring and world viewport maths, and forgets any camera the component resolved on its own. Pass null to return to automatic resolution.

`public void BindDefaultHitTester(DefaultMapNodeHitTester hitTester)`

:   Makes this tester resolve pointer presses and stores it in the serialized field, so the binding survives a domain reload. It replaces any tester passed to `onfigure` or `indPresenter`.

`public void BindInputSignals(InputSystemSignalAdapter signals)`

:   Makes this signal adapter the input source and stores it in the serialized field. The directional hold-repeat state is reset, so a direction held on the previous source cannot repeat straight into the new one.

`public void BindPresenter()`

:   Binds the controller to a presenter and follows it: the presenter's current layout is adopted, later layout changes are tracked, and focus is published back to the presenter. The layout subscription is released when the component is disabled and taken again when it is enabled, so a presenter swapped while disabled needs re-binding.
    - `presenter` &mdash; Supplies the layout and receives focus updates.
    - `contentTransform` &mdash; The transform pan and zoom are written to. Null means the map is not moved at all.
    - `source` &mdash; Where frames come from. Null leaves the component to fall back to its serialized signal adapter, or to legacy Input, on the next update.
    - `hitTester` &mdash; Resolves pointer presses to nodes. Null falls back to the serialized `efaultMapNodeHitTester`, then to one found among the children.

`public void Configure()`

:   Wires the controller to a layout directly, with no presenter: it drops any presenter binding and its layout-change subscription, recovers focus from the traversal state, and applies the current pan and zoom to the content transform. Prefer `indPresenter` when a `apPresenterBase` owns the layout, because only that path follows later layout changes.
    - `layout` &mdash; The layout whose node positions drive spatial navigation and framing.
    - `source` &mdash; Where frames come from. Null leaves the component to fall back to its serialized signal adapter, or to legacy Input, on the next update.
    - `hitTester` &mdash; Resolves pointer presses to nodes. Null leaves pointer selection off until a tester is bound or the component is re-enabled.
    - `contentTransform` &mdash; The transform pan and zoom are written to. Null means the map is not moved at all.

`public void ConfigureNavigationRepeat(float initialDelaySeconds, float intervalSeconds)`

:   Sets the hold-repeat cadence for directional navigation. A new direction always moves focus immediately; the next move waits the initial delay, and further moves follow at the interval. Calling this also cancels the current hold.
    - `initialDelaySeconds` &mdash; Seconds a direction is held before it starts repeating. Negative values are clamped to zero.
    - `intervalSeconds` &mdash; Seconds between repeats once repeating starts. Values below 0.01 are raised to 0.01.

`public void OnAfterDeserialize()`

:   Unity serialization callback. It rebuilds the cached source and hit tester from the serialized fields and forgets any automatically resolved camera, so a domain reload cannot leave the controller pointing at dead references. Unity calls it; you should not.

`public void OnBeforeSerialize()`

:   Unity serialization callback. It does nothing: the controller has no runtime state worth flattening.

`public void SetLayout(MapLayout layout)`

:   Swaps the layout that spatial navigation and framing work from, then recovers focus, brings it into view, and re-applies the transform. A null layout clears focus and leaves the controller inert until a layout is set again.

`public void SetSource(IMapInputSource source)`

:   Replaces the input source, cancels the current directional hold, and re-checks focus. Passing null makes the next update fall back to the serialized signal adapter, or to legacy Input when there is none.

`public void Tick(MapInputFrame frame)`

:   Applies one input frame, choosing the zoom anchor itself — the pointer when the frame carries one, otherwise the focused node — and only when the zoom would actually change. Navigation repeat runs on unscaled time, so a paused game still repeats at the same rate. The component already ticks itself every update from its bound source, so call this directly only when you drive input yourself. Frames that arrive before the traversal controller is initialized, or while no layout is set, are dropped.

`public void Tick(MapInputFrame frame, Vector2 anchorLocal)`

:   Applies one input frame around an explicit zoom anchor, timing navigation repeat with unscaled delta time.
    - `anchorLocal` &mdash; The point that stays still while the zoom changes, in the same units as `an`.

`public void Tick(MapInputFrame frame, Vector2 anchorLocal, float deltaSeconds)`

:   Applies one input frame around an explicit zoom anchor with a caller-supplied time step. Use this to drive the map from a fixed step or a test.
    - `anchorLocal` &mdash; The point that stays still while the zoom changes, in the same units as `an`.
    - `deltaSeconds` &mdash; Time since the previous tick. It advances the directional hold-repeat clock only; pan and zoom come from the frame's deltas, so the step never scales movement.

---

## MapInputFrame

```csharp
public readonly struct MapInputFrame
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapInput.cs</small>

One update's worth of map input, reduced to the six signals the controller acts
on: a directional axis, a submit request, a pointer, pan and zoom deltas, and a
pinch flag. Everything here describes that update alone, so a frame is meant to
be applied once — feeding the same frame twice pans, zooms, and submits twice.

**Constructors**

`public MapInputFrame()`

:   Creates a frame and infers `asPointerPosition`: it is true when the pointer is pressed, a pinch is running, or the position is not the screen origin. Use the other constructor when a source knows better, for instance a mouse resting exactly at (0, 0).
    - `navigation` &mdash; Directional intent; see `avigation` for the threshold applied.
    - `pointerPosition` &mdash; Pointer position in screen pixels.
    - `panDelta` &mdash; Pan movement for this frame, not an absolute offset.
    - `zoomDelta` &mdash; Zoom change for this frame, not an absolute zoom.

`public MapInputFrame()`

:   Creates a frame with `hasPointerPosition` stated outright, for sources that know whether a pointer exists this frame.
    - `navigation` &mdash; Directional intent; see `avigation` for the threshold applied.
    - `pointerPosition` &mdash; Pointer position in screen pixels.
    - `panDelta` &mdash; Pan movement for this frame, not an absolute offset.
    - `zoomDelta` &mdash; Zoom change for this frame, not an absolute zoom.
    - `hasPointerPosition` &mdash; False when no pointer exists, which makes the controller anchor zoom on the focused node instead.

**Properties**

`public bool HasPointerPosition`

:   Whether `ointerPosition` is usable this frame. It decides the zoom anchor: with a pointer the map zooms around it, without one it zooms around the focused node.

`public Vector2 Navigation`

:   Directional intent, normally -1..1 per axis. The controller follows the dominant axis and ignores both axes below 0.5, so a stick, a d-pad, and key axes all behave the same.

`public Vector2 PanDelta`

:   Pan movement for this frame in the source's own units; the controller scales it by its pan sensitivity and adds it to `apInputController.Pan`.

`public bool PinchActive`

:   True while a two-finger pinch is in progress. The controller suppresses pointer activation on those frames, so a pinch cannot select a node.

`public Vector2 PointerPosition`

:   Pointer position in screen pixels, meaningful only while `asPointerPosition` is set.

`public bool PointerPressed`

:   Set for the one frame the source reports a press or tap. The controller hit-tests at `ointerPosition` and submits the node it finds.

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

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Left` | &mdash; |
| `Right` | &mdash; |
| `Up` | &mdash; |
| `Down` | &mdash; |

---

## MapNavigationModel

```csharp
public sealed class MapNavigationModel
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapNavigation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public StableId FocusedNodeId`

:   &mdash;

**Methods**

`public void ClearFocus()`

:   &mdash;

`public bool Move(MapNavigationDirection direction, MapLayout layout, MapRuntimeStateSnapshot runtimeState)`

:   &mdash;

`public StableId RecoverFocus(MapProgressionState progression, MapLayout layout, MapRuntimeStateSnapshot runtimeState)`

:   &mdash;

`public bool TrySetFocus(StableId nodeId, MapRuntimeStateSnapshot runtimeState)`

:   &mdash;

---

## MapNodeRuntimeState

```csharp
public readonly struct MapNodeRuntimeState : IComparable<MapNodeRuntimeState>
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

One node's derived display state: the visual state a presenter styles it with, plus
the fog state that decides whether it can be seen at all. An immutable value read
out of a `apRuntimeStateSnapshot`; it is never updated in place, so a
copy keeps reporting the revision it was taken from.

**Constructors**

`public MapNodeRuntimeState(StableId nodeId, MapNodeVisualState visualState, MapFogState fogState)`

:   Pairs a node with the visual and fog state derived for it.

**Properties**

`public MapFogState FogState`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public MapNodeVisualState VisualState`

:   &mdash;

**Methods**

`public int CompareTo(MapNodeRuntimeState other)`

:   Orders by `odeId` alone, ignoring both states. This is what gives a snapshot's node list an order that depends on the graph and not on progress.

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
`MapNodeView.Bind` again when the node's presented state changes,
which is why a view never has to poll the graph or the traversal state.

**Constructors**

`public MapNodeViewData()`

:   Builds view data without presentation metrics: the label and tooltip are taken straight off `nodeType` unlocalized, the node size is a nominal default, and `asPresentationPosition` stays false so the view places and sizes the node from `position` itself.
    - `nodeType` &mdash; The compiled type this node draws as; null leaves the label and tooltip empty.

`public MapNodeViewData()`

:   The full form the presenter builds: placement and size are already resolved into presentation units, and the label and tooltip have already been through the localization adapter.
    - `presentationPosition` &mdash; Where to draw the node, in presentation units.
    - `nodeSize` &mdash; Unstyled node size, in the same units as `presentationPosition`.
    - `hasPresentationPosition` &mdash; False to tell the view that `presentationPosition` and `nodeSize` are not authoritative and it should place and size the node itself.
    - `displayLabel` &mdash; Localized label; null is stored as an empty string, which asks the view to draw no label.
    - `tooltip` &mdash; Localized tooltip; null is stored as an empty string.

**Properties**

`public string DisplayLabel`

:   Node label, already localized. Never null; empty asks the view to draw no label.

`public MapFogState FogState`

:   &mdash;

`public bool HasPresentationPosition`

:   False when this data was built without presentation metrics, in which case the view must place and size the node from `osition` itself instead of trusting `resentationPosition`.

`public MapNode Node`

:   &mdash;

`public float NodeSize`

:   Node size in the same presentation units as `resentationPosition`. This is the unstyled base size: a style scales it per visual state, so it is not necessarily the size drawn.

`public CompiledMapNodeType NodeType`

:   &mdash;

`public NormalizedMapPosition Position`

:   &mdash;

`public Vector2 PresentationPosition`

:   Where to draw the node, in presentation units. Meaningful only when `asPresentationPosition` is true.

`public string Tooltip`

:   Node tooltip, already localized. Never null; empty when the node type declares none.

`public MapNodeVisualState VisualState`

:   &mdash;

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
| `Visited` | Reached earlier with no completion recorded; a completed node reports `ompleted`. |
| `Completed` | Reached and finished, with its completion result recorded in the progression. |

---

## MapPresenterBase

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public abstract class MapPresenterBase : MonoBehaviour, IMapPresentationHost
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapPresenterBase.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public int ActiveEdgeCount`

:   &mdash;

`public int ActiveNodeCount`

:   &mdash;

`public MapLayout CurrentLayout`

:   &mdash;

`public StableId FocusedNodeId`

:   &mdash;

`public Vector2 PresentationContentSize`

:   &mdash;

`public float PresentationNodeSize`

:   &mdash;

`public BranchWeaver.Authoring.CompiledMapStyle Style`

:   The resolved style this map draws with. Never null: with no preset assigned it returns the shipped default, so the map is never unstyled.

`public MapTraversalController TraversalController`

:   &mdash;

**Events**

`public event Action<MapLayout> LayoutChanged`

:   &mdash;

**Methods**

`public void AdvanceTransitions(float deltaSeconds)`

:   &mdash;

`public void ApplyStyle(BranchWeaver.Authoring.MapStylePreset preset)`

:   Replaces the style and pushes it to every live view. Safe at runtime, which is what lets the Style Browser preview a look live.

`public void Clear()`

:   &mdash;

`public void Configure()`

:   &mdash;

`public void Present(MapGraph graph, MapProgressionState progression, MapRuntimeContent content, bool revealAll)`

:   &mdash;

`public void PushStyleToViews()`

:   Pushes the current style to every live node and edge view.

`public void Refresh()`

:   &mdash;

`public void SetFocusedNode(StableId nodeId)`

:   &mdash;

`public void SetTraversalController(MapTraversalController controller)`

:   &mdash;

`public void TickStyle(float presentationDeltaSeconds)`

:   Advances style animation: focus easing, the current-node pulse, and edge flow. Presentation only; nothing advanced here can reach a graph, a save envelope, or a fingerprint.

`public bool TryGetPresentationPosition(StableId nodeId, out Vector2 position)`

:   &mdash;

---

## MapRuntimeContent

:material-star: **Start here**

```csharp
public sealed class MapRuntimeContent
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContent.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapRuntimeContent(IEnumerable<CompiledMapNodeType> nodeTypes, CompiledMapTheme theme)`

:   &mdash;

**Properties**

`public IReadOnlyList<CompiledMapNodeType> NodeTypes`

:   &mdash;

`public CompiledMapTheme Theme`

:   &mdash;

**Methods**

`public bool TryGetNodeType(StableId typeId, out CompiledMapNodeType nodeType)`

:   &mdash;

---

## MapRuntimeStateDeriver

```csharp
public static class MapRuntimeStateDeriver
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static MapRuntimeStateSnapshot Derive()`

:   Derives fog and visual state with the default one-step look-ahead. Kept so existing callers and saves behave exactly as before.

`public static MapRuntimeStateSnapshot Derive()`

:   Derives fog and visual state with explicit fog settings, so a project can choose how far ahead the map is revealed.

---

## MapRuntimeStateSnapshot

```csharp
public sealed class MapRuntimeStateSnapshot
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeState.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapRuntimeStateSnapshot(long revision, IEnumerable<MapNodeRuntimeState> nodes)`

:   &mdash;

**Properties**

`public IReadOnlyList<MapNodeRuntimeState> Nodes`

:   &mdash;

`public long Revision`

:   &mdash;

**Methods**

`public bool TryGet(StableId id, out MapNodeRuntimeState state)`

:   &mdash;

---

## MapSelectionResult

```csharp
public sealed class MapSelectionResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

The outcome of asking the controller to move to a node.

It separates a request that never reached the traversal session — an unknown
node, a node that is not available, or a controller already dispatching
callbacks — from one that did, where `ransition` carries the
session's accept or reject.

**Properties**

`public StableId NodeId`

:   &mdash;

`public bool Succeeded`

:   True only when a move was attempted and the session accepted it, so an ignored request never reads as a success.

`public MapTransitionResult Transition`

:   The session's result for the move, or null when the request never reached the session.

`public bool WasAvailable`

:   Whether the node was available when the request arrived. False on a request that was dropped without being attempted.

**Methods**

`public static MapSelectionResult Attempted(StableId nodeId, bool wasAvailable, MapTransitionResult transition)`

:   Records a request that reached the session, carrying the result it produced.
    - `transition` &mdash; The session's accept or reject for the move; `ucceeded` follows it.

`public static MapSelectionResult Ignored(StableId nodeId)`

:   Records a request that was dropped before the session saw it: `ransition` stays null and `ucceeded` is false.

---

## MapSetupHierarchyBinding

```csharp
public sealed class MapSetupHierarchyBinding : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapSetupHierarchyBinding.cs</small>

Durable identity for scene objects created and owned by the BranchWeaver setup wizard.

**Properties**

`public Transform Content`

:   &mdash;

`public bool IsCanvas`

:   &mdash;

`public Component OptionalInputBridge`

:   &mdash;

`public InputSystemSignalAdapter OptionalInputSignals`

:   &mdash;

`public RectTransform SafeArea`

:   &mdash;

**Methods**

`public void Configure(bool usesCanvas, RectTransform ownedSafeArea, Transform ownedContent)`

:   &mdash;

`public void ConfigureOptionalInput(Component ownedBridge, InputSystemSignalAdapter ownedSignals)`

:   &mdash;

---

## MapTraversalController

:material-star: **Start here**

```csharp
public sealed class MapTraversalController : MonoBehaviour, IMapDevelopmentHost
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapTraversalController.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public IMapAudioCueAdapter AudioCueAdapter`

:   &mdash;

`public MapUnityEvent AvailabilityChangedUnityEvent`

:   &mdash;

`public MapRuntimeContent Content`

:   &mdash;

`public MapFogSettings FogSettings`

:   How far ahead of the traveller the map is revealed. Fog is derived rather than stored, so changing this re-reveals an existing save correctly with no migration.

`public MapGraph Graph`

:   &mdash;

`public bool IsInitialized`

:   &mdash;

`public ValidationReport LastControllerValidation`

:   &mdash;

`public MapUnityEvent MapCompletedUnityEvent`

:   &mdash;

`public MapUnityEvent MapGeneratedUnityEvent`

:   &mdash;

`public MapStringUnityEvent NodeCompletedUnityEvent`

:   &mdash;

`public MapStringUnityEvent NodeEnteredUnityEvent`

:   &mdash;

`public MapStringUnityEvent NodeSelectionRequestedUnityEvent`

:   &mdash;

`public bool RevealAll`

:   &mdash;

`public MapUnityEvent SaveRequestedUnityEvent`

:   &mdash;

`public MapSerializedEventBridge SerializedEvents`

:   &mdash;

`public MapProgressionState State`

:   &mdash;

`public MapUnityEvent ValidationFailedUnityEvent`

:   &mdash;

**Events**

`public event Action<MapTransitionEvent> AvailabilityChanged`

:   &mdash;

`public event Action<uint> DevelopmentRegenerateRequested`

:   &mdash;

`public event Action<MapTransitionEvent> MapCompleted`

:   &mdash;

`public event Action<MapGraph> MapGenerated`

:   &mdash;

`public event Action<MapTransitionEvent> NodeCompleted`

:   &mdash;

`public event Action<MapTransitionEvent> NodeEntered`

:   &mdash;

`public event Action<StableId> NodeSelectionRequested`

:   &mdash;

`public event Action<MapGraph, MapProgressionState> SaveRequested`

:   &mdash;

`public event Action<MapRuntimeStateSnapshot> StateChanged`

:   &mdash;

`public event Action<ValidationReport> ValidationFailed`

:   &mdash;

**Methods**

`public MapTransitionResult CompleteCurrent()`

:   &mdash;

`public MapTransitionResult CompleteCurrent(MapDataPayload result)`

:   &mdash;

`public MapDevelopmentCommandResult CopyGenerationManifest()`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentCompleteCurrent()`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentForceResult(MapDataPayload result)`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentRegenerate(uint seed)`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentReset()`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentRevealAll(bool reveal)`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentTeleport(StableId nodeId)`

:   &mdash;

`public MapDevelopmentCommandResult DevelopmentUnlock(StableId nodeId)`

:   &mdash;

`public MapRuntimeStateSnapshot GetRuntimeState()`

:   &mdash;

`public bool Initialize(MapGraph graph, MapRuntimeContent content)`

:   &mdash;

`public bool Initialize(MapGraph graph, MapProgressionState restoredState, MapRuntimeContent content)`

:   &mdash;

`public MapSelectionResult RequestNodeSelection(StableId nodeId)`

:   &mdash;

`public void RequestSave()`

:   &mdash;

---

## PassthroughLocalizationAdapter

```csharp
public sealed class PassthroughLocalizationAdapter : IMapLocalizationAdapter
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public string Resolve(string key, string fallback)`

:   &mdash;

---

## WorldMapNodeView

```csharp
public sealed class WorldMapNodeView : MonoBehaviour, IMapNodeView, IMapNodeHitState, IMapNodeTransitionView, IMapFocusView
```

`BranchWeaver.Presentation.World2D` &middot; <small>BranchWeaver/Runtime/Presentation/World2D/WorldMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public string DisplayLabel`

:   &mdash;

`public MapFogState FogState`

:   &mdash;

`public bool IsHitTestVisible`

:   &mdash;

`public bool IsTransitioning`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public NormalizedMapPosition NormalizedPosition`

:   &mdash;

`public string Tooltip`

:   &mdash;

`public Transform Transform`

:   &mdash;

`public MapNodeVisualState VisualState`

:   &mdash;

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   &mdash;

`public void BeginTransition(MapNodeVisualState fromVisual, MapFogState fromFog,)`

:   &mdash;

`public void Bind(MapNodeViewData data)`

:   &mdash;

`public void CancelTransition(bool applyTerminalState)`

:   &mdash;

`public void PrepareForBind()`

:   &mdash;

`public void RestoreAfterUnchangedBind()`

:   &mdash;

`public void SetActive(bool active)`

:   &mdash;

`public void SetFocused(bool focused)`

:   &mdash;

---

## WorldMapPresenter

:material-star: **Start here**

```csharp
public sealed class WorldMapPresenter : MapPresenterBase
```

`BranchWeaver.Presentation.World2D` &middot; <small>BranchWeaver/Runtime/Presentation/World2D/WorldMapPresenter.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

