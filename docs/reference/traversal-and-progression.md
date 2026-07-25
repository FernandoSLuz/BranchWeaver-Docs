# Traversal and progression

8 types in this area.

!!! abstract "On this page"
    [MapDataPayload](#mapdatapayload) &middot; [MapNodeCompletion](#mapnodecompletion) &middot; [MapProgressionState](#mapprogressionstate) &middot; [MapSession](#mapsession) &middot; [MapTransitionEvent](#maptransitionevent) &middot; [MapTransitionEventKind](#maptransitioneventkind) &middot; [MapTransitionFailureKind](#maptransitionfailurekind) &middot; [MapTransitionResult](#maptransitionresult)

## MapDataPayload

```csharp
public sealed class MapDataPayload : IEquatable<MapDataPayload>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapDataPayload.cs</small>

Generic tagged data for traversal results and customer-owned save metadata. It is
deliberately distinct from node-authored MapNodePayload.

**Constructors**

`public MapDataPayload(StableId payloadId, IEnumerable<MapProperty> properties)`

:   &mdash;

**Properties**

`public bool IsCanonical`

:   &mdash;

`public StableId PayloadId`

:   &mdash;

`public IReadOnlyList<MapProperty> Properties`

:   &mdash;

**Methods**

`public bool Equals(MapDataPayload other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapNodeCompletion

```csharp
public sealed class MapNodeCompletion : IEquatable<MapNodeCompletion>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapProgressionState.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodeCompletion(StableId nodeId, MapDataPayload resultPayload)`

:   &mdash;

**Properties**

`public StableId NodeId`

:   &mdash;

`public MapDataPayload ResultPayload`

:   &mdash;

**Methods**

`public bool Equals(MapNodeCompletion other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapProgressionState

:material-star: **Start here**

```csharp
public sealed class MapProgressionState : IEquatable<MapProgressionState>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapProgressionState.cs</small>

An immutable traversal snapshot. Route history retains traversal order.

**Constructors**

`public MapProgressionState()`

:   &mdash;

**Properties**

`public IReadOnlyList<StableId> AvailableNodeIds`

:   &mdash;

`public IReadOnlyList<MapNodeCompletion> Completions`

:   &mdash;

`public StableId CurrentNodeId`

:   &mdash;

`public bool IsMapCompleted`

:   &mdash;

`public long Revision`

:   &mdash;

`public IReadOnlyList<StableId> VisitedNodeIds`

:   &mdash;

**Methods**

`public bool Equals(MapProgressionState other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public bool IsAvailable(StableId nodeId)`

:   &mdash;

`public bool IsCompleted(StableId nodeId)`

:   &mdash;

`public bool IsVisited(StableId nodeId)`

:   &mdash;

`public bool TryGetCompletion(StableId nodeId, out MapNodeCompletion completion)`

:   &mdash;

---

## MapSession

:material-star: **Start here**

```csharp
public sealed class MapSession
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapSession.cs</small>

Standalone traversal orchestration over immutable graph and progression snapshots. The
ordered event list returned by a transition is authoritative. Optional callbacks run only
after the new state is committed; callback exceptions become warnings and never roll back.

**Constructors**

`public MapSession(MapGraph graph)`

:   &mdash;

`public MapSession(MapGraph graph, MapProgressionState state)`

:   &mdash;

**Properties**

`public MapGraph Graph`

:   &mdash;

`public MapProgressionState State`

:   &mdash;

**Events**

`public event Action<MapTransitionEvent> Transitioned`

:   &mdash;

**Methods**

`public MapTransitionResult CompleteCurrent()`

:   &mdash;

`public MapTransitionResult CompleteCurrent(MapDataPayload resultPayload)`

:   &mdash;

`public MapTransitionResult TryEnter(StableId nodeId)`

:   &mdash;

---

## MapTransitionEvent

:material-star: **Start here**

```csharp
public sealed class MapTransitionEvent
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapTransitionEvent()`

:   &mdash;

**Properties**

`public IReadOnlyList<StableId> AvailableNodeIds`

:   &mdash;

`public MapTransitionEventKind Kind`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public int Order`

:   &mdash;

`public MapDataPayload ResultPayload`

:   &mdash;

`public long Revision`

:   &mdash;

---

## MapTransitionEventKind

```csharp
public enum MapTransitionEventKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `NodeEntered` | &mdash; |
| `NodeCompleted` | &mdash; |
| `AvailabilityChanged` | &mdash; |
| `MapCompleted` | &mdash; |

---

## MapTransitionFailureKind

```csharp
public enum MapTransitionFailureKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `TransitionInProgress` | &mdash; |
| `MapAlreadyCompleted` | &mdash; |
| `CurrentNodeActive` | &mdash; |
| `CurrentNodeMissing` | &mdash; |
| `NodeUnknown` | &mdash; |
| `NodeUnavailable` | &mdash; |
| `ResultPayloadInvalid` | &mdash; |
| `RevisionOverflow` | &mdash; |

---

## MapTransitionResult

```csharp
public sealed class MapTransitionResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public IReadOnlyList<MapTransitionEvent> Events`

:   &mdash;

`public MapTransitionFailureKind FailureKind`

:   &mdash;

`public MapProgressionState PreviousState`

:   &mdash;

`public MapProgressionState State`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

**Methods**

`public static MapTransitionResult Rejected()`

:   &mdash;

---

