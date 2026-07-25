# Rules and constraints

18 types in this area.

!!! abstract "On this page"
    [ConstraintContext](#constraintcontext) &middot; [ConstraintEvaluationState](#constraintevaluationstate) &middot; [ConstraintResult](#constraintresult) &middot; [EdgeCrossingPolicy](#edgecrossingpolicy) &middot; [ForbiddenAdjacencyDirection](#forbiddenadjacencydirection) &middot; [ForbiddenAdjacencyRule](#forbiddenadjacencyrule) &middot; [ForcedNodeTypeRule](#forcednodetyperule) &middot; [IMapConstraint](#imapconstraint) &middot; [MapConnectionRules](#mapconnectionrules) &middot; [MapNodeSlot](#mapnodeslot) &middot; [MapNodeTypeAssignment](#mapnodetypeassignment) &middot; [MapSlotEdge](#mapslotedge) &middot; [MapValidator](#mapvalidator) &middot; [MapZoneDefinition](#mapzonedefinition) &middot; [NodeTypeQuotaRule](#nodetypequotarule) &middot; [NodeTypeWeight](#nodetypeweight) &middot; [NodeTypeWeightOverride](#nodetypeweightoverride) &middot; [ValidationReport](#validationreport)

## ConstraintContext

```csharp
public sealed class ConstraintContext
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

Everything an `MapConstraint` is allowed to see: the frozen rules, every slot
and slot edge in the attempt, and the type assignments decided so far. It carries no random
source, no Unity object, and no way back into the generator, which is what lets a constraint
reach the same verdict on every run of the same seed.

The generator builds a fresh context for each evaluation and hands that one instance to every
constraint in the pass, so treat it as read-only. During the search
`ssignments` normally covers only part of the map: check
`sComplete` before concluding that a rule is broken rather than merely undecided.

**Constructors**

`public ConstraintContext()`

:   Captures one evaluation's view of an attempt. Slots, edges, and assignments are copied and sorted here, so later changes to the collections passed in cannot reach the constraint.
    - `rules` &mdash; The rule snapshot the attempt runs under; required.
    - `slots` &mdash; Every slot in the attempt, assigned or not. Null is read as empty.
    - `edges` &mdash; The connections between those slots. Null is read as empty.
    - `assignments` &mdash; The slots whose type is already decided. Null is read as empty.
    - `isComplete` &mdash; True only when every slot in `slots` has an assignment.

**Properties**

`public IReadOnlyList<MapNodeTypeAssignment> Assignments`

:   The slots whose type is already decided, sorted. Partial during the search: expect fewer entries than `lots` until `sComplete` is true.

`public IReadOnlyList<MapSlotEdge> Edges`

:   The connections between those slots, sorted. During generation these are the layer-to-layer edges that carry connectivity; optional extra edges are added only after a complete assignment has been accepted, so do not read this as the finished graph's edge list. Validating an existing graph passes that graph's own edges instead.

`public bool IsComplete`

:   True when every slot has an assignment -- the last check before a candidate map is accepted, and always true when an existing graph is validated. While it is false, `onstraintEvaluationState.Undetermined` is a legitimate answer; once it is true, only `onstraintEvaluationState.Satisfied` passes.

`public MapRuleSnapshot Rules`

:   The rules in force for this attempt, layers and quotas included. Never null.

`public IReadOnlyList<MapNodeSlot> Slots`

:   Every slot in the attempt, ordered by layer then ordinal -- not only the assigned ones. Its count is the size of the map being built, so comparing it against `ssignments` shows how much is still open.

---

## ConstraintEvaluationState

```csharp
public enum ConstraintEvaluationState
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

What a custom constraint concluded about the assignment it was shown.
`onstraintEvaluationState.Violated` makes the generator abandon the partial
assignment it is on and report the result's code and message, while
`onstraintEvaluationState.Undetermined` is tolerated only while the assignment
is still partial: once every slot has a type -- and whenever an existing graph is validated
-- anything other than `onstraintEvaluationState.Satisfied` fails the map.

| Value | Meaning |
| --- | --- |
| `Undetermined` | Not decidable from the assignments shown so far. |
| `Satisfied` | The rule holds. |
| `Violated` | The rule is broken. |

---

## ConstraintResult

```csharp
public sealed class ConstraintResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

One constraint's answer for one evaluation: the state, plus the diagnostic code and message
that are reported when the state is `onstraintEvaluationState.Violated`. Build
these with `atisfied()`, `ndetermined()`, and
`iolated(string, string)`. A constraint that returns null is treated as having
reported a violation, so there is no "no answer" result to reach for.

**Constructors**

`public ConstraintResult(ConstraintEvaluationState state, string diagnosticCode, string message)`

:   Creates a result from its parts. The three factory methods cover every case the generator distinguishes; a null code or message is stored as an empty string.
    - `diagnosticCode` &mdash; The code to report with a violation. Leave it empty on satisfied and undetermined results, and on a violation that has no better code to offer.
    - `message` &mdash; The reason for a violation, reported to the caller as written.

**Properties**

`public string DiagnosticCode`

:   The code reported with a violation. Never null, and empty on satisfied and undetermined results; a violation that leaves it empty is reported as `apDiagnosticCodes.GenerationConstraintsUnsatisfiable` instead.

`public string Message`

:   The reason for a violation. Never null, and empty unless one was supplied. It reaches the generation and validation diagnostics verbatim, so write it for whoever reads that log.

`public ConstraintEvaluationState State`

:   &mdash;

**Methods**

`public static ConstraintResult Satisfied()`

:   A result stating that the rule holds, carrying no code or message.

`public static ConstraintResult Undetermined()`

:   A result stating that the rule cannot be judged yet. Only useful while `onstraintContext.IsComplete` is false; on a finished assignment it is treated as a failure rather than as a pass.

`public static ConstraintResult Violated(string code, string message)`

:   A result stating that the rule is broken, which makes the generator backtrack and record an error against the constraint that returned it.
    - `code` &mdash; The diagnostic code to report; an empty code becomes `apDiagnosticCodes.GenerationConstraintsUnsatisfiable`.
    - `message` &mdash; The reason, reported to the caller as written.

---

## EdgeCrossingPolicy

```csharp
public enum EdgeCrossingPolicy
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapConnectionRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Forbid` | &mdash; |
| `Allow` | &mdash; |

---

## ForbiddenAdjacencyDirection

```csharp
public enum ForbiddenAdjacencyDirection
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

Whether a forbidden adjacency follows edge direction or covers both orderings of its type
pair. There is no zero-valued member, so a default-initialised value is rejected by rule
validation rather than silently behaving like one of these.

| Value | Meaning |
| --- | --- |
| `Forward` | Only edges running from the first type to the second are banned; the reverse pairing is allowed. |
| `Either` | Edges are banned whichever of the two types sits on the source side. |

---

## ForbiddenAdjacencyRule

```csharp
public readonly struct ForbiddenAdjacencyRule : IComparable<ForbiddenAdjacencyRule>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

Bans edges between two node types. The generator applies it as a hard constraint on both
sides of the problem: it prunes types that would violate the ban while assigning them, and it
never adds an optional edge whose endpoint types match. A ban can therefore leave a chosen
topology with no valid type assignment at all, rather than merely thinning the connections.

**Constructors**

`public ForbiddenAdjacencyRule()`

:   Creates an adjacency ban between two node types. When `direction` is `orbiddenAdjacencyDirection.Either` the pair is stored in ascending type-ID order, so `irstTypeId` and `econdTypeId` may come back reversed from the arguments and two mirrored bans become indistinguishable.
    - `ruleId` &mdash; Identity of the rule; must be non-empty and unique among all rules in the snapshot.
    - `firstTypeId` &mdash; Source-side type when `direction` is `orbiddenAdjacencyDirection.Forward`.
    - `secondTypeId` &mdash; Target-side type when `direction` is `orbiddenAdjacencyDirection.Forward`.
    - `direction` &mdash; Whether the ban follows edge direction or covers both orderings.

**Properties**

`public ForbiddenAdjacencyDirection Direction`

:   &mdash;

`public StableId FirstTypeId`

:   Source-side type of a `orbiddenAdjacencyDirection.Forward` ban, or the lower-sorting member of the pair for an `orbiddenAdjacencyDirection.Either` ban. Not necessarily the first type handed to the constructor.

`public StableId RuleId`

:   Identity of this rule. Rule IDs share one uniqueness domain with every other rule and custom constraint in the snapshot, and diagnostics quote this ID to name the rule at fault.

`public StableId SecondTypeId`

:   Target-side type of a `orbiddenAdjacencyDirection.Forward` ban, or the higher-sorting member of the pair for an `orbiddenAdjacencyDirection.Either` ban.

**Methods**

`public int CompareTo(ForbiddenAdjacencyRule other)`

:   Orders bans by rule ID, then first type, second type, and direction, which is how a rule snapshot canonicalises its adjacency list.
    - **Returns** &mdash; A negative value, zero, or a positive value as this rule sorts before, alongside, or after `other`.

`public bool Forbids(StableId sourceType, StableId targetType)`

:   Reports whether this rule bans an edge between two typed endpoints. A `orbiddenAdjacencyDirection.Forward` ban matches only the stored ordering; an `orbiddenAdjacencyDirection.Either` ban matches both.
    - `sourceType` &mdash; Type of the endpoint on the earlier layer, which the edge leaves.
    - `targetType` &mdash; Type of the endpoint on the next layer, which the edge enters.
    - **Returns** &mdash; `true` when the edge is forbidden and must not exist.

---

## ForcedNodeTypeRule

```csharp
public readonly struct ForcedNodeTypeRule : IComparable<ForcedNodeTypeRule>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

Pins one slot to a node type before generation starts, fixing that slot's type instead of
drawing it by weight. A forced rule also obliges its layer to hold at least
`Slot.Ordinal + 1` nodes, so it can raise a layer's effective node count above the
authored minimum and change which layer sizes remain feasible.

**Constructors**

`public ForcedNodeTypeRule(StableId ruleId, MapNodeSlot slot, StableId typeId)`

:   Forces the node at one slot to take a specific type.
    - `ruleId` &mdash; Identity of the rule; must be non-empty and unique among all rules in the snapshot.
    - `slot` &mdash; Slot to pin; it must lie inside the map and its ordinal below the authored maximum of its layer.
    - `typeId` &mdash; Type to assign; it must be declared map-wide and not disabled by the zone covering the slot's layer.

**Properties**

`public StableId RuleId`

:   Identity of this rule. Rule IDs share one uniqueness domain with every other rule and custom constraint in the snapshot, and diagnostics quote this ID to name the rule at fault.

`public MapNodeSlot Slot`

:   Slot whose type is fixed. Two forced rules naming the same slot with different types are a rule error, as is a pinned node override that disagrees with the forced type.

`public StableId TypeId`

:   Type assigned to the slot. It must appear in the map-wide type table and must not be forbidden or zero-weighted by the zone covering `lot`.

**Methods**

`public int CompareTo(ForcedNodeTypeRule other)`

:   Orders forced rules by rule ID, then slot, then type, which is how a rule snapshot canonicalises its forced list.
    - **Returns** &mdash; A negative value, zero, or a positive value as this rule sorts before, alongside, or after `other`.

---

## IMapConstraint

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapConstraint
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

A game-specific rule the generator has to respect. Given the slots, edges, and type
assignments settled so far, it answers whether the map is still acceptable; register
implementations on `apRuleSnapshot` and BranchWeaver evaluates them inside the
search, so a rule that quotas and adjacency cannot express prunes bad maps while they are
being built instead of rejecting them once finished.

An implementation must be pure and deterministic: the same context must produce the same
result, with no random source, no clock, no Unity API, and no state carried between calls, or
one seed stops producing one map. It must not mutate the context or anything reachable from
it, because a single context instance is shared by every constraint in the pass. And it runs
deep inside a backtracking search -- once for every candidate type the search tries in every
slot, plus once when the assignment is complete -- so keep it cheap and allocation-free:
scanning `onstraintContext.Assignments` is fine, building collections per call is
not. Returning null counts as a violation, and a thrown exception is caught and turned into
one, so neither can crash generation but both fail the map.

---

## MapConnectionRules

```csharp
public sealed class MapConnectionRules
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapConnectionRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapConnectionRules()`

:   &mdash;

**Properties**

`public EdgeCrossingPolicy CrossingPolicy`

:   &mdash;

`public int MaximumIncomingPerNode`

:   &mdash;

`public int MaximumOutgoingPerNode`

:   &mdash;

`public int OptionalEdgeChance`

:   &mdash;

`public StableId RuleId`

:   &mdash;

`public static MapConnectionRules VersionTwoDefault`

:   &mdash;

---

## MapNodeSlot

```csharp
public readonly struct MapNodeSlot : IEquatable<MapNodeSlot>, IComparable<MapNodeSlot>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

Addresses one candidate node position in a layered map by layer and by ordinal within that
layer. Rules and overrides are authored against slots rather than node IDs, so a slot is
meaningful before generation has produced any node to name, and the same rule keeps its
meaning from one seed to the next.

**Constructors**

`public MapNodeSlot(int layer, int ordinal)`

:   Creates a slot address. Nothing is validated here; whether the slot falls inside the map is decided by the rule snapshot it is used with.
    - `layer` &mdash; Zero-based index into the layer list of that rule snapshot.
    - `ordinal` &mdash; Zero-based position inside the layer.

**Properties**

`public int Layer`

:   Zero-based index into the layer list of the rule snapshot this slot is read against.

`public int Ordinal`

:   Zero-based position of the node inside its layer. Layers are filled contiguously from zero, so naming ordinal n in a forced rule or a pinned override obliges that layer to hold at least n + 1 nodes, which can raise its effective count above the authored minimum.

**Methods**

`public int CompareTo(MapNodeSlot other)`

:   Orders slots by layer first and then by ordinal. This is the canonical order applied wherever slot collections are sorted for deterministic output.
    - **Returns** &mdash; A negative value, zero, or a positive value as this slot sorts before, alongside, or after `other`.

`public bool Equals(MapNodeSlot other)`

:   Reports whether both slots address the same layer and ordinal.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a slot addressing the same layer and ordinal.

`public override int GetHashCode()`

:   Returns a hash combining layer and ordinal, so slots are safe as dictionary keys; the generator keys its per-slot lookups this way.

`public override string ToString()`

:   Returns the compact `layer:ordinal` form that slot-related diagnostics carry as their context text.

---

## MapNodeTypeAssignment

```csharp
public readonly struct MapNodeTypeAssignment : IComparable<MapNodeTypeAssignment>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

One decided slot: where it sits, the identity the node there will carry, and the node type
chosen for it. Ordering is part of the contract -- `onstraintContext` sorts
assignments before a constraint sees them, so the same seed presents them in the same
sequence no matter what order the search settled them in.

**Constructors**

`public MapNodeTypeAssignment(MapNodeSlot slot, StableId nodeId, StableId typeId)`

:   Pairs one slot with the node identity and node type chosen for it.

**Properties**

`public StableId NodeId`

:   The identity the node in this slot will carry in the finished graph. It is settled before any type is chosen -- derived from the generation key for a generated node, or taken from the pinned override for an authored one -- so a constraint may key on it.

`public MapNodeSlot Slot`

:   &mdash;

`public StableId TypeId`

:   &mdash;

**Methods**

`public int CompareTo(MapNodeTypeAssignment other)`

:   Orders by `lot`, then `odeId`, then `ypeId`.

---

## MapSlotEdge

```csharp
public readonly struct MapSlotEdge : IEquatable<MapSlotEdge>, IComparable<MapSlotEdge>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

A directed connection between two slots, written in layer-and-ordinal coordinates rather than
node IDs -- the shape of a map before its nodes exist. Direction is part of identity: the
generator only ever produces edges that leave one layer for the next, and source-to-target
never equals target-to-source.

**Constructors**

`public MapSlotEdge(MapNodeSlot source, MapNodeSlot target)`

:   Connects one slot to another, leaving `source` and entering `target`.

**Properties**

`public MapNodeSlot Source`

:   &mdash;

`public MapNodeSlot Target`

:   &mdash;

**Methods**

`public int CompareTo(MapSlotEdge other)`

:   Orders by `ource`, then `arget`, which is how edge lists are kept in one deterministic order.

`public bool Equals(MapSlotEdge other)`

:   Two edges are equal only when both endpoints match in the same direction.

`public override bool Equals(object obj)`

:   Value equality against another `apSlotEdge`; any other object is unequal.

`public override int GetHashCode()`

:   Hash of both endpoints, consistent with `quals(MapSlotEdge)`.

`public override string ToString()`

:   Formats the edge as "layer:ordinal->layer:ordinal".

---

## MapValidator

```csharp
public sealed class MapValidator : IMapValidator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapValidator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public int Compare(MapEdge left, MapEdge right)`

:   &mdash;

`public bool Equals(EdgeConnection other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public ValidationReport Validate(MapGraph graph, MapRuleSnapshot rules)`

:   &mdash;

`public ValidationReport Validate()`

:   &mdash;

---

## MapZoneDefinition

```csharp
public sealed class MapZoneDefinition : IComparable<MapZoneDefinition>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapZoneDefinition.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapZoneDefinition()`

:   &mdash;

**Properties**

`public int FirstLayerInclusive`

:   &mdash;

`public IReadOnlyList<StableId> ForbiddenTypeIds`

:   &mdash;

`public StableId Id`

:   &mdash;

`public int LastLayerInclusive`

:   &mdash;

`public IReadOnlyList<StableId> PermittedTypeIds`

:   &mdash;

`public IReadOnlyList<NodeTypeWeightOverride> WeightOverrides`

:   &mdash;

**Methods**

`public int CompareTo(MapZoneDefinition other)`

:   &mdash;

`public bool ContainsLayer(int layer)`

:   &mdash;

---

## NodeTypeQuotaRule

```csharp
public readonly struct NodeTypeQuotaRule : IComparable<NodeTypeQuotaRule>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

A count bound on how many nodes of one type a scope may hold: the whole map when
`oneId` is empty, otherwise the layers of the named zone. The generator treats a
quota as a hard constraint rather than a preference, so it backtracks and finally fails with
a diagnostic instead of returning a map that breaks the bound.

**Constructors**

`public NodeTypeQuotaRule(StableId ruleId, StableId typeId, StableId zoneId, int minimum, int maximum)`

:   Creates a quota bounding the node count of one type inside one scope.
    - `ruleId` &mdash; Identity of the rule; must be non-empty and unique among all rules in the snapshot.
    - `zoneId` &mdash; Scope of the bound: empty for the whole map, otherwise a zone declared in the snapshot.
    - `minimum` &mdash; Inclusive lower bound on the node count.
    - `maximum` &mdash; Inclusive upper bound on the node count; there is no value meaning unbounded.

**Properties**

`public int Maximum`

:   Inclusive upper bound on how many nodes of `ypeId` the scope may hold. Every quota caps its type, since no value stands for unbounded: a maximum of zero bans the type from the scope outright.

`public int Minimum`

:   Inclusive lower bound on how many nodes of `ypeId` the scope must end up with. Zero means the quota only caps the type.

`public StableId RuleId`

:   Identity of this rule. Rule IDs share one uniqueness domain with every other rule and custom constraint in the snapshot, and diagnostics quote this ID to name the rule at fault.

`public StableId TypeId`

:   &mdash;

`public StableId ZoneId`

:   Scope of the bound. Empty counts the whole map; otherwise it must match the ID of a zone in the snapshot, and only nodes on that zone's layers are counted.

**Methods**

`public int CompareTo(NodeTypeQuotaRule other)`

:   Orders quotas by rule ID, then type, zone, minimum, and maximum, which is how a rule snapshot canonicalises its quota list.
    - **Returns** &mdash; A negative value, zero, or a positive value as this quota sorts before, alongside, or after `other`.

---

## NodeTypeWeight

```csharp
public readonly struct NodeTypeWeight : IComparable<NodeTypeWeight>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

One entry of the map-wide node type table: it declares that a type exists and how often the
generator should reach for it. The table is also the type domain, so a type with no entry
cannot be placed at all and cannot be referenced by a quota, forced, or adjacency rule.
Zones retune the value for their own layers through `odeTypeWeightOverride`.

**Constructors**

`public NodeTypeWeight(StableId typeId, int weight)`

:   Declares a node type and its map-wide selection weight.
    - `weight` &mdash; Relative selection weight; rule validation requires 1 to 1,000,000.

**Properties**

`public StableId TypeId`

:   &mdash;

`public int Weight`

:   Relative selection weight, which rule validation restricts to 1 through 1,000,000. Weights are proportional rather than ranked: a type of weight 3 is three times as likely to be tried first for a slot as a type of weight 1 on the same layer, unless the zone covering that layer overrides the weight.

**Methods**

`public int CompareTo(NodeTypeWeight other)`

:   Orders entries by type ID and then by weight, which is how a rule snapshot canonicalises its weight table.
    - **Returns** &mdash; A negative value, zero, or a positive value as this entry sorts before, alongside, or after `other`.

---

## NodeTypeWeightOverride

```csharp
public readonly struct NodeTypeWeightOverride : IComparable<NodeTypeWeightOverride>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapZoneDefinition.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public NodeTypeWeightOverride(StableId typeId, int weight)`

:   &mdash;

**Properties**

`public StableId TypeId`

:   &mdash;

`public int Weight`

:   &mdash;

**Methods**

`public int CompareTo(NodeTypeWeightOverride other)`

:   &mdash;

---

## ValidationReport

:material-star: **Start here**

```csharp
public sealed class ValidationReport
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Diagnostics.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public ValidationReport(IEnumerable<MapDiagnostic> diagnostics)`

:   &mdash;

**Properties**

`public IReadOnlyList<MapDiagnostic> Diagnostics`

:   &mdash;

`public int ErrorCount`

:   &mdash;

`public bool IsValid`

:   &mdash;

**Methods**

`public int Compare(MapDiagnostic left, MapDiagnostic right)`

:   &mdash;

---

