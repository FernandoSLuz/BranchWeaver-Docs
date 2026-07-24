# Presentation and views

64 types in this area.

!!! abstract "On this page"
    [CanvasMapCoordinateUtility](#canvasmapcoordinateutility) &middot; [CanvasMapEdgeFactory](#canvasmapedgefactory) &middot; [CanvasMapEdgeView](#canvasmapedgeview) &middot; [CanvasMapNodeFactory](#canvasmapnodefactory) &middot; [CanvasMapNodeView](#canvasmapnodeview) &middot; [CanvasMapPresenter](#canvasmappresenter) &middot; [DefaultMapNodeHitTester](#defaultmapnodehittester) &middot; [IMapAudioCueAdapter](#imapaudiocueadapter) &middot; [IMapBackgroundPresenter](#imapbackgroundpresenter) &middot; [IMapDevelopmentHost](#imapdevelopmenthost) &middot; [IMapEdgeAvailabilityView](#imapedgeavailabilityview) &middot; [IMapEdgeTransitionView](#imapedgetransitionview) &middot; [IMapEdgeView](#imapedgeview) &middot; [IMapEdgeViewFactory](#imapedgeviewfactory) &middot; [IMapFocusIndicatorPresenter](#imapfocusindicatorpresenter) &middot; [IMapFocusView](#imapfocusview) &middot; [IMapInputSource](#imapinputsource) &middot; [IMapLocalizationAdapter](#imaplocalizationadapter) &middot; [IMapNodeHitState](#imapnodehitstate) &middot; [IMapNodeHitTester](#imapnodehittester) &middot; [IMapNodeTransitionView](#imapnodetransitionview) &middot; [IMapNodeView](#imapnodeview) &middot; [IMapNodeViewFactory](#imapnodeviewfactory) &middot; [IMapPresentationHost](#imappresentationhost) &middot; [IMapPresentationTransitionAdapter](#imappresentationtransitionadapter) &middot; [IMapViewFactoryLifetime](#imapviewfactorylifetime) &middot; [IPlayerPawnPresenter](#iplayerpawnpresenter) &middot; [IRouteMarkerPresenter](#iroutemarkerpresenter) &middot; [InputSystemSignalAdapter](#inputsystemsignaladapter) &middot; [LegacyMapInputSource](#legacymapinputsource) &middot; [MapCameraResolver](#mapcameraresolver) &middot; [MapDevelopmentCommandResult](#mapdevelopmentcommandresult) &middot; [MapDevelopmentFailureKind](#mapdevelopmentfailurekind) &middot; [MapEdgeViewData](#mapedgeviewdata) &middot; [MapFogSettings](#mapfogsettings) &middot; [MapFogState](#mapfogstate) &middot; [MapInputController](#mapinputcontroller) &middot; [MapInputFrame](#mapinputframe) &middot; [MapNavigationDirection](#mapnavigationdirection) &middot; [MapNavigationModel](#mapnavigationmodel) &middot; [MapNodeRuntimeState](#mapnoderuntimestate) &middot; [MapNodeViewData](#mapnodeviewdata) &middot; [MapNodeVisualState](#mapnodevisualstate) &middot; [MapPresentationMetrics](#mappresentationmetrics) &middot; [MapPresenterBase](#mappresenterbase) &middot; [MapRuntimeContent](#mapruntimecontent) &middot; [MapRuntimeDiagnosticCodes](#mapruntimediagnosticcodes) &middot; [MapRuntimeStateDeriver](#mapruntimestatederiver) &middot; [MapRuntimeStateSnapshot](#mapruntimestatesnapshot) &middot; [MapSelectionResult](#mapselectionresult) &middot; [MapSerializedEventBridge](#mapserializedeventbridge) &middot; [MapSetupHierarchyBinding](#mapsetuphierarchybinding) &middot; [MapTouchGestureInterpreter](#maptouchgestureinterpreter) &middot; [MapTouchPhase](#maptouchphase) &middot; [MapTouchSample](#maptouchsample) &middot; [MapTraversalController](#maptraversalcontroller) &middot; [NullMapAudioCueAdapter](#nullmapaudiocueadapter) &middot; [PassthroughLocalizationAdapter](#passthroughlocalizationadapter) &middot; [ProceduralNodeSprite](#proceduralnodesprite) &middot; [WorldMapEdgeFactory](#worldmapedgefactory) &middot; [WorldMapEdgeView](#worldmapedgeview) &middot; [WorldMapNodeFactory](#worldmapnodefactory) &middot; [WorldMapNodeView](#worldmapnodeview) &middot; [WorldMapPresenter](#worldmappresenter)

## CanvasMapCoordinateUtility

```csharp
public static class CanvasMapCoordinateUtility
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static Vector2 ToAnchoredPosition(RectTransform content, NormalizedMapPosition position)`

:   &mdash;

---

## CanvasMapEdgeFactory

```csharp
public sealed class CanvasMapEdgeFactory : IMapEdgeViewFactory, IMapViewFactoryLifetime
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public int CreatedCount`

:   &mdash;

`public int ReleasedCount`

:   &mdash;

`public int ReusedCount`

:   &mdash;

**Methods**

`public IMapEdgeView Create(Transform parent)`

:   &mdash;

`public void Dispose()`

:   &mdash;

`public void Release(IMapEdgeView view)`

:   &mdash;

---

## CanvasMapEdgeView

```csharp
public sealed class CanvasMapEdgeView : MonoBehaviour, IMapEdgeView, IMapEdgeTransitionView, IMapStyledView, IMapEdgeAvailabilityView
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

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

## CanvasMapNodeFactory

```csharp
public sealed class CanvasMapNodeFactory : IMapNodeViewFactory, IMapViewFactoryLifetime
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public int CreatedCount`

:   &mdash;

`public int ReleasedCount`

:   &mdash;

`public int ReusedCount`

:   &mdash;

**Methods**

`public IMapNodeView Create(BranchWeaver.Authoring.CompiledMapNodeType nodeType, Transform parent)`

:   &mdash;

`public void Dispose()`

:   &mdash;

`public void Release(IMapNodeView view)`

:   &mdash;

---

## CanvasMapNodeView

```csharp
public sealed class CanvasMapNodeView : MonoBehaviour, IMapNodeView, IMapNodeHitState, IMapNodeTransitionView, IMapFocusView, IMapStyledView
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapViews.cs</small>

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

```csharp
public sealed class CanvasMapPresenter : MapPresenterBase
```

`BranchWeaver.Presentation.Canvas` &middot; <small>Runtime/Presentation/Canvas/CanvasMapPresenter.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## DefaultMapNodeHitTester

```csharp
public sealed class DefaultMapNodeHitTester : MonoBehaviour, IMapNodeHitTester
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public Camera EventCamera`

:   &mdash;

**Methods**

`public void BindCamera(Camera value)`

:   &mdash;

`public bool TryHit(Vector2 screenPosition, out StableId nodeId)`

:   &mdash;

---

## IMapAudioCueAdapter

```csharp
public interface IMapAudioCueAdapter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapBackgroundPresenter

```csharp
public interface IMapBackgroundPresenter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapDevelopmentHost

```csharp
public interface IMapDevelopmentHost
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapEdgeAvailabilityView

```csharp
public interface IMapEdgeAvailabilityView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapStyledViewContracts.cs</small>

Implemented by an edge view that can emphasize routes leading to a
reachable node.

Separate from `MapStyledView` so a custom edge view can adopt
styling without also having to reason about availability, and vice versa.

---

## IMapEdgeTransitionView

```csharp
public interface IMapEdgeTransitionView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapEdgeView

```csharp
public interface IMapEdgeView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapEdgeViewFactory

```csharp
public interface IMapEdgeViewFactory
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapFocusIndicatorPresenter

```csharp
public interface IMapFocusIndicatorPresenter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapFocusView

```csharp
public interface IMapFocusView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapInputSource

```csharp
public interface IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapLocalizationAdapter

```csharp
public interface IMapLocalizationAdapter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapNodeHitState

```csharp
public interface IMapNodeHitState
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapNodeHitTester

```csharp
public interface IMapNodeHitTester
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapNodeTransitionView

```csharp
public interface IMapNodeTransitionView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapNodeView

```csharp
public interface IMapNodeView
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapNodeViewFactory

```csharp
public interface IMapNodeViewFactory
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapPresentationHost

```csharp
public interface IMapPresentationHost
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapPresentationTransitionAdapter

```csharp
public interface IMapPresentationTransitionAdapter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapViewFactoryLifetime

```csharp
public interface IMapViewFactoryLifetime : IDisposable
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

Optional lifetime contract used only for factories created and owned by a presenter.

---

## IPlayerPawnPresenter

```csharp
public interface IPlayerPawnPresenter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IRouteMarkerPresenter

```csharp
public interface IRouteMarkerPresenter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## InputSystemSignalAdapter

```csharp
public sealed class InputSystemSignalAdapter : MonoBehaviour, IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

Package-neutral bridge for Input System PlayerInput UnityEvents. Wire public signal
methods from PlayerInput without adding a BranchWeaver compile-time package dependency.

**Methods**

`public MapInputFrame Capture()`

:   &mdash;

`public void EndPinch()`

:   &mdash;

`public void SignalNavigate(Vector2 value)`

:   &mdash;

`public void SignalPan(Vector2 delta)`

:   &mdash;

`public void SignalPinch(float scaleDelta)`

:   &mdash;

`public void SignalPointer(Vector2 value)`

:   &mdash;

`public void SignalPointerPress()`

:   &mdash;

`public void SignalSubmit()`

:   &mdash;

`public void SignalZoom(float delta)`

:   &mdash;

---

## LegacyMapInputSource

```csharp
public sealed class LegacyMapInputSource : IMapInputSource
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public MapInputFrame Capture()`

:   &mdash;

---

## MapCameraResolver

```csharp
public static class MapCameraResolver
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static Camera Resolve(Camera explicitCamera)`

:   &mdash;

---

## MapDevelopmentCommandResult

```csharp
public sealed class MapDevelopmentCommandResult
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public MapDevelopmentFailureKind FailureKind`

:   &mdash;

`public string Message`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public string Value`

:   &mdash;

**Methods**

`public static MapDevelopmentCommandResult Failure(MapDevelopmentFailureKind kind, string message)`

:   &mdash;

`public static MapDevelopmentCommandResult Success(string value = null)`

:   &mdash;

---

## MapDevelopmentFailureKind

```csharp
public enum MapDevelopmentFailureKind
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `NotInitialized` | &mdash; |
| `InvalidNode` | &mdash; |
| `RejectedTransition` | &mdash; |
| `Unsupported` | &mdash; |
| `InvalidPayload` | &mdash; |

---

## MapEdgeViewData

```csharp
public readonly struct MapEdgeViewData
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapEdgeViewData(MapEdge edge, IReadOnlyList<NormalizedMapPosition> points, Color color)`

:   &mdash;

`public MapEdgeViewData()`

:   &mdash;

**Properties**

`public Color Color`

:   &mdash;

`public MapEdge Edge`

:   &mdash;

`public MapFogState FogState`

:   &mdash;

`public IReadOnlyList<NormalizedMapPosition> Points`

:   &mdash;

`public IReadOnlyList<Vector2> PresentationPoints`

:   &mdash;

---

## MapFogSettings

```csharp
public struct MapFogSettings
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeState.cs</small>

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

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeState.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Hidden` | &mdash; |
| `Dimmed` | &mdash; |
| `Visible` | &mdash; |

---

## MapInputController

```csharp
public sealed class MapInputController : MonoBehaviour, ISerializationCallbackReceiver
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

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

:   &mdash;

`public MapPresenterBase Presenter`

:   &mdash;

`public MapTraversalController TraversalController`

:   &mdash;

`public Transform ViewportContent`

:   &mdash;

`public float Zoom`

:   &mdash;

**Events**

`public event Action<StableId> FocusChanged`

:   &mdash;

**Methods**

`public void BindCamera(Camera value)`

:   &mdash;

`public void BindDefaultHitTester(DefaultMapNodeHitTester hitTester)`

:   &mdash;

`public void BindInputSignals(InputSystemSignalAdapter signals)`

:   &mdash;

`public void BindPresenter()`

:   &mdash;

`public void Configure()`

:   &mdash;

`public void ConfigureNavigationRepeat(float initialDelaySeconds, float intervalSeconds)`

:   &mdash;

`public void OnAfterDeserialize()`

:   &mdash;

`public void OnBeforeSerialize()`

:   &mdash;

`public void SetLayout(MapLayout layout)`

:   &mdash;

`public void SetSource(IMapInputSource source)`

:   &mdash;

`public void Tick(MapInputFrame frame)`

:   &mdash;

`public void Tick(MapInputFrame frame, Vector2 anchorLocal)`

:   &mdash;

`public void Tick(MapInputFrame frame, Vector2 anchorLocal, float deltaSeconds)`

:   &mdash;

---

## MapInputFrame

```csharp
public readonly struct MapInputFrame
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapInputFrame()`

:   &mdash;

`public MapInputFrame()`

:   &mdash;

**Properties**

`public bool HasPointerPosition`

:   &mdash;

`public Vector2 Navigation`

:   &mdash;

`public Vector2 PanDelta`

:   &mdash;

`public bool PinchActive`

:   &mdash;

`public Vector2 PointerPosition`

:   &mdash;

`public bool PointerPressed`

:   &mdash;

`public bool Submit`

:   &mdash;

`public float ZoomDelta`

:   &mdash;

---

## MapNavigationDirection

```csharp
public enum MapNavigationDirection
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapNavigation.cs</small>

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

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapNavigation.cs</small>

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

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeState.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodeRuntimeState(StableId nodeId, MapNodeVisualState visualState, MapFogState fogState)`

:   &mdash;

**Properties**

`public MapFogState FogState`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public MapNodeVisualState VisualState`

:   &mdash;

**Methods**

`public int CompareTo(MapNodeRuntimeState other)`

:   &mdash;

---

## MapNodeViewData

```csharp
public readonly struct MapNodeViewData
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodeViewData()`

:   &mdash;

`public MapNodeViewData()`

:   &mdash;

**Properties**

`public string DisplayLabel`

:   &mdash;

`public MapFogState FogState`

:   &mdash;

`public bool HasPresentationPosition`

:   &mdash;

`public MapNode Node`

:   &mdash;

`public float NodeSize`

:   &mdash;

`public CompiledMapNodeType NodeType`

:   &mdash;

`public NormalizedMapPosition Position`

:   &mdash;

`public Vector2 PresentationPosition`

:   &mdash;

`public string Tooltip`

:   &mdash;

`public MapNodeVisualState VisualState`

:   &mdash;

---

## MapNodeVisualState

```csharp
public enum MapNodeVisualState
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeState.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Hidden` | &mdash; |
| `Locked` | &mdash; |
| `Available` | &mdash; |
| `Current` | &mdash; |
| `Visited` | &mdash; |
| `Completed` | &mdash; |

---

## MapPresentationMetrics

```csharp
public sealed class MapPresentationMetrics
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapPresentationMetrics.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public Vector2 ContentSize`

:   &mdash;

`public float NodeSize`

:   &mdash;

**Methods**

`public static MapPresentationMetrics Create(MapGraph graph, CompiledMapTheme theme)`

:   &mdash;

`public Vector2 ToPresentationPosition(NormalizedMapPosition position)`

:   &mdash;

---

## MapPresenterBase

```csharp
public abstract class MapPresenterBase : MonoBehaviour, IMapPresentationHost
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapPresenterBase.cs</small>

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

```csharp
public sealed class MapRuntimeContent
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContent.cs</small>

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

## MapRuntimeDiagnosticCodes

```csharp
public static class MapRuntimeDiagnosticCodes
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapRuntimeStateDeriver

```csharp
public static class MapRuntimeStateDeriver
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeState.cs</small>

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

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeState.cs</small>

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

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public StableId NodeId`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public MapTransitionResult Transition`

:   &mdash;

`public bool WasAvailable`

:   &mdash;

**Methods**

`public static MapSelectionResult Attempted(StableId nodeId, bool wasAvailable, MapTransitionResult transition)`

:   &mdash;

`public static MapSelectionResult Ignored(StableId nodeId)`

:   &mdash;

---

## MapSerializedEventBridge

```csharp
public sealed class MapSerializedEventBridge
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapTraversalController.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public IList<MapUnityEvent> AvailabilityChanged`

:   &mdash;

`public IList<MapUnityEvent> MapCompleted`

:   &mdash;

`public IList<MapUnityEvent> MapGenerated`

:   &mdash;

`public IList<MapStringUnityEvent> NodeCompleted`

:   &mdash;

`public IList<MapStringUnityEvent> NodeEntered`

:   &mdash;

`public IList<MapStringUnityEvent> NodeSelectionRequested`

:   &mdash;

`public IList<MapUnityEvent> SaveRequested`

:   &mdash;

`public IList<MapUnityEvent> ValidationFailed`

:   &mdash;

---

## MapSetupHierarchyBinding

```csharp
public sealed class MapSetupHierarchyBinding : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapSetupHierarchyBinding.cs</small>

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

## MapTouchGestureInterpreter

```csharp
public sealed class MapTouchGestureInterpreter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public MapInputFrame Process(IReadOnlyList<MapTouchSample> touches)`

:   &mdash;

---

## MapTouchPhase

```csharp
public enum MapTouchPhase
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Began` | &mdash; |
| `Moved` | &mdash; |
| `Stationary` | &mdash; |
| `Ended` | &mdash; |
| `Cancelled` | &mdash; |

---

## MapTouchSample

```csharp
public readonly struct MapTouchSample
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapInput.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapTouchSample(int fingerId, Vector2 position, MapTouchPhase phase)`

:   &mdash;

**Properties**

`public int FingerId`

:   &mdash;

`public MapTouchPhase Phase`

:   &mdash;

`public Vector2 Position`

:   &mdash;

---

## MapTraversalController

```csharp
public sealed class MapTraversalController : MonoBehaviour, IMapDevelopmentHost
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapTraversalController.cs</small>

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

## NullMapAudioCueAdapter

```csharp
public sealed class NullMapAudioCueAdapter : IMapAudioCueAdapter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public void Play(StableId cueId)`

:   &mdash;

---

## PassthroughLocalizationAdapter

```csharp
public sealed class PassthroughLocalizationAdapter : IMapLocalizationAdapter
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapRuntimeContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public string Resolve(string key, string fallback)`

:   &mdash;

---

## ProceduralNodeSprite

```csharp
public static class ProceduralNodeSprite
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/ProceduralNodeSprite.cs</small>

Generates shared rounded-square node sprites at runtime so icon-less node types render
as calm rounded marks instead of hard white squares. Sprites are cached per
(size, corner radius) pair and stay owned by the cache for the lifetime of the process;
callers must not destroy them. The sprite is one world unit wide (pixelsPerUnit = size)
so it drops into the existing 1x1 fallback-sprite sizing, and it stays readable
(no makeNoLongerReadable) so tests can inspect pixel coverage.

**Methods**

`public static Sprite GetRounded(int sizePx, float cornerRadiusFraction)`

:   &mdash;

---

## WorldMapEdgeFactory

```csharp
public sealed class WorldMapEdgeFactory : IMapEdgeViewFactory, IMapViewFactoryLifetime
```

`BranchWeaver.Presentation.World2D` &middot; <small>Runtime/Presentation/World2D/WorldMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public WorldMapEdgeFactory()`

:   &mdash;

`public WorldMapEdgeFactory(GameObject prefab)`

:   &mdash;

**Properties**

`public int CreatedCount`

:   &mdash;

`public int ReleasedCount`

:   &mdash;

`public int ReusedCount`

:   &mdash;

**Methods**

`public IMapEdgeView Create(Transform parent)`

:   &mdash;

`public void Dispose()`

:   &mdash;

`public void Release(IMapEdgeView view)`

:   &mdash;

---

## WorldMapEdgeView

```csharp
public sealed class WorldMapEdgeView : MonoBehaviour, IMapEdgeView, IMapEdgeTransitionView
```

`BranchWeaver.Presentation.World2D` &middot; <small>Runtime/Presentation/World2D/WorldMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public StableId EdgeId`

:   &mdash;

`public bool IsTransitioning`

:   &mdash;

`public Material OwnedMaterial`

:   &mdash;

`public IReadOnlyList<NormalizedMapPosition> Points`

:   &mdash;

`public Transform Transform`

:   &mdash;

**Methods**

`public void AdvanceTransition(float deltaSeconds)`

:   &mdash;

`public void BeginTransition(MapFogState fromFog, MapFogState toFog, float durationSeconds)`

:   &mdash;

`public void Bind(MapEdgeViewData data)`

:   &mdash;

`public void CancelTransition(bool applyTerminalState)`

:   &mdash;

`public void ConfigureOwnedDefaultMaterial()`

:   &mdash;

`public void DisposeOwnedResources()`

:   &mdash;

`public void PrepareForBind()`

:   &mdash;

`public void RestoreAfterUnchangedBind()`

:   &mdash;

`public void SetActive(bool active)`

:   &mdash;

---

## WorldMapNodeFactory

```csharp
public sealed class WorldMapNodeFactory : IMapNodeViewFactory, IMapViewFactoryLifetime
```

`BranchWeaver.Presentation.World2D` &middot; <small>Runtime/Presentation/World2D/WorldMapViews.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public int CreatedCount`

:   &mdash;

`public int ReleasedCount`

:   &mdash;

`public int ReusedCount`

:   &mdash;

**Methods**

`public IMapNodeView Create(BranchWeaver.Authoring.CompiledMapNodeType nodeType, Transform parent)`

:   &mdash;

`public void Dispose()`

:   &mdash;

`public void Release(IMapNodeView view)`

:   &mdash;

---

## WorldMapNodeView

```csharp
public sealed class WorldMapNodeView : MonoBehaviour, IMapNodeView, IMapNodeHitState, IMapNodeTransitionView, IMapFocusView
```

`BranchWeaver.Presentation.World2D` &middot; <small>Runtime/Presentation/World2D/WorldMapViews.cs</small>

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

```csharp
public sealed class WorldMapPresenter : MapPresenterBase
```

`BranchWeaver.Presentation.World2D` &middot; <small>Runtime/Presentation/World2D/WorldMapPresenter.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

