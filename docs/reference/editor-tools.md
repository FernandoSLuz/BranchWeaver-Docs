# Editor tools

3 types in this area.

## MapStudioCommandResult

```csharp
public sealed class MapStudioCommandResult
```

`BranchWeaver.Editor.MapStudio` &middot; <small>BranchWeaver/Editor/MapStudio/MapStudioModels.cs</small>

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

## MapStudioSession

```csharp
public sealed class MapStudioSession
```

`BranchWeaver.Editor.MapStudio` &middot; <small>BranchWeaver/Editor/MapStudio/MapStudioSession.cs</small>

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

`BranchWeaver.Editor.MapStudio` &middot; <small>BranchWeaver/Editor/MapStudio/MapStudioModels.cs</small>

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

