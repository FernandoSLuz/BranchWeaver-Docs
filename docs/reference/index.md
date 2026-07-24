# API reference

Every public type in BranchWeaver, grouped by what it is for rather than by namespace. **244 types.**

!!! tip "Filter as you type"
    Start typing in the box below to narrow the table. Use the search icon in the header to search the whole site instead.

<input type="text" id="api-filter" class="api-filter" placeholder="Filter types, groups, or descriptions..." autocomplete="off" aria-label="Filter API types">
<p id="api-filter-count" class="api-filter-count"></p>

<div class="api-table" markdown>

| Type | Kind | Area | What it is for |
| --- | --- | --- | --- |
| [`EdgeGenerationOverride`](getting-a-map.md#edgegenerationoverride) | struct | Getting a map | _Undocumented._ |
| [`EdgeOverrideDisposition`](getting-a-map.md#edgeoverridedisposition) | enum | Getting a map | _Undocumented._ |
| [`LayeredMapGenerator`](getting-a-map.md#layeredmapgenerator) | class | Getting a map | Generator version 1. |
| [`MapGenerationFailureKind`](getting-a-map.md#mapgenerationfailurekind) | enum | Getting a map | _Undocumented._ |
| [`MapGenerationMode`](getting-a-map.md#mapgenerationmode) | enum | Getting a map | _Undocumented._ |
| [`MapGenerationOverrides`](getting-a-map.md#mapgenerationoverrides) | class | Getting a map | _Undocumented._ |
| [`MapGenerationRequest`](getting-a-map.md#mapgenerationrequest) | class | Getting a map | _Undocumented._ |
| [`MapGenerationResult`](getting-a-map.md#mapgenerationresult) | class | Getting a map | _Undocumented._ |
| [`MapGenerationSearchOptions`](getting-a-map.md#mapgenerationsearchoptions) | class | Getting a map | _Undocumented._ |
| [`MapGenerationStatistics`](getting-a-map.md#mapgenerationstatistics) | class | Getting a map | _Undocumented._ |
| [`PinnedNodeFields`](getting-a-map.md#pinnednodefields) | enum | Getting a map | _Undocumented._ |
| [`PinnedNodeOverride`](getting-a-map.md#pinnednodeoverride) | struct | Getting a map | _Undocumented._ |
| [`MapDataPayload`](traversal-and-progression.md#mapdatapayload) | class | Traversal and progression | Generic tagged data for traversal results and customer-owned save metadata. |
| [`MapNodeCompletion`](traversal-and-progression.md#mapnodecompletion) | class | Traversal and progression | _Undocumented._ |
| [`MapProgressionState`](traversal-and-progression.md#mapprogressionstate) | class | Traversal and progression | An immutable traversal snapshot. |
| [`MapSession`](traversal-and-progression.md#mapsession) | class | Traversal and progression | Standalone traversal orchestration over immutable graph and progression snapshots. |
| [`MapTransitionEvent`](traversal-and-progression.md#maptransitionevent) | class | Traversal and progression | _Undocumented._ |
| [`MapTransitionEventKind`](traversal-and-progression.md#maptransitioneventkind) | enum | Traversal and progression | _Undocumented._ |
| [`MapTransitionFailureKind`](traversal-and-progression.md#maptransitionfailurekind) | enum | Traversal and progression | _Undocumented._ |
| [`MapTransitionResult`](traversal-and-progression.md#maptransitionresult) | class | Traversal and progression | _Undocumented._ |
| [`AuthoringDiagnosticCodes`](authoring-assets.md#authoringdiagnosticcodes) | class | Authoring assets | _Undocumented._ |
| [`BlueprintEdgeAuthoring`](authoring-assets.md#blueprintedgeauthoring) | class | Authoring assets | _Undocumented._ |
| [`BlueprintEdgeOverrideAuthoring`](authoring-assets.md#blueprintedgeoverrideauthoring) | class | Authoring assets | _Undocumented._ |
| [`BlueprintNodeAuthoring`](authoring-assets.md#blueprintnodeauthoring) | class | Authoring assets | _Undocumented._ |
| [`CompiledMapNodeType`](authoring-assets.md#compiledmapnodetype) | class | Authoring assets | _Undocumented._ |
| [`CompiledMapTheme`](authoring-assets.md#compiledmaptheme) | class | Authoring assets | _Undocumented._ |
| [`ForbiddenAdjacencyAuthoring`](authoring-assets.md#forbiddenadjacencyauthoring) | class | Authoring assets | _Undocumented._ |
| [`ForcedNodeAuthoring`](authoring-assets.md#forcednodeauthoring) | class | Authoring assets | _Undocumented._ |
| [`LayerRangeAuthoring`](authoring-assets.md#layerrangeauthoring) | class | Authoring assets | _Undocumented._ |
| [`MapAuthoringCompiler`](authoring-assets.md#mapauthoringcompiler) | class | Authoring assets | _Undocumented._ |
| [`MapBlueprintAsset`](authoring-assets.md#mapblueprintasset) | class | Authoring assets | _Undocumented._ |
| [`MapBlueprintCompilation`](authoring-assets.md#mapblueprintcompilation) | class | Authoring assets | _Undocumented._ |
| [`MapConstraintAsset`](authoring-assets.md#mapconstraintasset) | class | Authoring assets | _Undocumented._ |
| [`MapEdgeGeometryKind`](authoring-assets.md#mapedgegeometrykind) | enum | Authoring assets | _Undocumented._ |
| [`MapLayoutOrientation`](authoring-assets.md#maplayoutorientation) | enum | Authoring assets | _Undocumented._ |
| [`MapNodeTypeAsset`](authoring-assets.md#mapnodetypeasset) | class | Authoring assets | _Undocumented._ |
| [`MapNodeTypeCompilation`](authoring-assets.md#mapnodetypecompilation) | class | Authoring assets | _Undocumented._ |
| [`MapPropertyAuthoring`](authoring-assets.md#mappropertyauthoring) | class | Authoring assets | _Undocumented._ |
| [`MapRulesAsset`](authoring-assets.md#maprulesasset) | class | Authoring assets | _Undocumented._ |
| [`MapRulesCompilation`](authoring-assets.md#maprulescompilation) | class | Authoring assets | _Undocumented._ |
| [`MapThemeAsset`](authoring-assets.md#mapthemeasset) | class | Authoring assets | _Undocumented._ |
| [`MapThemeCompilation`](authoring-assets.md#mapthemecompilation) | class | Authoring assets | _Undocumented._ |
| [`MapThemeLimits`](authoring-assets.md#mapthemelimits) | class | Authoring assets | _Undocumented._ |
| [`NodeTypeWeightAuthoring`](authoring-assets.md#nodetypeweightauthoring) | class | Authoring assets | _Undocumented._ |
| [`NodeTypeWeightOverrideAuthoring`](authoring-assets.md#nodetypeweightoverrideauthoring) | class | Authoring assets | _Undocumented._ |
| [`QuotaAuthoring`](authoring-assets.md#quotaauthoring) | class | Authoring assets | _Undocumented._ |
| [`ZoneAuthoring`](authoring-assets.md#zoneauthoring) | class | Authoring assets | _Undocumented._ |
| [`CanvasMapNodeStyling`](styling-and-appearance.md#canvasmapnodestyling) | class | Styling and appearance | Turns a node's compiled type, visual state, and fog state into the surface request that draws it. |
| [`CompiledMapNodeStates`](styling-and-appearance.md#compiledmapnodestates) | class | Styling and appearance | The resolved per-state node treatments for one style. |
| [`CompiledMapStyle`](styling-and-appearance.md#compiledmapstyle) | class | Styling and appearance | The immutable style the views read. |
| [`IMapStyledView`](styling-and-appearance.md#imapstyledview) | interface | Styling and appearance | Implemented by a view that can be dressed by a map style and advanced by a visual clock. |
| [`MapBackdropTokens`](styling-and-appearance.md#mapbackdroptokens) | struct | Styling and appearance | The backdrop drawn behind the map. |
| [`MapEasing`](styling-and-appearance.md#mapeasing) | enum | Styling and appearance | Easing curve for a styled transition. |
| [`MapEdgeCap`](styling-and-appearance.md#mapedgecap) | enum | Styling and appearance | End treatment for a drawn edge. |
| [`MapEdgeStyleTokens`](styling-and-appearance.md#mapedgestyletokens) | struct | Styling and appearance | How routes between nodes are drawn. |
| [`MapFillMode`](styling-and-appearance.md#mapfillmode) | enum | Styling and appearance | How a surface fills its area. |
| [`MapFitMode`](styling-and-appearance.md#mapfitmode) | enum | Styling and appearance | How the map is fitted into the area it is given. |
| [`MapFramingTokens`](styling-and-appearance.md#mapframingtokens) | struct | Styling and appearance | Where the map sits inside the area it is given, and how far the player may pan and zoom. |
| [`MapMaterialPool`](styling-and-appearance.md#mapmaterialpool) | class | Styling and appearance | Reference-counted material pool for map surfaces, owned by a component rather than by static state. |
| [`MapMotionTokens`](styling-and-appearance.md#mapmotiontokens) | struct | Styling and appearance | Transition timings. |
| [`MapNodeShape`](styling-and-appearance.md#mapnodeshape) | enum | Styling and appearance | Silhouette drawn for a map node. |
| [`MapNodeStateStyle`](styling-and-appearance.md#mapnodestatestyle) | struct | Styling and appearance | Per-state treatment layered over the shared node style. |
| [`MapNodeStyleTokens`](styling-and-appearance.md#mapnodestyletokens) | struct | Styling and appearance | Shape and size shared by every node before per-state treatment. |
| [`MapPaletteTokens`](styling-and-appearance.md#mappalettetokens) | struct | Styling and appearance | The semantic colour roles a style assigns once and reuses everywhere. |
| [`MapStyleBrowserWindow`](styling-and-appearance.md#mapstylebrowserwindow) | class | Styling and appearance | Browse the shipped map styles, preview them with the real shader, and turn any of them into an editable asset in one click. |
| [`MapStyleDefaults`](styling-and-appearance.md#mapstyledefaults) | class | Styling and appearance | The shipped map styles, defined in code rather than as serialized assets. |
| [`MapStylePreset`](styling-and-appearance.md#mapstylepreset) | class | Styling and appearance | Everything the map draws itself with, in one asset: palette, node shape and treatment, per-state emphasis, edge stroke, backdrop, typography, motion, and on-screen framing. |
| [`MapStylePresetEditor`](styling-and-appearance.md#mapstylepreseteditor) | class | Styling and appearance | Inspector for `apStylePreset` with a live preview above the fields. |
| [`MapStylePreviewRenderer`](styling-and-appearance.md#mapstylepreviewrenderer) | class | Styling and appearance | Draws map style previews in editor windows and inspectors using the same shader and the same token mapping the runtime views use. |
| [`MapStyleRuntime`](styling-and-appearance.md#mapstyleruntime) | class | Styling and appearance | Bridges an authored `ompiledMapStyle` to runtime visual state. |
| [`MapSurfaceGraphic`](styling-and-appearance.md#mapsurfacegraphic) | class | Styling and appearance | Draws one styled map surface as a uGUI graphic through the BranchWeaver map surface shader. |
| [`MapSurfaceMode`](styling-and-appearance.md#mapsurfacemode) | enum | Styling and appearance | What a map surface material draws. |
| [`MapSurfaceRequest`](styling-and-appearance.md#mapsurfacerequest) | struct | Styling and appearance | The complete parameter set for one map surface material. |
| [`MapSurfaceTokens`](styling-and-appearance.md#mapsurfacetokens) | struct | Styling and appearance | Fill, stroke, glow, and shadow for a drawn surface. |
| [`MapTypographyTokens`](styling-and-appearance.md#maptypographytokens) | struct | Styling and appearance | Label sizing and treatment. |
| [`CanvasMapCoordinateUtility`](presentation-and-views.md#canvasmapcoordinateutility) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapEdgeFactory`](presentation-and-views.md#canvasmapedgefactory) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapEdgeView`](presentation-and-views.md#canvasmapedgeview) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapNodeFactory`](presentation-and-views.md#canvasmapnodefactory) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapNodeView`](presentation-and-views.md#canvasmapnodeview) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapPresenter`](presentation-and-views.md#canvasmappresenter) | class | Presentation and views | _Undocumented._ |
| [`DefaultMapNodeHitTester`](presentation-and-views.md#defaultmapnodehittester) | class | Presentation and views | _Undocumented._ |
| [`IMapAudioCueAdapter`](presentation-and-views.md#imapaudiocueadapter) | interface | Presentation and views | _Undocumented._ |
| [`IMapBackgroundPresenter`](presentation-and-views.md#imapbackgroundpresenter) | interface | Presentation and views | _Undocumented._ |
| [`IMapDevelopmentHost`](presentation-and-views.md#imapdevelopmenthost) | interface | Presentation and views | _Undocumented._ |
| [`IMapEdgeAvailabilityView`](presentation-and-views.md#imapedgeavailabilityview) | interface | Presentation and views | Implemented by an edge view that can emphasize routes leading to a reachable node. |
| [`IMapEdgeTransitionView`](presentation-and-views.md#imapedgetransitionview) | interface | Presentation and views | _Undocumented._ |
| [`IMapEdgeView`](presentation-and-views.md#imapedgeview) | interface | Presentation and views | _Undocumented._ |
| [`IMapEdgeViewFactory`](presentation-and-views.md#imapedgeviewfactory) | interface | Presentation and views | _Undocumented._ |
| [`IMapFocusIndicatorPresenter`](presentation-and-views.md#imapfocusindicatorpresenter) | interface | Presentation and views | _Undocumented._ |
| [`IMapFocusView`](presentation-and-views.md#imapfocusview) | interface | Presentation and views | _Undocumented._ |
| [`IMapInputSource`](presentation-and-views.md#imapinputsource) | interface | Presentation and views | _Undocumented._ |
| [`IMapLocalizationAdapter`](presentation-and-views.md#imaplocalizationadapter) | interface | Presentation and views | _Undocumented._ |
| [`IMapNodeHitState`](presentation-and-views.md#imapnodehitstate) | interface | Presentation and views | _Undocumented._ |
| [`IMapNodeHitTester`](presentation-and-views.md#imapnodehittester) | interface | Presentation and views | _Undocumented._ |
| [`IMapNodeTransitionView`](presentation-and-views.md#imapnodetransitionview) | interface | Presentation and views | _Undocumented._ |
| [`IMapNodeView`](presentation-and-views.md#imapnodeview) | interface | Presentation and views | _Undocumented._ |
| [`IMapNodeViewFactory`](presentation-and-views.md#imapnodeviewfactory) | interface | Presentation and views | _Undocumented._ |
| [`IMapPresentationHost`](presentation-and-views.md#imappresentationhost) | interface | Presentation and views | _Undocumented._ |
| [`IMapPresentationTransitionAdapter`](presentation-and-views.md#imappresentationtransitionadapter) | interface | Presentation and views | _Undocumented._ |
| [`IMapViewFactoryLifetime`](presentation-and-views.md#imapviewfactorylifetime) | interface | Presentation and views | Optional lifetime contract used only for factories created and owned by a presenter. |
| [`IPlayerPawnPresenter`](presentation-and-views.md#iplayerpawnpresenter) | interface | Presentation and views | _Undocumented._ |
| [`IRouteMarkerPresenter`](presentation-and-views.md#iroutemarkerpresenter) | interface | Presentation and views | _Undocumented._ |
| [`InputSystemSignalAdapter`](presentation-and-views.md#inputsystemsignaladapter) | class | Presentation and views | Package-neutral bridge for Input System PlayerInput UnityEvents. |
| [`LegacyMapInputSource`](presentation-and-views.md#legacymapinputsource) | class | Presentation and views | _Undocumented._ |
| [`MapCameraResolver`](presentation-and-views.md#mapcameraresolver) | class | Presentation and views | _Undocumented._ |
| [`MapDevelopmentCommandResult`](presentation-and-views.md#mapdevelopmentcommandresult) | class | Presentation and views | _Undocumented._ |
| [`MapDevelopmentFailureKind`](presentation-and-views.md#mapdevelopmentfailurekind) | enum | Presentation and views | _Undocumented._ |
| [`MapEdgeViewData`](presentation-and-views.md#mapedgeviewdata) | struct | Presentation and views | _Undocumented._ |
| [`MapFogState`](presentation-and-views.md#mapfogstate) | enum | Presentation and views | _Undocumented._ |
| [`MapInputController`](presentation-and-views.md#mapinputcontroller) | class | Presentation and views | _Undocumented._ |
| [`MapInputFrame`](presentation-and-views.md#mapinputframe) | struct | Presentation and views | _Undocumented._ |
| [`MapNavigationDirection`](presentation-and-views.md#mapnavigationdirection) | enum | Presentation and views | _Undocumented._ |
| [`MapNavigationModel`](presentation-and-views.md#mapnavigationmodel) | class | Presentation and views | _Undocumented._ |
| [`MapNodeRuntimeState`](presentation-and-views.md#mapnoderuntimestate) | struct | Presentation and views | _Undocumented._ |
| [`MapNodeViewData`](presentation-and-views.md#mapnodeviewdata) | struct | Presentation and views | _Undocumented._ |
| [`MapNodeVisualState`](presentation-and-views.md#mapnodevisualstate) | enum | Presentation and views | _Undocumented._ |
| [`MapPresentationMetrics`](presentation-and-views.md#mappresentationmetrics) | class | Presentation and views | _Undocumented._ |
| [`MapPresenterBase`](presentation-and-views.md#mappresenterbase) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeContent`](presentation-and-views.md#mapruntimecontent) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeDiagnosticCodes`](presentation-and-views.md#mapruntimediagnosticcodes) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeStateDeriver`](presentation-and-views.md#mapruntimestatederiver) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeStateSnapshot`](presentation-and-views.md#mapruntimestatesnapshot) | class | Presentation and views | _Undocumented._ |
| [`MapSelectionResult`](presentation-and-views.md#mapselectionresult) | class | Presentation and views | _Undocumented._ |
| [`MapSerializedEventBridge`](presentation-and-views.md#mapserializedeventbridge) | class | Presentation and views | _Undocumented._ |
| [`MapSetupHierarchyBinding`](presentation-and-views.md#mapsetuphierarchybinding) | class | Presentation and views | Durable identity for scene objects created and owned by the BranchWeaver setup wizard. |
| [`MapTouchGestureInterpreter`](presentation-and-views.md#maptouchgestureinterpreter) | class | Presentation and views | _Undocumented._ |
| [`MapTouchPhase`](presentation-and-views.md#maptouchphase) | enum | Presentation and views | _Undocumented._ |
| [`MapTouchSample`](presentation-and-views.md#maptouchsample) | struct | Presentation and views | _Undocumented._ |
| [`MapTraversalController`](presentation-and-views.md#maptraversalcontroller) | class | Presentation and views | _Undocumented._ |
| [`NullMapAudioCueAdapter`](presentation-and-views.md#nullmapaudiocueadapter) | class | Presentation and views | _Undocumented._ |
| [`PassthroughLocalizationAdapter`](presentation-and-views.md#passthroughlocalizationadapter) | class | Presentation and views | _Undocumented._ |
| [`ProceduralNodeSprite`](presentation-and-views.md#proceduralnodesprite) | class | Presentation and views | Generates shared rounded-square node sprites at runtime so icon-less node types render as calm rounded marks instead of hard white squares. |
| [`WorldMapEdgeFactory`](presentation-and-views.md#worldmapedgefactory) | class | Presentation and views | _Undocumented._ |
| [`WorldMapEdgeView`](presentation-and-views.md#worldmapedgeview) | class | Presentation and views | _Undocumented._ |
| [`WorldMapNodeFactory`](presentation-and-views.md#worldmapnodefactory) | class | Presentation and views | _Undocumented._ |
| [`WorldMapNodeView`](presentation-and-views.md#worldmapnodeview) | class | Presentation and views | _Undocumented._ |
| [`WorldMapPresenter`](presentation-and-views.md#worldmappresenter) | class | Presentation and views | _Undocumented._ |
| [`InputSystemMapInputBridge`](framing-input-and-navigation.md#inputsystemmapinputbridge) | class | Framing, input and navigation | Optional PlayerInput UnityEvent bridge compiled only when com.unity.inputsystem is installed. |
| [`MapAspectClass`](framing-input-and-navigation.md#mapaspectclass) | enum | Framing, input and navigation | _Undocumented._ |
| [`MapFrameResult`](framing-input-and-navigation.md#mapframeresult) | struct | Framing, input and navigation | The resolved on-screen placement of a map: the rectangle it may occupy, the scale that fits its content into that rectangle, and the pan limits that keep it reachable. |
| [`MapFrameUtility`](framing-input-and-navigation.md#mapframeutility) | class | Framing, input and navigation | Pure framing maths, separated from the component so it can be tested without a scene, a canvas, or a device. |
| [`MapSafeAreaController`](framing-input-and-navigation.md#mapsafeareacontroller) | class | Framing, input and navigation | _Undocumented._ |
| [`MapViewportFrame`](framing-input-and-navigation.md#mapviewportframe) | class | Framing, input and navigation | Places a map on screen: reserves margins for your own interface, fits the content, insets into the device safe area, and clamps pan and zoom. |
| [`MapViewportResult`](framing-input-and-navigation.md#mapviewportresult) | struct | Framing, input and navigation | _Undocumented._ |
| [`MapViewportUtility`](framing-input-and-navigation.md#mapviewportutility) | class | Framing, input and navigation | _Undocumented._ |
| [`MapWorldViewportUtility`](framing-input-and-navigation.md#mapworldviewportutility) | class | Framing, input and navigation | _Undocumented._ |
| [`ConstraintContext`](rules-and-constraints.md#constraintcontext) | class | Rules and constraints | _Undocumented._ |
| [`ConstraintEvaluationState`](rules-and-constraints.md#constraintevaluationstate) | enum | Rules and constraints | _Undocumented._ |
| [`ConstraintResult`](rules-and-constraints.md#constraintresult) | class | Rules and constraints | _Undocumented._ |
| [`EdgeCrossingPolicy`](rules-and-constraints.md#edgecrossingpolicy) | enum | Rules and constraints | _Undocumented._ |
| [`ForbiddenAdjacencyDirection`](rules-and-constraints.md#forbiddenadjacencydirection) | enum | Rules and constraints | _Undocumented._ |
| [`ForbiddenAdjacencyRule`](rules-and-constraints.md#forbiddenadjacencyrule) | struct | Rules and constraints | _Undocumented._ |
| [`ForcedNodeTypeRule`](rules-and-constraints.md#forcednodetyperule) | struct | Rules and constraints | _Undocumented._ |
| [`IMapConstraint`](rules-and-constraints.md#imapconstraint) | interface | Rules and constraints | _Undocumented._ |
| [`MapConnectionRules`](rules-and-constraints.md#mapconnectionrules) | class | Rules and constraints | _Undocumented._ |
| [`MapNodeSlot`](rules-and-constraints.md#mapnodeslot) | struct | Rules and constraints | _Undocumented._ |
| [`MapNodeTypeAssignment`](rules-and-constraints.md#mapnodetypeassignment) | struct | Rules and constraints | _Undocumented._ |
| [`MapRulesValidator`](rules-and-constraints.md#maprulesvalidator) | class | Rules and constraints | _Undocumented._ |
| [`MapSlotEdge`](rules-and-constraints.md#mapslotedge) | struct | Rules and constraints | _Undocumented._ |
| [`MapValidator`](rules-and-constraints.md#mapvalidator) | class | Rules and constraints | _Undocumented._ |
| [`MapZoneDefinition`](rules-and-constraints.md#mapzonedefinition) | class | Rules and constraints | _Undocumented._ |
| [`NodeTypeQuotaRule`](rules-and-constraints.md#nodetypequotarule) | struct | Rules and constraints | _Undocumented._ |
| [`NodeTypeWeight`](rules-and-constraints.md#nodetypeweight) | struct | Rules and constraints | _Undocumented._ |
| [`NodeTypeWeightOverride`](rules-and-constraints.md#nodetypeweightoverride) | struct | Rules and constraints | _Undocumented._ |
| [`ValidationReport`](rules-and-constraints.md#validationreport) | class | Rules and constraints | _Undocumented._ |
| [`IMapLayoutStrategy`](graph-layout-and-geometry.md#imaplayoutstrategy) | interface | Graph, layout and geometry | _Undocumented._ |
| [`LayeredMapLayoutStrategy`](graph-layout-and-geometry.md#layeredmaplayoutstrategy) | class | Graph, layout and geometry | _Undocumented._ |
| [`MapEdge`](graph-layout-and-geometry.md#mapedge) | struct | Graph, layout and geometry | _Undocumented._ |
| [`MapEdgeGeometry`](graph-layout-and-geometry.md#mapedgegeometry) | class | Graph, layout and geometry | _Undocumented._ |
| [`MapGraph`](graph-layout-and-geometry.md#mapgraph) | class | Graph, layout and geometry | An immutable graph snapshot. |
| [`MapLayout`](graph-layout-and-geometry.md#maplayout) | class | Graph, layout and geometry | _Undocumented._ |
| [`MapLayoutNode`](graph-layout-and-geometry.md#maplayoutnode) | struct | Graph, layout and geometry | _Undocumented._ |
| [`MapLayoutOrientation`](graph-layout-and-geometry.md#maplayoutorientation) | enum | Graph, layout and geometry | _Undocumented._ |
| [`MapLayoutRequest`](graph-layout-and-geometry.md#maplayoutrequest) | struct | Graph, layout and geometry | _Undocumented._ |
| [`MapNode`](graph-layout-and-geometry.md#mapnode) | class | Graph, layout and geometry | _Undocumented._ |
| [`NormalizedMapPosition`](graph-layout-and-geometry.md#normalizedmapposition) | struct | Graph, layout and geometry | An integer-normalized map position. |
| [`FileMapSaveAdapter`](saving-and-migration.md#filemapsaveadapter) | class | Saving and migration | Rooted file persistence. |
| [`IMapSaveAdapter`](saving-and-migration.md#imapsaveadapter) | interface | Saving and migration | _Undocumented._ |
| [`IMapSaveMigration`](saving-and-migration.md#imapsavemigration) | interface | Saving and migration | _Undocumented._ |
| [`MapSaveEnvelope`](saving-and-migration.md#mapsaveenvelope) | class | Saving and migration | A complete, versioned graph and traversal snapshot. |
| [`MapSaveFailureKind`](saving-and-migration.md#mapsavefailurekind) | enum | Saving and migration | _Undocumented._ |
| [`MapSaveOperationResult`](saving-and-migration.md#mapsaveoperationresult) | class | Saving and migration | _Undocumented._ |
| [`MapSaveReadResult`](saving-and-migration.md#mapsavereadresult) | class | Saving and migration | _Undocumented._ |
| [`MapSaveRecoverySource`](saving-and-migration.md#mapsaverecoverysource) | enum | Saving and migration | _Undocumented._ |
| [`MapSaveSerializationResult`](saving-and-migration.md#mapsaveserializationresult) | class | Saving and migration | _Undocumented._ |
| [`MapSaveSerializer`](saving-and-migration.md#mapsaveserializer) | class | Saving and migration | Strict, culture-invariant JSON persistence for complete map save envelopes. |
| [`MapSaveV1ToV2Migration`](saving-and-migration.md#mapsavev1tov2migration) | class | Saving and migration | Save format 1 had no customer metadata field. |
| [`MemoryMapSaveAdapter`](saving-and-migration.md#memorymapsaveadapter) | class | Saving and migration | An in-memory adapter that stores canonical JSON rather than live object references. |
| [`MapBlueprintPersistence`](editor-tools.md#mapblueprintpersistence) | class | Editor tools | _Undocumented._ |
| [`MapBlueprintPersistenceResult`](editor-tools.md#mapblueprintpersistenceresult) | class | Editor tools | _Undocumented._ |
| [`MapBlueprintSourceToken`](editor-tools.md#mapblueprintsourcetoken) | class | Editor tools | _Undocumented._ |
| [`MapRuntimeRendererSelection`](editor-tools.md#mapruntimerendererselection) | enum | Editor tools | _Undocumented._ |
| [`MapSetupConfigurationCodes`](editor-tools.md#mapsetupconfigurationcodes) | class | Editor tools | _Undocumented._ |
| [`MapSetupConfigurationResult`](editor-tools.md#mapsetupconfigurationresult) | class | Editor tools | _Undocumented._ |
| [`MapSetupConfigurator`](editor-tools.md#mapsetupconfigurator) | class | Editor tools | _Undocumented._ |
| [`MapSetupDiagnosticCodes`](editor-tools.md#mapsetupdiagnosticcodes) | class | Editor tools | _Undocumented._ |
| [`MapSetupValidationRequest`](editor-tools.md#mapsetupvalidationrequest) | class | Editor tools | _Undocumented._ |
| [`MapSetupValidator`](editor-tools.md#mapsetupvalidator) | class | Editor tools | _Undocumented._ |
| [`MapSetupWizard`](editor-tools.md#mapsetupwizard) | class | Editor tools | _Undocumented._ |
| [`MapStarterAssetFactory`](editor-tools.md#mapstarterassetfactory) | class | Editor tools | _Undocumented._ |
| [`MapStarterAssetResult`](editor-tools.md#mapstarterassetresult) | class | Editor tools | _Undocumented._ |
| [`MapStudioAuditCoordinator`](editor-tools.md#mapstudioauditcoordinator) | class | Editor tools | Owns one window audit operation. |
| [`MapStudioAuditOperation`](editor-tools.md#mapstudioauditoperation) | class | Editor tools | _Undocumented._ |
| [`MapStudioAuditResult`](editor-tools.md#mapstudioauditresult) | class | Editor tools | _Undocumented._ |
| [`MapStudioAuditRow`](editor-tools.md#mapstudioauditrow) | class | Editor tools | _Undocumented._ |
| [`MapStudioAuditStatistics`](editor-tools.md#mapstudioauditstatistics) | class | Editor tools | _Undocumented._ |
| [`MapStudioCommandResult`](editor-tools.md#mapstudiocommandresult) | class | Editor tools | _Undocumented._ |
| [`MapStudioDiagnosticCodes`](editor-tools.md#mapstudiodiagnosticcodes) | class | Editor tools | _Undocumented._ |
| [`MapStudioFocus`](editor-tools.md#mapstudiofocus) | class | Editor tools | _Undocumented._ |
| [`MapStudioGraphStatistics`](editor-tools.md#mapstudiographstatistics) | class | Editor tools | _Undocumented._ |
| [`MapStudioGraphView`](editor-tools.md#mapstudiographview) | class | Editor tools | _Undocumented._ |
| [`MapStudioJson`](editor-tools.md#mapstudiojson) | class | Editor tools | _Undocumented._ |
| [`MapStudioNodeVisuals`](editor-tools.md#mapstudionodevisuals) | class | Editor tools | Pure mapping from a compiled node type and the editor state flags to the visuals of one Map Studio graph node button. |
| [`MapStudioSeedAudit`](editor-tools.md#mapstudioseedaudit) | class | Editor tools | _Undocumented._ |
| [`MapStudioSeedHistoryEntry`](editor-tools.md#mapstudioseedhistoryentry) | class | Editor tools | _Undocumented._ |
| [`MapStudioSession`](editor-tools.md#mapstudiosession) | class | Editor tools | _Undocumented._ |
| [`MapStudioSnapshot`](editor-tools.md#mapstudiosnapshot) | class | Editor tools | _Undocumented._ |
| [`MapStudioWindow`](editor-tools.md#mapstudiowindow) | class | Editor tools | _Undocumented._ |
| [`SampleSceneMenuItems`](editor-tools.md#samplescenemenuitems) | class | Editor tools | _Undocumented._ |
| [`MapDevelopmentOverlay`](determinism-and-diagnostics.md#mapdevelopmentoverlay) | class | Determinism and diagnostics | _Undocumented._ |
| [`MapDiagnostic`](determinism-and-diagnostics.md#mapdiagnostic) | class | Determinism and diagnostics | _Undocumented._ |
| [`StableId`](determinism-and-diagnostics.md#stableid) | struct | Determinism and diagnostics | A stable, serialization-safe identifier. |
| [`BranchWeaverSampleKind`](other.md#branchweaversamplekind) | enum | Other | _Undocumented._ |
| [`DeterministicRandomState`](other.md#deterministicrandomstate) | struct | Other | _Undocumented._ |
| [`IMapGenerator`](other.md#imapgenerator) | interface | Other | _Undocumented._ |
| [`IMapValidator`](other.md#imapvalidator) | interface | Other | _Undocumented._ |
| [`LayerNodeRange`](other.md#layernoderange) | struct | Other | _Undocumented._ |
| [`MapDiagnosticCodes`](other.md#mapdiagnosticcodes) | class | Other | _Undocumented._ |
| [`MapDiagnosticSeverity`](other.md#mapdiagnosticseverity) | enum | Other | _Undocumented._ |
| [`MapFingerprint`](other.md#mapfingerprint) | class | Other | Versioned, domain-separated, big-endian canonical SHA-256 fingerprints. |
| [`MapGenerationManifest`](other.md#mapgenerationmanifest) | class | Other | _Undocumented._ |
| [`MapNodePayload`](other.md#mapnodepayload) | class | Other | _Undocumented._ |
| [`MapProperty`](other.md#mapproperty) | struct | Other | _Undocumented._ |
| [`MapPropertyKind`](other.md#mappropertykind) | enum | Other | _Undocumented._ |
| [`MapPropertyValue`](other.md#mappropertyvalue) | struct | Other | A Unity-independent tagged value used by map payloads. |
| [`MapRuleSnapshot`](other.md#maprulesnapshot) | class | Other | Immutable, engine-independent rules compiled from future authoring assets. |
| [`SampleMapBuildResult`](other.md#samplemapbuildresult) | class | Other | Immutable result of compiling and generating a shipped sample. |
| [`SampleMapCatalog`](other.md#samplemapcatalog) | class | Other | Compiles the editable sample assets into deterministic runtime snapshots. |
| [`SampleSceneBootstrap`](other.md#samplescenebootstrap) | class | Other | Self-contained sample host. |
| [`SampleTraveler`](other.md#sampletraveler) | class | Other | The animated hero that stands on the current node of the active sample presentation. |
| [`SampleViewFit`](other.md#sampleviewfit) | class | Other | Pure math helpers that fit a presented map inside a canvas viewport. |
| [`SpriteSheetAnimator`](other.md#spritesheetanimator) | class | Other | Plays a sprite-sheet idle loop on either a uGUI `mage` or a `priteRenderer` living on the same GameObject. |
| [`XorShift32Random`](other.md#xorshift32random) | class | Other | Version 1 of BranchWeaver's deterministic random stream. |

</div>

