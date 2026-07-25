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

:   Creates a payload from the given entries. They are copied and sorted by key, so the caller may reuse or mutate the sequence afterwards, and two payloads built from the same entries in different orders compare equal and hash alike. Nothing is checked here: read `IsCanonical` before handing the payload to a session.
    - `payloadId` &mdash; Identity of the payload; it may be left empty only when there are no properties.
    - `properties` &mdash; The entries to carry. Null means no properties.

**Properties**

`public bool IsCanonical`

:   True when the payload is well formed: properties only under a non-empty ID, no empty key, no repeated key, and every value canonical for its kind. `MapSession` refuses a completion result that fails this, so test a payload you assembled yourself before handing it in rather than reading the refusal afterwards.

`public StableId PayloadId`

:   Identity of this payload -- what tells your game which shape of data it is holding. A canonical payload leaves it empty only when it carries no properties.

`public IReadOnlyList<MapProperty> Properties`

:   The entries, sorted by key rather than kept in the order they were supplied. In a canonical payload each key appears exactly once.

**Methods**

`public bool Equals(MapDataPayload other)`

:   Reports whether both payloads carry the same ID and the same entries. Both sides are already sorted, so the order the entries were originally supplied in makes no difference.
    - **Returns** &mdash; True when the payloads match; false when `other` is null.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a payload equal to this one.

`public override int GetHashCode()`

:   Returns a hash over the ID and every entry in sorted order. It depends on content alone, and each part is hashed with a fixed algorithm rather than with `string.GetHashCode()`, so the value is reproducible across processes and platforms and may safely be persisted.

---

## MapNodeCompletion

```csharp
public sealed class MapNodeCompletion : IEquatable<MapNodeCompletion>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapProgressionState.cs</small>

One finished node paired with whatever the game reported for it. Immutable, and the payload
is never null, so a completion can be read without a null guard.

**Constructors**

`public MapNodeCompletion(StableId nodeId, MapDataPayload resultPayload)`

:   Records that a node was completed with the given result.
    - `resultPayload` &mdash; Outcome data for the node, such as a reward roll or a chosen branch. Null is stored as `MapDataPayload.Empty`; a session accepts only a canonical payload.

**Properties**

`public StableId NodeId`

:   The node this records the finishing of. It is the graph node's own id, so the record survives the graph being rebuilt from its seed and can be matched back to a node without keeping the graph that produced it.

`public MapDataPayload ResultPayload`

:   What the game reported when the node was completed, or `MapDataPayload.Empty` when the completion carried no data.

**Methods**

`public bool Equals(MapNodeCompletion other)`

:   Compares node and payload: the same node completed with a different result is not equal.

`public override bool Equals(object obj)`

:   Value equality against another `MapNodeCompletion`. Anything else, null included, is unequal.

`public override int GetHashCode()`

:   Combines the node and its result payload, so it agrees with `Equals(MapNodeCompletion)` and two completions of the same node with different results land in different buckets.

---

## MapProgressionState

:material-star: **Start here**

```csharp
public sealed class MapProgressionState : IEquatable<MapProgressionState>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapProgressionState.cs</small>

An immutable traversal snapshot. Route history retains traversal order.

It carries everything a run needs: where the player stands, what may be entered next, what
has already been finished, and the revision that stamps this snapshot. A
`MapSession` never mutates one; each committed transition produces a fresh
snapshot with the next revision, so a snapshot can be held, compared, saved, or handed to
presentation without the run moving underneath it.

**Constructors**

`public MapProgressionState()`

:   Builds a snapshot directly, which is what restoring a saved run does. Every sequence is copied, and a null sequence becomes an empty one. Nothing is checked against a graph here: `MapSession` validates a snapshot when it is constructed with one.
    - `revision` &mdash; Transition counter stamped on this snapshot; a new run starts at zero.
    - `currentNodeId` &mdash; The node being played, or an empty id when no node is in progress.
    - `availableNodeIds` &mdash; Nodes that may be entered next. Stored sorted, so the order passed in is not preserved.
    - `visitedNodeIds` &mdash; Entered nodes in traversal order, oldest first.
    - `completions` &mdash; Finished nodes, one per completed node and in the same order as `visitedNodeIds`; a session rejects a snapshot whose completions do not line up with its route.
    - `isMapCompleted` &mdash; True when the last completed node had no outgoing routes.

