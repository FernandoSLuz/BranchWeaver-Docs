# Rules and constraints

18 types in this area.

!!! abstract "On this page"
    [ConstraintContext](#constraintcontext) &middot; [ConstraintEvaluationState](#constraintevaluationstate) &middot; [ConstraintResult](#constraintresult) &middot; [EdgeCrossingPolicy](#edgecrossingpolicy) &middot; [ForbiddenAdjacencyDirection](#forbiddenadjacencydirection) &middot; [ForbiddenAdjacencyRule](#forbiddenadjacencyrule) &middot; [ForcedNodeTypeRule](#forcednodetyperule) &middot; [IMapConstraint](#imapconstraint) &middot; [MapConnectionRules](#mapconnectionrules) &middot; [MapNodeSlot](#mapnodeslot) &middot; [MapNodeTypeAssignment](#mapnodetypeassignment) &middot; [MapSlotEdge](#mapslotedge) &middot; [MapValidator](#mapvalidator) &middot; [MapZoneDefinition](#mapzonedefinition) &middot; [NodeTypeQuotaRule](#nodetypequotarule) &middot; [NodeTypeWeight](#nodetypeweight) &middot; [NodeTypeWeightOverride](#nodetypeweightoverride) &middot; [ValidationReport](#validationreport)

## ConstraintContext

:material-star: **Start here**

```csharp
public sealed class ConstraintContext
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

Everything an `IMapConstraint` is allowed to see: the frozen rules, every slot
and slot edge in the attempt, and the type assignments decided so far. It carries no random
source, no Unity object, and no way back into the generator, which is what lets a constraint
reach the same verdict on every run of the same seed.

The generator builds a fresh context for each evaluation and hands that one instance to every
constraint in the pass, so treat it as read-only. During the search
`Assignments` normally covers only part of the map: check
`IsComplete` before concluding that a rule is broken rather than merely undecided.

**Constructors**

`public ConstraintContext( MapRuleSnapshot rules, IEnumerable<MapNodeSlot> slots, IEnumerable<MapSlotEdge> edges, IEnumerable<MapNodeTypeAssignment> assignments, bool isComplete)`

:   Captures one evaluation's view of an attempt. Slots, edges, and assignments are copied and sorted here, so later changes to the collections passed in cannot reach the constraint.
    - `rules` &mdash; The immutable rule snapshot in force; null throws `ArgumentNullException`.
    - `slots` &mdash; Every slot in the attempt, assigned or not. Null is read as empty.
    - `edges` &mdash; Slot connections to copy and sort; null is treated as an empty sequence.
    - `assignments` &mdash; Settled type choices to copy and sort; null is treated as an empty sequence.
    - `isComplete` &mdash; True only when every slot in `slots` has an assignment.

**Properties**

`public IReadOnlyList<MapNodeTypeAssignment> Assignments`

:   The slots whose type is already decided, sorted. Partial during the search: expect fewer entries than `Slots` until `IsComplete` is true.

`public IReadOnlyList<MapSlotEdge> Edges`

:   The connections between those slots, sorted. During generation these are the layer-to-layer edges that carry connectivity; optional extra edges are added only after a complete assignment has been accepted, so do not read this as the finished graph's edge list. Validating an existing graph passes that graph's own edges instead.

`public bool IsComplete`

:   True when every slot has an assignment -- the last check before a candidate map is accepted, and always true when an existing graph is validated. While it is false, `ConstraintEvaluationState.Undetermined` is a legitimate answer; once it is true, only `ConstraintEvaluationState.Satisfied` passes.

`public MapRuleSnapshot Rules`

:   The rules in force for this attempt, layers and quotas included. Never null.

`public IReadOnlyList<MapNodeSlot> Slots`

:   Every slot in the attempt, ordered by layer then ordinal -- not only the assigned ones. Its count is the size of the map being built, so comparing it against `Assignments` shows how much is still open.

---

## ConstraintEvaluationState

:material-star: **Start here**

```csharp
public enum ConstraintEvaluationState
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

What a custom constraint concluded about the assignment it was shown.
`ConstraintEvaluationState.Violated` makes the generator abandon the partial
assignment it is on and report the result's code and message, while
`ConstraintEvaluationState.Undetermined` is tolerated only while the assignment
is still partial: once every slot has a type -- and whenever an existing graph is validated
-- anything other than `ConstraintEvaluationState.Satisfied` fails the map.

| Value | Meaning |
| --- | --- |
| `Undetermined` | Not decidable from the assignments shown so far. |
| `Satisfied` | The rule holds. |
| `Violated` | The rule is broken. |

---

## ConstraintResult

:material-star: **Start here**

```csharp
public sealed class ConstraintResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

One constraint's answer for one evaluation: the state, plus the diagnostic code and message
that are reported when the state is `ConstraintEvaluationState.Violated`. Build
these with `Satisfied()`, `Undetermined()`, and
`Violated(string, string)`. A constraint that returns null is treated as having
reported a violation, so there is no "no answer" result to reach for.

**Constructors**

`public ConstraintResult(ConstraintEvaluationState state, string diagnosticCode, string message)`

:   Records a constraint verdict and normalizes null diagnostic text to empty strings; it does not validate enum values.
    - `diagnosticCode` &mdash; The stable machine-readable code to emit for a violation, or null for no code.
    - `message` &mdash; The author-facing explanation to emit for a violation, or null for no message.
    - `state` &mdash; The satisfied, undetermined, or violated verdict returned to the search.

**Properties**

`public string DiagnosticCode`

:   The code reported with a violation. Never null, and empty on satisfied and undetermined results; a violation that leaves it empty is reported as `MapDiagnosticCodes.GenerationConstraintsUnsatisfiable` instead.

`public string Message`

:   The reason for a violation. Never null, and empty unless one was supplied. It reaches the generation and validation diagnostics verbatim, so write it for whoever reads that log.

`public ConstraintEvaluationState State`

:   The verdict itself, and the only part of the result the generator branches on. `DiagnosticCode` and `Message` are read only when this is `ConstraintEvaluationState.Violated`, so filling them in on a satisfied or undetermined result has no effect.

**Methods**

`public static ConstraintResult Satisfied()`

:   A result stating that the rule holds, carrying no code or message.
    - **Returns** &mdash; A new satisfied result with empty diagnostic code and message.

`public static ConstraintResult Undetermined()`

:   A result stating that the rule cannot be judged yet. Only useful while `ConstraintContext.IsComplete` is false; on a finished assignment it is treated as a failure rather than as a pass.
    - **Returns** &mdash; A new undetermined result with empty diagnostic code and message.

`public static ConstraintResult Violated(string code, string message)`

:   A result stating that the rule is broken, which makes the generator backtrack and record an error against the constraint that returned it.
    - `code` &mdash; The stable diagnostic code for the broken rule; null is stored as an empty code.
    - `message` &mdash; The human-readable reason the assignment violates the rule; null is stored as an empty message.
    - **Returns** &mdash; A new violated result carrying the normalized code and message.

---

## EdgeCrossingPolicy

:material-star: **Start here**

```csharp
public enum EdgeCrossingPolicy
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapConnectionRules.cs</small>

Whether the generator may produce routes that cross one another between two layers.

Crossing here is structural, not visual: two edges leaving the same layer cross when one
starts at a lower ordinal than the other and ends at a higher one. `Forbid` therefore
confines generation to a monotone topology, which is what gives the untangled run-map look
under any layout strategy, and `Allow` lifts that restriction so routes may weave past
each other.

| Value | Meaning |
| --- | --- |
| `Forbid` | Rejects ordinal inversions between edges crossing the same pair of adjacent layers. |
| `Allow` | Permits edge endpoint order to invert between adjacent layers. |

---

## ForbiddenAdjacencyDirection

:material-star: **Start here**

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

:material-star: **Start here**

```csharp
public readonly struct ForbiddenAdjacencyRule : IComparable<ForbiddenAdjacencyRule>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

Bans edges between two node types. The generator applies it as a hard constraint on both
sides of the problem: it prunes types that would violate the ban while assigning them, and it
never adds an optional edge whose endpoint types match. A ban can therefore leave a chosen
topology with no valid type assignment at all, rather than merely thinning the connections.

**Constructors**

`public ForbiddenAdjacencyRule( StableId ruleId, StableId firstTypeId, StableId secondTypeId, ForbiddenAdjacencyDirection direction)`

:   Records an adjacency ban and canonicalizes an order-insensitive pair into ascending type-id order; identifiers and direction remain available for later snapshot validation.
    - `ruleId` &mdash; Identity of the rule; must be non-empty and unique among all rules in the snapshot.
    - `firstTypeId` &mdash; Source-side type when `direction` is `ForbiddenAdjacencyDirection.Forward`.
    - `secondTypeId` &mdash; Target-side type when `direction` is `ForbiddenAdjacencyDirection.Forward`.
    - `direction` &mdash; Whether the ban follows edge direction or covers both orderings.

**Properties**

`public ForbiddenAdjacencyDirection Direction`

:   Whether the ban follows edge direction or covers both orderings of the pair. It also governs how the two type IDs were stored: `ForbiddenAdjacencyDirection.Either` sorts them, so on such a rule the pair cannot be read back as source and target.

`public StableId FirstTypeId`

:   Source-side type of a `ForbiddenAdjacencyDirection.Forward` ban, or the lower-sorting member of the pair for an `ForbiddenAdjacencyDirection.Either` ban. Not necessarily the first type handed to the constructor.

`public StableId RuleId`

:   Identity of this rule. Rule IDs share one uniqueness domain with every other rule and custom constraint in the snapshot, and diagnostics quote this ID to name the rule at fault.

`public StableId SecondTypeId`

:   Target-side type of a `ForbiddenAdjacencyDirection.Forward` ban, or the higher-sorting member of the pair for an `ForbiddenAdjacencyDirection.Either` ban.

**Methods**

`public int CompareTo(ForbiddenAdjacencyRule other)`

:   Orders bans by rule ID, then first type, second type, and direction, which is how a rule snapshot canonicalises its adjacency list.
    - `other` &mdash; The adjacency ban to order against this value by rule id, type pair, then direction.
    - **Returns** &mdash; A negative value, zero, or a positive value as this rule sorts before, alongside, or after `other`.

`public bool Forbids(StableId sourceType, StableId targetType)`

:   Reports whether this rule bans an edge between two typed endpoints. A `ForbiddenAdjacencyDirection.Forward` ban matches only the stored ordering; an `ForbiddenAdjacencyDirection.Either` ban matches both.
    - `sourceType` &mdash; Type of the endpoint on the earlier layer, which the edge leaves.
    - `targetType` &mdash; Type of the endpoint on the next layer, which the edge enters.
    - **Returns** &mdash; `true` when the edge is forbidden and must not exist.

---

## ForcedNodeTypeRule

:material-star: **Start here**

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

:   Type assigned to the slot. It must appear in the map-wide type table and must not be forbidden or zero-weighted by the zone covering `Slot`.

**Methods**

`public int CompareTo(ForcedNodeTypeRule other)`

:   Orders forced rules by rule ID, then slot, then type, which is how a rule snapshot canonicalises its forced list.
    - `other` &mdash; The forced placement to order against this value by rule id, slot, then type id.
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
implementations on `MapRuleSnapshot` and BranchWeaver evaluates them inside the
search, so a rule that quotas and adjacency cannot express prunes bad maps while they are
being built instead of rejecting them once finished.

An implementation must be pure and deterministic: the same context must produce the same
result, with no random source, no clock, no Unity API, and no state carried between calls, or
one seed stops producing one map. It must not mutate the context or anything reachable from
it, because a single context instance is shared by every constraint in the pass. And it runs
deep inside a backtracking search -- once for every candidate type the search tries in every
slot, plus once when the assignment is complete -- so keep it cheap and allocation-free:
scanning `ConstraintContext.Assignments` is fine, building collections per call is
not. Returning null counts as a violation, and a thrown exception is caught and turned into
one, so neither can crash generation but both fail the map.

**Properties**

`public StableId Id`

:   Stable identity for this rule. It names the rule in diagnostics, is hashed into the rules fingerprint, and decides evaluation order -- constraints run sorted by ID, not in the order they were registered. It must be non-empty, unique among the rules of one snapshot, and constant: `MapRuleSnapshot` reads it once, when it is built.

`public string RevisionFingerprint`

:   A 64-character lowercase SHA-256 hex string standing for this rule's logic. It is hashed into the rules fingerprint, so change it whenever the rule's decisions change -- otherwise a map generated under the old logic still fingerprints as current. Anything that is not lowercase SHA-256 hex is reported as a rules error, and like `Id` it is read once, when the snapshot is built.

**Methods**

`public ConstraintResult Evaluate(ConstraintContext context)`

:   Judges one assignment. Report `ConstraintEvaluationState.Violated` only when the context already breaks the rule; while `ConstraintContext.IsComplete` is false, a rule that cannot be settled yet must answer `ConstraintEvaluationState.Undetermined` instead, or the search abandons partial maps that would have completed legally.
    - `context` &mdash; The read-only snapshot of slots, edges, assignments, and rules for this evaluation pass.
    - **Returns** &mdash; The verdict, carrying the code and message to report on a violation. Never return null -- that is recorded as a violation of this rule.

---

## MapConnectionRules

:material-star: **Start here**

```csharp
public sealed class MapConnectionRules
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapConnectionRules.cs</small>

The topology half of a rule set: how many routes a node may send and receive, how many
optional routes are added beyond the mandatory backbone, and whether routes may cross.
Where the rest of a rule set decides what each node is, this decides how the nodes are
wired together.

Every value here, the identity included, is hashed into the rules fingerprint that feeds
the generation key and the generator's random streams. Changing any of them re-rolls every
map, so an existing seed no longer reproduces the layout a player saw.

**Constructors**

`public MapConnectionRules( StableId ruleId, int maximumOutgoingPerNode, int maximumIncomingPerNode, int optionalEdgeChance, EdgeCrossingPolicy crossingPolicy)`

:   Records topology limits without range checks; rule validation later enforces degree, chance, identity, and enum bounds.
    - `ruleId` &mdash; Identity reported in diagnostics and hashed into the fingerprint.
    - `maximumOutgoingPerNode` &mdash; Branch cap; validation requires 1 to 256.
    - `maximumIncomingPerNode` &mdash; Merge cap; validation requires 1 to 256.
    - `optionalEdgeChance` &mdash; Optional-route chance out of 10,000; validation requires 0 to 10,000.
    - `crossingPolicy` &mdash; Whether crossing routes are forbidden or allowed.

**Properties**

`public EdgeCrossingPolicy CrossingPolicy`

:   Whether generated routes may cross. Forbidding them narrows the generator to a monotone enumeration per layer and also turns on the crossing check in map validation, so a graph that was hand-built or loaded from an older save is reported rather than quietly drawn tangled.

`public int MaximumIncomingPerNode`

:   Merge cap: the most routes one node may receive from the layer behind it, on the same terms as `MaximumOutgoingPerNode`. Raising one without the other biases a map towards fanning out or funnelling in.

`public int MaximumOutgoingPerNode`

:   Branch cap: the most routes one node may send to the layer in front of it. Validation requires 1 to 256, and separately rejects a cap that cannot fan out far enough to reach the next layer at any of its permitted node counts.

`public int OptionalEdgeChance`

:   The chance out of 10,000 -- not out of 100 -- that any route not already part of the mandatory backbone is added as well. Zero yields the sparsest map that still connects. The draw is only the first gate. An optional route is still dropped when it would breach a degree cap, cross while crossings are forbidden, join a forbidden type pair, or hit an override marked forbidden, so 10,000 means "as dense as the other rules permit" rather than "every node joined to every node".

`public StableId RuleId`

:   Identity these rules are reported under when generation or validation blames them for a diagnostic. It is hashed into the rules fingerprint as well, so renaming it changes the maps every seed produces even though nothing about the topology limits moved.

`public static MapConnectionRules VersionTwoDefault`

:   The permissive starting point a rule set takes when it states no connection rules of its own: both degree caps opened to the per-layer node ceiling, no optional routes, and crossings forbidden. Shaping a map means tightening these rather than loosening them. A fresh instance is built on every read, and this type carries no value equality, so two reads give two objects that are not reference-equal.

---

## MapNodeSlot

:material-star: **Start here**

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

:   Records a layer and within-layer ordinal without range checks; rule validation rejects negative or out-of-map slots.
    - `layer` &mdash; Zero-based index into the layer list of that rule snapshot.
    - `ordinal` &mdash; Zero-based position inside the layer.

**Properties**

`public int Layer`

:   Zero-based index into the layer list of the rule snapshot this slot is read against.

`public int Ordinal`

:   Zero-based position of the node inside its layer. Layers are filled contiguously from zero, so naming ordinal n in a forced rule or a pinned override obliges that layer to hold at least n + 1 nodes, which can raise its effective count above the authored minimum.

**Fields**

`public static bool operator`

:   Reports whether two slots address the same layer and ordinal.
    - `left` &mdash; The first slot coordinates in the equality comparison.
    - `right` &mdash; The second slot coordinates in the equality comparison.
    - **Returns** &mdash; The converted immutable value; the source operand remains unchanged.

**Methods**

`public int CompareTo(MapNodeSlot other)`

:   Orders slots by layer first and then by ordinal. This is the canonical order applied wherever slot collections are sorted for deterministic output.
    - `other` &mdash; The slot to order against this one by layer and then ordinal.
    - **Returns** &mdash; A negative value, zero, or a positive value as this slot sorts before, alongside, or after `other`.

`public bool Equals(MapNodeSlot other)`

:   Reports whether both slots address the same layer and ordinal.
    - `other` &mdash; The slot whose layer and ordinal are compared with this value.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a slot addressing the same layer and ordinal.
    - `obj` &mdash; The object to test; only a `MapNodeSlot` with equal coordinates can match.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash combining layer and ordinal, so slots are safe as dictionary keys; the generator keys its per-slot lookups this way.
    - **Returns** &mdash; A deterministic combined hash of the zero-based layer and ordinal fields.

`public override string ToString()`

:   Returns the compact `layer:ordinal` form that slot-related diagnostics carry as their context text.
    - **Returns** &mdash; The compact decimal coordinate `layer:ordinal`.

---

## MapNodeTypeAssignment

:material-star: **Start here**

```csharp
public readonly struct MapNodeTypeAssignment : IComparable<MapNodeTypeAssignment>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/ConstraintContracts.cs</small>

One decided slot: where it sits, the identity of the node there, and the node type chosen for
it. Ordering is part of the contract -- `ConstraintContext` sorts
assignments before a constraint sees them, so the same seed presents them in the same
sequence no matter what order the search settled them in.

**Constructors**

`public MapNodeTypeAssignment(MapNodeSlot slot, StableId nodeId, StableId typeId)`

:   Pairs one slot with the node identity and node type chosen for it.
    - `slot` &mdash; The layer-and-ordinal location whose type decision is being recorded.
    - `nodeId` &mdash; The generated or existing node identity occupying the slot; stored without validation.
    - `typeId` &mdash; The node-type identity chosen for the slot; stored without validating rule membership.

**Properties**

`public StableId NodeId`

:   The identity of the node occupying this slot: the ID of the existing node when a finished graph is validated, and during generation the ID the node will be built with, which is settled before any type is chosen. Either way a constraint may key on it.

`public MapNodeSlot Slot`

:   Where in the layered grid this decision sits, as a layer and an ordinal within it. It is the first key assignments are sorted on, so scanning `ConstraintContext.Assignments` walks the map in layer order.

`public StableId TypeId`

:   The node type the search settled on for this slot. It names an entry in the snapshot's weight table, so a constraint that cares about a particular type compares IDs and never has to resolve the type to its content.

**Methods**

`public int CompareTo(MapNodeTypeAssignment other)`

:   Orders by `Slot`, then `NodeId`, then `TypeId`.
    - `other` &mdash; The assignment to order against this one by slot, node id, then type id.
    - **Returns** &mdash; A negative value, zero, or a positive value according to the canonical assignment order.

---

## MapSlotEdge

:material-star: **Start here**

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
    - `source` &mdash; The layer-and-ordinal slot the directed connection leaves.
    - `target` &mdash; The layer-and-ordinal slot the directed connection enters.

**Properties**

`public MapNodeSlot Source`

:   The slot the edge leaves. Edge lists sort on it before `Target`, so they arrive grouped by source slot.

`public MapNodeSlot Target`

:   The slot the edge arrives at -- one layer further on in anything the generator produced. Nothing on this struct enforces that; it is a property of how edges are built, not of the value.

**Methods**

`public int CompareTo(MapSlotEdge other)`

:   Orders by `Source`, then `Target`, which is how edge lists are kept in one deterministic order.
    - `other` &mdash; The directed slot edge to order against this value.
    - **Returns** &mdash; A negative value, zero, or a positive value after comparing source then target.

`public bool Equals(MapSlotEdge other)`

:   Two edges are equal only when both endpoints match in the same direction.
    - `other` &mdash; The slot edge whose directed endpoints are compared with this value.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Value equality against another `MapSlotEdge`; any other object is unequal.
    - `obj` &mdash; The object to test; only a `MapSlotEdge` with equal endpoints can match.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Hash of both endpoints, consistent with `Equals(MapSlotEdge)`.
    - **Returns** &mdash; A deterministic combined hash of the source and target slots.

`public override string ToString()`

:   Formats the edge as "layer:ordinal->layer:ordinal".
    - **Returns** &mdash; The directed endpoint text `source->target` using each slot's canonical form.

---

## MapValidator

:material-star: **Start here**

```csharp
public sealed class MapValidator : IMapValidator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapValidator.cs</small>

The shipped `IMapValidator`: it judges a finished graph against the rule snapshot
it claims to have come from. It checks the graph's own metadata and fingerprints, node identity
and placement, edge shape and crossings, and reachability, and for generator version two also
forced types, quotas, forbidden adjacencies, custom constraints, and authoring overrides.

Nothing is repaired and nothing is thrown -- every problem becomes an error diagnostic -- so a
single call lists everything wrong with a graph instead of stopping at the first fault. A
custom constraint that throws is caught and reported as a violation, so one bad constraint
cannot take a generation run down. The validator keeps no state between calls and sorts the
graph into canonical order before inspecting it, so the same graph and rules always produce the
same report in the same order.

**Methods**

`public ValidationReport Validate(MapGraph graph, MapRuleSnapshot rules)`

:   Judges a graph against the rules, taking the generation mode from the graph itself and comparing it against no authoring overrides. A version-two graph must still carry well-formed override metadata, but it is checked only for shape and self-consistency, not against any particular set of pins -- none were supplied. Use the overload taking a mode and overrides when the caller knows which ones the graph was generated under.
    - `graph` &mdash; The immutable candidate to inspect; null produces a graph-missing diagnostic instead of throwing.
    - `rules` &mdash; The expected rule snapshot; null and invalid snapshots contribute rule diagnostics and prevent deeper graph checks.
    - **Returns** &mdash; Every diagnostic found. Any error-severity diagnostic rejects the graph.

`public ValidationReport Validate( MapGraph graph, MapRuleSnapshot rules, MapGenerationMode mode, MapGenerationOverrides overrides)`

:   Judges a graph against the rules, the generation mode, and the authoring overrides the caller believes it was produced under. This is the strict form, and the one an authoring pipeline wants: a version-two graph must also declare the same mode, carry an overrides fingerprint and generation key that match `overrides`, and preserve every pinned node field and every edge override. A procedural request additionally requires the overrides to be empty, and a manual one requires seed zero and forbids the graph from holding any node or edge the overrides did not spell out.
    - `graph` &mdash; The immutable candidate to inspect; null produces a graph-missing diagnostic instead of throwing.
    - `rules` &mdash; The expected rule snapshot; null and invalid snapshots contribute rule diagnostics and prevent deeper graph checks.
    - `mode` &mdash; The procedural, manual, or hybrid contract the graph metadata and contents must satisfy.
    - `overrides` &mdash; The exact authored pins and edge dispositions to verify; null is treated as an empty set.
    - **Returns** &mdash; Every diagnostic found. Any error-severity diagnostic rejects the graph.

---

## MapZoneDefinition

:material-star: **Start here**

```csharp
public sealed class MapZoneDefinition : IComparable<MapZoneDefinition>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapZoneDefinition.cs</small>

A contiguous inclusive band of layers that carries its own node type rules: an allowed set, a
forbidden set, and per-type weight overrides. Zones are how a map varies its character with
depth without needing a separate rule snapshot per region. Rule validation keeps zone ranges
disjoint, so at most one zone governs any layer, and layers no zone covers use the map-wide
node type table unchanged.

**Constructors**

`public MapZoneDefinition( StableId id, int firstLayerInclusive, int lastLayerInclusive, IEnumerable<StableId> permittedTypeIds, IEnumerable<StableId> forbiddenTypeIds, IEnumerable<NodeTypeWeightOverride> weightOverrides)`

:   Records a layer band and defensively copies each type-rule sequence into canonical order; identity, range, duplicates, and effective domain are checked by rule validation later.
    - `id` &mdash; Identity of the zone, which quota rules use to scope themselves to it.
    - `firstLayerInclusive` &mdash; Zero-based index of the first layer in the zone, counted into the layer list of the rule snapshot the zone belongs to.
    - `lastLayerInclusive` &mdash; Zero-based index of the last layer in the zone, itself included.
    - `permittedTypeIds` &mdash; Types allowed in the zone. An empty or null sequence is not an empty allowance but the absence of one: every map-wide declared type stays permitted.
    - `forbiddenTypeIds` &mdash; Types barred from the zone, applied after the allowed set.
    - `weightOverrides` &mdash; Per-type weight replacements; an entry of weight 0 bars its type as well.

**Properties**

`public int FirstLayerInclusive`

:   Zero-based index of the first layer of the zone within the rule snapshot's layer list. Validation requires 0 <= first <= last < layer count.

`public IReadOnlyList<StableId> ForbiddenTypeIds`

:   Types barred from this zone, sorted. Applied after `PermittedTypeIds`, so listing a type in both bars it.

`public StableId Id`

:   Identity of this zone. A `NodeTypeQuotaRule` names it to bound a type inside this band of layers rather than across the whole map, and diagnostics quote it to say which zone is at fault, so it has to be non-empty and unique among the snapshot's zones.

`public int LastLayerInclusive`

:   Zero-based index of the last layer of the zone, itself part of the zone.

`public IReadOnlyList<StableId> PermittedTypeIds`

:   Types allowed in this zone, sorted. An empty list means the zone imposes no allowance and every map-wide declared type remains available, so this is not a way to empty a zone.

`public IReadOnlyList<NodeTypeWeightOverride> WeightOverrides`

:   Zone-local weight replacements, sorted, at most one per type. A type with no entry keeps its map-wide weight; an entry of weight 0 bars the type from the zone entirely.

**Methods**

`public int CompareTo(MapZoneDefinition other)`

:   Orders zones by ID first, then by layer range, then by their allowed, forbidden, and override contents. Comparing the whole contents rather than the ID alone is what lets a rule snapshot sort its zones into an order that depends only on what they say, which is a precondition for a stable rule fingerprint. A null zone sorts before any zone.
    - `other` &mdash; The zone to order by identity, layer bounds, and all canonicalized type rules; null sorts first.
    - **Returns** &mdash; A negative value, zero, or a positive value as this zone sorts before, alongside, or after `other`.

`public bool ContainsLayer(int layer)`

:   Reports whether the given layer index falls inside this zone, both bounds included.
    - `layer` &mdash; Zero-based map layer index constrained by the compiled rule snapshot.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

---

## NodeTypeQuotaRule

:material-star: **Start here**

```csharp
public readonly struct NodeTypeQuotaRule : IComparable<NodeTypeQuotaRule>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

A count bound on how many nodes of one type a scope may hold: the whole map when
`ZoneId` is empty, otherwise the layers of the named zone. The generator treats a
quota as a hard constraint rather than a preference, so it backtracks and finally fails with
a diagnostic instead of returning a map that breaks the bound.

**Constructors**

`public NodeTypeQuotaRule(StableId ruleId, StableId typeId, StableId zoneId, int minimum, int maximum)`

:   Records one scoped count interval without validation; snapshot validation checks identities, zone membership, and bounds.
    - `ruleId` &mdash; Identity of the rule; must be non-empty and unique among all rules in the snapshot.
    - `zoneId` &mdash; Scope of the bound: empty for the whole map, otherwise a zone declared in the snapshot.
    - `minimum` &mdash; Inclusive lower bound on the node count.
    - `maximum` &mdash; Inclusive upper bound on the node count; there is no value meaning unbounded.
    - `typeId` &mdash; The declared node type to count within the selected map or zone scope.

**Properties**

`public int Maximum`

:   Inclusive upper bound on how many nodes of `TypeId` the scope may hold. Every quota caps its type, since no value stands for unbounded: a maximum of zero bans the type from the scope outright.

`public int Minimum`

:   Inclusive lower bound on how many nodes of `TypeId` the scope must end up with. Zero means the quota only caps the type.

`public StableId RuleId`

:   Identity of this rule. Rule IDs share one uniqueness domain with every other rule and custom constraint in the snapshot, and diagnostics quote this ID to name the rule at fault.

`public StableId TypeId`

:   The node type being counted. It must be declared in the map-wide type table, since a quota bounds a type rather than introducing one, and each quota bounds exactly one type: several rules are needed to bound several types.

`public StableId ZoneId`

:   Scope of the bound. Empty counts the whole map; otherwise it must match the ID of a zone in the snapshot, and only nodes on that zone's layers are counted.

**Methods**

`public int CompareTo(NodeTypeQuotaRule other)`

:   Orders quotas by rule ID, then type, zone, minimum, and maximum, which is how a rule snapshot canonicalises its quota list.
    - `other` &mdash; The quota to order against this value by rule id, type, zone, and bounds.
    - **Returns** &mdash; A negative value, zero, or a positive value as this quota sorts before, alongside, or after `other`.

---

## NodeTypeWeight

:material-star: **Start here**

```csharp
public readonly struct NodeTypeWeight : IComparable<NodeTypeWeight>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/NodeTypeRules.cs</small>

One entry of the map-wide node type table: it declares that a type exists and how often the
generator should reach for it. The table is also the type domain, so a type with no entry
cannot be placed at all and cannot be referenced by a quota, forced, or adjacency rule.
Zones retune the value for their own layers through `NodeTypeWeightOverride`.

**Constructors**

`public NodeTypeWeight(StableId typeId, int weight)`

:   Declares a node type and its map-wide selection weight.
    - `weight` &mdash; Relative selection weight; rule validation requires 1 to 1,000,000.
    - `typeId` &mdash; The node-type identity whose relative weight is declared; validation later requires it to be non-empty and unique.

**Properties**

`public StableId TypeId`

:   The node type this entry declares. Because the weight table is also the type domain, an ID appearing here is what makes that type placeable at all and referenceable by a quota, forced, or adjacency rule.

`public int Weight`

:   Relative selection weight, which rule validation restricts to 1 through 1,000,000. Weights are proportional rather than ranked: a type of weight 3 is three times as likely to be tried first for a slot as a type of weight 1 on the same layer, unless the zone covering that layer overrides the weight.

**Methods**

`public int CompareTo(NodeTypeWeight other)`

:   Orders entries by type ID and then by weight, which is how a rule snapshot canonicalises its weight table.
    - `other` &mdash; The weight entry to order against this value by type identity and then weight.
    - **Returns** &mdash; A negative value, zero, or a positive value as this entry sorts before, alongside, or after `other`.

---

## NodeTypeWeightOverride

:material-star: **Start here**

```csharp
public readonly struct NodeTypeWeightOverride : IComparable<NodeTypeWeightOverride>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Constraints/MapZoneDefinition.cs</small>

Replaces the map-wide selection weight of one node type for the layers of a single zone.
A weight of zero is not merely unlikely but excluding: the type becomes unplaceable in that
zone exactly as a forbidden-type entry would make it, and rule validation rejects a zone left
with no effective type at all.

**Constructors**

`public NodeTypeWeightOverride(StableId typeId, int weight)`

:   Declares the zone-local weight to apply to one node type.
    - `typeId` &mdash; Type to retune. It must also appear in the map-wide node type table, because that table is the type domain; an override cannot introduce a type of its own.
    - `weight` &mdash; Zone-local replacement weight, which rule validation restricts to 0 through 1,000,000. Note that this admits 0, where a map-wide weight may not go below 1.

**Properties**

`public StableId TypeId`

:   The node type being retuned. It must already appear in the map-wide type table, which is the type domain: an override adjusts how often an existing type is reached for and cannot bring a new one into the zone.

`public int Weight`

:   Weight used for this type inside the zone in place of its map-wide weight, restricted by rule validation to 0 through 1,000,000. Zero excludes the type from the zone.

**Methods**

`public int CompareTo(NodeTypeWeightOverride other)`

:   Orders overrides by type ID and then by weight. This is the canonical order the owning zone sorts its overrides into, so that two zones authored in different orders produce the same rule fingerprint.
    - `other` &mdash; The zone-local weight entry to order by type identity and replacement weight.
    - **Returns** &mdash; A negative value, zero, or a positive value as this override sorts before, alongside, or after `other`.

---

## ValidationReport

:material-star: **Start here**

```csharp
public sealed class ValidationReport
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Diagnostics.cs</small>

Everything one validation pass had to say, plus the single number that decides whether the
pass succeeded. Compilation, generation preflight, generation, and save loading all report
through this type, so one habit - check `IsValid`, then show
`Diagnostics` - covers the whole package.

The diagnostics are copied and sorted on construction: errors before warnings, then by code,
context, related IDs, and message, all ordinal. The order therefore depends only on what was
found and not on the order it was found in, which is what lets two runs over equivalent input
be compared line by line. Warnings never make a report invalid.

**Constructors**

`public ValidationReport(IEnumerable<MapDiagnostic> diagnostics)`

:   Copies and canonically sorts diagnostics, then counts error-severity entries to determine validity.
    - `diagnostics` &mdash; Diagnostics to enumerate once; null means an empty valid report, while individual entries must be non-null.

**Properties**

`public IReadOnlyList<MapDiagnostic> Diagnostics`

:   Every diagnostic from the pass, errors first, then warnings. Never null; empty when the pass found nothing to say.

`public int ErrorCount`

:   How many of the diagnostics are errors. Warnings are not counted, so this is zero for a report that still carries advice.

`public bool IsValid`

:   Whether the validated subject may be used: true when there are no errors, whatever warnings were raised.

---

