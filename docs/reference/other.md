# Other

21 types in this area.

!!! abstract "On this page"
    [BranchWeaverSampleKind](#branchweaversamplekind) &middot; [DeterministicRandomState](#deterministicrandomstate) &middot; [IMapGenerator](#imapgenerator) &middot; [IMapValidator](#imapvalidator) &middot; [LayerNodeRange](#layernoderange) &middot; [MapDiagnosticCodes](#mapdiagnosticcodes) &middot; [MapDiagnosticSeverity](#mapdiagnosticseverity) &middot; [MapFingerprint](#mapfingerprint) &middot; [MapGenerationManifest](#mapgenerationmanifest) &middot; [MapNodePayload](#mapnodepayload) &middot; [MapProperty](#mapproperty) &middot; [MapPropertyKind](#mappropertykind) &middot; [MapPropertyValue](#mappropertyvalue) &middot; [MapRuleSnapshot](#maprulesnapshot) &middot; [SampleMapBuildResult](#samplemapbuildresult) &middot; [SampleMapCatalog](#samplemapcatalog) &middot; [SampleSceneBootstrap](#samplescenebootstrap) &middot; [SampleTraveler](#sampletraveler) &middot; [SampleViewFit](#sampleviewfit) &middot; [SpriteSheetAnimator](#spritesheetanimator) &middot; [XorShift32Random](#xorshift32random)

## BranchWeaverSampleKind

```csharp
public enum BranchWeaverSampleKind
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SampleMapCatalog.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `QuickStart` | &mdash; |
| `WayfarerCampaign` | &mdash; |

---

## DeterministicRandomState

```csharp
public readonly struct DeterministicRandomState : IEquatable<DeterministicRandomState>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/DeterministicRandom.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public DeterministicRandomState(int algorithmVersion, uint state)`

:   &mdash;

**Properties**

`public int AlgorithmVersion`

:   &mdash;

`public uint State`

:   &mdash;

**Methods**

`public bool Equals(DeterministicRandomState other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## IMapGenerator

```csharp
public interface IMapGenerator
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/GenerationContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapValidator

```csharp
public interface IMapValidator
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/GenerationContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## LayerNodeRange

```csharp
public readonly struct LayerNodeRange : IEquatable<LayerNodeRange>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/MapRules.cs</small>

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

## MapDiagnosticCodes

```csharp
public static class MapDiagnosticCodes
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Diagnostics.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapDiagnosticSeverity

```csharp
public enum MapDiagnosticSeverity
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Diagnostics.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Fingerprinting.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/GenerationContracts.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Properties/MapNodePayload.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Properties/MapNodePayload.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Properties/MapPropertyValue.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Properties/MapPropertyValue.cs</small>

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

```csharp
public sealed class MapRuleSnapshot
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/MapRules.cs</small>

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

## SampleMapBuildResult

```csharp
public sealed class SampleMapBuildResult
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SampleMapCatalog.cs</small>

Immutable result of compiling and generating a shipped sample. Samples call the same
public authoring compiler and generator customers call; no sample-only graph path exists.

**Properties**

`public MapRuntimeContent Content`

:   &mdash;

`public MapGraph Graph`

:   &mdash;

`public MapGenerationManifest Manifest`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

---

## SampleMapCatalog

```csharp
public static class SampleMapCatalog
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SampleMapCatalog.cs</small>

Compiles the editable sample assets into deterministic runtime snapshots.

**Methods**

`public static SampleMapBuildResult Build()`

:   &mdash;

`public static MapRuntimeContent CompileRuntimeContent()`

:   &mdash;

`public static StableId SaveSlotFor(BranchWeaverSampleKind kind)`

:   &mdash;

---

## SampleSceneBootstrap

```csharp
public sealed class SampleSceneBootstrap : MonoBehaviour
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SampleSceneBootstrap.cs</small>

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

## SampleTraveler

```csharp
public sealed class SampleTraveler : MonoBehaviour
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SampleTraveler.cs</small>

The animated hero that stands on the current node of the active sample presentation.
One component owns two bodies — a uGUI image under the canvas content and a sprite
renderer under the world content — and keeps exactly the active one visible. The idle
loop always plays; entering a node glides the body over while appearing, regenerating,
or switching presentations snaps without a distracting cross-map flight.

**Properties**

`public RectTransform CanvasBody`

:   &mdash;

`public int CharacterIndex`

:   &mdash;

`public static IReadOnlyList<string> CharacterNames`

:   Display names in hero-cycle order; "Archer" displays the Hunter source sheet.

`public string CurrentCharacterName`

:   &mdash;

`public bool IsVisible`

:   &mdash;

`public Transform WorldBody`

:   &mdash;

**Methods**

`public void Configure(MapTraversalController controller, IReadOnlyList<Sprite[]> characterFrameSets)`

:   Hands over the traversal state and the per-character idle frames (index order matches `haracterNames`). Sheets all run at the animator's default 24 fps, which is what their frame JSON declares; an empty list still leaves names and positioning fully functional for headless hosts.

`public void SetCharacterIndex(int index)`

:   Selects the hero skin; any integer wraps into the display-name cycle.

`public void SetPresentationTargets(CanvasMapPresenter canvasPresenter, WorldMapPresenter worldPresenter)`

:   Builds the two presentation bodies under the given presenters' content roots.

`public void SetWorldPresentationActive(bool worldActive)`

:   &mdash;

---

## SampleViewFit

```csharp
public static class SampleViewFit
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SampleViewFit.cs</small>

Pure math helpers that fit a presented map inside a canvas viewport. The helpers only see
value types so they can be reused by any sample host and asserted directly in tests.

**Methods**

`public static Vector2 ComputeContentScale(Vector2 contentSize, Rect viewportLocalRect, float margin)`

:   Uniform scale that fits `contentSize` inside `viewportLocalRect` minus `margin` on every side. The scale never exceeds one, so small maps keep their authored size, and degenerate inputs fall back to no scaling.

`public static Vector2 ComputeCoverSize(Vector2 frameSize, float contentAspect)`

:   Size of the smallest rect that keeps `contentAspect` (width / height) while covering `frameSize` entirely: the overflow is cropped off-screen instead of letterboxed, so a scenic backdrop fills the frame without distortion. Degenerate inputs fall back to the frame itself.

`public static bool IsInsideViewport(Vector2 anchoredPos, Vector2 nodeSize, Rect viewportLocalRect)`

:   True when the rect centered at `anchoredPos` with extents `nodeSize` lies fully inside `viewportLocalRect` (both expressed in the same local space). A small tolerance absorbs float jitter.

---

## SpriteSheetAnimator

```csharp
public sealed class SpriteSheetAnimator : MonoBehaviour
```

`BranchWeaver.Samples` &middot; <small>Samples/Shared/SpriteSheetAnimator.cs</small>

Plays a sprite-sheet idle loop on either a uGUI `mage` or a
`priteRenderer` living on the same GameObject. Sheets stay imported as a
single sprite; frames are sliced at runtime from the texture plus the accompanying
frame JSON (uniform grid, top-down rows, feet pivot) and cached per sheet texture.
Stepping uses unscaled time so menus and pause states keep the idle alive.

**Properties**

`public int CurrentFrameIndex`

:   &mdash;

`public Sprite CurrentSprite`

:   &mdash;

`public float Fps`

:   &mdash;

`public int FrameCount`

:   &mdash;

`public bool IsPlaying`

:   &mdash;

`public bool Loop`

:   &mdash;

**Fields**

`public float Fps`

:   &mdash;

`public Sprite[] Frames`

:   &mdash;

`public int atlas`

:   &mdash;

`public SpriteSheetFrameJson[] frames`

:   &mdash;

`public int h`

:   &mdash;

`public int index`

:   &mdash;

`public SpriteSheetPivotJson pivot`

:   &mdash;

`public int w`

:   &mdash;

`public float x`

:   &mdash;

`public int x`

:   &mdash;

`public float y`

:   &mdash;

`public int y`

:   &mdash;

**Methods**

`public void Advance(float deltaSeconds)`

:   Steps the animation clock manually; also called from Update with unscaled dt.

`public static Sprite[] LoadFrames(Texture2D sheet, TextAsset framesJson, out float framesPerSecond)`

:   Slices `sheet` into one sprite per JSON frame rect. The JSON uses top-down row coordinates and a normalized pivot ((0.5, 0) = feet); both are converted into Unity's bottom-up texture space. Sprites are created with a full-rect mesh so non-readable import settings keep working, and the result is cached per sheet texture.

`public void Play()`

:   &mdash;

`public void SetSheet(Sprite[] frames, float framesPerSecond)`

:   Assigns the frame set and restarts the loop from frame zero.

---

## XorShift32Random

```csharp
public sealed class XorShift32Random
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/DeterministicRandom.cs</small>

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

