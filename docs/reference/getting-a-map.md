# Getting a map

12 types in this area.

!!! abstract "On this page"
    [EdgeGenerationOverride](#edgegenerationoverride) &middot; [EdgeOverrideDisposition](#edgeoverridedisposition) &middot; [LayeredMapGenerator](#layeredmapgenerator) &middot; [MapGenerationFailureKind](#mapgenerationfailurekind) &middot; [MapGenerationMode](#mapgenerationmode) &middot; [MapGenerationOverrides](#mapgenerationoverrides) &middot; [MapGenerationRequest](#mapgenerationrequest) &middot; [MapGenerationResult](#mapgenerationresult) &middot; [MapGenerationSearchOptions](#mapgenerationsearchoptions) &middot; [MapGenerationStatistics](#mapgenerationstatistics) &middot; [PinnedNodeFields](#pinnednodefields) &middot; [PinnedNodeOverride](#pinnednodeoverride)

## EdgeGenerationOverride

```csharp
public readonly struct EdgeGenerationOverride : IComparable<EdgeGenerationOverride>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationOverrides.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public EdgeGenerationOverride()`

:   &mdash;

**Properties**

`public EdgeOverrideDisposition Disposition`

:   &mdash;

`public StableId OverrideId`

:   &mdash;

`public StableId PinnedEdgeId`

:   &mdash;

`public MapSlotEdge SlotEdge`

:   &mdash;

`public MapNodeSlot SourceSlot`

:   &mdash;

`public MapNodeSlot TargetSlot`

:   &mdash;

**Methods**

`public int CompareTo(EdgeGenerationOverride other)`

:   &mdash;

---

## EdgeOverrideDisposition

```csharp
public enum EdgeOverrideDisposition
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationOverrides.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Required` | &mdash; |
| `Forbidden` | &mdash; |

---

## LayeredMapGenerator

```csharp
public sealed class LayeredMapGenerator : IMapGenerator
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/LayeredMapGenerator.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

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

```csharp
public enum MapGenerationMode
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationOverrides.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Procedural` | &mdash; |
| `Manual` | &mdash; |
| `Hybrid` | &mdash; |

---

## MapGenerationOverrides

```csharp
public sealed class MapGenerationOverrides
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationOverrides.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapGenerationOverrides()`

:   &mdash;

**Properties**

`public IReadOnlyList<EdgeGenerationOverride> Edges`

:   &mdash;

`public bool IsEmpty`

:   &mdash;

`public IReadOnlyList<PinnedNodeOverride> Nodes`

:   &mdash;

**Methods**

`public string ComputeFingerprint()`

:   &mdash;

---

## MapGenerationRequest

```csharp
public sealed class MapGenerationRequest
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/GenerationContracts.cs</small>

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

```csharp
public sealed class MapGenerationResult
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/GenerationContracts.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationSearchOptions.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationOverrides.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `Type` | &mdash; |
| `Position` | &mdash; |
| `Payload` | &mdash; |
| `All` | &mdash; |

---

## PinnedNodeOverride

```csharp
public readonly struct PinnedNodeOverride : IComparable<PinnedNodeOverride>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Generation/MapGenerationOverrides.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public PinnedNodeOverride()`

:   &mdash;

**Properties**

`public PinnedNodeFields Fields`

:   &mdash;

`public StableId NodeId`

:   &mdash;

`public MapNodePayload Payload`

:   &mdash;

`public NormalizedMapPosition Position`

:   &mdash;

`public MapNodeSlot Slot`

:   &mdash;

`public StableId TypeId`

:   &mdash;

**Methods**

`public int CompareTo(PinnedNodeOverride other)`

:   &mdash;

---

