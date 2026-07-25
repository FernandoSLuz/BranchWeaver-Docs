# Authoring assets

17 types in this area.

!!! abstract "On this page"
    [CompiledMapNodeType](#compiledmapnodetype) &middot; [CompiledMapTheme](#compiledmaptheme) &middot; [MapAuthoringCompiler](#mapauthoringcompiler) &middot; [MapBlueprintAsset](#mapblueprintasset) &middot; [MapBlueprintCompilation](#mapblueprintcompilation) &middot; [MapConstraintAsset](#mapconstraintasset) &middot; [MapEdgeGeometryKind](#mapedgegeometrykind) &middot; [MapFlowDirection](#mapflowdirection) &middot; [MapLayoutOrientation](#maplayoutorientation) &middot; [MapNodeTypeAsset](#mapnodetypeasset) &middot; [MapNodeTypeCompilation](#mapnodetypecompilation) &middot; [MapPropertyAuthoring](#mappropertyauthoring) &middot; [MapRulesAsset](#maprulesasset) &middot; [MapRulesCompilation](#maprulescompilation) &middot; [MapThemeAsset](#mapthemeasset) &middot; [MapThemeCompilation](#mapthemecompilation) &middot; [MapThemeLimits](#mapthemelimits)

## CompiledMapNodeType

```csharp
public sealed class CompiledMapNodeType
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapNodeTypeAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public CompiledMapNodeType(StableId id, string displayLabel, MapNodePayload defaultPayload)`

:   &mdash;

`public CompiledMapNodeType()`

:   &mdash;

**Properties**

`public Color AvailableColor`

:   &mdash;

`public GameObject CanvasPrefab`

:   &mdash;

`public string CompleteAudioCueId`

:   &mdash;

`public Color CompletedColor`

:   &mdash;

`public Color CurrentColor`

:   &mdash;

`public MapNodePayload DefaultPayload`

:   &mdash;

`public string DisplayLabel`

:   &mdash;

`public string EnterAudioCueId`

:   &mdash;

`public Color HiddenColor`

:   &mdash;

`public Sprite Icon`

:   &mdash;

`public StableId Id`

:   &mdash;

`public string LocalizationKey`

:   &mdash;

`public Color LockedColor`

:   &mdash;

`public string RendererKey`

:   &mdash;

`public string Tooltip`

:   &mdash;

`public Color VisitedColor`

:   &mdash;

`public GameObject WorldPrefab`

:   &mdash;

---

## CompiledMapTheme

```csharp
public sealed class CompiledMapTheme
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/RuntimeCompilation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public CompiledMapTheme()`

:   &mdash;

**Properties**

`public Color BackgroundColor`

:   &mdash;

`public int BezierControlOffset`

:   &mdash;

`public int BezierSegments`

:   &mdash;

`public Color EdgeColor`

:   &mdash;

`public MapEdgeGeometryKind EdgeGeometry`

:   &mdash;

`public StableId Id`

:   &mdash;

`public int LayerSpacing`

:   &mdash;

`public float MaximumZoom`

:   &mdash;

`public float MinimumZoom`

:   &mdash;

`public int NodeSpacing`

:   &mdash;

`public MapLayoutOrientation Orientation`

:   &mdash;

`public float StateTransitionSeconds`

:   &mdash;

---

## MapAuthoringCompiler

:material-star: **Start here**

```csharp
public sealed class MapAuthoringCompiler
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapAuthoringCompiler.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public MapBlueprintCompilation CompileBlueprint(MapBlueprintAsset asset)`

:   &mdash;

`public MapNodeTypeCompilation CompileNodeType(MapNodeTypeAsset asset)`

:   &mdash;

`public MapRulesCompilation CompileRules(MapRulesAsset asset)`

:   &mdash;

`public MapThemeCompilation CompileTheme(MapThemeAsset asset)`

:   &mdash;

---

## MapBlueprintAsset

:material-star: **Start here**

```csharp
public sealed class MapBlueprintAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapBlueprintAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public long AuthoringRevision`

:   &mdash;

`public int BlueprintFormatVersion`

:   &mdash;

`public IReadOnlyList<BlueprintEdgeOverrideAuthoring> EdgeOverrides`

:   &mdash;

`public IReadOnlyList<BlueprintEdgeAuthoring> Edges`

:   &mdash;

`public string GenerationKey`

:   &mdash;

`public string GraphFingerprint`

:   &mdash;

`public int MaximumCountStates`

:   &mdash;

`public int MaximumTopologyTrials`

:   &mdash;

`public int MaximumTypeTrials`

:   &mdash;

`public MapGenerationMode Mode`

:   &mdash;

`public IReadOnlyList<BlueprintNodeAuthoring> Nodes`

:   &mdash;

`public string OverridesFingerprint`

:   &mdash;

`public MapRulesAsset Rules`

:   &mdash;

`public string RulesFingerprint`

:   &mdash;

`public uint Seed`

:   &mdash;

**Methods**

`public void ConfigureForNewAsset(MapRulesAsset rulesAsset, MapGenerationMode generationMode, uint generationSeed)`

:   &mdash;

---

## MapBlueprintCompilation

```csharp
public sealed class MapBlueprintCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapBlueprintCompilation()`

:   &mdash;

**Properties**

`public long AuthoringRevision`

:   &mdash;

`public MapGraph Graph`

:   &mdash;

`public IReadOnlyList<StableId> LockedNodeIds`

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

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

---

## MapConstraintAsset

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public abstract class MapConstraintAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapConstraintAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public abstract IMapConstraint CompileConstraint()`

:   &mdash;

---

## MapEdgeGeometryKind

```csharp
public enum MapEdgeGeometryKind
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapThemeAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapFlowDirection

```csharp
public enum MapFlowDirection
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapStyleTokens.cs</small>

Which screen direction the map's progress runs in.

The theme decides which axis layers advance along; this decides which
way along that axis, and is applied when normalized positions are converted
for display. It is presentation-only, so flipping a map cannot change the
generated graph, a save, or a fingerprint -- a saved run reopened after a
direction change is still the same run, drawn the other way round.

| Value | Meaning |
| --- | --- |
| `BottomToTop` | Progress runs upward. |
| `TopToBottom` | Progress runs downward, as in a descent. |
| `LeftToRight` | Progress runs rightward. |
| `RightToLeft` | Progress runs leftward, for right-to-left reading orders. |

---

## MapLayoutOrientation

```csharp
public enum MapLayoutOrientation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapThemeAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapNodeTypeAsset

:material-star: **Start here**

```csharp
public sealed class MapNodeTypeAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapNodeTypeAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public Color AvailableColor`

:   &mdash;

`public GameObject CanvasPrefab`

:   &mdash;

`public string CompleteAudioCueId`

:   &mdash;

`public Color CompletedColor`

:   &mdash;

`public Color CurrentColor`

:   &mdash;

`public string DefaultPayloadId`

:   &mdash;

`public IReadOnlyList<MapPropertyAuthoring> DefaultProperties`

:   &mdash;

`public string DisplayLabel`

:   &mdash;

`public string EnterAudioCueId`

:   &mdash;

`public Color HiddenColor`

:   &mdash;

`public Sprite Icon`

:   &mdash;

`public string LocalizationKey`

:   &mdash;

`public Color LockedColor`

:   &mdash;

`public string RendererKey`

:   &mdash;

`public string StableIdText`

:   &mdash;

`public string Tooltip`

:   &mdash;

`public Color VisitedColor`

:   &mdash;

`public GameObject WorldPrefab`

:   &mdash;

**Methods**

`public void Configure()`

:   &mdash;

---

## MapNodeTypeCompilation

```csharp
public sealed class MapNodeTypeCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNodeTypeCompilation(CompiledMapNodeType value, ValidationReport validation)`

:   &mdash;

**Properties**

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

`public CompiledMapNodeType Value`

:   &mdash;

---

## MapPropertyAuthoring

```csharp
public sealed class MapPropertyAuthoring
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapPropertyAuthoring.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapPropertyAuthoring()`

:   &mdash;

`public MapPropertyAuthoring()`

:   &mdash;

**Properties**

`public string Key`

:   &mdash;

`public MapPropertyKind Kind`

:   &mdash;

`public long NumericValue`

:   &mdash;

`public string StableIdValue`

:   &mdash;

`public string StringValue`

:   &mdash;

---

## MapRulesAsset

:material-star: **Start here**

```csharp
public sealed class MapRulesAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapRulesAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public string ConnectionRuleId`

:   &mdash;

`public EdgeCrossingPolicy CrossingPolicy`

:   &mdash;

`public IReadOnlyList<MapConstraintAsset> CustomConstraints`

:   &mdash;

`public MapNodeTypeAsset DefaultNodeType`

:   &mdash;

`public IReadOnlyList<ForbiddenAdjacencyAuthoring> ForbiddenAdjacencies`

:   &mdash;

`public IReadOnlyList<ForcedNodeAuthoring> ForcedNodes`

:   &mdash;

`public int GeneratorVersion`

:   &mdash;

`public IReadOnlyList<LayerRangeAuthoring> Layers`

:   &mdash;

`public int MaximumIncoming`

:   &mdash;

`public int MaximumOutgoing`

:   &mdash;

`public IReadOnlyList<NodeTypeWeightAuthoring> NodeTypeWeights`

:   &mdash;

`public int OptionalEdgeChance`

:   &mdash;

`public IReadOnlyList<QuotaAuthoring> Quotas`

:   &mdash;

`public int SchemaVersion`

:   &mdash;

`public IReadOnlyList<ZoneAuthoring> Zones`

:   &mdash;

**Methods**

`public void Configure()`

:   &mdash;

`public void ConfigureAdvanced()`

:   &mdash;

---

## MapRulesCompilation

```csharp
public sealed class MapRulesCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapRulesCompilation(MapRuleSnapshot value, IEnumerable<CompiledMapNodeType> nodeTypes, ValidationReport validation)`

:   &mdash;

**Properties**

`public IReadOnlyList<CompiledMapNodeType> NodeTypes`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

`public MapRuleSnapshot Value`

:   &mdash;

---

## MapThemeAsset

:material-star: **Start here**

```csharp
public sealed class MapThemeAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapThemeAsset.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public Color BackgroundColor`

:   &mdash;

`public int BezierControlOffset`

:   &mdash;

`public int BezierSegments`

:   &mdash;

`public Color EdgeColor`

:   &mdash;

`public MapEdgeGeometryKind EdgeGeometry`

:   &mdash;

`public int LayerSpacing`

:   &mdash;

`public float MaximumZoom`

:   &mdash;

`public float MinimumZoom`

:   &mdash;

`public int NodeSpacing`

:   &mdash;

`public MapLayoutOrientation Orientation`

:   &mdash;

`public string StableIdText`

:   &mdash;

`public float StateTransitionSeconds`

:   &mdash;

**Methods**

`public void ConfigureRuntime()`

:   &mdash;

---

## MapThemeCompilation

```csharp
public sealed class MapThemeCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/RuntimeCompilation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapThemeCompilation(CompiledMapTheme value, ValidationReport validation)`

:   &mdash;

**Properties**

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

`public CompiledMapTheme Value`

:   &mdash;

---

## MapThemeLimits

```csharp
public static class MapThemeLimits
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

