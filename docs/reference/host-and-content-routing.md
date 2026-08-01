# Host and content routing

16 types in this area.

!!! abstract "On this page"
    [BranchWeaverMapHost](#branchweavermaphost) &middot; [IMapNodeContentResolver](#imapnodecontentresolver) &middot; [IMapNodeContentSelectionValidator](#imapnodecontentselectionvalidator) &middot; [MapContentPoolAsset](#mapcontentpoolasset) &middot; [MapContentPoolEntry](#mapcontentpoolentry) &middot; [MapContentResolutionFailureKind](#mapcontentresolutionfailurekind) &middot; [MapContentResolutionRequest](#mapcontentresolutionrequest) &middot; [MapContentResolutionResult](#mapcontentresolutionresult) &middot; [MapContentRoutingDiagnosticCodes](#mapcontentroutingdiagnosticcodes) &middot; [MapContentSelection](#mapcontentselection) &middot; [MapHostDiagnosticCodes](#maphostdiagnosticcodes) &middot; [MapHostFailureKind](#maphostfailurekind) &middot; [MapHostOperationKind](#maphostoperationkind) &middot; [MapHostOperationResult](#maphostoperationresult) &middot; [MapHostSaveAdapterKind](#maphostsaveadapterkind) &middot; [MapHostSeedPolicy](#maphostseedpolicy)

## BranchWeaverMapHost

:material-star: **Start here**

```csharp
public sealed class BranchWeaverMapHost : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Designer-first scene host for one complete BranchWeaver run. It compiles authoring assets,
generates or restores the graph, binds presentation, owns deterministic content-routing
history, and persists the entire run through a selected `IMapSaveAdapter`.
Advanced callers can continue to use the compiler, generator, controller, and adapters
directly; the host is an orchestration layer rather than a replacement API.

**Properties**

`public MapContentSelection ActiveSelection`

:   The current node's routed content, or null between nodes.

`public MapBlueprintAsset Blueprint`

:   The blueprint compiled for new runs.

`public IReadOnlyList<MapContentSelection> ContentHistory`

:   Committed routed selections in traversal order.

`public MapStringUnityEvent ContentRequestedUnityEvent`

:   Inspector-safe content-ID counterpart to `ContentRequested`.

`public MapDataPayload CustomerMetadata`

:   Customer-owned metadata restored from or most recently written to the save.

`public Exception Exception`

:   What the generator threw, if anything; cancellation lands in `Result` instead.

`public MapStringUnityEvent HostFailedUnityEvent`

:   Inspector-safe failure-message counterpart to `HostFailed`.

`public MapUnityEvent HostReadyUnityEvent`

:   Inspector-safe counterpart to `HostReady`.

`public bool IsFinished`

:   Whether the worker has stopped, however it stopped.

`public bool IsReady`

:   Whether a traversal run is initialized.

`public MapHostOperationResult LastResult`

:   The most recent host result, or null before the first operation.

`public bool LogFailuresToConsole`

:   Whether a failed operation is also written to the Console as one error naming this host.

`public MapPresenterBase Presenter`

:   The bound presenter, or null for headless use.

`public MapGenerationResult Result`

:   The completed attempt, valid only once `IsFinished` is true.

`public MapUnityEvent SaveCompletedUnityEvent`

:   Inspector-safe counterpart to `SaveCompleted`.

`public MapStylePreset StylePreset`

:   The style this host pushes to the presenter when a run starts, or null while it defers to the presenter's own style.

`public MapThemeAsset Theme`

:   The theme compiled for runtime presentation.

`public MapTraversalController TraversalController`

:   The bound low-level traversal controller.

**Fields**

`public string BlueprintFingerprint`

:   &mdash;

`public MapRuntimeContent Content`

:   &mdash;

`public MapGenerationRequest Request`

:   &mdash;

`public string ResolverFingerprint`

:   &mdash;

`public StableId ResolverId`

:   &mdash;

`public MapRuleSnapshot Rules`

:   &mdash;

**Events**

`public event Action<MapTransitionEvent> AvailabilityChanged`

:   Forwards `MapTraversalController.AvailabilityChanged`.

`public event Action<MapContentSelection> ContentRequested`

:   Raised with the durable content selection for an entered node.

`public event Action<uint> DevelopmentRegenerateRequested`

:   Forwards `MapTraversalController.DevelopmentRegenerateRequested`.

`public event Action<MapHostOperationResult> HostFailed`

:   Raised for a non-reentrant typed host failure.

`public event Action<MapGraph> HostReady`

:   Raised after a new or restored graph is fully initialized.

`public event Action<MapTransitionEvent> MapCompleted`

:   Forwards `MapTraversalController.MapCompleted`.

`public event Action<MapGraph> MapGenerated`

:   Forwards `MapTraversalController.MapGenerated`.

`public event Action<MapTransitionEvent> NodeCompleted`

:   Forwards `MapTraversalController.NodeCompleted`.

`public event Action<MapTransitionEvent> NodeEntered`

:   Forwards `MapTraversalController.NodeEntered`.

`public event Action<StableId> NodeSelectionRequested`

:   Forwards `MapTraversalController.NodeSelectionRequested`.

`public event Action<MapHostOperationResult> SaveCompleted`

:   Raised after a save commits successfully.

`public event Action<MapGraph, MapProgressionState> SaveRequested`

:   Forwards `MapTraversalController.SaveRequested`.

`public event Action<MapRuntimeStateSnapshot> StateChanged`

:   Forwards `MapTraversalController.StateChanged`.

`public event Action<ValidationReport> ValidationFailed`

:   Forwards `MapTraversalController.ValidationFailed`.

**Methods**

`public void ApplyStyle(MapStylePreset preset)`

:   Assigns the style this host pushes to the presenter, and pushes it straight away when a presenter is bound. Passing null hands the choice back to the presenter, whose own style is then left untouched for the rest of the run.
    - `preset` &mdash; The style to adopt, or null to defer to the presenter's own style.

`public void BindScene(MapTraversalController controller, MapPresenterBase mapPresenter)`

:   Updates only scene-object wiring, preserving authored assets and persistence settings.
    - `controller` &mdash; Input controller consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mapPresenter` &mdash; Input map Presenter consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public MapHostOperationResult CompleteCurrent()`

:   Completes the current node with an empty result.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public MapHostOperationResult CompleteCurrent(MapDataPayload resultPayload)`

:   Completes the current node with canonical customer result data.
    - `resultPayload` &mdash; Input result Payload consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public void ConfigureForScene()`

:   Configures the serialized golden path used by the Setup Wizard.
    - `mapBlueprint` &mdash; Input map Blueprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mapTheme` &mdash; Input map Theme consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `controller` &mdash; Input controller consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mapPresenter` &mdash; Input map Presenter consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `pool` &mdash; Input pool consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `startAutomatically` &mdash; Whether start Automatically; false selects the documented conservative behavior.
    - `slotId` &mdash; Stable identifier for slot; invalid or empty IDs are rejected before mutation.

`public void ConfigureForScene()`

:   Configures the serialized golden path used by the Setup Wizard, including the run's style.
    - `mapBlueprint` &mdash; Input map Blueprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mapTheme` &mdash; Input map Theme consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mapStyle` &mdash; The style pushed to the presenter when a run starts. Null leaves the presenter's own style alone.
    - `controller` &mdash; Input controller consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mapPresenter` &mdash; Input map Presenter consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `pool` &mdash; Input pool consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `startAutomatically` &mdash; Whether start Automatically; false selects the documented conservative behavior.
    - `slotId` &mdash; Stable identifier for slot; invalid or empty IDs are rejected before mutation.

`public MapHostOperationResult RequestNode(string nodeId)`

:   Parses a stable ID, resolves content, and requests entry into that node.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public MapHostOperationResult RequestNode(StableId nodeId)`

:   Resolves content before atomically committing traversal into an available node.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public void Run(object state)`

:   Runs the search; matches WaitCallback so it can be queued directly.
    - `state` &mdash; Unused; required by the thread-pool delegate.

`public MapHostOperationResult Save()`

:   Persists BranchWeaver value atomically; an expected storage failure is reported without replacing the last valid save.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public MapHostOperationResult Save(MapDataPayload customerMetadata)`

:   Persists BranchWeaver value atomically; an expected storage failure is reported without replacing the last valid save.
    - `customerMetadata` &mdash; Input customer Metadata consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public void SetContentResolver(IMapNodeContentResolver resolver)`

:   Overrides the serialized resolver for code-driven integrations and tests.
    - `resolver` &mdash; Input resolver consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public void SetSaveAdapter(IMapSaveAdapter adapter)`

:   Overrides the serialized persistence choice for code-driven integrations and tests.
    - `adapter` &mdash; Input adapter consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public MapHostOperationResult StartNew()`

:   Runs start New against validated inputs and returns a complete result rather than exposing partially updated state.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public MapHostOperationResult StartNew(uint seed)`

:   Runs start New against validated inputs and returns a complete result rather than exposing partially updated state.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public MapHostOperationResult StartNew(uint seed, CancellationToken cancellationToken)`

:   Runs start New against validated inputs and returns a complete result rather than exposing partially updated state. The search still runs on the calling thread, so a wide blueprint budget holds the frame; cancelling only stops it between search steps. Use `StartNewAsync(uint, CancellationToken, Action{MapHostOperationResult})` to keep the frame moving.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `cancellationToken` &mdash; Stops the search. A cancelled search comes back as a generation failure, never as a thrown exception or a partial map.
    - **Returns** &mdash; The complete map Host Operation Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public IEnumerator StartNewAsync(Action<MapHostOperationResult> completed)`

:   Starts a new run without holding the frame: the search runs on a worker thread and the scene work happens back on the main thread once it finishes. Hand it to `MonoBehaviour.StartCoroutine(IEnumerator)` and read the outcome from `completed`.
    - `completed` &mdash; Called once on the main thread with the same result the synchronous call would have returned. Null reports nothing beyond the usual host events.
    - **Returns** &mdash; The coroutine to run; no work happens until it is started.

`public IEnumerator StartNewAsync()`

:   Starts a new run without holding the frame, on an explicit seed. No other host operation may begin while it is in flight, and cancelling the token ends the search at its next check rather than at the end of the budget.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `cancellationToken` &mdash; Stops the search. A cancelled search comes back as a generation failure, never as a thrown exception or a partial map.
    - `completed` &mdash; Called once on the main thread with the same result the synchronous call would have returned. Null reports nothing beyond the usual host events.
    - **Returns** &mdash; The coroutine to run; no work happens until it is started.

`public MapHostOperationResult TryLoad()`

:   Attempts to load without throwing for expected invalid input; failure leaves output parameters at documented defaults.
    - **Returns** &mdash; Whether the operation produced every required output without changing state on failure.

---

## IMapNodeContentResolver

```csharp
public interface IMapNodeContentResolver
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

Resolves one stable content ID for a node. Implementations must be deterministic and must not
mutate the request or hidden global state. The host records a successful selection only after
traversal accepts the node, which makes a refused or retried request safe.

---

## IMapNodeContentSelectionValidator

```csharp
public interface IMapNodeContentSelectionValidator
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

Optional compatibility check used while restoring persisted selections.

---

## MapContentPoolAsset

:material-star: **Start here**

```csharp
public sealed class MapContentPoolAsset : ScriptableObject, IMapNodeContentResolver, IMapNodeContentSelectionValidator
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

A dependency-free deterministic resolver authored in the Inspector. Empty type and zone
filters mean "any"; a negative maximum layer means no upper bound. Eligible rows are sorted
by content ID before weighted selection, so reordering Inspector rows cannot reroll a node.

**Properties**

`public string ConfigurationFingerprint`

:   Canonical fingerprint of the resolver ID and every authored row. Inspector row and node-type filter order do not affect it; malformed configurations return an empty string and are refused by `BranchWeaverMapHost`. The value is computed once and reused until the asset is edited or reconfigured, so reading it per node costs nothing.

`public IReadOnlyList<MapContentPoolEntry> Entries`

:   Authored weighted rows in Inspector order.

`public StableId Id`

:   &mdash;

`public StableId ResolverId`

:   Parsed resolver ID, or empty while the authored text is invalid.

`public string StableIdText`

:   Raw stable resolver ID text.

`public int Weight`

:   &mdash;

**Methods**

`public void Configure(string id, IEnumerable<MapContentPoolEntry> poolEntries)`

:   Replaces the identity and rows for code-created assets.
    - `id` &mdash; Input id consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `poolEntries` &mdash; Ordered pool Entries input; implementations copy or enumerate it without taking caller ownership.

`public bool ContainsContent(StableId contentId)`

:   Checks row membership by stable content ID.
    - `contentId` &mdash; Stable identifier for content; invalid or empty IDs are rejected before mutation.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public MapContentResolutionResult Resolve(MapContentResolutionRequest request)`

:   Filters, validates, sorts, and deterministically selects one eligible row.
    - `request` &mdash; Input request consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Content Resolution Result outcome; inspect its typed status or diagnostics before consuming payload data.

---

## MapContentPoolEntry

```csharp
public sealed class MapContentPoolEntry
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

One weighted and filtered row in a `MapContentPoolAsset`.

**Constructors**

`public MapContentPoolEntry()`

:   Creates an immutable map Content Pool Entry snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `contentId` &mdash; Stable identifier for content; invalid or empty IDs are rejected before mutation.
    - `weight` &mdash; Positive relative selection weight; zero or negative values are rejected by validation.
    - `nodeTypes` &mdash; Ordered node Types input; implementations copy or enumerate it without taking caller ownership.
    - `minimumLayer` &mdash; Zero-based map layer index constrained by the compiled rule snapshot.
    - `maximumLayer` &mdash; Zero-based map layer index constrained by the compiled rule snapshot.
    - `zoneId` &mdash; Stable identifier for zone; invalid or empty IDs are rejected before mutation.
    - `unique` &mdash; Whether unique; false selects the documented conservative behavior.
    - `cooldownSelections` &mdash; Input cooldown Selections consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public string ContentIdText`

:   Raw stable content ID text.

`public int CooldownSelections`

:   Number of intervening selections required before reuse.

`public int MaximumLayer`

:   Inclusive maximum node layer, or -1 for no upper bound.

`public int MinimumLayer`

:   Inclusive minimum node layer.

`public IReadOnlyList<MapNodeTypeAsset> NodeTypes`

:   Accepted node-type assets; empty accepts every type.

`public bool Unique`

:   Whether this content may be selected only once per run.

`public int Weight`

:   Positive relative selection weight.

`public string ZoneIdText`

:   Optional required zone stable ID text.

---

## MapContentResolutionFailureKind

```csharp
public enum MapContentResolutionFailureKind
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

Why a node-content request did not produce a selection.

| Value | Meaning |
| --- | --- |
| `None` | The request produced a selection. |
| `InvalidRequest` | The graph, node, or history request was malformed. |
| `InvalidResolver` | The resolver's own identity or rows are invalid. |
| `Exhausted` | No row remains eligible after filters and history rules. |
| `ResolverFailed` | A custom resolver failed while evaluating the request. |

---

## MapContentResolutionRequest

```csharp
public sealed class MapContentResolutionRequest
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

Immutable input to an `IMapNodeContentResolver`.

**Constructors**

`public MapContentResolutionRequest()`

:   Copies the supplied history and pairs it with one exact graph node.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `node` &mdash; Input node consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `zoneId` &mdash; Stable identifier for zone; invalid or empty IDs are rejected before mutation.
    - `history` &mdash; Ordered history input; implementations copy or enumerate it without taking caller ownership.

**Properties**

`public MapGraph Graph`

:   The immutable graph being traversed.

`public IReadOnlyList<MapContentSelection> History`

:   Prior committed selections, copied in traversal order.

`public MapNode Node`

:   The exact node being considered; it must come from `Graph`.

`public StableId ZoneId`

:   The compiled zone containing the node layer, or an empty ID.

---

## MapContentResolutionResult

```csharp
public sealed class MapContentResolutionResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

Typed success or refusal returned by a node-content resolver.

**Properties**

`public MapContentResolutionFailureKind FailureKind`

:   The refusal category, or `MapContentResolutionFailureKind.None`.

`public MapContentSelection Selection`

:   The selected content, or null on failure.

`public bool Succeeded`

:   True when a valid selection was produced.

`public ValidationReport Validation`

:   Stable diagnostics; never null.

**Methods**

`public static MapContentResolutionResult Failure()`

:   Runs failure against validated inputs and returns a complete result rather than exposing partially updated state.
    - `failureKind` &mdash; Input failure Kind consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Content Resolution Result outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapContentResolutionResult Success(MapContentSelection selection, ValidationReport validation = null)`

:   Runs success against validated inputs and returns a complete result rather than exposing partially updated state.
    - `selection` &mdash; Input selection consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Content Resolution Result outcome; inspect its typed status or diagnostics before consuming payload data.

---

## MapContentRoutingDiagnosticCodes

```csharp
public static class MapContentRoutingDiagnosticCodes
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

Stable diagnostics emitted by content routing.

---

## MapContentSelection

:material-star: **Start here**

```csharp
public sealed class MapContentSelection : IEquatable<MapContentSelection>
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapContentPoolAsset.cs</small>

The durable result of resolving game content for one entered node. The IDs and sequence are
deliberately engine-neutral values so a host can persist them without retaining an asset or
scene-object reference.

**Constructors**

`public MapContentSelection(StableId nodeId, StableId resolverId, StableId contentId, int sequence)`

:   Creates an immutable map Content Selection snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - `resolverId` &mdash; Stable identifier for resolver; invalid or empty IDs are rejected before mutation.
    - `contentId` &mdash; Stable identifier for content; invalid or empty IDs are rejected before mutation.
    - `sequence` &mdash; Zero-based sequence used for deterministic ordering; negative values are invalid.

**Properties**

`public StableId ContentId`

:   The customer-owned content identity to open.

`public StableId NodeId`

:   The graph node this content belongs to.

`public StableId ResolverId`

:   The resolver identity that produced this selection.

`public int Sequence`

:   Zero-based position in the run's routed-content history.

**Methods**

`public bool Equals(MapContentSelection other)`

:   Compares node, resolver, content, and sequence.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports value equality with another selection.
    - `obj` &mdash; Input obj consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a deterministic content-based hash code.
    - **Returns** &mdash; The requested immutable or borrowed value; ownership remains with the object documented by the return type.

---

## MapHostDiagnosticCodes

```csharp
public static class MapHostDiagnosticCodes
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Stable diagnostic identifiers emitted by `BranchWeaverMapHost`.

---

## MapHostFailureKind

```csharp
public enum MapHostFailureKind
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Why a host operation did not complete.

| Value | Meaning |
| --- | --- |
| `None` | No failure. |
| `OperationInProgress` | A callback attempted to nest another host operation. |
| `NotConfigured` | A required asset, scene binding, or adapter is absent. |
| `InvalidIdentifier` | A caller or serialized field supplied malformed stable-ID text. |
| `AuthoringInvalid` | The blueprint, rules, node types, or theme did not compile. |
| `GenerationFailed` | The bounded generator did not produce a graph. |
| `ControllerRejected` | The traversal controller refused initialization. |
| `SaveNotFound` | The requested save slot does not exist. |
| `SaveFailed` | Persistence rejected or could not complete an operation. |
| `ContentResolutionFailed` | The configured content resolver refused or failed a request. |
| `ContentStateIncompatible` | Persisted routing state cannot be used with the configured resolver. |
| `TransitionRejected` | The node entry or completion transition was refused. |
| `SaveIdentityIncompatible` | The save belongs to a different blueprint or generation configuration. |

---

## MapHostOperationKind

```csharp
public enum MapHostOperationKind
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Controls map Host Operation Kind decisions; numeric values are serialized and must remain stable across package upgrades.

| Value | Meaning |
| --- | --- |
| `StartNew` | A new graph and traversal run were requested. |
| `TryLoad` | A saved run was requested. |
| `Save` | The current run was offered to persistence. |
| `RequestNode` | Traversal into one node was requested. |
| `CompleteCurrent` | The current node was offered a completion result. |

---

## MapHostOperationResult

```csharp
public sealed class MapHostOperationResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Typed outcome returned by every operation on `BranchWeaverMapHost`.

**Properties**

`public MapHostFailureKind FailureKind`

:   The host-level refusal category.

`public string Message`

:   The first diagnostic message, or an empty string for a clean success.

`public MapHostOperationKind Operation`

:   The call that produced this result.

`public MapSaveFailureKind SaveFailureKind`

:   The storage-level refusal category for save operations.

`public MapContentSelection Selection`

:   The newly committed routed content, only for a successful node request.

`public bool Succeeded`

:   True exactly when no failure or error diagnostic was reported.

`public ValidationReport Validation`

:   Stable diagnostics and context; never null.

---

## MapHostSaveAdapterKind

```csharp
public enum MapHostSaveAdapterKind
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Which persistence source the host creates or resolves from the scene.

| Value | Meaning |
| --- | --- |
| `File` | Use crash-resistant files below `Application.persistentDataPath`. |
| `Memory` | Use an in-process adapter, primarily for previews and tests. |
| `Component` | Use the serialized MonoBehaviour implementing `IMapSaveAdapter`. |

---

## MapHostSeedPolicy

```csharp
public enum MapHostSeedPolicy
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/BranchWeaverMapHost.cs</small>

Where the parameterless `BranchWeaverMapHost.StartNew()` obtains its seed.

| Value | Meaning |
| --- | --- |
| `Blueprint` | Use the seed authored on the selected blueprint. |
| `Fixed` | Use the fixed seed serialized on the host. |

---

