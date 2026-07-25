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

:   Creates an edge override for one pair of adjacent-layer slots.
    - `overrideId` &mdash; Identity of the override itself; required, unique among the overrides, and quoted in diagnostics.
    - `disposition` &mdash; Whether the edge is required or forbidden.
    - `sourceSlot` &mdash; The slot the edge leaves.
    - `targetSlot` &mdash; The slot the edge enters; its layer must be one above the source's.
    - `pinnedEdgeId` &mdash; The ID a required edge must carry, unique among pinned edges; leave default when forbidding.

**Properties**

`public EdgeOverrideDisposition Disposition`

:   &mdash;

`public StableId OverrideId`

:   &mdash;

`public StableId PinnedEdgeId`

:   &mdash;

`public MapSlotEdge SlotEdge`

:   The ordered slot pair this override constrains, as the generator keys it.

`public MapNodeSlot SourceSlot`

:   &mdash;

`public MapNodeSlot TargetSlot`

:   &mdash;

**Methods**

`public int CompareTo(EdgeGenerationOverride other)`

:   Orders edge overrides deterministically -- slot pair, then disposition, then override ID, then pinned edge ID -- so a set of overrides fingerprints the same way no matter the order it was supplied in.
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

:   &mdash;

`public LayeredMapGenerator(IMapValidator validator)`

:   &mdash;

**Methods**

`public MapGenerationResult Generate(MapGenerationRequest request)`

:   &mdash;

---

## MapGenerationFailureKind

```csharp
public enum MapGenerationFailureKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `InvalidInput` | &mdash; |
| `Unsatisfiable` | &mdash; |
| `SearchBudgetExhausted` | &mdash; |
| `Cancelled` | &mdash; |
| `PostValidationFailed` | &mdash; |

---

## MapGenerationMode

:material-star: **Start here**

```csharp
public enum MapGenerationMode
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

How much of a map a generation request may invent for itself, and therefore what role
`apGenerationOverrides` plays: Procedural rejects overrides outright, Manual
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

:   &mdash;

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

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapGenerationRequest(MapRuleSnapshot rules, uint seed)`

:   &mdash;

`public MapGenerationRequest()`

:   &mdash;

**Properties**

`public CancellationToken CancellationToken`

:   &mdash;

`public MapGenerationMode Mode`

:   &mdash;

`public MapGenerationOverrides Overrides`

:   &mdash;

`public MapRuleSnapshot Rules`

:   &mdash;

`public MapGenerationSearchOptions SearchOptions`

:   &mdash;

`public uint Seed`

:   &mdash;

---

## MapGenerationResult

:material-star: **Start here**

```csharp
public sealed class MapGenerationResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public MapGenerationFailureKind FailureKind`

:   &mdash;

`public MapGraph Graph`

:   Null when generation failed.

`public MapGenerationManifest Manifest`

:   Null when generation failed.

`public MapGenerationStatistics Statistics`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

**Methods**

`public static MapGenerationResult Failure(ValidationReport validation)`

:   &mdash;

`public static MapGenerationResult Failure()`

:   &mdash;

`public static MapGenerationResult Success()`

:   &mdash;

`public static MapGenerationResult Success()`

:   &mdash;

---

## MapGenerationSearchOptions

```csharp
public sealed class MapGenerationSearchOptions
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapGenerationSearchOptions()`

:   &mdash;

**Properties**

`public bool IsValid`

:   &mdash;

`public int MaximumCountStates`

:   &mdash;

`public int MaximumTopologyTrials`

:   &mdash;

`public int MaximumTypeTrials`

:   &mdash;

---

## MapGenerationStatistics

```csharp
public sealed class MapGenerationStatistics
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapGenerationStatistics()`

:   &mdash;

**Properties**

`public int CountStates`

:   &mdash;

`public int DeepestTypeAssignment`

:   &mdash;

`public static MapGenerationStatistics Empty`

:   &mdash;

`public string ExhaustedPhase`

:   &mdash;

`public int TopologyTrials`

:   &mdash;

`public int TypeTrials`

:   &mdash;

---

## PinnedNodeFields

```csharp
public enum PinnedNodeFields
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Generation/MapGenerationOverrides.cs</small>

Which of a pinned node's authored values the generator must reproduce exactly. A flag left
clear hands that value back to the generator, and the matching value on the
`innedNodeOverride` must then be left at its default -- a type ID or position
carried next to a clear flag is reported as an invalid override rather than quietly ignored.
Identity is pinned separately and always, so even `innedNodeFields.None` still
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

:   Creates a pin. Every value whose flag is clear in `fields` must be left at its default, and a null `payload` is stored as `apNodePayload.Empty`.
    - `slot` &mdash; The layer and ordinal the pinned node must occupy.
    - `nodeId` &mdash; The node ID the generated node must carry. Required, even when no field is pinned.
    - `fields` &mdash; Which of type, position, and payload this pin fixes.
    - `typeId` &mdash; The fixed node type; leave default unless `innedNodeFields.Type` is set.
    - `position` &mdash; The fixed normalized position; leave default unless `innedNodeFields.Position` is set.
    - `payload` &mdash; The fixed payload; leave empty unless `innedNodeFields.Payload` is set.

**Properties**

`public PinnedNodeFields Fields`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public MapNodePayload Payload`

:   The fixed payload, never null. Empty unless `innedNodeFields.Payload` is set in `ields`.

`public NormalizedMapPosition Position`

:   The fixed normalized position. Default unless `innedNodeFields.Position` is set in `ields`.

`public MapNodeSlot Slot`

:   &mdash;

`public StableId TypeId`

:   The fixed node type. Empty unless `innedNodeFields.Type` is set in `ields`.

**Methods**

`public int CompareTo(PinnedNodeOverride other)`

:   Orders pins deterministically -- slot, then node ID, then pinned fields, type, position, and finally payload contents -- which is what lets one set of pins fingerprint the same way no matter the order it was supplied in.
    - **Returns** &mdash; A negative value, zero, or a positive value as this pin sorts before, alongside, or after `other`.

---

