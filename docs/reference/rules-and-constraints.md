# Rules and constraints

19 types in this area.

!!! abstract "On this page"
    [ConstraintContext](#constraintcontext) &middot; [ConstraintEvaluationState](#constraintevaluationstate) &middot; [ConstraintResult](#constraintresult) &middot; [EdgeCrossingPolicy](#edgecrossingpolicy) &middot; [ForbiddenAdjacencyDirection](#forbiddenadjacencydirection) &middot; [ForbiddenAdjacencyRule](#forbiddenadjacencyrule) &middot; [ForcedNodeTypeRule](#forcednodetyperule) &middot; [IMapConstraint](#imapconstraint) &middot; [MapConnectionRules](#mapconnectionrules) &middot; [MapNodeSlot](#mapnodeslot) &middot; [MapNodeTypeAssignment](#mapnodetypeassignment) &middot; [MapRulesValidator](#maprulesvalidator) &middot; [MapSlotEdge](#mapslotedge) &middot; [MapValidator](#mapvalidator) &middot; [MapZoneDefinition](#mapzonedefinition) &middot; [NodeTypeQuotaRule](#nodetypequotarule) &middot; [NodeTypeWeight](#nodetypeweight) &middot; [NodeTypeWeightOverride](#nodetypeweightoverride) &middot; [ValidationReport](#validationreport)

## ConstraintContext

```csharp
public sealed class ConstraintContext
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/ConstraintContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public ConstraintContext()`

:   &mdash;

**Properties**

`public IReadOnlyList<MapNodeTypeAssignment> Assignments`

:   &mdash;

`public IReadOnlyList<MapSlotEdge> Edges`

:   &mdash;

`public bool IsComplete`

:   &mdash;

`public MapRuleSnapshot Rules`

:   &mdash;

`public IReadOnlyList<MapNodeSlot> Slots`

:   &mdash;

---

## ConstraintEvaluationState

```csharp
public enum ConstraintEvaluationState
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/ConstraintContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Undetermined` | &mdash; |
| `Satisfied` | &mdash; |
| `Violated` | &mdash; |

---

## ConstraintResult

```csharp
public sealed class ConstraintResult
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/ConstraintContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public ConstraintResult(ConstraintEvaluationState state, string diagnosticCode, string message)`

:   &mdash;

**Properties**

`public string DiagnosticCode`

:   &mdash;

`public string Message`

:   &mdash;

`public ConstraintEvaluationState State`

:   &mdash;

**Methods**

`public static ConstraintResult Satisfied()`

:   &mdash;

`public static ConstraintResult Undetermined()`

:   &mdash;

`public static ConstraintResult Violated(string code, string message)`

:   &mdash;

---

## EdgeCrossingPolicy

```csharp
public enum EdgeCrossingPolicy
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/MapConnectionRules.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/NodeTypeRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Forward` | &mdash; |
| `Either` | &mdash; |

---

## ForbiddenAdjacencyRule

```csharp
public readonly struct ForbiddenAdjacencyRule : IComparable<ForbiddenAdjacencyRule>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/NodeTypeRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public ForbiddenAdjacencyRule()`

:   &mdash;

**Properties**

`public ForbiddenAdjacencyDirection Direction`

:   &mdash;

`public StableId FirstTypeId`

:   &mdash;

`public StableId RuleId`

:   &mdash;

`public StableId SecondTypeId`

:   &mdash;

**Methods**

`public int CompareTo(ForbiddenAdjacencyRule other)`

:   &mdash;

`public bool Forbids(StableId sourceType, StableId targetType)`

:   &mdash;

---

## ForcedNodeTypeRule

```csharp
public readonly struct ForcedNodeTypeRule : IComparable<ForcedNodeTypeRule>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/NodeTypeRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public ForcedNodeTypeRule(StableId ruleId, MapNodeSlot slot, StableId typeId)`

:   &mdash;

**Properties**

`public StableId RuleId`

:   &mdash;

`public MapNodeSlot Slot`

:   &mdash;

`public StableId TypeId`

:   &mdash;

**Methods**

`public int CompareTo(ForcedNodeTypeRule other)`

:   &mdash;

---

## IMapConstraint

```csharp
public interface IMapConstraint
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/ConstraintContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapConnectionRules

```csharp
public sealed class MapConnectionRules
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/MapConnectionRules.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/NodeTypeRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodeSlot(int layer, int ordinal)`

:   &mdash;

**Properties**

`public int Layer`

:   &mdash;

`public int Ordinal`

:   &mdash;

**Methods**

`public int CompareTo(MapNodeSlot other)`

:   &mdash;

`public bool Equals(MapNodeSlot other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public override string ToString()`

:   &mdash;

---

## MapNodeTypeAssignment

```csharp
public readonly struct MapNodeTypeAssignment : IComparable<MapNodeTypeAssignment>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/ConstraintContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodeTypeAssignment(MapNodeSlot slot, StableId nodeId, StableId typeId)`

:   &mdash;

**Properties**

`public StableId NodeId`

:   &mdash;

`public MapNodeSlot Slot`

:   &mdash;

`public StableId TypeId`

:   &mdash;

**Methods**

`public int CompareTo(MapNodeTypeAssignment other)`

:   &mdash;

---

## MapRulesValidator

```csharp
public static class MapRulesValidator
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/MapRulesValidator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public int Compare(MapZoneDefinition left, MapZoneDefinition right)`

:   &mdash;

`public static ValidationReport Validate(MapRuleSnapshot rules)`

:   &mdash;

---

## MapSlotEdge

```csharp
public readonly struct MapSlotEdge : IEquatable<MapSlotEdge>, IComparable<MapSlotEdge>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/ConstraintContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapSlotEdge(MapNodeSlot source, MapNodeSlot target)`

:   &mdash;

**Properties**

`public MapNodeSlot Source`

:   &mdash;

`public MapNodeSlot Target`

:   &mdash;

**Methods**

`public int CompareTo(MapSlotEdge other)`

:   &mdash;

`public bool Equals(MapSlotEdge other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public override string ToString()`

:   &mdash;

---

## MapValidator

```csharp
public sealed class MapValidator : IMapValidator
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/MapValidator.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/MapZoneDefinition.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/NodeTypeRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public NodeTypeQuotaRule(StableId ruleId, StableId typeId, StableId zoneId, int minimum, int maximum)`

:   &mdash;

**Properties**

`public int Maximum`

:   &mdash;

`public int Minimum`

:   &mdash;

`public StableId RuleId`

:   &mdash;

`public StableId TypeId`

:   &mdash;

`public StableId ZoneId`

:   &mdash;

**Methods**

`public int CompareTo(NodeTypeQuotaRule other)`

:   &mdash;

---

## NodeTypeWeight

```csharp
public readonly struct NodeTypeWeight : IComparable<NodeTypeWeight>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/NodeTypeRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public NodeTypeWeight(StableId typeId, int weight)`

:   &mdash;

**Properties**

`public StableId TypeId`

:   &mdash;

`public int Weight`

:   &mdash;

**Methods**

`public int CompareTo(NodeTypeWeight other)`

:   &mdash;

---

## NodeTypeWeightOverride

```csharp
public readonly struct NodeTypeWeightOverride : IComparable<NodeTypeWeightOverride>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Constraints/MapZoneDefinition.cs</small>

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

```csharp
public sealed class ValidationReport
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Diagnostics.cs</small>

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

