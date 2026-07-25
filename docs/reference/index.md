# API reference

The types you are meant to use in BranchWeaver, grouped by what they are for rather than by namespace. **169 types.**

!!! info "What is not listed here"
    77 further types are public in the source but left out of this reference. They are public only because `internal` is per-assembly in C# and the package spans several assemblies -- plumbing, not API. They carry `[EditorBrowsable(Never)]` in the source to say so. Nothing you need is hidden: if a documented type exposes it, it is documented too.

## Start here

The types a new project meets first.

| Type | Area | What it is for |
| --- | --- | --- |
| [`LayeredMapGenerator`](getting-a-map.md#layeredmapgenerator) | Getting a map | Generator version 1. |
| [`MapGenerationMode`](getting-a-map.md#mapgenerationmode) | Getting a map | How much of a map a generation request may invent for itself, and therefore what role `apGenerationOverrides` plays: Procedural rejects overrides outright, Manual builds nothing th... |
| [`MapGenerationRequest`](getting-a-map.md#mapgenerationrequest) | Getting a map | _Undocumented._ |
| [`MapGenerationResult`](getting-a-map.md#mapgenerationresult) | Getting a map | _Undocumented._ |
| [`MapProgressionState`](traversal-and-progression.md#mapprogressionstate) | Traversal and progression | An immutable traversal snapshot. |
| [`MapSession`](traversal-and-progression.md#mapsession) | Traversal and progression | Standalone traversal orchestration over immutable graph and progression snapshots. |
| [`MapTransitionEvent`](traversal-and-progression.md#maptransitionevent) | Traversal and progression | _Undocumented._ |
| [`MapAuthoringCompiler`](authoring-assets.md#mapauthoringcompiler) | Authoring assets | _Undocumented._ |
| [`MapBlueprintAsset`](authoring-assets.md#mapblueprintasset) | Authoring assets | _Undocumented._ |
| [`MapNodeTypeAsset`](authoring-assets.md#mapnodetypeasset) | Authoring assets | _Undocumented._ |
| [`MapRulesAsset`](authoring-assets.md#maprulesasset) | Authoring assets | _Undocumented._ |
| [`MapThemeAsset`](authoring-assets.md#mapthemeasset) | Authoring assets | _Undocumented._ |
| [`MapStylePreset`](styling-and-appearance.md#mapstylepreset) | Styling and appearance | Everything the map draws itself with, in one asset: palette, node shape and treatment, per-state emphasis, edge stroke, backdrop, typography, motion, and on-screen framing. |
| [`CanvasMapPresenter`](presentation-and-views.md#canvasmappresenter) | Presentation and views | _Undocumented._ |
| [`IMapEdgeView`](presentation-and-views.md#imapedgeview) | Presentation and views | The contract for anything that draws a single map edge. |
| [`IMapEdgeViewFactory`](presentation-and-views.md#imapedgeviewfactory) | Presentation and views | Creates and recycles the edge views a presenter draws with — the same seam as `MapNodeViewFactory`, for routes instead of nodes. |
| [`IMapNodeView`](presentation-and-views.md#imapnodeview) | Presentation and views | The contract for anything that draws a single map node. |
| [`IMapNodeViewFactory`](presentation-and-views.md#imapnodeviewfactory) | Presentation and views | Creates and recycles the node views a presenter draws with. |
| [`MapEdgeViewData`](presentation-and-views.md#mapedgeviewdata) | Presentation and views | Everything an edge view needs to draw one route in one presented state: the graph edge, the sampled path along it, the colour to draw it in, and its fog state. |
| [`MapInputController`](presentation-and-views.md#mapinputcontroller) | Presentation and views | The component that turns input frames into map interaction: it moves focus between nodes, submits the focused or pressed node to a `apTraversalController`, and pans and zooms the c... |
| [`MapNodeViewData`](presentation-and-views.md#mapnodeviewdata) | Presentation and views | Everything a node view needs to draw one node in one presented state: the graph node, where it sits, its compiled type, and its visual and fog state. |
| [`MapRuntimeContent`](presentation-and-views.md#mapruntimecontent) | Presentation and views | _Undocumented._ |
| [`MapTraversalController`](presentation-and-views.md#maptraversalcontroller) | Presentation and views | _Undocumented._ |
| [`WorldMapPresenter`](presentation-and-views.md#worldmappresenter) | Presentation and views | _Undocumented._ |
| [`ValidationReport`](rules-and-constraints.md#validationreport) | Rules and constraints | _Undocumented._ |
| [`MapGraph`](graph-layout-and-geometry.md#mapgraph) | Graph, layout and geometry | An immutable graph snapshot. |
| [`MapNode`](graph-layout-and-geometry.md#mapnode) | Graph, layout and geometry | _Undocumented._ |
| [`IMapSaveAdapter`](saving-and-migration.md#imapsaveadapter) | Saving and migration | The storage boundary for map saves: read, write, and delete one slot of complete save data. |
| [`MapSaveEnvelope`](saving-and-migration.md#mapsaveenvelope) | Saving and migration | A complete, versioned graph and traversal snapshot. |
| [`MapDiagnostic`](determinism-and-diagnostics.md#mapdiagnostic) | Determinism and diagnostics | _Undocumented._ |
| [`StableId`](determinism-and-diagnostics.md#stableid) | Determinism and diagnostics | A stable, serialization-safe identifier. |
| [`IMapGenerator`](other.md#imapgenerator) | Other | _Undocumented._ |
| [`MapRuleSnapshot`](other.md#maprulesnapshot) | Other | Immutable, engine-independent rules compiled from future authoring assets. |

## Every type

!!! tip "Filter as you type"
    Start typing in the box below to narrow the table. Use the search icon in the header to search the whole site instead.

<input type="text" id="api-filter" class="api-filter" placeholder="Filter types, groups, or descriptions..." autocomplete="off" aria-label="Filter API types">
<p id="api-filter-count" class="api-filter-count"></p>

<div class="api-table" markdown>

| Type | Kind | Area | What it is for |
| --- | --- | --- | --- |
| [`EdgeGenerationOverride`](getting-a-map.md#edgegenerationoverride) | struct | Getting a map | One authored constraint on a single slot-to-slot connection: require it and fix the ID the edge will carry, or forbid it. |
| [`EdgeOverrideDisposition`](getting-a-map.md#edgeoverridedisposition) | enum | Getting a map | Whether an edge override demands a connection or bans one. |
| [`LayeredMapGenerator`](getting-a-map.md#layeredmapgenerator) | class | Getting a map | Generator version 1. |
| [`MapGenerationFailureKind`](getting-a-map.md#mapgenerationfailurekind) | enum | Getting a map | _Undocumented._ |
| [`MapGenerationMode`](getting-a-map.md#mapgenerationmode) | enum | Getting a map | How much of a map a generation request may invent for itself, and therefore what role `apGenerationOverrides` plays: Procedural rejects overrides outright, Manual builds nothing th... |
| [`MapGenerationOverrides`](getting-a-map.md#mapgenerationoverrides) | class | Getting a map | The complete set of authoring overrides carried by one generation request: pinned nodes and edge dispositions, copied out of the sequences you pass and sorted into canonical order,... |
| [`MapGenerationRequest`](getting-a-map.md#mapgenerationrequest) | class | Getting a map | _Undocumented._ |
| [`MapGenerationResult`](getting-a-map.md#mapgenerationresult) | class | Getting a map | _Undocumented._ |
| [`MapGenerationSearchOptions`](getting-a-map.md#mapgenerationsearchoptions) | class | Getting a map | _Undocumented._ |
| [`MapGenerationStatistics`](getting-a-map.md#mapgenerationstatistics) | class | Getting a map | _Undocumented._ |
| [`PinnedNodeFields`](getting-a-map.md#pinnednodefields) | enum | Getting a map | Which of a pinned node's authored values the generator must reproduce exactly. |
| [`PinnedNodeOverride`](getting-a-map.md#pinnednodeoverride) | struct | Getting a map | One authored node pinned to a map slot: the identity that slot must hold, plus whichever of its type, position, and payload the generator is not free to choose. |
| [`MapDataPayload`](traversal-and-progression.md#mapdatapayload) | class | Traversal and progression | Generic tagged data for traversal results and customer-owned save metadata. |
| [`MapNodeCompletion`](traversal-and-progression.md#mapnodecompletion) | class | Traversal and progression | _Undocumented._ |
| [`MapProgressionState`](traversal-and-progression.md#mapprogressionstate) | class | Traversal and progression | An immutable traversal snapshot. |
| [`MapSession`](traversal-and-progression.md#mapsession) | class | Traversal and progression | Standalone traversal orchestration over immutable graph and progression snapshots. |
| [`MapTransitionEvent`](traversal-and-progression.md#maptransitionevent) | class | Traversal and progression | _Undocumented._ |
| [`MapTransitionEventKind`](traversal-and-progression.md#maptransitioneventkind) | enum | Traversal and progression | _Undocumented._ |
| [`MapTransitionFailureKind`](traversal-and-progression.md#maptransitionfailurekind) | enum | Traversal and progression | _Undocumented._ |
| [`MapTransitionResult`](traversal-and-progression.md#maptransitionresult) | class | Traversal and progression | _Undocumented._ |
| [`CompiledMapNodeType`](authoring-assets.md#compiledmapnodetype) | class | Authoring assets | _Undocumented._ |
| [`CompiledMapTheme`](authoring-assets.md#compiledmaptheme) | class | Authoring assets | _Undocumented._ |
| [`MapAuthoringCompiler`](authoring-assets.md#mapauthoringcompiler) | class | Authoring assets | _Undocumented._ |
| [`MapBlueprintAsset`](authoring-assets.md#mapblueprintasset) | class | Authoring assets | _Undocumented._ |
| [`MapBlueprintCompilation`](authoring-assets.md#mapblueprintcompilation) | class | Authoring assets | _Undocumented._ |
| [`MapConstraintAsset`](authoring-assets.md#mapconstraintasset) | class | Authoring assets | _Undocumented._ |
| [`MapEdgeGeometryKind`](authoring-assets.md#mapedgegeometrykind) | enum | Authoring assets | _Undocumented._ |
| [`MapFlowDirection`](authoring-assets.md#mapflowdirection) | enum | Authoring assets | Which screen direction the map's progress runs in. |
| [`MapLayoutOrientation`](authoring-assets.md#maplayoutorientation) | enum | Authoring assets | _Undocumented._ |
| [`MapNodeTypeAsset`](authoring-assets.md#mapnodetypeasset) | class | Authoring assets | _Undocumented._ |
| [`MapNodeTypeCompilation`](authoring-assets.md#mapnodetypecompilation) | class | Authoring assets | _Undocumented._ |
| [`MapPropertyAuthoring`](authoring-assets.md#mappropertyauthoring) | class | Authoring assets | _Undocumented._ |
| [`MapRulesAsset`](authoring-assets.md#maprulesasset) | class | Authoring assets | _Undocumented._ |
| [`MapRulesCompilation`](authoring-assets.md#maprulescompilation) | class | Authoring assets | _Undocumented._ |
| [`MapThemeAsset`](authoring-assets.md#mapthemeasset) | class | Authoring assets | _Undocumented._ |
| [`MapThemeCompilation`](authoring-assets.md#mapthemecompilation) | class | Authoring assets | _Undocumented._ |
| [`MapThemeLimits`](authoring-assets.md#mapthemelimits) | class | Authoring assets | _Undocumented._ |
| [`CompiledMapStyle`](styling-and-appearance.md#compiledmapstyle) | class | Styling and appearance | The immutable style the views read. |
| [`IMapStyledView`](styling-and-appearance.md#imapstyledview) | interface | Styling and appearance | Implemented by a view that can be dressed by a map style and advanced by a visual clock. |
| [`MapBackdropTokens`](styling-and-appearance.md#mapbackdroptokens) | struct | Styling and appearance | The backdrop drawn behind the map. |
| [`MapEasing`](styling-and-appearance.md#mapeasing) | enum | Styling and appearance | Easing curve for a styled transition. |
| [`MapEdgeCap`](styling-and-appearance.md#mapedgecap) | enum | Styling and appearance | End treatment for a drawn edge. |
| [`MapEdgeStyleTokens`](styling-and-appearance.md#mapedgestyletokens) | struct | Styling and appearance | How routes between nodes are drawn. |
| [`MapFillMode`](styling-and-appearance.md#mapfillmode) | enum | Styling and appearance | How a surface fills its area. |
| [`MapFitMode`](styling-and-appearance.md#mapfitmode) | enum | Styling and appearance | How the map is fitted into the area it is given. |
| [`MapFramingTokens`](styling-and-appearance.md#mapframingtokens) | struct | Styling and appearance | Where the map sits inside the area it is given, and how far the player may pan and zoom. |
| [`MapMotionTokens`](styling-and-appearance.md#mapmotiontokens) | struct | Styling and appearance | Transition timings. |
| [`MapNodeShape`](styling-and-appearance.md#mapnodeshape) | enum | Styling and appearance | Silhouette drawn for a map node. |
| [`MapNodeStateStyle`](styling-and-appearance.md#mapnodestatestyle) | struct | Styling and appearance | Per-state treatment layered over the shared node style. |
| [`MapNodeStyleTokens`](styling-and-appearance.md#mapnodestyletokens) | struct | Styling and appearance | Shape and size shared by every node before per-state treatment. |
| [`MapPaletteTokens`](styling-and-appearance.md#mappalettetokens) | struct | Styling and appearance | The semantic colour roles a style assigns once and reuses everywhere. |
| [`MapStyleDefaults`](styling-and-appearance.md#mapstyledefaults) | class | Styling and appearance | The shipped map styles, defined in code rather than as serialized assets. |
| [`MapStylePreset`](styling-and-appearance.md#mapstylepreset) | class | Styling and appearance | Everything the map draws itself with, in one asset: palette, node shape and treatment, per-state emphasis, edge stroke, backdrop, typography, motion, and on-screen framing. |
| [`MapSurfaceGraphic`](styling-and-appearance.md#mapsurfacegraphic) | class | Styling and appearance | Draws one styled map surface as a uGUI graphic through the BranchWeaver map surface shader. |
| [`MapSurfaceTokens`](styling-and-appearance.md#mapsurfacetokens) | struct | Styling and appearance | Fill, stroke, glow, and shadow for a drawn surface. |
| [`MapTypographyTokens`](styling-and-appearance.md#maptypographytokens) | struct | Styling and appearance | Label sizing and treatment. |
| [`CanvasMapEdgeView`](presentation-and-views.md#canvasmapedgeview) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapNodeView`](presentation-and-views.md#canvasmapnodeview) | class | Presentation and views | _Undocumented._ |
| [`CanvasMapPresenter`](presentation-and-views.md#canvasmappresenter) | class | Presentation and views | _Undocumented._ |
| [`DefaultMapNodeHitTester`](presentation-and-views.md#defaultmapnodehittester) | class | Presentation and views | The shipped hit tester. |
| [`IMapAudioCueAdapter`](presentation-and-views.md#imapaudiocueadapter) | interface | Presentation and views | Plays the cue ids authored on node types, so the package never has to know which audio system a project uses. |
| [`IMapBackgroundPresenter`](presentation-and-views.md#imapbackgroundpresenter) | interface | Presentation and views | Optional hook for drawing whatever sits behind the map: a backdrop image, a parallax layer, a shader quad. |
| [`IMapDevelopmentHost`](presentation-and-views.md#imapdevelopmenthost) | interface | Presentation and views | The command surface behind the development overlay: reveal, unlock, teleport, reset, force a result, regenerate, and copy the generation manifest. |
| [`IMapEdgeAvailabilityView`](presentation-and-views.md#imapedgeavailabilityview) | interface | Presentation and views | Implemented by an edge view that can emphasize routes leading to a reachable node. |
| [`IMapEdgeTransitionView`](presentation-and-views.md#imapedgetransitionview) | interface | Presentation and views | Optional on an `MapEdgeView`: the edge counterpart of `MapNodeTransitionView`, driven in the same order and under the same condition that no `MapPresentationTransitionAdapter` is i... |
| [`IMapEdgeView`](presentation-and-views.md#imapedgeview) | interface | Presentation and views | The contract for anything that draws a single map edge. |
| [`IMapEdgeViewFactory`](presentation-and-views.md#imapedgeviewfactory) | interface | Presentation and views | Creates and recycles the edge views a presenter draws with — the same seam as `MapNodeViewFactory`, for routes instead of nodes. |
| [`IMapFocusIndicatorPresenter`](presentation-and-views.md#imapfocusindicatorpresenter) | interface | Presentation and views | Optional hook for one shared focus indicator drawn at the focused node, as an alternative to every node styling its own focus. |
| [`IMapFocusView`](presentation-and-views.md#imapfocusview) | interface | Presentation and views | Optional on an `MapNodeView`: lets a view show keyboard or gamepad focus. |
| [`IMapInputSource`](presentation-and-views.md#imapinputsource) | interface | Presentation and views | Supplies the map with input frames. |
| [`IMapLocalizationAdapter`](presentation-and-views.md#imaplocalizationadapter) | interface | Presentation and views | Bridges node labels and tooltips to whatever localization system a project already uses. |
| [`IMapNodeHitState`](presentation-and-views.md#imapnodehitstate) | interface | Presentation and views | Optional on an `MapNodeView`: lets the view decide for itself whether it can be clicked. |
| [`IMapNodeHitTester`](presentation-and-views.md#imapnodehittester) | interface | Presentation and views | Resolves a screen position to a map node. |
| [`IMapNodeTransitionView`](presentation-and-views.md#imapnodetransitionview) | interface | Presentation and views | Optional on an `MapNodeView`: lets a view animate its own state changes, which is how the shipped node views cross-fade. |
| [`IMapNodeView`](presentation-and-views.md#imapnodeview) | interface | Presentation and views | The contract for anything that draws a single map node. |
| [`IMapNodeViewFactory`](presentation-and-views.md#imapnodeviewfactory) | interface | Presentation and views | Creates and recycles the node views a presenter draws with. |
| [`IMapPresentationTransitionAdapter`](presentation-and-views.md#imappresentationtransitionadapter) | interface | Presentation and views | Takes over every node and edge state transition for the whole map, as an alternative to letting each view animate itself. |
| [`IMapViewFactoryLifetime`](presentation-and-views.md#imapviewfactorylifetime) | interface | Presentation and views | Optional lifetime contract used only for factories created and owned by a presenter. |
| [`IPlayerPawnPresenter`](presentation-and-views.md#iplayerpawnpresenter) | interface | Presentation and views | Optional hook for drawing the traveller's own marker on the map. |
| [`IRouteMarkerPresenter`](presentation-and-views.md#iroutemarkerpresenter) | interface | Presentation and views | Optional hook for marking the route already walked: footprints, a trail, a drawn line. |
| [`InputSystemSignalAdapter`](presentation-and-views.md#inputsystemsignaladapter) | class | Presentation and views | Package-neutral bridge for Input System PlayerInput UnityEvents. |
| [`LegacyMapInputSource`](presentation-and-views.md#legacymapinputsource) | class | Presentation and views | Input source for Unity's legacy Input Manager: axes for navigation, Return, Space or the Submit button for activation, the mouse for pointing, middle-drag to pan and the wheel to z... |
| [`MapDevelopmentCommandResult`](presentation-and-views.md#mapdevelopmentcommandresult) | class | Presentation and views | The outcome of one development command: success, optionally carrying a value, or a refusal with a reason fit to show in a debug overlay. |
| [`MapDevelopmentFailureKind`](presentation-and-views.md#mapdevelopmentfailurekind) | enum | Presentation and views | Why a development command was refused. |
| [`MapEdgeViewData`](presentation-and-views.md#mapedgeviewdata) | struct | Presentation and views | Everything an edge view needs to draw one route in one presented state: the graph edge, the sampled path along it, the colour to draw it in, and its fog state. |
| [`MapFogSettings`](presentation-and-views.md#mapfogsettings) | struct | Presentation and views | How far ahead of the traveller the map is revealed. |
| [`MapFogState`](presentation-and-views.md#mapfogstate) | enum | Presentation and views | How visible a node is, derived from its `apNodeVisualState`: a hidden node reports `idden`, a locked one `immed`, and anything the traveller has reached or can reach `isible`. |
| [`MapInputController`](presentation-and-views.md#mapinputcontroller) | class | Presentation and views | The component that turns input frames into map interaction: it moves focus between nodes, submits the focused or pressed node to a `apTraversalController`, and pans and zooms the c... |
| [`MapInputFrame`](presentation-and-views.md#mapinputframe) | struct | Presentation and views | One update's worth of map input, reduced to the six signals the controller acts on: a directional axis, a submit request, a pointer, pan and zoom deltas, and a pinch flag. |
| [`MapNavigationDirection`](presentation-and-views.md#mapnavigationdirection) | enum | Presentation and views | _Undocumented._ |
| [`MapNavigationModel`](presentation-and-views.md#mapnavigationmodel) | class | Presentation and views | _Undocumented._ |
| [`MapNodeRuntimeState`](presentation-and-views.md#mapnoderuntimestate) | struct | Presentation and views | One node's derived display state: the visual state a presenter styles it with, plus the fog state that decides whether it can be seen at all. |
| [`MapNodeViewData`](presentation-and-views.md#mapnodeviewdata) | struct | Presentation and views | Everything a node view needs to draw one node in one presented state: the graph node, where it sits, its compiled type, and its visual and fog state. |
| [`MapNodeVisualState`](presentation-and-views.md#mapnodevisualstate) | enum | Presentation and views | How one node reads to the player, and the state a presenter styles that node with. |
| [`MapPresenterBase`](presentation-and-views.md#mappresenterbase) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeContent`](presentation-and-views.md#mapruntimecontent) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeStateDeriver`](presentation-and-views.md#mapruntimestatederiver) | class | Presentation and views | _Undocumented._ |
| [`MapRuntimeStateSnapshot`](presentation-and-views.md#mapruntimestatesnapshot) | class | Presentation and views | _Undocumented._ |
| [`MapSelectionResult`](presentation-and-views.md#mapselectionresult) | class | Presentation and views | The outcome of asking the controller to move to a node. |
| [`MapSetupHierarchyBinding`](presentation-and-views.md#mapsetuphierarchybinding) | class | Presentation and views | Durable identity for scene objects created and owned by the BranchWeaver setup wizard. |
| [`MapTraversalController`](presentation-and-views.md#maptraversalcontroller) | class | Presentation and views | _Undocumented._ |
| [`PassthroughLocalizationAdapter`](presentation-and-views.md#passthroughlocalizationadapter) | class | Presentation and views | _Undocumented._ |
| [`WorldMapNodeView`](presentation-and-views.md#worldmapnodeview) | class | Presentation and views | _Undocumented._ |
| [`WorldMapPresenter`](presentation-and-views.md#worldmappresenter) | class | Presentation and views | _Undocumented._ |
| [`InputSystemMapInputBridge`](framing-input-and-navigation.md#inputsystemmapinputbridge) | class | Framing, input and navigation | Optional PlayerInput UnityEvent bridge compiled only when com.unity.inputsystem is installed. |
| [`MapAspectClass`](framing-input-and-navigation.md#mapaspectclass) | enum | Framing, input and navigation | _Undocumented._ |
| [`MapFrameResult`](framing-input-and-navigation.md#mapframeresult) | struct | Framing, input and navigation | The resolved on-screen placement of a map: the rectangle it may occupy, the scale that fits its content into that rectangle, and the pan limits that keep it reachable. |
| [`MapSafeAreaController`](framing-input-and-navigation.md#mapsafeareacontroller) | class | Framing, input and navigation | _Undocumented._ |
| [`MapViewportFrame`](framing-input-and-navigation.md#mapviewportframe) | class | Framing, input and navigation | Places a map on screen: reserves margins for your own interface, fits the content, insets into the device safe area, and clamps pan and zoom. |
| [`MapViewportResult`](framing-input-and-navigation.md#mapviewportresult) | struct | Framing, input and navigation | _Undocumented._ |
| [`ConstraintContext`](rules-and-constraints.md#constraintcontext) | class | Rules and constraints | Everything an `MapConstraint` is allowed to see: the frozen rules, every slot and slot edge in the attempt, and the type assignments decided so far. |
| [`ConstraintEvaluationState`](rules-and-constraints.md#constraintevaluationstate) | enum | Rules and constraints | What a custom constraint concluded about the assignment it was shown. |
| [`ConstraintResult`](rules-and-constraints.md#constraintresult) | class | Rules and constraints | One constraint's answer for one evaluation: the state, plus the diagnostic code and message that are reported when the state is `onstraintEvaluationState.Violated`. |
| [`EdgeCrossingPolicy`](rules-and-constraints.md#edgecrossingpolicy) | enum | Rules and constraints | _Undocumented._ |
| [`ForbiddenAdjacencyDirection`](rules-and-constraints.md#forbiddenadjacencydirection) | enum | Rules and constraints | Whether a forbidden adjacency follows edge direction or covers both orderings of its type pair. |
| [`ForbiddenAdjacencyRule`](rules-and-constraints.md#forbiddenadjacencyrule) | struct | Rules and constraints | Bans edges between two node types. |
| [`ForcedNodeTypeRule`](rules-and-constraints.md#forcednodetyperule) | struct | Rules and constraints | Pins one slot to a node type before generation starts, fixing that slot's type instead of drawing it by weight. |
| [`IMapConstraint`](rules-and-constraints.md#imapconstraint) | interface | Rules and constraints | A game-specific rule the generator has to respect. |
| [`MapConnectionRules`](rules-and-constraints.md#mapconnectionrules) | class | Rules and constraints | _Undocumented._ |
| [`MapNodeSlot`](rules-and-constraints.md#mapnodeslot) | struct | Rules and constraints | Addresses one candidate node position in a layered map by layer and by ordinal within that layer. |
| [`MapNodeTypeAssignment`](rules-and-constraints.md#mapnodetypeassignment) | struct | Rules and constraints | One decided slot: where it sits, the identity the node there will carry, and the node type chosen for it. |
| [`MapSlotEdge`](rules-and-constraints.md#mapslotedge) | struct | Rules and constraints | A directed connection between two slots, written in layer-and-ordinal coordinates rather than node IDs -- the shape of a map before its nodes exist. |
| [`MapValidator`](rules-and-constraints.md#mapvalidator) | class | Rules and constraints | _Undocumented._ |
| [`MapZoneDefinition`](rules-and-constraints.md#mapzonedefinition) | class | Rules and constraints | _Undocumented._ |
| [`NodeTypeQuotaRule`](rules-and-constraints.md#nodetypequotarule) | struct | Rules and constraints | A count bound on how many nodes of one type a scope may hold: the whole map when `oneId` is empty, otherwise the layers of the named zone. |
| [`NodeTypeWeight`](rules-and-constraints.md#nodetypeweight) | struct | Rules and constraints | One entry of the map-wide node type table: it declares that a type exists and how often the generator should reach for it. |
| [`NodeTypeWeightOverride`](rules-and-constraints.md#nodetypeweightoverride) | struct | Rules and constraints | _Undocumented._ |
| [`ValidationReport`](rules-and-constraints.md#validationreport) | class | Rules and constraints | _Undocumented._ |
| [`IMapLayoutStrategy`](graph-layout-and-geometry.md#imaplayoutstrategy) | interface | Graph, layout and geometry | _Undocumented._ |
| [`LayeredMapLayoutStrategy`](graph-layout-and-geometry.md#layeredmaplayoutstrategy) | class | Graph, layout and geometry | _Undocumented._ |
| [`MapEdge`](graph-layout-and-geometry.md#mapedge) | struct | Graph, layout and geometry | _Undocumented._ |
| [`MapGraph`](graph-layout-and-geometry.md#mapgraph) | class | Graph, layout and geometry | An immutable graph snapshot. |
| [`MapLayout`](graph-layout-and-geometry.md#maplayout) | class | Graph, layout and geometry | _Undocumented._ |
| [`MapLayoutNode`](graph-layout-and-geometry.md#maplayoutnode) | struct | Graph, layout and geometry | _Undocumented._ |
| [`MapLayoutOrientation`](graph-layout-and-geometry.md#maplayoutorientation) | enum | Graph, layout and geometry | _Undocumented._ |
| [`MapLayoutRequest`](graph-layout-and-geometry.md#maplayoutrequest) | struct | Graph, layout and geometry | _Undocumented._ |
| [`MapNode`](graph-layout-and-geometry.md#mapnode) | class | Graph, layout and geometry | _Undocumented._ |
| [`NormalizedMapPosition`](graph-layout-and-geometry.md#normalizedmapposition) | struct | Graph, layout and geometry | An integer-normalized map position. |
| [`FileMapSaveAdapter`](saving-and-migration.md#filemapsaveadapter) | class | Saving and migration | Rooted file persistence. |
| [`IMapSaveAdapter`](saving-and-migration.md#imapsaveadapter) | interface | Saving and migration | The storage boundary for map saves: read, write, and delete one slot of complete save data. |
| [`IMapSaveMigration`](saving-and-migration.md#imapsavemigration) | interface | Saving and migration | One step of the save upgrade chain: it accepts an envelope at its declared source version and returns the same run at its target version. |
| [`MapSaveEnvelope`](saving-and-migration.md#mapsaveenvelope) | class | Saving and migration | A complete, versioned graph and traversal snapshot. |
| [`MapSaveFailureKind`](saving-and-migration.md#mapsavefailurekind) | enum | Saving and migration | Why a save read, write, or delete did not succeed. |
| [`MapSaveOperationResult`](saving-and-migration.md#mapsaveoperationresult) | class | Saving and migration | The outcome of a save write or delete: whether it committed, the typed reason when it did not, and the diagnostics behind that reason. |
| [`MapSaveReadResult`](saving-and-migration.md#mapsavereadresult) | class | Saving and migration | The outcome of a save read: the loaded envelope, which stored candidate supplied it, and the diagnostics gathered on the way. |
| [`MapSaveRecoverySource`](saving-and-migration.md#mapsaverecoverysource) | enum | Saving and migration | Which stored candidate supplied the bytes of a successful read. |
| [`MapSaveSerializationResult`](saving-and-migration.md#mapsaveserializationresult) | class | Saving and migration | The outcome of one `apSaveSerializer` call, in either direction. |
| [`MapSaveSerializer`](saving-and-migration.md#mapsaveserializer) | class | Saving and migration | Strict, culture-invariant JSON persistence for complete map save envelopes. |
| [`MapSaveV1ToV2Migration`](saving-and-migration.md#mapsavev1tov2migration) | class | Saving and migration | Save format 1 had no customer metadata field. |
| [`MemoryMapSaveAdapter`](saving-and-migration.md#memorymapsaveadapter) | class | Saving and migration | An in-memory adapter that stores canonical JSON rather than live object references. |
| [`MapStudioCommandResult`](editor-tools.md#mapstudiocommandresult) | class | Editor tools | _Undocumented._ |
| [`MapStudioSession`](editor-tools.md#mapstudiosession) | class | Editor tools | _Undocumented._ |
| [`MapStudioSnapshot`](editor-tools.md#mapstudiosnapshot) | class | Editor tools | _Undocumented._ |
| [`MapDevelopmentOverlay`](determinism-and-diagnostics.md#mapdevelopmentoverlay) | class | Determinism and diagnostics | _Undocumented._ |
| [`MapDiagnostic`](determinism-and-diagnostics.md#mapdiagnostic) | class | Determinism and diagnostics | _Undocumented._ |
| [`StableId`](determinism-and-diagnostics.md#stableid) | struct | Determinism and diagnostics | A stable, serialization-safe identifier. |
| [`IMapGenerator`](other.md#imapgenerator) | interface | Other | _Undocumented._ |
| [`IMapValidator`](other.md#imapvalidator) | interface | Other | _Undocumented._ |
| [`LayerNodeRange`](other.md#layernoderange) | struct | Other | _Undocumented._ |
| [`MapDiagnosticSeverity`](other.md#mapdiagnosticseverity) | enum | Other | _Undocumented._ |
| [`MapFingerprint`](other.md#mapfingerprint) | class | Other | Versioned, domain-separated, big-endian canonical SHA-256 fingerprints. |
| [`MapGenerationManifest`](other.md#mapgenerationmanifest) | class | Other | _Undocumented._ |
| [`MapNodePayload`](other.md#mapnodepayload) | class | Other | _Undocumented._ |
| [`MapProperty`](other.md#mapproperty) | struct | Other | _Undocumented._ |
| [`MapPropertyKind`](other.md#mappropertykind) | enum | Other | _Undocumented._ |
| [`MapPropertyValue`](other.md#mappropertyvalue) | struct | Other | A Unity-independent tagged value used by map payloads. |
| [`MapRuleSnapshot`](other.md#maprulesnapshot) | class | Other | Immutable, engine-independent rules compiled from future authoring assets. |
| [`SampleSceneBootstrap`](other.md#samplescenebootstrap) | class | Other | Self-contained sample host. |
| [`XorShift32Random`](other.md#xorshift32random) | class | Other | Version 1 of BranchWeaver's deterministic random stream. |

</div>

