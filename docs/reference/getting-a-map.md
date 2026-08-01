# Getting a map

12 types in this area.

!!! abstract "On this page"
    [EdgeGenerationOverride](#edgegenerationoverride) &middot; [EdgeOverrideDisposition](#edgeoverridedisposition) &middot; [LayeredMapGenerator](#layeredmapgenerator) &middot; [MapGenerationFailureKind](#mapgenerationfailurekind) &middot; [MapGenerationMode](#mapgenerationmode) &middot; [MapGenerationOverrides](#mapgenerationoverrides) &middot; [MapGenerationRequest](#mapgenerationrequest) &middot; [MapGenerationResult](#mapgenerationresult) &middot; [MapGenerationSearchOptions](#mapgenerationsearchoptions) &middot; [MapGenerationStatistics](#mapgenerationstatistics) &middot; [PinnedNodeFields](#pinnednodefields) &middot; [PinnedNodeOverride](#pinnednodeoverride)

## EdgeGenerationOverride

```csharp
public readonly struct EdgeGenerationOverride : IComparable<EdgeGenerationOverride>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

One authored constraint on a single slot-to-slot connection: require it and fix the ID the
edge will carry, or forbid it. The slots must sit in adjacent layers -- the target exactly one
layer above the source -- and only one override may exist for a given slot pair, so a
required and a forbidden override for the same pair is a conflict rather than a precedence
question.

**Constructors**

`public EdgeGenerationOverride()`

:   Creates an immutable edge Generation Override snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `overrideId` &mdash; Identity of the override itself; required, unique among the overrides, and quoted in diagnostics.
    - `disposition` &mdash; Whether the edge is required or forbidden.
    - `sourceSlot` &mdash; Input source Slot consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `targetSlot` &mdash; Input target Slot consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `pinnedEdgeId` &mdash; Stable identifier for pinned Edge; invalid or empty IDs are rejected before mutation.

**Properties**

`public EdgeOverrideDisposition Disposition`

:   Whether this override demands the connection or bans it.

`public StableId OverrideId`

:   Identity of the override itself, which is not the identity of the edge it asks for. Required, unique among the overrides, and quoted in diagnostics, so it is worth naming after the intent -- a rejected constraint is reported by this ID alone.

`public StableId PinnedEdgeId`

:   The ID a required edge must be generated with, unique among the pinned edges, which is how that edge can be referred to once the map exists. Empty on a forbidden override, where naming an edge ID is rejected rather than ignored.

`public MapSlotEdge SlotEdge`

:   The ordered slot pair this override constrains, as the generator keys it.

`public MapNodeSlot SourceSlot`

:   The slot the constrained edge leaves.

`public MapNodeSlot TargetSlot`

:   The slot the constrained edge enters. Its layer must be exactly one above the source's.

**Methods**

`public int CompareTo(EdgeGenerationOverride other)`

:   Orders edge overrides deterministically -- slot pair, then disposition, then override ID, then pinned edge ID -- so a set of overrides fingerprints the same way no matter the order it was supplied in.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A negative value, zero, or a positive value as this override sorts before, alongside, or after `other`.

---

## EdgeOverrideDisposition

```csharp
public enum EdgeOverrideDisposition
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

Whether an edge override demands a connection or bans one. The two dispositions carry
different obligations: a required edge names the ID the generated edge must be given and
needs a pinned node at both of its slots, while a forbidden edge must not name an edge ID at
all.

| Value | Meaning |
| --- | --- |
| `Required` | The map must contain this edge, carrying the override's pinned edge ID. |
| `Forbidden` | The map must not connect these two slots, by required topology or by optional edge. |

---

## LayeredMapGenerator

:material-star: **Start here**

```csharp
public sealed class LayeredMapGenerator : IMapGenerator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/LayeredMapGenerator.cs</small>

Generator version 1. Adjacent layers are connected by a randomized monotone lattice.
For layer sizes m and n, that lattice contains exactly m + n - 1 edges.

**Constructors**

`public LayeredMapGenerator()`

:   Creates an immutable layered Map Generator snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.

`public LayeredMapGenerator(IMapValidator validator)`

:   Creates an immutable layered Map Generator snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `validator` &mdash; Input validator consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Methods**

`public MapGenerationResult Generate(MapGenerationRequest request)`

:   Produces one map from the request, or a typed failure. Nothing is thrown: a null request, null or invalid rules, and a candidate that fails validation all come back as a failed result carrying the diagnostics that explain it. This is the entry point for both shipped generators, not only the version-1 one described on the type. When the rule snapshot declares generator version 2 the call is handed straight to that search, which is what honours the mode, the overrides, the search budgets, and the cancellation token; the version-1 path below reads only the rules and the seed, gives every node the default type, and makes a single attempt -- a candidate the validator rejects fails the seed rather than being retried.
    - `request` &mdash; Input request consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The graph and its generation manifest, or the diagnostics behind the failure. Never null.

---

## MapGenerationFailureKind

```csharp
public enum MapGenerationFailureKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

Why a generation attempt returned no graph, as reported by
`MapGenerationResult.FailureKind`. The kinds are told apart because the fix differs:
`Unsatisfiable` means the rules themselves have to change, whereas
`SearchBudgetExhausted` means a larger budget or a different seed may still succeed.

| Value | Meaning |
| --- | --- |
| `None` | No failure; the attempt succeeded and the result carries a graph. |
| `InvalidInput` | The request was rejected in preflight and no search ran -- missing or invalid rules, an unsupported mode, non-positive search budgets, or overrides that conflict with the mode. |
| `Unsatisfiable` | The search completed and proved that no graph satisfies the hard constraints. |
| `SearchBudgetExhausted` | A search budget ran out first, so unsatisfiability was neither proven nor ruled out. |
| `Cancelled` | The caller's cancellation token was signalled. |
| `PostValidationFailed` | Complete candidates were found, but every one of them failed post-generation validation. |

---

## MapGenerationMode

:material-star: **Start here**

```csharp
public enum MapGenerationMode
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

How much of a map a generation request may invent for itself, and therefore what role
`MapGenerationOverrides` plays: Procedural rejects overrides outright, Manual
builds nothing the overrides did not spell out, and Hybrid lets a seeded search fill in
around whatever you pinned. The mode is folded into the generation key and into every random
stream the generator draws from, so the same rules and seed under two different modes are two
unrelated maps -- changing mode does not refine a map, it replaces it.

| Value | Meaning |
| --- | --- |
| `Procedural` | Rules and seed alone decide the map. |
| `Manual` | The overrides are the map: every node comes from a pin that fixes all of its fields, every edge from a required edge override, and the seed must be zero. |
| `Hybrid` | A seeded search builds the map but must honour every pin and edge override, and stays free to add nodes and edges the overrides left open. |

---

## MapGenerationOverrides

```csharp
public sealed class MapGenerationOverrides
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

The complete set of authoring overrides carried by one generation request: pinned nodes and
edge dispositions, copied out of the sequences you pass and sorted into canonical order, so
two callers who supply the same overrides in different orders get the same fingerprint and the
same map. The instance is immutable once built and never aliases your collections. Building
one does not validate it -- duplicate slots, conflicting dispositions, and mode mismatches are
reported by generation and validation, not by this constructor.

**Constructors**

`public MapGenerationOverrides()`

:   Copies and sorts the given overrides. A null sequence is treated as an empty one, and later changes to the sequences you passed do not reach this instance.
    - `nodes` &mdash; Pinned nodes, in any order.
    - `edges` &mdash; Required and forbidden edge overrides, in any order.

**Properties**

`public IReadOnlyList<EdgeGenerationOverride> Edges`

:   The edge overrides, in canonical sorted order rather than the order supplied.

`public bool IsEmpty`

:   Whether this set constrains nothing at all, pinning neither a node nor an edge. A request in `MapGenerationMode.Procedural` is required to carry a set that reports true here, so this is the check that separates an unconstrained request from one that must run in another mode.

`public IReadOnlyList<PinnedNodeOverride> Nodes`

:   The pinned nodes, in canonical sorted order rather than the order supplied.

**Methods**

`public string ComputeFingerprint()`

:   Hashes every pin and edge override into the canonical overrides fingerprint. Generation folds this value into its generation key and into the random streams it draws from, so an override set that differs anywhere produces a different map, and an unchanged one reproduces the map exactly.
    - **Returns** &mdash; The hex digest of this override set.

---

## MapGenerationRequest

:material-star: **Start here**

```csharp
public sealed class MapGenerationRequest
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

Everything one generation attempt needs, in one immutable object: the compiled rules, the seed,
how much of the map the generator may invent, the authoring overrides it must honour, the search
budgets it may spend, and the token that stops it. Keeping a request is enough to rebuild its map
exactly, because generation only ever reads it.
Mode, overrides, search budgets, and cancellation reach the version-2 generator only; when the
rule snapshot declares generator version 1, just `Rules` and `Seed` are
read. Nothing is validated here either -- procedural mode carrying overrides, manual mode with a
non-zero seed, or a null rule snapshot all come back as a failed
`MapGenerationResult` with diagnostics rather than as a thrown exception.

**Constructors**

`public MapGenerationRequest(MapRuleSnapshot rules, uint seed)`

:   Creates an immutable map Generation Request snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `rules` &mdash; Input rules consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `seed` &mdash; Seeds every random stream the generator draws from.

`public MapGenerationRequest()`

:   Creates an immutable map Generation Request snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `rules` &mdash; Input rules consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `seed` &mdash; Seeds every random stream. Must be zero when `mode` is `MapGenerationMode.Manual`.
    - `mode` &mdash; How much of the map the generator may invent for itself.
    - `overrides` &mdash; Input overrides consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `searchOptions` &mdash; Input search Options consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `cancellationToken` &mdash; Stops the search. A cancelled request produces a `MapGenerationFailureKind.Cancelled` result, not a thrown exception and not a partial graph.

**Properties**

`public CancellationToken CancellationToken`

:   Stops the search, and is observed by the version-2 generator only. Cancelling comes back as a `MapGenerationFailureKind.Cancelled` result rather than as a thrown exception, so a cancelled attempt is handled on the same path as any other failure and never leaves a partial graph behind.

`public MapGenerationMode Mode`

:   How much of the map the generator may invent for itself. Read by the version-2 generator only, so a rule snapshot declaring generator version 1 generates procedurally whatever is set here.

`public MapGenerationOverrides Overrides`

:   The overrides to honour, never null; an unconstrained request carries `MapGenerationOverrides.Empty`.

`public MapRuleSnapshot Rules`

:   The compiled rules the map must satisfy, and the snapshot whose declared generator version decides which generator reads this request. Stored exactly as given, null included, which generation reports as a failed result rather than an argument exception.

`public MapGenerationSearchOptions SearchOptions`

:   The search budgets, never null; a request that did not state them carries `MapGenerationSearchOptions.Default`.

`public uint Seed`

:   Seeds every random stream the generator draws from. Zero is a usable seed everywhere, and `MapGenerationMode.Manual` requires it.

---

## MapGenerationResult

:material-star: **Start here**

```csharp
public sealed class MapGenerationResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

The single outcome of a generation attempt: on success a complete graph and its
`MapGenerationManifest`, on failure a `MapGenerationFailureKind` naming
what went wrong, and either way the diagnostics and the search statistics. There is no partial
success -- a failed result never carries a graph -- so `Succeeded` is the only test
needed before reading `Graph`.
The failure kinds are worth telling apart: `MapGenerationFailureKind.Unsatisfiable`
means no map can satisfy the rules and the author must relax them,
`MapGenerationFailureKind.SearchBudgetExhausted` means the budget ran out before that
was proven either way, and `MapGenerationFailureKind.Cancelled` means the caller
stopped the search. Results come from the `Success(MapGraph, MapGenerationManifest, ValidationReport)`
and `Failure(ValidationReport)` factories; there is no public constructor.

**Properties**

`public MapGenerationFailureKind FailureKind`

:   Why the attempt failed. `MapGenerationFailureKind.None` exactly when `Succeeded` is true; a failed result always names a kind.

`public MapGraph Graph`

:   Null when generation failed.

`public MapGenerationManifest Manifest`

:   Null when generation failed.

`public MapGenerationStatistics Statistics`

:   What the search cost, never null. Version-2 generation reports the trials it spent per phase, which is how a budget-exhausted failure is turned into a larger budget; version-1 generation searches nothing and reports zeroes.

`public bool Succeeded`

:   Whether the attempt produced a map. It is the only test needed before reading `Graph` and `Manifest`, which are non-null exactly when this is true; a false result always names its reason in `FailureKind`.

`public ValidationReport Validation`

:   The diagnostics for the attempt, never null and present on success too, where it may still carry warnings worth surfacing to the author.

**Methods**

`public static MapGenerationResult Failure(ValidationReport validation)`

:   Runs failure against validated inputs and returns a complete result rather than exposing partially updated state.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A failed result carrying no graph and no manifest.

`public static MapGenerationResult Failure()`

:   Runs failure against validated inputs and returns a complete result rather than exposing partially updated state.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `failureKind` &mdash; Why the attempt failed. Must not be `MapGenerationFailureKind.None`, which throws `ArgumentException`.
    - `statistics` &mdash; Input statistics consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A failed result carrying no graph and no manifest.

`public static MapGenerationResult Success()`

:   Runs success against validated inputs and returns a complete result rather than exposing partially updated state.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `manifest` &mdash; Input manifest consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A result whose `Succeeded` is true and whose `FailureKind` is `MapGenerationFailureKind.None`.

`public static MapGenerationResult Success()`

:   Runs success against validated inputs and returns a complete result rather than exposing partially updated state.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `manifest` &mdash; Input manifest consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `statistics` &mdash; Input statistics consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A result whose `Succeeded` is true and whose `FailureKind` is `MapGenerationFailureKind.None`.

---

## MapGenerationSearchOptions

```csharp
public sealed class MapGenerationSearchOptions
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

The work a single generation attempt may spend, as one positive cap per search phase. The
generator counts against these caps as it explores, and the first cap it reaches ends the attempt
with `MapGenerationFailureKind.SearchBudgetExhausted` -- a search that stopped early,
not a proof that the rules cannot be satisfied. The caps bound only how far the search runs; the
order candidates are tried in comes from the seed and the rules, so raising a cap can turn a
failure into a success but never changes a map that already generated.

**Constructors**

`public MapGenerationSearchOptions()`

:   Creates an immutable map Generation Search Options snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `maximumCountStates` &mdash; Cap on the complete per-layer node-count combinations the search may consider.
    - `maximumTopologyTrials` &mdash; Cap on the individual edge-candidate steps the search may take while wiring layers together.
    - `maximumTypeTrials` &mdash; Cap on the node-type assignment attempts the backtracking type solver may make.

**Properties**

`public bool IsValid`

:   True when all three caps are positive. Anything else is rejected in generation preflight, so an invalid instance fails the attempt with `MapGenerationFailureKind.InvalidInput` rather than searching with no budget.

`public int MaximumCountStates`

:   How many complete per-layer node-count combinations the search may consider before giving up.

`public int MaximumTopologyTrials`

:   How many edge-candidate steps the search may take while wiring layers together. Counted per step of the walk, not per finished layer, so one layout can spend many.

`public int MaximumTypeTrials`

:   How many node-type assignment attempts the type solver may make. Every retry after a constraint conflict spends one, so tight type quotas raise the cost sharply.

---

## MapGenerationStatistics

```csharp
public sealed class MapGenerationStatistics
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

What one generation attempt actually cost, counted against
`MapGenerationSearchOptions`. Successes and failures both report it, which is what
makes it useful: compare the counters with the caps to see how close a blueprint runs to its
budget before it ever fails in a player's hands. An attempt rejected before the search started
reports `Empty`.

**Constructors**

`public MapGenerationStatistics()`

:   Creates an immutable map Generation Statistics snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `countStates` &mdash; Per-layer node-count combinations considered.
    - `topologyTrials` &mdash; Edge-candidate steps taken while wiring layers.
    - `typeTrials` &mdash; Node-type assignment attempts made.
    - `deepestTypeAssignment` &mdash; Deepest point the type solver reached, in assigned slots.
    - `exhaustedPhase` &mdash; Input exhausted Phase consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public int CountStates`

:   Per-layer node-count combinations the search considered, counted against `MapGenerationSearchOptions.MaximumCountStates`.

`public int DeepestTypeAssignment`

:   How many slots the type solver had filled at the deepest point it reached. Well short of the node count on a failure means a type rule conflicts early, which is where to look first.

`public static MapGenerationStatistics Empty`

:   All counters zero and no exhausted phase, for a result that never reached the search.

`public string ExhaustedPhase`

:   Which budget ran out: `count`, `topology` or `type`. Empty when no budget was exhausted, so this is only meaningful alongside `MapGenerationFailureKind.SearchBudgetExhausted`.

`public int TopologyTrials`

:   Edge-candidate steps the search took, counted against `MapGenerationSearchOptions.MaximumTopologyTrials`.

`public int TypeTrials`

:   Node-type assignment attempts the search made, counted against `MapGenerationSearchOptions.MaximumTypeTrials`.

---

## PinnedNodeFields

```csharp
public enum PinnedNodeFields
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

Which of a pinned node's authored values the generator must reproduce exactly. A flag left
clear hands that value back to the generator, and the matching value on the
`PinnedNodeOverride` must then be left at its default -- a type ID or position
carried next to a clear flag is reported as an invalid override rather than quietly ignored.
Identity is pinned separately and always, so even `PinnedNodeFields.None` still
binds the slot to the pin's node ID.

| Value | Meaning |
| --- | --- |
| `None` | Only the node ID is pinned; type, position, and payload stay generated. |
| `Type` | The node type is fixed, and must be a declared type that its zone permits. |
| `Position` | The normalized position is fixed instead of derived from layer and ordinal. |
| `Payload` | The payload is fixed, and must pass payload validation. |
| `All` | Type, position, and payload are all pinned. |

---

## PinnedNodeOverride

```csharp
public readonly struct PinnedNodeOverride : IComparable<PinnedNodeOverride>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

One authored node pinned to a map slot: the identity that slot must hold, plus whichever of
its type, position, and payload the generator is not free to choose. At most one pin may
occupy a slot, and every pinned node ID must be non-empty and unique across the override set.
A pin also raises the effective minimum node count of its layer far enough to cover its
ordinal, so pinning a high ordinal forces a wider layer.

**Constructors**

`public PinnedNodeOverride()`

:   Creates an immutable pinned Node Override snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `slot` &mdash; Input slot consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `nodeId` &mdash; Stable identifier for node; invalid or empty IDs are rejected before mutation.
    - `fields` &mdash; Which of type, position, and payload this pin fixes.
    - `typeId` &mdash; Stable identifier for type; invalid or empty IDs are rejected before mutation.
    - `position` &mdash; Input position consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `payload` &mdash; Input payload consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public PinnedNodeFields Fields`

:   Which of the node's type, position, and payload this pin fixes. Anything left clear is the generator's to choose, and its value on this pin must then be left at its default.

`public StableId NodeId`

:   The ID the generated node must carry. Required on every pin and unique across the override set, because identity is pinned even when `Fields` is `PinnedNodeFields.None` -- which is what lets you find this node again in a graph the generator otherwise built for itself.

`public MapNodePayload Payload`

:   The fixed payload, never null. Empty unless `PinnedNodeFields.Payload` is set in `Fields`.

`public NormalizedMapPosition Position`

:   The fixed normalized position. Default unless `PinnedNodeFields.Position` is set in `Fields`.

`public MapNodeSlot Slot`

:   The layer and ordinal this pin claims. At most one pin may occupy a slot, and because layers fill contiguously from ordinal zero, pinning a high ordinal obliges its layer to hold at least that many nodes.

`public StableId TypeId`

:   The fixed node type. Empty unless `PinnedNodeFields.Type` is set in `Fields`.

**Methods**

`public int CompareTo(PinnedNodeOverride other)`

:   Orders pins deterministically -- slot, then node ID, then pinned fields, type, position, and finally payload contents -- which is what lets one set of pins fingerprint the same way no matter the order it was supplied in.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A negative value, zero, or a positive value as this pin sorts before, alongside, or after `other`.

---

