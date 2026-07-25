# API reference

The types you are meant to use in BranchWeaver, grouped by what they are for rather than by namespace. **175 types.**

!!! info "What is not listed here"
    70 further types are public in the source but left out of this reference. They are public only because `internal` is per-assembly in C# and the package spans several assemblies -- plumbing, not API. They carry `[EditorBrowsable(Never)]` in the source to say so. Nothing you need is hidden: if a documented type exposes it, it is documented too.

## Start here

The types a new project meets first.

| Type | Area | What it is for |
| --- | --- | --- |
| [`LayeredMapGenerator`](getting-a-map.md#layeredmapgenerator) | Getting a map | Generator version 1. |
| [`MapGenerationMode`](getting-a-map.md#mapgenerationmode) | Getting a map | How much of a map a generation request may invent for itself, and therefore what role `MapGenerationOverrides` plays: Procedural rejects overrides outright, Manual builds nothing t... |
| [`MapGenerationRequest`](getting-a-map.md#mapgenerationrequest) | Getting a map | Everything one generation attempt needs, in one immutable object: the compiled rules, the seed, how much of the map the generator may invent, the authoring overrides it must honour... |
| [`MapGenerationResult`](getting-a-map.md#mapgenerationresult) | Getting a map | The single outcome of a generation attempt: on success a complete graph and its `MapGenerationManifest`, on failure a `MapGenerationFailureKind` naming what went wrong, and either ... |
| [`MapProgressionState`](traversal-and-progression.md#mapprogressionstate) | Traversal and progression | An immutable traversal snapshot. |
| [`MapSession`](traversal-and-progression.md#mapsession) | Traversal and progression | Standalone traversal orchestration over immutable graph and progression snapshots. |
| [`MapTransitionEvent`](traversal-and-progression.md#maptransitionevent) | Traversal and progression | One immutable thing that happened during a traversal transition: a node was entered or completed, the choosable set changed, or the run ended. |
| [`MapAuthoringCompiler`](authoring-assets.md#mapauthoringcompiler) | Authoring assets | Turns authoring assets into the immutable compiled types the runtime works with: node types, themes, rule snapshots, and blueprints. |
| [`MapBlueprintAsset`](authoring-assets.md#mapblueprintasset) | Authoring assets | The saved form of one map: the rules it came from, the mode and seed it was generated with, the complete node and edge rows the editor persisted, the budgets a regeneration is allo... |
| [`MapNodeTypeAsset`](authoring-assets.md#mapnodetypeasset) | Authoring assets | One kind of node a map may contain: its stable identity, the label and tooltip shown for it, the prefabs, icon, and per-state colors the built-in views draw it with, and the defaul... |
| [`MapRulesAsset`](authoring-assets.md#maprulesasset) | Authoring assets | The inspector-authored ruleset every BranchWeaver map is generated from: how many nodes each layer may hold, which node types may appear and how often they are chosen, the zones th... |
| [`MapThemeAsset`](authoring-assets.md#mapthemeasset) | Authoring assets | The authored asset that decides how a generated map is laid out and drawn: layer and node spacing, which axis the layers run along, how edges are shaped, the two colours the built-... |
| [`MapStylePreset`](styling-and-appearance.md#mapstylepreset) | Styling and appearance | Everything the map draws itself with, in one asset: palette, node shape and treatment, per-state emphasis, edge stroke, backdrop, typography, motion, and on-screen framing. |
| [`CanvasMapPresenter`](presentation-and-views.md#canvasmappresenter) | Presentation and views | Draws a map inside a uGUI Canvas. |
| [`IMapEdgeView`](presentation-and-views.md#imapedgeview) | Presentation and views | The contract for anything that draws a single map edge. |
| [`IMapEdgeViewFactory`](presentation-and-views.md#imapedgeviewfactory) | Presentation and views | Creates and recycles the edge views a presenter draws with - the same seam as `IMapNodeViewFactory`, for routes instead of nodes. |
| [`IMapNodeView`](presentation-and-views.md#imapnodeview) | Presentation and views | The contract for anything that draws a single map node. |
| [`IMapNodeViewFactory`](presentation-and-views.md#imapnodeviewfactory) | Presentation and views | Creates and recycles the node views a presenter draws with. |
| [`MapEdgeViewData`](presentation-and-views.md#mapedgeviewdata) | Presentation and views | Everything an edge view needs to draw one route in one presented state: the graph edge, the sampled path along it, the colour to draw it in, and its fog state. |
| [`MapInputController`](presentation-and-views.md#mapinputcontroller) | Presentation and views | The component that turns input frames into map interaction: it moves focus between nodes, submits the focused or pressed node to a `MapTraversalController`, and pans and zooms the ... |
| [`MapNodeViewData`](presentation-and-views.md#mapnodeviewdata) | Presentation and views | Everything a node view needs to draw one node in one presented state: the graph node, where it sits, its compiled type, and its visual and fog state. |
| [`MapRuntimeContent`](presentation-and-views.md#mapruntimecontent) | Presentation and views | Everything needed to draw a map that the graph itself does not carry: the node types its type IDs resolve to, and the theme they are laid out and styled with. |
| [`MapTraversalController`](presentation-and-views.md#maptraversalcontroller) | Presentation and views | The scene component that owns one traversal run: it holds the graph, the progression, and the compiled content, applies every move through a `MapSession`, and reports what happened... |
| [`WorldMapPresenter`](presentation-and-views.md#worldmappresenter) | Presentation and views | Draws a map as ordinary scene objects rather than UI. |
| [`ValidationReport`](rules-and-constraints.md#validationreport) | Rules and constraints | Everything one validation pass had to say, plus the single number that decides whether the pass succeeded. |
| [`MapGraph`](graph-layout-and-geometry.md#mapgraph) | Graph, layout and geometry | An immutable graph snapshot. |
| [`MapNode`](graph-layout-and-geometry.md#mapnode) | Graph, layout and geometry | One node of a generated map: its identity, the node type chosen for it, its slot in the layered grid, and any authored payload. |
| [`IMapSaveAdapter`](saving-and-migration.md#imapsaveadapter) | Saving and migration | The storage boundary for map saves: read, write, and delete one slot of complete save data. |
| [`MapSaveEnvelope`](saving-and-migration.md#mapsaveenvelope) | Saving and migration | A complete, versioned graph and traversal snapshot. |
| [`MapDiagnostic`](determinism-and-diagnostics.md#mapdiagnostic) | Determinism and diagnostics | One problem found while compiling authoring assets, running generation preflight, validating a graph, or loading a save: a severity, a stable machine-readable code, a message writt... |
| [`StableId`](determinism-and-diagnostics.md#stableid) | Determinism and diagnostics | A stable, serialization-safe identifier. |
| [`IMapGenerator`](other.md#imapgenerator) | Other | The generation boundary of the package: one call turns a `MapGenerationRequest` into either a complete map or a typed failure. |
| [`MapRuleSnapshot`](other.md#maprulesnapshot) | Other | Immutable, engine-independent rules compiled from authoring assets: the layer widths, the node type table, the zones, the quota, forced-type and forbidden-adjacency rules, the conn... |

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
| [`MapGenerationFailureKind`](getting-a-map.md#mapgenerationfailurekind) | enum | Getting a map | Why a generation attempt returned no graph, as reported by `MapGenerationResult.FailureKind`. |
| [`MapGenerationMode`](getting-a-map.md#mapgenerationmode) | enum | Getting a map | How much of a map a generation request may invent for itself, and therefore what role `MapGenerationOverrides` plays: Procedural rejects overrides outright, Manual builds nothing t... |
| [`MapGenerationOverrides`](getting-a-map.md#mapgenerationoverrides) | class | Getting a map | The complete set of authoring overrides carried by one generation request: pinned nodes and edge dispositions, copied out of the sequences you pass and sorted into canonical order,... |
| [`MapGenerationRequest`](getting-a-map.md#mapgenerationrequest) | class | Getting a map | Everything one generation attempt needs, in one immutable object: the compiled rules, the seed, how much of the map the generator may invent, the authoring overrides it must honour... |
| [`MapGenerationResult`](getting-a-map.md#mapgenerationresult) | class | Getting a map | The single outcome of a generation attempt: on success a complete graph and its `MapGenerationManifest`, on failure a `MapGenerationFailureKind` naming what went wrong, and either ... |
| [`MapGenerationSearchOptions`](getting-a-map.md#mapgenerationsearchoptions) | class | Getting a map | The work a single generation attempt may spend, as one positive cap per search phase. |
| [`MapGenerationStatistics`](getting-a-map.md#mapgenerationstatistics) | class | Getting a map | What one generation attempt actually cost, counted against `MapGenerationSearchOptions`. |
| [`PinnedNodeFields`](getting-a-map.md#pinnednodefields) | enum | Getting a map | Which of a pinned node's authored values the generator must reproduce exactly. |
| [`PinnedNodeOverride`](getting-a-map.md#pinnednodeoverride) | struct | Getting a map | One authored node pinned to a map slot: the identity that slot must hold, plus whichever of its type, position, and payload the generator is not free to choose. |
| [`MapDataPayload`](traversal-and-progression.md#mapdatapayload) | class | Traversal and progression | Generic tagged data for traversal results and customer-owned save metadata. |
| [`MapNodeCompletion`](traversal-and-progression.md#mapnodecompletion) | class | Traversal and progression | One finished node paired with whatever the game reported for it. |
| [`MapProgressionState`](traversal-and-progression.md#mapprogressionstate) | class | Traversal and progression | An immutable traversal snapshot. |
| [`MapSession`](traversal-and-progression.md#mapsession) | class | Traversal and progression | Standalone traversal orchestration over immutable graph and progression snapshots. |
| [`MapTransitionEvent`](traversal-and-progression.md#maptransitionevent) | class | Traversal and progression | One immutable thing that happened during a traversal transition: a node was entered or completed, the choosable set changed, or the run ended. |
| [`MapTransitionEventKind`](traversal-and-progression.md#maptransitioneventkind) | enum | Traversal and progression | What one `MapTransitionEvent` reports. |
| [`MapTransitionFailureKind`](traversal-and-progression.md#maptransitionfailurekind) | enum | Traversal and progression | Why a transition was refused. |
| [`MapTransitionResult`](traversal-and-progression.md#maptransitionresult) | class | Traversal and progression | The outcome of one attempted transition: whether it was applied, the progression state on each side of it, the ordered events it produced, and its diagnostics. |
| [`CompiledMapNodeType`](authoring-assets.md#compiledmapnodetype) | class | Authoring assets | One node type after compilation: an immutable bundle of its parsed `StableId`, its fallback display strings, the prefabs, icon, and per-state colors a view draws it with, and its d... |
| [`CompiledMapTheme`](authoring-assets.md#compiledmaptheme) | class | Authoring assets | One map theme after compilation: the spacing a map is laid out with, the colors and edge geometry it is drawn with, the zoom range a view may offer, and how long a state change tak... |
| [`MapAuthoringCompiler`](authoring-assets.md#mapauthoringcompiler) | class | Authoring assets | Turns authoring assets into the immutable compiled types the runtime works with: node types, themes, rule snapshots, and blueprints. |
| [`MapBlueprintAsset`](authoring-assets.md#mapblueprintasset) | class | Authoring assets | The saved form of one map: the rules it came from, the mode and seed it was generated with, the complete node and edge rows the editor persisted, the budgets a regeneration is allo... |
| [`MapBlueprintCompilation`](authoring-assets.md#mapblueprintcompilation) | class | Authoring assets | The result of compiling one `MapBlueprintAsset`: everything a generation request needs -- rules, mode, seed, overrides, and search budgets -- plus the graph the blueprint authored,... |
| [`MapConstraintAsset`](authoring-assets.md#mapconstraintasset) | class | Authoring assets | The ScriptableObject base for a generation rule of your own: subclass it, author whatever fields the rule needs in the Inspector, and hand back an `IMapConstraint` that judges a ma... |
| [`MapEdgeGeometryKind`](authoring-assets.md#mapedgegeometrykind) | enum | Authoring assets | How a route between two nodes is shaped when the built-in views sample it. |
| [`MapFlowDirection`](authoring-assets.md#mapflowdirection) | enum | Authoring assets | Which screen direction the map's progress runs in. |
| [`MapLayoutOrientation`](authoring-assets.md#maplayoutorientation) | enum | Authoring assets | Which axis a map's layers advance along once it is laid out. |
| [`MapNodeTypeAsset`](authoring-assets.md#mapnodetypeasset) | class | Authoring assets | One kind of node a map may contain: its stable identity, the label and tooltip shown for it, the prefabs, icon, and per-state colors the built-in views draw it with, and the defaul... |
| [`MapNodeTypeCompilation`](authoring-assets.md#mapnodetypecompilation) | class | Authoring assets | The result of compiling one `MapNodeTypeAsset`: the immutable node type on success, and in every case the diagnostics the compiler gathered. |
| [`MapPropertyAuthoring`](authoring-assets.md#mappropertyauthoring) | class | Authoring assets | One authored row of a tagged property: its key, which kind of value it holds, and three value fields to hold it -- a numeric one shared by the boolean, integer, and fixed-point kin... |
| [`MapRulesAsset`](authoring-assets.md#maprulesasset) | class | Authoring assets | The inspector-authored ruleset every BranchWeaver map is generated from: how many nodes each layer may hold, which node types may appear and how often they are chosen, the zones th... |
| [`MapRulesCompilation`](authoring-assets.md#maprulescompilation) | class | Authoring assets | The result of compiling one `MapRulesAsset`: the rule snapshot a generator can be handed, every node type those rules referenced, and the diagnostics the compiler gathered. |
| [`MapThemeAsset`](authoring-assets.md#mapthemeasset) | class | Authoring assets | The authored asset that decides how a generated map is laid out and drawn: layer and node spacing, which axis the layers run along, how edges are shaped, the two colours the built-... |
| [`MapThemeCompilation`](authoring-assets.md#mapthemecompilation) | class | Authoring assets | The result of compiling one `MapThemeAsset`: the immutable theme on success, and in every case the diagnostics the compiler gathered. |
| [`MapThemeLimits`](authoring-assets.md#mapthemelimits) | class | Authoring assets | The ceilings a map theme is compiled against. |
| [`CanvasMapNodeStyling`](styling-and-appearance.md#canvasmapnodestyling) | class | Styling and appearance | Turns a node's compiled type, visual state, and fog state into the surface request that draws it. |
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
| [`MapStyleRuntime`](styling-and-appearance.md#mapstyleruntime) | class | Styling and appearance | Bridges an authored `CompiledMapStyle` to runtime visual state. |
| [`MapSurfaceGraphic`](styling-and-appearance.md#mapsurfacegraphic) | class | Styling and appearance | Draws one styled map surface as a uGUI graphic through the BranchWeaver map surface shader. |
| [`MapSurfaceRequest`](styling-and-appearance.md#mapsurfacerequest) | struct | Styling and appearance | The complete parameter set for one map surface material. |
| [`MapSurfaceTokens`](styling-and-appearance.md#mapsurfacetokens) | struct | Styling and appearance | Fill, stroke, glow, and shadow for a drawn surface. |
| [`MapTypographyTokens`](styling-and-appearance.md#maptypographytokens) | struct | Styling and appearance | Label sizing and treatment. |
| [`CanvasMapEdgeView`](presentation-and-views.md#canvasmapedgeview) | class | Presentation and views | Draws one edge between two map nodes as a chain of uGUI images, and is the edge view the Canvas presentation builds by default. |
| [`CanvasMapNodeView`](presentation-and-views.md#canvasmapnodeview) | class | Presentation and views | Draws one map node as a uGUI element inside a Canvas, and is the node view the Canvas presentation builds by default. |
| [`CanvasMapPresenter`](presentation-and-views.md#canvasmappresenter) | class | Presentation and views | Draws a map inside a uGUI Canvas. |
| [`DefaultMapNodeHitTester`](presentation-and-views.md#defaultmapnodehittester) | class | Presentation and views | The shipped hit tester. |
| [`IMapAudioCueAdapter`](presentation-and-views.md#imapaudiocueadapter) | interface | Presentation and views | Plays the cue ids authored on node types, so the package never has to know which audio system a project uses. |
| [`IMapBackgroundPresenter`](presentation-and-views.md#imapbackgroundpresenter) | interface | Presentation and views | Optional hook for drawing whatever sits behind the map: a backdrop image, a parallax layer, a shader quad. |
| [`IMapDevelopmentHost`](presentation-and-views.md#imapdevelopmenthost) | interface | Presentation and views | The command surface behind the development overlay: reveal, unlock, teleport, reset, force a result, regenerate, and copy the generation manifest. |
| [`IMapEdgeAvailabilityView`](presentation-and-views.md#imapedgeavailabilityview) | interface | Presentation and views | Implemented by an edge view that can emphasize routes leading to a reachable node. |
| [`IMapEdgeTransitionView`](presentation-and-views.md#imapedgetransitionview) | interface | Presentation and views | Optional on an `IMapEdgeView`: the edge counterpart of `IMapNodeTransitionView`, driven in the same order and under the same condition that no `IMapPresentationTransitionAdapter` i... |
| [`IMapEdgeView`](presentation-and-views.md#imapedgeview) | interface | Presentation and views | The contract for anything that draws a single map edge. |
| [`IMapEdgeViewFactory`](presentation-and-views.md#imapedgeviewfactory) | interface | Presentation and views | Creates and recycles the edge views a presenter draws with - the same seam as `IMapNodeViewFactory`, for routes instead of nodes. |
| [`IMapFocusIndicatorPresenter`](presentation-and-views.md#imapfocusindicatorpresenter) | interface | Presentation and views | Optional hook for one shared focus indicator drawn at the focused node, as an alternative to every node styling its own focus. |
| [`IMapFocusView`](presentation-and-views.md#imapfocusview) | interface | Presentation and views | Optional on an `IMapNodeView`: lets a view show keyboard or gamepad focus. |
| [`IMapInputSource`](presentation-and-views.md#imapinputsource) | interface | Presentation and views | Supplies the map with input frames. |
| [`IMapLocalizationAdapter`](presentation-and-views.md#imaplocalizationadapter) | interface | Presentation and views | Bridges node labels and tooltips to whatever localization system a project already uses. |
| [`IMapNodeHitState`](presentation-and-views.md#imapnodehitstate) | interface | Presentation and views | Optional on an `IMapNodeView`: lets the view decide for itself whether it can be clicked. |
| [`IMapNodeHitTester`](presentation-and-views.md#imapnodehittester) | interface | Presentation and views | Resolves a screen position to a map node. |
| [`IMapNodeTransitionView`](presentation-and-views.md#imapnodetransitionview) | interface | Presentation and views | Optional on an `IMapNodeView`: lets a view animate its own state changes, which is how the shipped node views cross-fade. |
| [`IMapNodeView`](presentation-and-views.md#imapnodeview) | interface | Presentation and views | The contract for anything that draws a single map node. |
| [`IMapNodeViewFactory`](presentation-and-views.md#imapnodeviewfactory) | interface | Presentation and views | Creates and recycles the node views a presenter draws with. |
| [`IMapPresentationTransitionAdapter`](presentation-and-views.md#imappresentationtransitionadapter) | interface | Presentation and views | Takes over every node and edge state transition for the whole map, as an alternative to letting each view animate itself. |
| [`IMapViewFactoryLifetime`](presentation-and-views.md#imapviewfactorylifetime) | interface | Presentation and views | Optional lifetime contract used only for factories created and owned by a presenter. |
| [`IPlayerPawnPresenter`](presentation-and-views.md#iplayerpawnpresenter) | interface | Presentation and views | Optional hook for drawing the traveller's own marker on the map. |
| [`IRouteMarkerPresenter`](presentation-and-views.md#iroutemarkerpresenter) | interface | Presentation and views | Optional hook for marking the route already walked: footprints, a trail, a drawn line. |
| [`InputSystemSignalAdapter`](presentation-and-views.md#inputsystemsignaladapter) | class | Presentation and views | Package-neutral bridge for Input System PlayerInput UnityEvents. |
| [`LegacyMapInputSource`](presentation-and-views.md#legacymapinputsource) | class | Presentation and views | Input source for Unity's legacy Input Manager: axes for navigation, Return, Space or the Submit button for activation, the mouse for pointing, middle-drag to pan and the wheel to z... |
| [`MapCameraBloom`](presentation-and-views.md#mapcamerabloom) | class | Presentation and views | Optional map bloom and vignette. |
| [`MapDevelopmentCommandResult`](presentation-and-views.md#mapdevelopmentcommandresult) | class | Presentation and views | The outcome of one development command: success, optionally carrying a value, or a refusal with a reason fit to show in a debug overlay. |
| [`MapDevelopmentFailureKind`](presentation-and-views.md#mapdevelopmentfailurekind) | enum | Presentation and views | Why a development command was refused. |
| [`MapEdgeViewData`](presentation-and-views.md#mapedgeviewdata) | struct | Presentation and views | Everything an edge view needs to draw one route in one presented state: the graph edge, the sampled path along it, the colour to draw it in, and its fog state. |
| [`MapFogSettings`](presentation-and-views.md#mapfogsettings) | struct | Presentation and views | How far ahead of the traveller the map is revealed. |
| [`MapFogState`](presentation-and-views.md#mapfogstate) | enum | Presentation and views | How visible a node is, derived from its `MapNodeVisualState`: a hidden node reports `MapFogState.Hidden`, a locked one `MapFogState.Dimmed`, and anything the traveller has reached ... |
| [`MapInputController`](presentation-and-views.md#mapinputcontroller) | class | Presentation and views | The component that turns input frames into map interaction: it moves focus between nodes, submits the focused or pressed node to a `MapTraversalController`, and pans and zooms the ... |
| [`MapInputFrame`](presentation-and-views.md#mapinputframe) | struct | Presentation and views | One update's worth of map input, reduced to the six signals the controller acts on: a directional axis, a submit request, a pointer, pan and zoom deltas, and a pinch flag. |
| [`MapNavigationDirection`](presentation-and-views.md#mapnavigationdirection) | enum | Presentation and views | A directional focus step, named in normalized layout space: Up is increasing Y and Right is increasing X, whatever the presenter later does with those axes on screen. |
| [`MapNavigationModel`](presentation-and-views.md#mapnavigationmodel) | class | Presentation and views | Keyboard and gamepad focus for a map. |
| [`MapNodeRuntimeState`](presentation-and-views.md#mapnoderuntimestate) | struct | Presentation and views | One node's derived display state: the visual state a presenter styles it with, plus the fog state that decides whether it can be seen at all. |
| [`MapNodeViewData`](presentation-and-views.md#mapnodeviewdata) | struct | Presentation and views | Everything a node view needs to draw one node in one presented state: the graph node, where it sits, its compiled type, and its visual and fog state. |
| [`MapNodeVisualState`](presentation-and-views.md#mapnodevisualstate) | enum | Presentation and views | How one node reads to the player, and the state a presenter styles that node with. |
| [`MapPresenterBase`](presentation-and-views.md#mappresenterbase) | class | Presentation and views | Turns a traversal controller's graph, progression and compiled content into live node and edge views, and keeps them in step for the rest of the run. |
| [`MapRuntimeContent`](presentation-and-views.md#mapruntimecontent) | class | Presentation and views | Everything needed to draw a map that the graph itself does not carry: the node types its type IDs resolve to, and the theme they are laid out and styled with. |
| [`MapRuntimeStateDeriver`](presentation-and-views.md#mapruntimestatederiver) | class | Presentation and views | Turns a graph plus the traveller's progression into the per-node fog and visual states a view needs, and is what decides how much of the map the player can currently see. |
| [`MapRuntimeStateSnapshot`](presentation-and-views.md#mapruntimestatesnapshot) | class | Presentation and views | The whole map's derived display state for one progression revision: one entry per node, sorted by node ID and addressable by ID. |
| [`MapSelectionResult`](presentation-and-views.md#mapselectionresult) | class | Presentation and views | The outcome of asking the controller to move to a node. |
| [`MapSetupHierarchyBinding`](presentation-and-views.md#mapsetuphierarchybinding) | class | Presentation and views | Durable identity for scene objects created and owned by the BranchWeaver setup wizard. |
| [`MapTraversalController`](presentation-and-views.md#maptraversalcontroller) | class | Presentation and views | The scene component that owns one traversal run: it holds the graph, the progression, and the compiled content, applies every move through a `MapSession`, and reports what happened... |
| [`PassthroughLocalizationAdapter`](presentation-and-views.md#passthroughlocalizationadapter) | class | Presentation and views | The `IMapLocalizationAdapter` used when a project has no localization system wired up: it returns the authored fallback text unchanged, falling back to the key itself when no text ... |
| [`WorldMapEdgeView`](presentation-and-views.md#worldmapedgeview) | class | Presentation and views | Draws one edge between two map nodes as a world-space line, and is the edge view the World2D presentation builds by default. |
| [`WorldMapNodeView`](presentation-and-views.md#worldmapnodeview) | class | Presentation and views | Draws one map node as a world-space sprite, and is the node view the World2D presentation builds by default. |
| [`WorldMapPresenter`](presentation-and-views.md#worldmappresenter) | class | Presentation and views | Draws a map as ordinary scene objects rather than UI. |
| [`InputSystemMapInputBridge`](framing-input-and-navigation.md#inputsystemmapinputbridge) | class | Framing, input and navigation | Optional PlayerInput UnityEvent bridge compiled only when com.unity.inputsystem is installed. |
| [`MapAspectClass`](framing-input-and-navigation.md#mapaspectclass) | enum | Framing, input and navigation | Coarse bucket for a screen's shape, so framing and layout can be chosen per display class instead of per resolution. |
| [`MapFrameResult`](framing-input-and-navigation.md#mapframeresult) | struct | Framing, input and navigation | The resolved on-screen placement of a map: the rectangle it may occupy, the scale that fits its content into that rectangle, and the pan limits that keep it reachable. |
| [`MapFrameUtility`](framing-input-and-navigation.md#mapframeutility) | class | Framing, input and navigation | Pure framing maths, separated from the component so it can be tested without a scene, a canvas, or a device. |
| [`MapSafeAreaController`](framing-input-and-navigation.md#mapsafeareacontroller) | class | Framing, input and navigation | Keeps the RectTransform it sits on inside the device safe area, so notches, rounded corners, and gesture bars never cover the map. |
| [`MapViewportFrame`](framing-input-and-navigation.md#mapviewportframe) | class | Framing, input and navigation | Places a map on screen: reserves margins for your own interface, fits the content, insets into the device safe area, and clamps pan and zoom. |
| [`MapViewportResult`](framing-input-and-navigation.md#mapviewportresult) | struct | Framing, input and navigation | The outcome of measuring one screen: whether the measurement succeeded, the safe area as fractions of the screen, and the aspect bucket. |
| [`ConstraintContext`](rules-and-constraints.md#constraintcontext) | class | Rules and constraints | Everything an `IMapConstraint` is allowed to see: the frozen rules, every slot and slot edge in the attempt, and the type assignments decided so far. |
| [`ConstraintEvaluationState`](rules-and-constraints.md#constraintevaluationstate) | enum | Rules and constraints | What a custom constraint concluded about the assignment it was shown. |
| [`ConstraintResult`](rules-and-constraints.md#constraintresult) | class | Rules and constraints | One constraint's answer for one evaluation: the state, plus the diagnostic code and message that are reported when the state is `ConstraintEvaluationState.Violated`. |
| [`EdgeCrossingPolicy`](rules-and-constraints.md#edgecrossingpolicy) | enum | Rules and constraints | Whether the generator may produce routes that cross one another between two layers. |
| [`ForbiddenAdjacencyDirection`](rules-and-constraints.md#forbiddenadjacencydirection) | enum | Rules and constraints | Whether a forbidden adjacency follows edge direction or covers both orderings of its type pair. |
| [`ForbiddenAdjacencyRule`](rules-and-constraints.md#forbiddenadjacencyrule) | struct | Rules and constraints | Bans edges between two node types. |
| [`ForcedNodeTypeRule`](rules-and-constraints.md#forcednodetyperule) | struct | Rules and constraints | Pins one slot to a node type before generation starts, fixing that slot's type instead of drawing it by weight. |
| [`IMapConstraint`](rules-and-constraints.md#imapconstraint) | interface | Rules and constraints | A game-specific rule the generator has to respect. |
| [`MapConnectionRules`](rules-and-constraints.md#mapconnectionrules) | class | Rules and constraints | The topology half of a rule set: how many routes a node may send and receive, how many optional routes are added beyond the mandatory backbone, and whether routes may cross. |
| [`MapNodeSlot`](rules-and-constraints.md#mapnodeslot) | struct | Rules and constraints | Addresses one candidate node position in a layered map by layer and by ordinal within that layer. |
| [`MapNodeTypeAssignment`](rules-and-constraints.md#mapnodetypeassignment) | struct | Rules and constraints | One decided slot: where it sits, the identity of the node there, and the node type chosen for it. |
| [`MapSlotEdge`](rules-and-constraints.md#mapslotedge) | struct | Rules and constraints | A directed connection between two slots, written in layer-and-ordinal coordinates rather than node IDs -- the shape of a map before its nodes exist. |
| [`MapValidator`](rules-and-constraints.md#mapvalidator) | class | Rules and constraints | The shipped `IMapValidator`: it judges a finished graph against the rule snapshot it claims to have come from. |
| [`MapZoneDefinition`](rules-and-constraints.md#mapzonedefinition) | class | Rules and constraints | A contiguous inclusive band of layers that carries its own node type rules: an allowed set, a forbidden set, and per-type weight overrides. |
| [`NodeTypeQuotaRule`](rules-and-constraints.md#nodetypequotarule) | struct | Rules and constraints | A count bound on how many nodes of one type a scope may hold: the whole map when `ZoneId` is empty, otherwise the layers of the named zone. |
| [`NodeTypeWeight`](rules-and-constraints.md#nodetypeweight) | struct | Rules and constraints | One entry of the map-wide node type table: it declares that a type exists and how often the generator should reach for it. |
| [`NodeTypeWeightOverride`](rules-and-constraints.md#nodetypeweightoverride) | struct | Rules and constraints | Replaces the map-wide selection weight of one node type for the layers of a single zone. |
| [`ValidationReport`](rules-and-constraints.md#validationreport) | class | Rules and constraints | Everything one validation pass had to say, plus the single number that decides whether the pass succeeded. |
| [`IMapLayoutStrategy`](graph-layout-and-geometry.md#imaplayoutstrategy) | interface | Graph, layout and geometry | Turns a graph's topology into normalized node positions. |
| [`LayeredMapLayoutStrategy`](graph-layout-and-geometry.md#layeredmaplayoutstrategy) | class | Graph, layout and geometry | The shipped layout. |
| [`MapEdge`](graph-layout-and-geometry.md#mapedge) | struct | Graph, layout and geometry | A directed connection from one node to another, with a stable identity of its own so a route can be recorded and reloaded by edge rather than by node pair. |
| [`MapGraph`](graph-layout-and-geometry.md#mapgraph) | class | Graph, layout and geometry | An immutable graph snapshot. |
| [`MapLayout`](graph-layout-and-geometry.md#maplayout) | class | Graph, layout and geometry | The immutable result of one layout pass: every laid-out node with its normalized position, plus the orientation those positions were built for. |
| [`MapLayoutNode`](graph-layout-and-geometry.md#maplayoutnode) | struct | Graph, layout and geometry | One node paired with the position a layout pass gave it. |
| [`MapLayoutOrientation`](graph-layout-and-geometry.md#maplayoutorientation) | enum | Graph, layout and geometry | Which axis a layout advances its layers along. |
| [`MapLayoutRequest`](graph-layout-and-geometry.md#maplayoutrequest) | struct | Graph, layout and geometry | The band a layout is asked to fill, in normalized 0..`NormalizedMapPosition.Scale` units: layers advance along the orientation's axis between the layer bounds, and the nodes sharin... |
| [`MapNode`](graph-layout-and-geometry.md#mapnode) | class | Graph, layout and geometry | One node of a generated map: its identity, the node type chosen for it, its slot in the layered grid, and any authored payload. |
| [`NormalizedMapPosition`](graph-layout-and-geometry.md#normalizedmapposition) | struct | Graph, layout and geometry | An integer-normalized map position. |
| [`FileMapSaveAdapter`](saving-and-migration.md#filemapsaveadapter) | class | Saving and migration | Rooted file persistence. |
| [`IMapSaveAdapter`](saving-and-migration.md#imapsaveadapter) | interface | Saving and migration | The storage boundary for map saves: read, write, and delete one slot of complete save data. |
| [`IMapSaveMigration`](saving-and-migration.md#imapsavemigration) | interface | Saving and migration | One step of the save upgrade chain: it accepts an envelope at its declared source version and returns the same run at its target version. |
| [`MapSaveEnvelope`](saving-and-migration.md#mapsaveenvelope) | class | Saving and migration | A complete, versioned graph and traversal snapshot. |
| [`MapSaveFailureKind`](saving-and-migration.md#mapsavefailurekind) | enum | Saving and migration | Why a save read, write, or delete did not succeed. |
| [`MapSaveOperationResult`](saving-and-migration.md#mapsaveoperationresult) | class | Saving and migration | The outcome of a save write or delete: whether it committed, the typed reason when it did not, and the diagnostics behind that reason. |
| [`MapSaveReadResult`](saving-and-migration.md#mapsavereadresult) | class | Saving and migration | The outcome of a save read: the loaded envelope, which stored candidate supplied it, and the diagnostics gathered on the way. |
| [`MapSaveRecoverySource`](saving-and-migration.md#mapsaverecoverysource) | enum | Saving and migration | Which stored candidate supplied the bytes of a successful read. |
| [`MapSaveSerializationResult`](saving-and-migration.md#mapsaveserializationresult) | class | Saving and migration | The outcome of one `MapSaveSerializer` call, in either direction. |
| [`MapSaveSerializer`](saving-and-migration.md#mapsaveserializer) | class | Saving and migration | Strict, culture-invariant JSON persistence for complete map save envelopes. |
| [`MapSaveV1ToV2Migration`](saving-and-migration.md#mapsavev1tov2migration) | class | Saving and migration | Save format 1 had no customer metadata field. |
| [`MemoryMapSaveAdapter`](saving-and-migration.md#memorymapsaveadapter) | class | Saving and migration | An in-memory adapter that stores canonical JSON rather than live object references. |
| [`MapStudioCommandResult`](editor-tools.md#mapstudiocommandresult) | class | Editor tools | What one Map Studio command did: whether it was accepted, the snapshot to display afterwards, and the error that explains a rejection. |
| [`MapStudioSession`](editor-tools.md#mapstudiosession) | class | Editor tools | The editing model behind the Map Studio window: it holds one `MapStudioSnapshot` at a time and turns each authoring gesture -- regenerate, move, retype, pin, connect, undo -- into ... |
| [`MapStudioSnapshot`](editor-tools.md#mapstudiosnapshot) | class | Editor tools | Immutable picture of one Map Studio preview: the compiled rules the preview is pinned to, the generation mode and seed, the graph as it currently stands, the overrides and search b... |
| [`MapDevelopmentOverlay`](determinism-and-diagnostics.md#mapdevelopmentoverlay) | class | Determinism and diagnostics | A draggable IMGUI window that drives the development commands of a running map: reveal everything, unlock or teleport to a node by ID, complete the current node, force a completion... |
| [`MapDiagnostic`](determinism-and-diagnostics.md#mapdiagnostic) | class | Determinism and diagnostics | One problem found while compiling authoring assets, running generation preflight, validating a graph, or loading a save: a severity, a stable machine-readable code, a message writt... |
| [`StableId`](determinism-and-diagnostics.md#stableid) | struct | Determinism and diagnostics | A stable, serialization-safe identifier. |
| [`IMapGenerator`](other.md#imapgenerator) | interface | Other | The generation boundary of the package: one call turns a `MapGenerationRequest` into either a complete map or a typed failure. |
| [`IMapValidator`](other.md#imapvalidator) | interface | Other | The whole-graph check the generators run in addition to their own. |
| [`LayerNodeRange`](other.md#layernoderange) | struct | Other | How many nodes one layer may hold, as an inclusive range. |
| [`MapDiagnosticSeverity`](other.md#mapdiagnosticseverity) | enum | Other | How much weight a `MapDiagnostic` carries. |
| [`MapFingerprint`](other.md#mapfingerprint) | class | Other | Versioned, domain-separated, big-endian canonical SHA-256 fingerprints. |
| [`MapGenerationManifest`](other.md#mapgenerationmanifest) | class | Other | The reproduction record of one successful generation: which generator and which random algorithm ran, the seed and the fingerprints of the inputs they ran on, and the fingerprint o... |
| [`MapNodePayload`](other.md#mapnodepayload) | class | Other | The immutable set of typed properties carried by a node or a node type: how BranchWeaver lets a map hold your game's data (rewards, difficulty, labels) without the package needing ... |
| [`MapProperty`](other.md#mapproperty) | struct | Other | One entry of a node payload: a stable key paired with a tagged value. |
| [`MapPropertyKind`](other.md#mappropertykind) | enum | Other | Which of a `MapPropertyValue`'s fields carries the data. |
| [`MapPropertyValue`](other.md#mappropertyvalue) | struct | Other | A Unity-independent tagged value used by map payloads. |
| [`MapRuleSnapshot`](other.md#maprulesnapshot) | class | Other | Immutable, engine-independent rules compiled from authoring assets: the layer widths, the node type table, the zones, the quota, forced-type and forbidden-adjacency rules, the conn... |
| [`SampleSceneBootstrap`](other.md#samplescenebootstrap) | class | Other | Self-contained sample host. |
| [`XorShift32Random`](other.md#xorshift32random) | class | Other | Version 1 of BranchWeaver's deterministic random stream. |

</div>

