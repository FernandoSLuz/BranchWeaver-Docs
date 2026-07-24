# Editor tools

31 types in this area.

!!! abstract "On this page"
    [MapBlueprintPersistence](#mapblueprintpersistence) &middot; [MapBlueprintPersistenceResult](#mapblueprintpersistenceresult) &middot; [MapBlueprintSourceToken](#mapblueprintsourcetoken) &middot; [MapRuntimeRendererSelection](#mapruntimerendererselection) &middot; [MapSetupConfigurationCodes](#mapsetupconfigurationcodes) &middot; [MapSetupConfigurationResult](#mapsetupconfigurationresult) &middot; [MapSetupConfigurator](#mapsetupconfigurator) &middot; [MapSetupDiagnosticCodes](#mapsetupdiagnosticcodes) &middot; [MapSetupValidationRequest](#mapsetupvalidationrequest) &middot; [MapSetupValidator](#mapsetupvalidator) &middot; [MapSetupWizard](#mapsetupwizard) &middot; [MapStarterAssetFactory](#mapstarterassetfactory) &middot; [MapStarterAssetResult](#mapstarterassetresult) &middot; [MapStudioAuditCoordinator](#mapstudioauditcoordinator) &middot; [MapStudioAuditOperation](#mapstudioauditoperation) &middot; [MapStudioAuditResult](#mapstudioauditresult) &middot; [MapStudioAuditRow](#mapstudioauditrow) &middot; [MapStudioAuditStatistics](#mapstudioauditstatistics) &middot; [MapStudioCommandResult](#mapstudiocommandresult) &middot; [MapStudioDiagnosticCodes](#mapstudiodiagnosticcodes) &middot; [MapStudioFocus](#mapstudiofocus) &middot; [MapStudioGraphStatistics](#mapstudiographstatistics) &middot; [MapStudioGraphView](#mapstudiographview) &middot; [MapStudioJson](#mapstudiojson) &middot; [MapStudioNodeVisuals](#mapstudionodevisuals) &middot; [MapStudioSeedAudit](#mapstudioseedaudit) &middot; [MapStudioSeedHistoryEntry](#mapstudioseedhistoryentry) &middot; [MapStudioSession](#mapstudiosession) &middot; [MapStudioSnapshot](#mapstudiosnapshot) &middot; [MapStudioWindow](#mapstudiowindow) &middot; [SampleSceneMenuItems](#samplescenemenuitems)

## MapBlueprintPersistence

```csharp
public static class MapBlueprintPersistence
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapBlueprintPersistence.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static MapBlueprintPersistenceResult Apply(MapBlueprintAsset target, MapRulesAsset rulesAsset,)`

:   &mdash;

`public static MapBlueprintSourceToken CaptureToken(MapBlueprintAsset asset)`

:   &mdash;

`public static MapBlueprintPersistenceResult SaveAs(string assetPath, MapRulesAsset rulesAsset, MapStudioSnapshot snapshot)`

:   &mdash;

---

## MapBlueprintPersistenceResult

```csharp
public sealed class MapBlueprintPersistenceResult
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapBlueprintPersistence.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapBlueprintPersistenceResult(bool succeeded, MapBlueprintAsset asset, MapBlueprintSourceToken token, MapDiagnostic diagnostic)`

:   &mdash;

**Properties**

`public MapBlueprintAsset Asset`

:   &mdash;

`public MapDiagnostic Diagnostic`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public MapBlueprintSourceToken Token`

:   &mdash;

---

## MapBlueprintSourceToken

```csharp
public sealed class MapBlueprintSourceToken : IEquatable<MapBlueprintSourceToken>
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapBlueprintPersistence.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapBlueprintSourceToken(string assetGuid, long revision, string serializedDigest)`

:   &mdash;

**Properties**

`public string AssetGuid`

:   &mdash;

`public long Revision`

:   &mdash;

`public string SerializedDigest`

:   &mdash;

`public string Value`

:   &mdash;

**Methods**

`public bool Equals(MapBlueprintSourceToken other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapRuntimeRendererSelection

```csharp
public enum MapRuntimeRendererSelection
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupValidator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Auto` | &mdash; |
| `Canvas` | &mdash; |
| `World2D` | &mdash; |

---

## MapSetupConfigurationCodes

```csharp
public static class MapSetupConfigurationCodes
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupConfigurator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapSetupConfigurationResult

```csharp
public sealed class MapSetupConfigurationResult
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupConfigurator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapSetupConfigurationResult(string code, string message, MapPresenterBase presenter)`

:   &mdash;

**Properties**

`public string Code`

:   &mdash;

`public string Message`

:   &mdash;

`public MapPresenterBase Presenter`

:   &mdash;

`public bool Succeeded`

:   &mdash;

---

## MapSetupConfigurator

```csharp
public static class MapSetupConfigurator
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupConfigurator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static MapPresenterBase Configure(GameObject root, bool canvas, bool useInputSystem = false)`

:   &mdash;

`public static MapSetupConfigurationResult ConfigureWithResult(GameObject root, bool canvas,)`

:   &mdash;

---

## MapSetupDiagnosticCodes

```csharp
public static class MapSetupDiagnosticCodes
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupValidator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapSetupValidationRequest

```csharp
public sealed class MapSetupValidationRequest
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupValidator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Fields**

`public MapBlueprintAsset Blueprint`

:   &mdash;

`public MapGraph Graph`

:   &mdash;

`public IReadOnlyList<MapNodeTypeAsset> NodeTypes`

:   &mdash;

`public MapRuntimeRendererSelection RendererSelection`

:   &mdash;

`public bool RequireInputSystemSignals`

:   &mdash;

`public GameObject Root`

:   &mdash;

`public MapThemeAsset Theme`

:   &mdash;

---

## MapSetupValidator

```csharp
public static class MapSetupValidator
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupValidator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static ValidationReport Validate(MapSetupValidationRequest request)`

:   &mdash;

---

## MapSetupWizard

```csharp
public sealed class MapSetupWizard : EditorWindow
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/MapSetupWizard.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public void Draw()`

:   &mdash;

`public static void Open()`

:   &mdash;

`public void Set(BranchWeaver.Core.ValidationReport value)`

:   &mdash;

---

## MapStarterAssetFactory

```csharp
public static class MapStarterAssetFactory
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/SampleSceneMenuItems.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static MapStarterAssetResult Create(string folder)`

:   &mdash;

---

## MapStarterAssetResult

```csharp
public sealed class MapStarterAssetResult
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/SampleSceneMenuItems.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStarterAssetResult(MapRulesAsset rules, MapThemeAsset theme, IReadOnlyList<string> createdPaths, string error)`

:   &mdash;

**Properties**

`public IReadOnlyList<string> CreatedPaths`

:   &mdash;

`public string Error`

:   &mdash;

`public MapRulesAsset Rules`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public MapThemeAsset Theme`

:   &mdash;

---

## MapStudioAuditCoordinator

```csharp
public sealed class MapStudioAuditCoordinator : IDisposable
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioAuditCoordinator.cs</small>

Owns one window audit operation. Invalidating an operation cancels its worker and
advances the publication generation, so an already-completing stale task cannot
publish results into a different preview or source selection.

**Properties**

`public bool HasActiveOperation`

:   &mdash;

**Methods**

`public MapStudioAuditOperation Begin()`

:   &mdash;

`public void CancelActive()`

:   &mdash;

`public bool Complete(long operationId)`

:   &mdash;

`public void Dispose()`

:   &mdash;

`public void Invalidate()`

:   &mdash;

---

## MapStudioAuditOperation

```csharp
public sealed class MapStudioAuditOperation
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioAuditCoordinator.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioAuditOperation(long id, CancellationToken cancellationToken)`

:   &mdash;

**Properties**

`public CancellationToken CancellationToken`

:   &mdash;

`public long Id`

:   &mdash;

---

## MapStudioAuditResult

```csharp
public sealed class MapStudioAuditResult
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioSeedAudit.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioAuditResult(IEnumerable<MapStudioAuditRow> rows, bool cancelled,)`

:   &mdash;

**Properties**

`public bool Cancelled`

:   &mdash;

`public MapDiagnostic Diagnostic`

:   &mdash;

`public string Fingerprint`

:   &mdash;

`public IReadOnlyList<MapStudioAuditRow> Rows`

:   &mdash;

`public MapStudioAuditStatistics Statistics`

:   &mdash;

---

## MapStudioAuditRow

```csharp
public sealed class MapStudioAuditRow
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioSeedAudit.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioAuditRow(uint seed, bool succeeded, MapGenerationFailureKind failure,)`

:   &mdash;

**Properties**

`public MapGenerationFailureKind FailureKind`

:   &mdash;

`public MapGenerationStatistics GenerationStatistics`

:   &mdash;

`public string GraphFingerprint`

:   &mdash;

`public MapStudioGraphStatistics GraphStatistics`

:   &mdash;

`public uint Seed`

:   &mdash;

`public bool Succeeded`

:   &mdash;

---

## MapStudioAuditStatistics

```csharp
public sealed class MapStudioAuditStatistics
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioSeedAudit.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioAuditStatistics(int attempts, int successes, int failures, int minimumNodes,)`

:   &mdash;

**Properties**

`public int Attempts`

:   &mdash;

`public int Failures`

:   &mdash;

`public int MaximumBranch`

:   &mdash;

`public int MaximumEdges`

:   &mdash;

`public int MaximumMerge`

:   &mdash;

`public int MaximumNodes`

:   &mdash;

`public long MeanEdgesScaled`

:   &mdash;

`public long MeanNodesScaled`

:   &mdash;

`public int MinimumEdges`

:   &mdash;

`public int MinimumNodes`

:   &mdash;

`public long ReachableNodes`

:   &mdash;

`public int Successes`

:   &mdash;

`public long TotalEdges`

:   &mdash;

`public long TotalNodes`

:   &mdash;

---

## MapStudioCommandResult

```csharp
public sealed class MapStudioCommandResult
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioModels.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioCommandResult(bool succeeded, MapStudioSnapshot snapshot, MapDiagnostic diagnostic)`

:   &mdash;

**Properties**

`public MapDiagnostic Diagnostic`

:   &mdash;

`public MapStudioSnapshot Snapshot`

:   &mdash;

`public bool Succeeded`

:   &mdash;

---

## MapStudioDiagnosticCodes

```csharp
public static class MapStudioDiagnosticCodes
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioModels.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapStudioFocus

```csharp
public sealed class MapStudioFocus
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioModels.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioFocus(IEnumerable<StableId> rules, IEnumerable<StableId> nodes, IEnumerable<MapNodeSlot> slots)`

:   &mdash;

**Properties**

`public static MapStudioFocus Empty`

:   &mdash;

`public IReadOnlyList<StableId> NodeIds`

:   &mdash;

`public IReadOnlyList<StableId> RuleIds`

:   &mdash;

`public IReadOnlyList<MapNodeSlot> Slots`

:   &mdash;

---

## MapStudioGraphStatistics

```csharp
public sealed class MapStudioGraphStatistics
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioModels.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioGraphStatistics(int nodeCount, int edgeCount, int maximumBranch, int maximumMerge, int reachableCount)`

:   &mdash;

**Properties**

`public int EdgeCount`

:   &mdash;

`public int MaximumBranch`

:   &mdash;

`public int MaximumMerge`

:   &mdash;

`public int NodeCount`

:   &mdash;

`public int ReachableCount`

:   &mdash;

**Methods**

`public static MapStudioGraphStatistics FromGraph(MapGraph graph)`

:   &mdash;

---

## MapStudioGraphView

```csharp
public sealed class MapStudioGraphView : VisualElement
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioGraphView.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioGraphView()`

:   &mdash;

**Properties**

`public bool IsPanning`

:   &mdash;

`public StableId SelectedEdgeId`

:   &mdash;

`public StableId SelectedNodeId`

:   &mdash;

**Events**

`public event Action<StableId> EdgeSelected`

:   &mdash;

`public event Action<StableId, NormalizedMapPosition> NodeMoved`

:   &mdash;

`public event Action<StableId> NodeSelected`

:   &mdash;

**Methods**

`public void Render(MapStudioSnapshot snapshot)`

:   &mdash;

`public void Select(StableId id)`

:   &mdash;

`public void SelectEdge(StableId id)`

:   &mdash;

`public bool TryBeginPan(VisualElement eventTarget, int button, int pointerId, Vector2 pointerPosition)`

:   &mdash;

`public bool TrySelectEdgeAt(Vector2 localPoint, float threshold)`

:   &mdash;

---

## MapStudioJson

```csharp
public static class MapStudioJson
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioJson.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static string Export(MapStudioSnapshot snapshot)`

:   &mdash;

---

## MapStudioNodeVisuals

```csharp
public static class MapStudioNodeVisuals
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioNodeVisuals.cs</small>

Pure mapping from a compiled node type and the editor state flags to the visuals
of one Map Studio graph node button. Kept free of UIToolkit so EditMode tests can
cover the mapping directly.

---

## MapStudioSeedAudit

```csharp
public sealed class MapStudioSeedAudit
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioSeedAudit.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public MapStudioAuditResult Run(MapStudioSnapshot snapshot, uint firstSeed, uint lastSeed,)`

:   &mdash;

`public Task<MapStudioAuditResult> RunAsync(MapStudioSnapshot snapshot, uint firstSeed, uint lastSeed,)`

:   &mdash;

---

## MapStudioSeedHistoryEntry

```csharp
public sealed class MapStudioSeedHistoryEntry
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioModels.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioSeedHistoryEntry(uint seed, bool succeeded, MapGenerationFailureKind failureKind,)`

:   &mdash;

**Properties**

`public MapGenerationFailureKind FailureKind`

:   &mdash;

`public string GraphFingerprint`

:   &mdash;

`public uint Seed`

:   &mdash;

`public MapGenerationStatistics Statistics`

:   &mdash;

`public bool Succeeded`

:   &mdash;

---

## MapStudioSession

```csharp
public sealed class MapStudioSession
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioSession.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioSession(MapRuleSnapshot rules)`

:   &mdash;

`public MapStudioSession(MapRuleSnapshot rules, IEnumerable<CompiledMapNodeType> nodeTypes)`

:   &mdash;

`public MapStudioSession(MapRuleSnapshot rules, IMapGenerator generator)`

:   &mdash;

`public MapStudioSession(MapRuleSnapshot rules, IMapGenerator generator, IEnumerable<CompiledMapNodeType> nodeTypes)`

:   &mdash;

**Properties**

`public bool CanRedo`

:   &mdash;

`public bool CanUndo`

:   &mdash;

`public MapStudioSnapshot Current`

:   &mdash;

**Methods**

`public MapStudioCommandResult AddManualNode(StableId id, StableId typeId, MapNodeSlot slot,)`

:   &mdash;

`public MapStudioCommandResult Connect(StableId sourceId, StableId targetId, string edgeIdText)`

:   &mdash;

`public MapStudioCommandResult Disconnect(StableId edgeId)`

:   &mdash;

`public MapStudioCommandResult FocusDiagnostic(int index)`

:   &mdash;

`public static MapStudioSession Load(MapBlueprintCompilation compilation, string sourceToken,)`

:   &mdash;

`public void MarkSaved(long sourceRevision, string sourceToken)`

:   &mdash;

`public MapStudioCommandResult MoveNode(StableId nodeId, NormalizedMapPosition position)`

:   &mdash;

`public MapStudioCommandResult Redo()`

:   &mdash;

`public MapStudioCommandResult Regenerate(uint seed, CancellationToken cancellationToken)`

:   &mdash;

`public MapStudioCommandResult RemoveManualNode(StableId id)`

:   &mdash;

`public MapStudioCommandResult ReplayHistory(int index, CancellationToken cancellationToken)`

:   &mdash;

`public MapStudioCommandResult SetMode(MapGenerationMode mode)`

:   &mdash;

`public MapStudioCommandResult SetNodeLocked(StableId nodeId, bool locked)`

:   &mdash;

`public MapStudioCommandResult SetNodePayload(StableId nodeId, MapNodePayload payload)`

:   &mdash;

`public MapStudioCommandResult SetNodeType(StableId nodeId, StableId typeId)`

:   &mdash;

`public MapStudioCommandResult SetPinnedFields(StableId nodeId, PinnedNodeFields fields)`

:   &mdash;

`public MapStudioCommandResult Undo()`

:   &mdash;

`public MapStudioCommandResult UnpinNode(StableId nodeId)`

:   &mdash;

`public MapStudioCommandResult Validate()`

:   &mdash;

---

## MapStudioSnapshot

```csharp
public sealed class MapStudioSnapshot
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioModels.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapStudioSnapshot(MapRuleSnapshot rules, IEnumerable<CompiledMapNodeType> nodeTypes,)`

:   &mdash;

**Properties**

`public long ChangeOrdinal`

:   &mdash;

`public MapStudioFocus Focus`

:   &mdash;

`public MapGenerationStatistics GenerationStatistics`

:   &mdash;

`public MapGraph Graph`

:   &mdash;

`public MapStudioGraphStatistics GraphStatistics`

:   &mdash;

`public bool IsDirty`

:   &mdash;

`public IReadOnlyList<StableId> LockedNodeIds`

:   &mdash;

`public MapGenerationMode Mode`

:   &mdash;

`public IReadOnlyList<CompiledMapNodeType> NodeTypes`

:   &mdash;

`public MapGenerationOverrides Overrides`

:   &mdash;

`public MapRuleSnapshot Rules`

:   &mdash;

`public MapGenerationSearchOptions SearchOptions`

:   &mdash;

`public uint Seed`

:   &mdash;

`public IReadOnlyList<MapStudioSeedHistoryEntry> SeedHistory`

:   &mdash;

`public long SourceRevision`

:   &mdash;

`public string SourceToken`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

**Methods**

`public bool TryGetNodeType(StableId typeId, out CompiledMapNodeType type)`

:   &mdash;

---

## MapStudioWindow

```csharp
public sealed class MapStudioWindow : EditorWindow
```

`BranchWeaver.Editor.MapStudio` &middot; <small>Editor/MapStudio/MapStudioWindow.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public TextField Key`

:   &mdash;

`public EnumField Kind`

:   &mdash;

`public LongField Numeric`

:   &mdash;

`public Button Remove`

:   &mdash;

`public VisualElement Root`

:   &mdash;

`public TextField StableId`

:   &mdash;

`public TextField Text`

:   &mdash;

`public int Value`

:   &mdash;

**Methods**

`public void CreateGUI()`

:   &mdash;

`public static void Open()`

:   &mdash;

`public void Report(int value)`

:   &mdash;

`public static bool TryParseSeed(string text, out uint seed)`

:   &mdash;

---

## SampleSceneMenuItems

```csharp
public static class SampleSceneMenuItems
```

`BranchWeaver.Editor` &middot; <small>Editor/Setup/SampleSceneMenuItems.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static void OpenQuickStartSample()`

:   &mdash;

`public static bool OpenSampleScene(string scenePath, string displayName)`

:   &mdash;

`public static void OpenWayfarerSample()`

:   &mdash;

---