**Properties**

`public IReadOnlyList<StableId> AvailableNodeIds`

:   Nodes that may be entered next, sorted by id rather than by authoring order.

`public IReadOnlyList<MapNodeCompletion> Completions`

:   Finished nodes with their results, in the same order as `VisitedNodeIds`.

`public StableId CurrentNodeId`

:   The node being played, or an empty id when the player is between nodes. While it is set no node is available, because the current node must be completed first.

`public bool IsMapCompleted`

:   True once the run has ended, because the last completed node led nowhere. A session refuses further transitions from this point.

`public long Revision`

:   Advances by one on every committed transition, so it also tells two snapshots of the same run apart. A run created from a graph starts at zero.

`public IReadOnlyList<StableId> VisitedNodeIds`

:   Every entered node in traversal order, oldest first. While a node is in progress it is the last entry, so this list is one longer than `Completions`.

**Methods**

`public bool Equals(MapProgressionState other)`

:   Compares the whole snapshot, revision included, and treats route and completion order as significant. Two snapshots of the same run at different revisions are never equal.

`public override bool Equals(object obj)`

:   Value equality against another `MapProgressionState`. Anything else, null included, is unequal.

`public override int GetHashCode()`

:   Combines the revision, the current node, the completion flag, and every available id, visited id, and completion in order, so it agrees with `Equals(MapProgressionState)`. It walks the whole route rather than a fixed number of fields, so it costs more the further a run has progressed. Cache the value if a snapshot is used as a dictionary key on a per-frame path.

`public bool IsAvailable(StableId nodeId)`

:   True when the node may be entered right now.

`public bool IsCompleted(StableId nodeId)`

:   True when the node has been finished and its result recorded.

`public bool IsVisited(StableId nodeId)`

:   True when the node has been entered. Entering is not finishing: a node the player is standing on is visited but not yet completed.

`public bool TryGetCompletion(StableId nodeId, out MapNodeCompletion completion)`

:   Reads back the result recorded for a finished node.
    - `completion` &mdash; The recorded completion, or null when the node has not been finished.
    - **Returns** &mdash; True when a completion for the node exists.

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

:   Starts a fresh run over a map: no node is current, nothing has been visited, and the graph's start nodes -- the ones no edge leads into -- are what the player may enter first.
    - `graph` &mdash; The map to traverse. It is validated, never repaired.

`public MapSession(MapGraph graph, MapProgressionState state)`

:   Resumes a run from a progression snapshot, typically one just loaded from a save. The graph and the progression are validated together, so a snapshot that does not describe one legal ordered route through this particular graph is rejected outright rather than loaded and silently corrected. That is deliberate: a save edited by hand, or written against a map that has since been regenerated, fails loudly at load instead of drifting.
    - `graph` &mdash; The map to traverse.
    - `state` &mdash; The progression to resume from.

**Properties**

`public MapGraph Graph`

:   The map being traversed, fixed for the life of the session. A different map means a new session, not a new graph here.

`public MapProgressionState State`

:   Where the run stands now. Every committed transition replaces it with a fresh snapshot at the next revision rather than mutating it, so a reference taken earlier still describes the run as it stood then -- which is what makes this safe to hold on to and to persist.

**Events**

`public event Action<MapTransitionEvent> Transitioned`

:   Raised once for each event of a committed transition, in event order, and only after `State` has already been updated -- so a handler always reads the new state. A handler cannot start another transition: a call made from inside one is refused with `MapTransitionFailureKind.TransitionInProgress` rather than reentering the session. A handler that throws neither rolls the transition back nor stops the remaining handlers; the failure is recorded as a warning on that transition's `MapTransitionResult.Validation` instead.

