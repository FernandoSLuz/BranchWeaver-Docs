# Other

13 types in this area.

!!! abstract "On this page"
    [IMapGenerator](#imapgenerator) &middot; [IMapValidator](#imapvalidator) &middot; [LayerNodeRange](#layernoderange) &middot; [MapDiagnosticSeverity](#mapdiagnosticseverity) &middot; [MapFingerprint](#mapfingerprint) &middot; [MapGenerationManifest](#mapgenerationmanifest) &middot; [MapNodePayload](#mapnodepayload) &middot; [MapProperty](#mapproperty) &middot; [MapPropertyKind](#mappropertykind) &middot; [MapPropertyValue](#mappropertyvalue) &middot; [MapRuleSnapshot](#maprulesnapshot) &middot; [SampleSceneBootstrap](#samplescenebootstrap) &middot; [XorShift32Random](#xorshift32random)

## IMapGenerator

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapGenerator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapValidator

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapValidator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## LayerNodeRange

```csharp
public readonly struct LayerNodeRange : IEquatable<LayerNodeRange>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapRules.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public LayerNodeRange(int minimum, int maximum)`

:   &mdash;

**Properties**

`public int Maximum`

:   &mdash;

`public int Minimum`

:   &mdash;

**Methods**

`public bool Equals(LayerNodeRange other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapDiagnosticSeverity

```csharp
public enum MapDiagnosticSeverity
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Diagnostics.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Warning` | &mdash; |
| `Error` | &mdash; |

---

## MapFingerprint

```csharp
public static class MapFingerprint
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Fingerprinting.cs</small>

Versioned, domain-separated, big-endian canonical SHA-256 fingerprints.

**Methods**

`public static string ComputeGenerationKey()`

:   &mdash;

`public static string ComputeGraph(MapGraph graph)`

:   &mdash;

`public static string ComputeOverrides(MapGenerationOverrides overrides)`

:   &mdash;

`public static string ComputeRules(MapRuleSnapshot rules)`

:   &mdash;

`public static bool IsSha256Hex(string value)`

:   &mdash;

---

## MapGenerationManifest

```csharp
public sealed class MapGenerationManifest
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapGenerationManifest()`

:   &mdash;

`public MapGenerationManifest()`

:   &mdash;

**Properties**

`public string GenerationKey`

:   &mdash;

`public MapGenerationMode GenerationMode`

:   &mdash;

`public int GeneratorVersion`

:   &mdash;

`public string GraphFingerprint`

:   &mdash;

`public string OverridesFingerprint`

:   &mdash;

`public int RandomAlgorithmVersion`

:   &mdash;

`public string RulesFingerprint`

:   &mdash;

`public uint Seed`

:   &mdash;

---

## MapNodePayload

```csharp
public sealed class MapNodePayload : IEquatable<MapNodePayload>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapNodePayload.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodePayload(StableId payloadId, IEnumerable<MapProperty> properties)`

:   &mdash;

**Properties**

`public StableId PayloadId`

:   &mdash;

`public IReadOnlyList<MapProperty> Properties`

:   &mdash;

**Methods**

`public bool Equals(MapNodePayload other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapProperty

```csharp
public readonly struct MapProperty : IEquatable<MapProperty>, IComparable<MapProperty>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapNodePayload.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapProperty(StableId key, MapPropertyValue value)`

:   &mdash;

**Properties**

`public StableId Key`

:   &mdash;

`public MapPropertyValue Value`

:   &mdash;

**Methods**

`public int CompareTo(MapProperty other)`

:   &mdash;

`public bool Equals(MapProperty other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapPropertyKind

```csharp
public enum MapPropertyKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapPropertyValue.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Boolean` | &mdash; |
| `Integer` | &mdash; |
| `FixedPoint` | &mdash; |
| `String` | &mdash; |
| `StableId` | &mdash; |

---

## MapPropertyValue

```csharp
public readonly struct MapPropertyValue : IEquatable<MapPropertyValue>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapPropertyValue.cs</small>

A Unity-independent tagged value used by map payloads.

**Constructors**

`public MapPropertyValue()`

:   &mdash;

**Properties**

`public bool IsCanonical`

:   &mdash;

`public MapPropertyKind Kind`

:   &mdash;

`public long NumericValue`

:   &mdash;

`public StableId StableIdValue`

:   &mdash;

`public string StringValue`

:   &mdash;

**Methods**

`public static MapPropertyValue Boolean(bool value)`

:   &mdash;

`public bool Equals(MapPropertyValue other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public static MapPropertyValue FixedPoint(long scaledValue)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public static MapPropertyValue Id(StableId value)`

:   &mdash;

`public static MapPropertyValue Integer(long value)`

:   &mdash;

`public static MapPropertyValue String(string value)`

:   &mdash;

---

## MapRuleSnapshot

:material-star: **Start here**

```csharp
public sealed class MapRuleSnapshot
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapRules.cs</small>

Immutable, engine-independent rules compiled from future authoring assets.

**Constructors**

`public MapRuleSnapshot()`

:   &mdash;

`public MapRuleSnapshot()`

:   &mdash;

**Properties**

`public MapConnectionRules ConnectionRules`

:   &mdash;

`public IReadOnlyList<IMapConstraint> CustomConstraints`

:   &mdash;

`public StableId DefaultNodeTypeId`

:   &mdash;

`public IReadOnlyList<ForbiddenAdjacencyRule> ForbiddenAdjacencies`

:   &mdash;

`public IReadOnlyList<ForcedNodeTypeRule> ForcedNodeTypes`

:   &mdash;

`public int GeneratorVersion`

:   &mdash;

`public StableId Id`

:   &mdash;

`public IReadOnlyList<LayerNodeRange> Layers`

:   &mdash;

`public IReadOnlyList<NodeTypeWeight> NodeTypeWeights`

:   &mdash;

`public IReadOnlyList<NodeTypeQuotaRule> Quotas`

:   &mdash;

`public string RevisionFingerprint`

:   &mdash;

`public int SchemaVersion`

:   &mdash;

`public IReadOnlyList<MapZoneDefinition> Zones`

:   &mdash;

**Methods**

`public int Compare(IMapConstraint left, IMapConstraint right)`

:   &mdash;

`public string ComputeFingerprint()`

:   &mdash;

`public ConstraintResult Evaluate(ConstraintContext context)`

:   &mdash;

`public MapZoneDefinition FindZoneForLayer(int layer)`

:   &mdash;

---

## SampleSceneBootstrap

```csharp
public sealed class SampleSceneBootstrap : MonoBehaviour
```

`BranchWeaver.Samples` &middot; <small>BranchWeaver/Samples/Shared/SampleSceneBootstrap.cs</small>

Self-contained sample host. It builds only neutral Unity primitives at runtime and keeps
gameplay ownership outside BranchWeaver: the Complete button stands in for customer content.

**Properties**

`public uint ActiveSeed`

:   &mdash;

`public CanvasMapPresenter CanvasPresenter`

:   &mdash;

`public MapTraversalController Controller`

:   &mdash;

`public bool IsStarted`

:   &mdash;

`public bool IsWorldView`

:   &mdash;

`public string LastMessage`

:   &mdash;

`public BranchWeaverSampleKind SampleKind`

:   &mdash;

`public SampleTraveler Traveler`

:   &mdash;

`public WorldMapPresenter WorldPresenter`

:   &mdash;

**Methods**

`public bool CompleteCurrent()`

:   &mdash;

`public void Configure()`

:   &mdash;

`public bool DeleteSaveAndResetProgress()`

:   &mdash;

`public bool EnterFirstAvailable()`

:   &mdash;

`public bool LoadNow()`

:   &mdash;

`public bool RegenerateNextSeed()`

:   &mdash;

`public bool SaveNow()`

:   &mdash;

`public bool StartSample()`

:   &mdash;

`public void StopSample()`

:   &mdash;

`public bool ToggleOrientation()`

:   &mdash;

`public bool TogglePresentation()`

:   &mdash;

---

## XorShift32Random

```csharp
public sealed class XorShift32Random
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/DeterministicRandom.cs</small>

Version 1 of BranchWeaver's deterministic random stream.
The xorshift32 transition and zero-seed normalization are public compatibility contracts.

**Constructors**

`public XorShift32Random(uint seed)`

:   &mdash;

`public XorShift32Random(DeterministicRandomState state)`

:   &mdash;

**Properties**

`public uint State`

:   &mdash;

**Methods**

`public DeterministicRandomState CaptureState()`

:   &mdash;

`public bool NextBool()`

:   &mdash;

`public int NextInt(int exclusiveMaximum)`

:   &mdash;

`public int NextInt(int inclusiveMinimum, int inclusiveMaximum)`

:   Returns a value in the inclusive range. A fixed range returns immediately without consuming random state, which keeps optional fixed rules from shifting later choices.

`public uint NextUInt()`

:   &mdash;

---

