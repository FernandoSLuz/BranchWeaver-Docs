# BranchWeaver API reference

Generated from the shipped source. 237 public types across 10 namespaces.

Members shown are the public surface. Anything not listed here is an implementation detail and may change between releases without notice.

## Contents

- [BranchWeaver.Core](#branchweavercore) - 77 types
- [BranchWeaver.Authoring](#branchweaverauthoring) - 45 types
- [BranchWeaver.Runtime](#branchweaverruntime) - 66 types
- [BranchWeaver.Presentation.Canvas](#branchweaverpresentationcanvas) - 8 types
- [BranchWeaver.Presentation.World2D](#branchweaverpresentationworld2d) - 5 types
- [BranchWeaver.Integrations.InputSystem](#branchweaverintegrationsinputsystem) - 1 types
- [BranchWeaver.Editor](#branchweavereditor) - 11 types
- [BranchWeaver.Editor.MapStudio](#branchweavereditormapstudio) - 20 types
- [BranchWeaver.Editor.Styles](#branchweavereditorstyles) - 3 types
- [BranchWeaver.DevTools](#branchweaverdevtools) - 1 types

---

## Types you will use most

### `MapSession`

`BranchWeaver.Core` - class

Authoritative traversal. Owns where the traveller is and which nodes are reachable. Every move goes through `TryEnter`, which returns a result rather than throwing, so illegal moves are data you can react to.

```csharp
MapGraph Graph
MapProgressionState State
event Action<MapTransitionEvent> Transitioned
MapTransitionResult TryEnter(StableId nodeId)
MapTransitionResult CompleteCurrent()
MapTransitionResult CompleteCurrent(MapDataPayload resultPayload)
```

### `MapPresenterBase`

`BranchWeaver.Runtime` - class

Base for both presenters. Turns graph plus runtime state into views. `ApplyStyle` swaps the look at runtime; `TickStyle` advances focus easing, the current-node pulse, and edge flow.

```csharp
event Action<MapLayout> LayoutChanged
void ApplyStyle(BranchWeaver.Authoring.MapStylePreset preset)
void PushStyleToViews()
void TickStyle(float presentationDeltaSeconds)
int ActiveNodeCount
int ActiveEdgeCount
MapLayout CurrentLayout
MapTraversalController TraversalController
Vector2 PresentationContentSize
float PresentationNodeSize
StableId FocusedNodeId
bool TryGetPresentationPosition(StableId nodeId, out Vector2 position)
void SetTraversalController(MapTraversalController controller)
void Configure()
void Refresh()
void Present(MapGraph graph, MapProgressionState progression, MapRuntimeContent content, bool revealAll)
void Clear()
void SetFocusedNode(StableId nodeId)
void AdvanceTransitions(float deltaSeconds)
```

### `MapViewportFrame`

`BranchWeaver.Runtime` - class

Places the map on screen: fit mode, fractional margins that reserve space for your own interface, safe-area insetting, and clamped pan and zoom. `FrameAll` refits; `FocusOn` centres a node.

```csharp
MapFrameResult Frame
void FrameAll()
bool FocusOn(BranchWeaver.Core.StableId nodeId)
void Apply()
```

### `MapStylePreset`

`BranchWeaver.Authoring` - class

One asset holding the entire look. `Compile()` returns the immutable `CompiledMapStyle` the views read. `CopyFrom` is what the Style Browser uses for Create editable copy.

```csharp
string StableIdText
string Description
CompiledMapStyle Compile()
void CopyFrom(CompiledMapStyle source, string newStableId, string newDisplayName)
```

### `MapStyleDefaults`

`BranchWeaver.Authoring` - class

The four shipped styles, defined in code so the map is never unstyled and no art is redistributed. `Resolve(preset)` never returns null.

```csharp
MapNodeShape Shape
float CornerRadius
float StrokeWidth
float GlowRadius
float GlowIntensity
float ShadowRadius
float GradientSpread
MapFillMode FillMode
float EdgeWidth
MapEdgeCap EdgeCap
float DashLength
float DashGap
float FlowSpeed
static MapPaletteTokens SlateNocturnePalette()
static MapPaletteTokens ParchmentAtlasPalette()
static MapPaletteTokens NeonCircuitPalette()
static MapPaletteTokens MinimalMonoPalette()
static CompiledMapStyle Default()
static CompiledMapStyle SlateNocturne()
static CompiledMapStyle ParchmentAtlas()
static CompiledMapStyle NeonCircuit()
static CompiledMapStyle MinimalMono()
static IReadOnlyList<CompiledMapStyle> All()
static bool TryFind(string stableId, out CompiledMapStyle style)
static CompiledMapStyle Resolve(MapStylePreset preset)
static MapNodeStateStyle HiddenState()
static MapNodeStateStyle LockedState()
static MapNodeStateStyle AvailableState()
static MapNodeStateStyle CurrentState()
static MapNodeStateStyle VisitedState()
static MapNodeStateStyle CompletedState()
static MapTypographyTokens DefaultTypography()
static MapMotionTokens DefaultMotion()
static MapFramingTokens DefaultFraming()
static MapNodeStyleTokens SlateNocturneNode()
static MapEdgeStyleTokens SlateNocturneEdge()
static MapBackdropTokens SlateNocturneBackdrop()
```

### `MapThemeAsset`

`BranchWeaver.Authoring` - class

Layout spacing, orientation, edge geometry, and zoom limits. Kept separate from the style because these values feed compilation.

```csharp
string StableIdText
MapLayoutOrientation Orientation
int LayerSpacing
int NodeSpacing
Color BackgroundColor
Color EdgeColor
MapEdgeGeometryKind EdgeGeometry
int BezierSegments
int BezierControlOffset
float MinimumZoom
float MaximumZoom
float StateTransitionSeconds
void ConfigureRuntime()
```

### `FileMapSaveAdapter`

`BranchWeaver.Core` - class

File-backed save slots with a fail-closed unsafe-path guard.

```csharp
string RootDirectory
MapSaveReadResult TryRead(StableId slotId)
MapSaveOperationResult TryWrite(StableId slotId, MapSaveEnvelope envelope)
MapSaveOperationResult TryDelete(StableId slotId)
string Primary
string Temporary
string Backup
string Tombstone
string Path
MapSaveRecoverySource Source
```

---

## BranchWeaver.Core

Engine-free. Compiled with `noEngineReferences: true`, so it cannot touch a GameObject, a Transform, or UnityEngine.Random even by accident. Graph generation, validation, traversal, and save serialization live here.

| Type | Kind | Public members |
| --- | --- | --- |
| `ConstraintContext` | class | 5 |
| `ConstraintResult` | class | 6 |
| `FileMapSaveAdapter` | class | 10 |
| `LayeredMapGenerator` | class | 1 |
| `LayeredMapLayoutStrategy` | class | 2 |
| `MapConnectionRules` | class | 5 |
| `MapDataPayload` | class | 4 |
| `MapDiagnostic` | class | 8 |
| `MapDiagnosticCodes` | class | 0 |
| `MapFingerprint` | class | 5 |
| `MapGenerationManifest` | class | 8 |
| `MapGenerationOverrides` | class | 3 |
| `MapGenerationRequest` | class | 6 |
| `MapGenerationResult` | class | 9 |
| `MapGenerationSearchOptions` | class | 3 |
| `MapGenerationStatistics` | class | 5 |
| `MapGraph` | class | 9 |
| `MapLayout` | class | 3 |
| `MapNode` | class | 6 |
| `MapNodeCompletion` | class | 5 |
| `MapNodePayload` | class | 4 |
| `MapProgressionState` | class | 10 |
| `MapRuleSnapshot` | class | 15 |
| `MapRulesValidator` | class | 2 |
| `MapSaveEnvelope` | class | 9 |
| `MapSaveOperationResult` | class | 3 |
| `MapSaveReadResult` | class | 5 |
| `MapSaveSerializationResult` | class | 5 |
| `MapSaveSerializer` | class | 2 |
| `MapSaveV1ToV2Migration` | class | 1 |
| `MapSession` | class | 6 |
| `MapTransitionEvent` | class | 5 |
| `MapTransitionResult` | class | 6 |
| `MapValidator` | class | 6 |
| `MapZoneDefinition` | class | 8 |
| `MemoryMapSaveAdapter` | class | 3 |
| `ValidationReport` | class | 2 |
| `XorShift32Random` | class | 5 |
| `DeterministicRandomState` | struct | 5 |
| `EdgeGenerationOverride` | struct | 6 |
| `ForbiddenAdjacencyRule` | struct | 6 |
| `ForcedNodeTypeRule` | struct | 4 |
| `LayerNodeRange` | struct | 5 |
| `MapEdge` | struct | 8 |
| `MapLayoutNode` | struct | 6 |
| `MapLayoutRequest` | struct | 5 |
| `MapNodeSlot` | struct | 7 |
| `MapNodeTypeAssignment` | struct | 4 |
| `MapProperty` | struct | 6 |
| `MapPropertyValue` | struct | 12 |
| `MapSlotEdge` | struct | 7 |
| `NodeTypeQuotaRule` | struct | 6 |
| `NodeTypeWeight` | struct | 3 |
| `NodeTypeWeightOverride` | struct | 3 |
| `NormalizedMapPosition` | struct | 8 |
| `PinnedNodeOverride` | struct | 7 |
| `StableId` | struct | 9 |
| `IMapConstraint` | interface | 0 |
| `IMapGenerator` | interface | 0 |
| `IMapLayoutStrategy` | interface | 0 |
| `IMapSaveAdapter` | interface | 0 |
| `IMapSaveMigration` | interface | 0 |
| `IMapValidator` | interface | 0 |
| `ConstraintEvaluationState` | enum | 0 |
| `EdgeCrossingPolicy` | enum | 0 |
| `EdgeOverrideDisposition` | enum | 0 |
| `ForbiddenAdjacencyDirection` | enum | 0 |
| `MapDiagnosticSeverity` | enum | 0 |
| `MapGenerationFailureKind` | enum | 0 |
| `MapGenerationMode` | enum | 0 |
| `MapLayoutOrientation` | enum | 0 |
| `MapPropertyKind` | enum | 0 |
| `MapSaveFailureKind` | enum | 0 |
| `MapSaveRecoverySource` | enum | 0 |
| `MapTransitionEventKind` | enum | 0 |
| `MapTransitionFailureKind` | enum | 0 |
| `PinnedNodeFields` | enum | 0 |

## BranchWeaver.Authoring

ScriptableObject assets you create in the Project window, plus the compiler that freezes them into immutable runtime content.

| Type | Kind | Public members |
| --- | --- | --- |
| `AuthoringDiagnosticCodes` | class | 0 |
| `BlueprintEdgeAuthoring` | class | 3 |
| `BlueprintEdgeOverrideAuthoring` | class | 7 |
| `BlueprintNodeAuthoring` | class | 11 |
| `CompiledMapNodeStates` | class | 6 |
| `CompiledMapNodeType` | class | 17 |
| `CompiledMapStyle` | class | 13 |
| `CompiledMapTheme` | class | 12 |
| `ForbiddenAdjacencyAuthoring` | class | 4 |
| `ForcedNodeAuthoring` | class | 4 |
| `LayerRangeAuthoring` | class | 2 |
| `MapAuthoringCompiler` | class | 4 |
| `MapBlueprintAsset` | class | 16 |
| `MapBlueprintCompilation` | class | 10 |
| `MapConstraintAsset` | class | 1 |
| `MapNodeTypeAsset` | class | 19 |
| `MapNodeTypeCompilation` | class | 3 |
| `MapPropertyAuthoring` | class | 5 |
| `MapRulesAsset` | class | 17 |
| `MapRulesCompilation` | class | 4 |
| `MapStyleDefaults` | class | 37 |
| `MapStylePreset` | class | 4 |
| `MapThemeAsset` | class | 13 |
| `MapThemeCompilation` | class | 3 |
| `MapThemeLimits` | class | 0 |
| `NodeTypeWeightAuthoring` | class | 2 |
| `NodeTypeWeightOverrideAuthoring` | class | 2 |
| `QuotaAuthoring` | class | 5 |
| `ZoneAuthoring` | class | 6 |
| `MapBackdropTokens` | struct | 7 |
| `MapEdgeStyleTokens` | struct | 11 |
| `MapFramingTokens` | struct | 13 |
| `MapMotionTokens` | struct | 9 |
| `MapNodeStateStyle` | struct | 9 |
| `MapNodeStyleTokens` | struct | 7 |
| `MapPaletteTokens` | struct | 12 |
| `MapSurfaceTokens` | struct | 11 |
| `MapTypographyTokens` | struct | 8 |
| `MapEasing` | enum | 0 |
| `MapEdgeCap` | enum | 0 |
| `MapEdgeGeometryKind` | enum | 0 |
| `MapFillMode` | enum | 0 |
| `MapFitMode` | enum | 0 |
| `MapLayoutOrientation` | enum | 0 |
| `MapNodeShape` | enum | 0 |

## BranchWeaver.Runtime

MonoBehaviour glue: presenters, traversal controller, styling, framing, and input.

| Type | Kind | Public members |
| --- | --- | --- |
| `DefaultMapNodeHitTester` | class | 3 |
| `InputSystemSignalAdapter` | class | 9 |
| `LegacyMapInputSource` | class | 1 |
| `MapCameraResolver` | class | 1 |
| `MapDevelopmentCommandResult` | class | 6 |
| `MapEdgeGeometry` | class | 1 |
| `MapFrameUtility` | class | 1 |
| `MapInputController` | class | 24 |
| `MapMaterialPool` | class | 6 |
| `MapNavigationModel` | class | 5 |
| `MapPresentationMetrics` | class | 4 |
| `MapPresenterBase` | class | 19 |
| `MapRuntimeContent` | class | 3 |
| `MapRuntimeDiagnosticCodes` | class | 0 |
| `MapRuntimeStateDeriver` | class | 1 |
| `MapRuntimeStateSnapshot` | class | 3 |
| `MapSafeAreaController` | class | 2 |
| `MapSelectionResult` | class | 6 |
| `MapSerializedEventBridge` | class | 8 |
| `MapSetupHierarchyBinding` | class | 7 |
| `MapStyleRuntime` | class | 4 |
| `MapTouchGestureInterpreter` | class | 1 |
| `MapTraversalController` | class | 40 |
| `MapViewportFrame` | class | 4 |
| `MapViewportUtility` | class | 2 |
| `MapWorldViewportUtility` | class | 2 |
| `NullMapAudioCueAdapter` | class | 1 |
| `PassthroughLocalizationAdapter` | class | 1 |
| `ProceduralNodeSprite` | class | 1 |
| `MapEdgeViewData` | struct | 5 |
| `MapFrameResult` | struct | 7 |
| `MapInputFrame` | struct | 8 |
| `MapNodeRuntimeState` | struct | 4 |
| `MapNodeViewData` | struct | 10 |
| `MapSurfaceRequest` | struct | 35 |
| `MapTouchSample` | struct | 3 |
| `MapViewportResult` | struct | 3 |
| `IMapAudioCueAdapter` | interface | 0 |
| `IMapBackgroundPresenter` | interface | 0 |
| `IMapDevelopmentHost` | interface | 0 |
| `IMapEdgeAvailabilityView` | interface | 0 |
| `IMapEdgeTransitionView` | interface | 0 |
| `IMapEdgeView` | interface | 0 |
| `IMapEdgeViewFactory` | interface | 0 |
| `IMapFocusIndicatorPresenter` | interface | 0 |
| `IMapFocusView` | interface | 0 |
| `IMapInputSource` | interface | 0 |
| `IMapLocalizationAdapter` | interface | 0 |
| `IMapNodeHitState` | interface | 0 |
| `IMapNodeHitTester` | interface | 0 |
| `IMapNodeTransitionView` | interface | 0 |
| `IMapNodeView` | interface | 0 |
| `IMapNodeViewFactory` | interface | 0 |
| `IMapPresentationHost` | interface | 0 |
| `IMapPresentationTransitionAdapter` | interface | 0 |
| `IMapStyledView` | interface | 0 |
| `IMapViewFactoryLifetime` | interface | 0 |
| `IPlayerPawnPresenter` | interface | 0 |
| `IRouteMarkerPresenter` | interface | 0 |
| `MapAspectClass` | enum | 0 |
| `MapDevelopmentFailureKind` | enum | 0 |
| `MapFogState` | enum | 0 |
| `MapNavigationDirection` | enum | 0 |
| `MapNodeVisualState` | enum | 0 |
| `MapSurfaceMode` | enum | 0 |
| `MapTouchPhase` | enum | 0 |

## BranchWeaver.Presentation.Canvas

uGUI presenter. The default for screen-space maps.

| Type | Kind | Public members |
| --- | --- | --- |
| `CanvasMapCoordinateUtility` | class | 1 |
| `CanvasMapEdgeFactory` | class | 6 |
| `CanvasMapEdgeView` | class | 15 |
| `CanvasMapNodeFactory` | class | 6 |
| `CanvasMapNodeStyling` | class | 3 |
| `CanvasMapNodeView` | class | 19 |
| `CanvasMapPresenter` | class | 0 |
| `MapSurfaceGraphic` | class | 5 |

## BranchWeaver.Presentation.World2D

World-space presenter for maps that live in the scene.

| Type | Kind | Public members |
| --- | --- | --- |
| `WorldMapEdgeFactory` | class | 6 |
| `WorldMapEdgeView` | class | 14 |
| `WorldMapNodeFactory` | class | 6 |
| `WorldMapNodeView` | class | 17 |
| `WorldMapPresenter` | class | 0 |

## BranchWeaver.Integrations.InputSystem

| Type | Kind | Public members |
| --- | --- | --- |
| `InputSystemMapInputBridge` | class | 14 |

## BranchWeaver.Editor

| Type | Kind | Public members |
| --- | --- | --- |
| `MapSetupConfigurationCodes` | class | 0 |
| `MapSetupConfigurationResult` | class | 4 |
| `MapSetupConfigurator` | class | 2 |
| `MapSetupDiagnosticCodes` | class | 0 |
| `MapSetupValidationRequest` | class | 7 |
| `MapSetupValidator` | class | 1 |
| `MapSetupWizard` | class | 3 |
| `MapStarterAssetFactory` | class | 1 |
| `MapStarterAssetResult` | class | 5 |
| `SampleSceneMenuItems` | class | 3 |
| `MapRuntimeRendererSelection` | enum | 0 |

## BranchWeaver.Editor.MapStudio

| Type | Kind | Public members |
| --- | --- | --- |
| `MapBlueprintPersistence` | class | 3 |
| `MapBlueprintPersistenceResult` | class | 4 |
| `MapBlueprintSourceToken` | class | 7 |
| `MapStudioAuditCoordinator` | class | 6 |
| `MapStudioAuditOperation` | class | 2 |
| `MapStudioAuditResult` | class | 5 |
| `MapStudioAuditRow` | class | 6 |
| `MapStudioAuditStatistics` | class | 14 |
| `MapStudioCommandResult` | class | 3 |
| `MapStudioDiagnosticCodes` | class | 0 |
| `MapStudioFocus` | class | 4 |
| `MapStudioGraphStatistics` | class | 6 |
| `MapStudioGraphView` | class | 10 |
| `MapStudioJson` | class | 1 |
| `MapStudioNodeVisuals` | class | 0 |
| `MapStudioSeedAudit` | class | 2 |
| `MapStudioSeedHistoryEntry` | class | 5 |
| `MapStudioSession` | class | 22 |
| `MapStudioSnapshot` | class | 18 |
| `MapStudioWindow` | class | 12 |

## BranchWeaver.Editor.Styles

Style Browser and the live-preview inspector.

| Type | Kind | Public members |
| --- | --- | --- |
| `MapStyleBrowserWindow` | class | 5 |
| `MapStylePresetEditor` | class | 3 |
| `MapStylePreviewRenderer` | class | 6 |

## BranchWeaver.DevTools

Development overlays. Not required at runtime.

| Type | Kind | Public members |
| --- | --- | --- |
| `MapDevelopmentOverlay` | class | 1 |