**Methods**

`public MapTransitionResult CompleteCurrent()`

:   Completes the current node without recording any result data, exactly as passing `MapDataPayload.Empty` would.
    - **Returns** &mdash; The outcome; see the overload taking a payload for what completing a node does.

`public MapTransitionResult CompleteCurrent(MapDataPayload resultPayload)`

:   Completes the current node and records alongside it whatever your game wants to remember about the outcome. The nodes it leads to become available; when it leads nowhere, the run is marked completed and no further transition will be accepted. The payload is stored in the progression and travels with the save, which is why a non-canonical one is refused rather than normalised -- the session will not persist data it cannot round-trip.
    - `resultPayload` &mdash; What the node produced. It must satisfy `MapDataPayload.IsCanonical`; use `MapDataPayload.Empty` when there is nothing to record.
    - **Returns** &mdash; The outcome. A success carries a `MapTransitionEventKind.NodeCompleted` event, then `MapTransitionEventKind.AvailabilityChanged` if anything opened up, and `MapTransitionEventKind.MapCompleted` if nothing did.

`public MapTransitionResult TryEnter(StableId nodeId)`

:   Enters an available node and makes it the current one. Every precondition is checked first and a refusal changes nothing, so any node ID may be offered and the reason read back off the result -- there is no need to pre-check availability yourself. A successful entry appends the node to the visited route, empties the available set until the node is completed, and produces a `MapTransitionEventKind.NodeEntered` event followed by an `MapTransitionEventKind.AvailabilityChanged` event.
    - `nodeId` &mdash; The node to enter; it must currently be in `MapProgressionState.AvailableNodeIds`.
    - **Returns** &mdash; The outcome, with the reason in `MapTransitionResult.FailureKind` when the attempt was refused.

---

## MapTransitionEvent

:material-star: **Start here**

```csharp
public sealed class MapTransitionEvent
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

One immutable thing that happened during a traversal transition: a node was entered or
completed, the choosable set changed, or the run ended. This is the type your UI listens to --
entering a node, finishing it, and the map ending each arrive as their own event, so a view can
react to exactly the change it cares about instead of diffing progression snapshots. Every
event of one transition shares that transition's `Revision` and reports the
availability that transition produced, and the events are already committed by the time you see
them: a listener that throws cannot undo them.

**Constructors**

`public MapTransitionEvent()`

:   Creates one transition event. The available ids are copied and sorted, so the caller's collection is neither retained nor required to be ordered.
    - `kind` &mdash; What the event reports.
    - `order` &mdash; Zero-based position within its own transition, not a running total.
    - `revision` &mdash; The progression revision this transition produced.
    - `nodeId` &mdash; The node the event is about. Pass the default id for events that describe the map rather than a node, such as `MapTransitionEventKind.AvailabilityChanged`.
    - `resultPayload` &mdash; Completion data for a node-completed or map-completed event. Null becomes `MapDataPayload.Empty`.
    - `availableNodeIds` &mdash; The nodes choosable after the transition. Null becomes an empty set.

**Properties**

`public IReadOnlyList<StableId> AvailableNodeIds`

:   The nodes choosable after the transition, ascending. It is the complete post-transition set rather than a delta, and it is repeated on every event of the transition -- including `MapTransitionEventKind.NodeEntered`, where entering a node leaves it empty until that node is completed.

`public MapTransitionEventKind Kind`

:   What this event reports, and therefore which of the other properties mean anything: an availability change leaves `NodeId` empty, and only a completion fills `ResultPayload`. Switch on it rather than assuming a shape, since one transition emits several events.

`public StableId NodeId`

:   The node this event is about. Empty for events that describe the map rather than one node, so check `StableId.IsEmpty` before using it.

`public int Order`

:   Zero-based position within its own transition, not a running total across the run. Use it to keep the events of one transition in order, not to tell transitions apart.

`public MapDataPayload ResultPayload`

:   The completion data supplied when the node finished. This is `MapDataPayload.Empty` for every kind except `MapTransitionEventKind.NodeCompleted` and `MapTransitionEventKind.MapCompleted`.

`public long Revision`

:   The progression revision this transition produced. Every event of one transition carries the same value, which is how a listener can tell which events belong together.

---

## MapTransitionEventKind

```csharp
public enum MapTransitionEventKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

What one `MapTransitionEvent` reports. A single transition emits several of these
in order, so switch on the kind rather than assuming one event per call.

| Value | Meaning |
| --- | --- |
| `NodeEntered` | The run moved into a node. |
| `NodeCompleted` | The current node finished. |
| `AvailabilityChanged` | The set of choosable nodes changed; read the new set from `MapTransitionEvent.AvailableNodeIds`. |
| `MapCompleted` | The completed node had no outgoing edges, so the run is over. |

---

## MapTransitionFailureKind

```csharp
public enum MapTransitionFailureKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

Why a transition was refused. Every value except `MapTransitionFailureKind.None`
means nothing was committed: the progression state, its revision, and the available set are all
as they were.

| Value | Meaning |
| --- | --- |
| `None` | No failure -- the transition was applied. |
| `TransitionInProgress` | The call came from inside a transition callback, which would reenter a session mid-dispatch. |
| `MapAlreadyCompleted` | The run already reached its end; start a new session to traverse again. |
| `CurrentNodeActive` | A node is still current. |
| `CurrentNodeMissing` | There is no current node to complete. |
| `NodeUnknown` | The requested id is empty or names no node in this graph. |
| `NodeUnavailable` | The node exists but is not in the current available set, so it is not a legal choice yet. |
| `ResultPayloadInvalid` | The completion payload was null or not canonical, and a non-canonical payload cannot be written into progression state. |
| `RevisionOverflow` | The progression revision cannot be incremented any further. |

---

## MapTransitionResult

```csharp
public sealed class MapTransitionResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Traversal/MapTransition.cs</small>

The outcome of one attempted transition: whether it was applied, the progression state on each
side of it, the ordered events it produced, and its diagnostics. A refused attempt is reported
here rather than thrown, and it changes nothing -- so a caller can offer any node to
`MapSession.TryEnter` and read `FailureKind` instead of pre-checking.

**Properties**

`public IReadOnlyList<MapTransitionEvent> Events`

:   The authoritative ordered account of what the transition did. Empty for a refused attempt. Prefer replaying these over comparing snapshots, and note that one call can produce several.

`public MapTransitionFailureKind FailureKind`

:   Why the attempt was refused, or `MapTransitionFailureKind.None` when it was applied.

`public MapProgressionState PreviousState`

:   The progression state before the transition. On a refused attempt nothing moved, so this is the same state as `State`.

`public MapProgressionState State`

:   The progression state after the transition, already committed to the session on success. On a refused attempt it is the unchanged current state.

`public bool Succeeded`

:   Whether the transition was applied. A false value means the run did not move at all -- `Events` is empty and `PreviousState` and `State` are the same object -- so a refusal needs no undo and is safe to ignore beyond telling the player why.

`public ValidationReport Validation`

:   Diagnostics for the attempt. A refusal carries one error explaining `FailureKind`. A success carries only warnings -- for instance a transition callback that threw, which is reported here because the committed state was kept anyway.

**Methods**

`public static MapTransitionResult Rejected()`

:   Builds a refused result with an error diagnostic of your own. Use it when code wrapping a session must turn a request down before the session sees it, so that callers still get a refusal in the same shape a session would have produced.
    - `failureKind` &mdash; The kind to report. `MapTransitionFailureKind.None` is not meaningful here.
    - `state` &mdash; The unchanged current progression state, which the result carries on both sides.
    - `diagnosticCode` &mdash; The diagnostic code to record for the refusal.
    - `message` &mdash; The human-readable explanation to record alongside the code.
    - `nodeId` &mdash; The node the refusal is about. Pass the default id when it concerns no specific node.
    - **Returns** &mdash; A refused result carrying no events and one error diagnostic.

---

