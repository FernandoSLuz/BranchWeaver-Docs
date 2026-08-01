# Authoring assets

17 types in this area.

!!! abstract "On this page"
    [CompiledMapNodeType](#compiledmapnodetype) &middot; [CompiledMapTheme](#compiledmaptheme) &middot; [MapAuthoringCompiler](#mapauthoringcompiler) &middot; [MapBlueprintAsset](#mapblueprintasset) &middot; [MapBlueprintCompilation](#mapblueprintcompilation) &middot; [MapConstraintAsset](#mapconstraintasset) &middot; [MapEdgeGeometryKind](#mapedgegeometrykind) &middot; [MapFlowDirection](#mapflowdirection) &middot; [MapLayoutOrientation](#maplayoutorientation) &middot; [MapNodeTypeAsset](#mapnodetypeasset) &middot; [MapNodeTypeCompilation](#mapnodetypecompilation) &middot; [MapPropertyAuthoring](#mappropertyauthoring) &middot; [MapRulesAsset](#maprulesasset) &middot; [MapRulesCompilation](#maprulescompilation) &middot; [MapThemeAsset](#mapthemeasset) &middot; [MapThemeCompilation](#mapthemecompilation) &middot; [MapThemeLimits](#mapthemelimits)

## CompiledMapNodeType

```csharp
public sealed class CompiledMapNodeType
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapNodeTypeAsset.cs</small>

One node type after compilation: an immutable bundle of its parsed `StableId`, its
fallback display strings, the prefabs, icon, and per-state colors a view draws it with, and its
default payload. This, rather than the `MapNodeTypeAsset` it came from, is what
presenters, view factories, and the traversal controller are handed, so a custom view reads a
node's appearance from here and never needs to reach back to an asset.

A `MapAuthoringCompiler` only produces one when the asset compiled with no
diagnostics at all, so an instance obtained that way is already validated: its IDs parse and its
colors have finite channels.

**Constructors**

`public CompiledMapNodeType(StableId id, string displayLabel, MapNodePayload defaultPayload)`

:   Creates an authored compiled Map Node Type row from the supplied fields; validation is deferred so the compiler can report every related issue together.
    - `id` &mdash; Input id consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `displayLabel` &mdash; Input display Label consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `defaultPayload` &mdash; Input default Payload consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public CompiledMapNodeType()`

:   Creates an authored compiled Map Node Type row from the supplied fields; validation is deferred so the compiler can report every related issue together.
    - `localizationKey` &mdash; Adapter lookup key for the label; the tooltip uses the same key with `.tooltip` appended.
    - `tooltip` &mdash; Fallback tooltip used when the localized lookup yields nothing.
    - `rendererKey` &mdash; Optional pooling and styling discriminator; see `MapNodeTypeAsset.RendererKey`.
    - `defaultPayload` &mdash; Payload describing what the type means to your game; it is not applied to generated nodes.
    - `id` &mdash; Input id consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `displayLabel` &mdash; Input display Label consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `icon` &mdash; Input icon consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `canvasPrefab` &mdash; Input canvas Prefab consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `worldPrefab` &mdash; Input world Prefab consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `hiddenColor` &mdash; Input hidden Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `lockedColor` &mdash; Input locked Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `availableColor` &mdash; Input available Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `currentColor` &mdash; Input current Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `visitedColor` &mdash; Input visited Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `completedColor` &mdash; Input completed Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `enterAudioCueId` &mdash; Stable identifier for enter Audio Cue; invalid or empty IDs are rejected before mutation.
    - `completeAudioCueId` &mdash; Stable identifier for complete Audio Cue; invalid or empty IDs are rejected before mutation.

**Properties**

`public Color AvailableColor`

:   Color for a node the player may enter next. A node unlocked by hand reads as available too, so it is indistinguishable from one made reachable by normal progression.

`public GameObject CanvasPrefab`

:   Canvas view prefab, or null to let the built-in factory build a plain canvas node.

`public string CompleteAudioCueId`

:   Cue played on completion, on the same terms as `EnterAudioCueId`.

`public Color CompletedColor`

:   Color for a node whose completion result is in the progression. Completion is tested first of all six states, so this wins over current, available, and visited alike.

`public Color CurrentColor`

:   Color for the node the player is standing on. Completion is tested before position, so a current node that already has a result recorded draws in `CompletedColor`.

`public MapNodePayload DefaultPayload`

:   What a node of this type means to your game, as tagged content. Never null. Generation does not copy it into the nodes it produces -- a generated node's own payload is empty unless a pinned override supplied one -- so resolve a node's contents through its type, not through the node.

`public string DisplayLabel`

:   The authored label, not a localized one. A presenter resolves `LocalizationKey` first and only falls back to this, so reading it directly bypasses localization.

`public string EnterAudioCueId`

:   Cue the traversal controller passes to your audio adapter on entering a node of this type. Empty, or text that is not a valid stable ID, plays nothing.

`public Color HiddenColor`

:   Color for an undiscovered node, and the fallback for any visual state a view does not recognise. Fog scales the alpha of whichever of these six colors was selected.

`public Sprite Icon`

:   Sprite the built-in views draw for the node, or null. A styled node insets it inside the node shape; an unstyled one uses it as the node's own sprite and falls back to a generated rounded sprite when there is none.

`public StableId Id`

:   The parsed identity that rules, graphs, and saves address this type by. It comes from the asset's authored ID text rather than from its file name, so moving or renaming the asset leaves every weight, quota, forced slot, and adjacency ban still pointing at this type.

`public string LocalizationKey`

:   Lookup key for the label. The tooltip is resolved under the same key with `.tooltip` appended; an empty key suppresses both lookups.

`public Color LockedColor`

:   Color for a node the player has discovered but cannot reach from where they stand.

`public string RendererKey`

:   Optional discriminator that keeps views of this type out of another type's pool; see `MapNodeTypeAsset.RendererKey`.

`public string Tooltip`

:   The authored tooltip, used when the localized `.tooltip` lookup yields nothing.

`public Color VisitedColor`

:   Color for a node reached earlier with no completion recorded against it. It is the last of the reachable states to be tested, so a visited node that is also current or available takes those colors instead.

`public GameObject WorldPrefab`

:   World-space view prefab, or null to let the built-in factory build a plain world node.

---

## CompiledMapTheme

```csharp
public sealed class CompiledMapTheme
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/RuntimeCompilation.cs</small>

One map theme after compilation: the spacing a map is laid out with, the colors and edge geometry
it is drawn with, the zoom range a view may offer, and how long a state change takes to play. It
is presentation only and takes no part in generation, so swapping a theme restyles a map without
changing which map it is.

A theme that came from `MapAuthoringCompiler.CompileTheme(MapThemeAsset)` has already
been range-checked against `MapThemeLimits`, and out-of-range authoring is reported as
a diagnostic rather than clamped, so a presenter can use these numbers as they stand.

**Constructors**

`public CompiledMapTheme()`

:   Creates an authored compiled Map Theme row from the supplied fields; validation is deferred so the compiler can report every related issue together.
    - `layerSpacing` &mdash; Distance between successive layers, in presentation units.
    - `nodeSpacing` &mdash; Distance between neighbouring nodes inside one layer, in presentation units.
    - `bezierSegments` &mdash; Line segments per curved edge; ignored unless `edgeGeometry` is Bezier.
    - `bezierControlOffset` &mdash; Curve control-point offset in normalized fixed point, 10,000 units per 1.0.
    - `stateTransitionSeconds` &mdash; How long a node or edge state change plays for; zero asks for an instant change, which the built-in views honour.
    - `id` &mdash; Input id consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `orientation` &mdash; Input orientation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `backgroundColor` &mdash; Input background Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `edgeColor` &mdash; Input edge Color consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `edgeGeometry` &mdash; Input edge Geometry consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `minimumZoom` &mdash; Input minimum Zoom consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `maximumZoom` &mdash; Input maximum Zoom consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public Color BackgroundColor`

:   The authored backdrop colour, carried for a custom view or backdrop to read. Unlike `EdgeColor` no built-in view consumes it -- the shipped presentation paints its backdrop from the style preset's backdrop and palette tokens -- so changing this alone changes nothing that is drawn. Compilation only checks that its channels are finite, never that they sit in 0..1, so an HDR value reaches a reader exactly as authored.

`public int BezierControlOffset`

:   How far a curved edge's control points sit off the straight line, in normalized fixed point at 10,000 units per 1.0. Zero draws a Bezier edge as a straight one.

`public int BezierSegments`

:   Line segments per curved edge, from 2 to 64. It only matters when `EdgeGeometry` is Bezier, where more segments buy smoothness with vertices.

`public Color EdgeColor`

:   The colour edges are drawn in when no presentation style is installed on the presenter. A style replaces it outright rather than tinting against it, so this is the fallback look and not a base colour a style modulates.

`public MapEdgeGeometryKind EdgeGeometry`

:   The shape edges are sampled into: a straight line, a right-angled polyline that steps across at the halfway point, or a cubic Bezier. Only Bezier reads `BezierSegments` and `BezierControlOffset`, but the compiler range-checks both whichever kind is chosen.

`public StableId Id`

:   Identity of the theme asset this was compiled from, carried so a presenter or a diagnostic can say which theme is in force and so two themes can be told apart. Layout and drawing read the other fields; nothing keys off this one.

`public int LayerSpacing`

:   Distance between successive layers, in presentation units. Together with the number of layers it sets the map's extent along the orientation axis, and a spacing large enough to push that extent past `MapThemeLimits.MaximumContentExtent` makes deriving presentation metrics throw rather than report a diagnostic.

`public float MaximumZoom`

:   Furthest zoom a view may offer, capped at `MapThemeLimits.MaximumZoom` so no theme can ask for an unbounded one.

`public float MinimumZoom`

:   Closest zoom a view may offer. It is positive and never above `MaximumZoom`, so the pair is always a usable range.

`public int NodeSpacing`

:   Distance between neighbouring nodes inside one layer, in presentation units. It sets the extent across the layers from the busiest layer's node count, under the same ceiling as `LayerSpacing`, and the built-in views also derive their node size from it.

`public MapLayoutOrientation Orientation`

:   Which way layers advance, and therefore which screen axis carries progress. It affects layout only: the same graph read vertically and horizontally is the same map.

`public float StateTransitionSeconds`

:   How long a node or edge state change plays for, from 0 to `MapThemeLimits.MaximumTransitionSeconds`. The presenter passes it to whichever transition path is installed on every state change, and the built-in views treat zero as an instant change rather than a one-frame animation.

---

## MapAuthoringCompiler

:material-star: **Start here**

```csharp
public sealed class MapAuthoringCompiler
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapAuthoringCompiler.cs</small>

Turns authoring assets into the immutable compiled types the runtime works with: node types,
themes, rule snapshots, and blueprints.

Every entry point returns a compilation result instead of throwing, so an editor tool can list
everything wrong with an asset in one pass rather than fixing faults one at a time. Compilation
follows asset references: a blueprint compiles its rules, and rules compile every node type
they reach, with all of those diagnostics folded into the report you get back. The compiler
holds no state between calls and never writes to the assets it reads.

**Methods**

`public MapBlueprintCompilation CompileBlueprint(MapBlueprintAsset asset)`

:   Validates and copies blueprint into immutable engine-neutral data; failure exposes diagnostics and no partial compiled value.
    - `asset` &mdash; Input asset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The compiled blueprint and its diagnostics; check `MapBlueprintCompilation.Succeeded` before reading the rules.

`public MapNodeTypeCompilation CompileNodeType(MapNodeTypeAsset asset)`

:   Validates and copies node Type into immutable engine-neutral data; failure exposes diagnostics and no partial compiled value.
    - `asset` &mdash; Input asset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The compiled type and its diagnostics; check `MapNodeTypeCompilation.Succeeded` before reading the value.

`public MapRulesCompilation CompileRules(MapRulesAsset asset)`

:   Validates and copies rules into immutable engine-neutral data; failure exposes diagnostics and no partial compiled value.
    - `asset` &mdash; Input asset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The snapshot, the node types it referenced, and the diagnostics. The snapshot is discarded when any diagnostic is an error.

`public MapThemeCompilation CompileTheme(MapThemeAsset asset)`

:   Validates and copies theme into immutable engine-neutral data; failure exposes diagnostics and no partial compiled value.
    - `asset` &mdash; Input asset consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The compiled theme and its diagnostics; check `MapThemeCompilation.Succeeded` before reading the value.

---

## MapBlueprintAsset

:material-star: **Start here**

```csharp
public sealed class MapBlueprintAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapBlueprintAsset.cs</small>

The saved form of one map: the rules it came from, the mode and seed it was generated with,
the complete node and edge rows the editor persisted, the budgets a regeneration is allowed,
and optional cached fingerprints tying all of that together. Compiling it with
`MapAuthoringCompiler.CompileBlueprint(MapBlueprintAsset)` turns the rows into the
authored graph and, separately, hands back the rules, mode, seed, overrides, and budgets a
generator needs to reproduce that map at runtime, so the asset is both a stored map and a
recipe for one.

Nothing here is settable from code beyond `ConfigureForNewAsset`. Map Studio edits
the asset through Unity serialization instead, which is what keeps
`AuthoringRevision` and the fingerprints in step with the rows they describe.

**Properties**

`public long AuthoringRevision`

:   Editor revision, incremented on every applied edit so a stale in-memory preview cannot overwrite a newer asset. It takes no part in the generation key, so bumping it cannot change the map.

`public int BlueprintFormatVersion`

:   Serialization format of the persisted rows. Only 1 is supported; any other value fails compilation outright rather than being read on a best-effort basis.

`public IReadOnlyList<BlueprintEdgeOverrideAuthoring> EdgeOverrides`

:   Edges required or forbidden between adjacent slots. These rows are read in `MapGenerationMode.Procedural` and `MapGenerationMode.Hybrid` only: a `MapGenerationMode.Manual` blueprint ignores them and derives one required override per row of `Edges` instead.

`public IReadOnlyList<BlueprintEdgeAuthoring> Edges`

:   Every persisted edge, keyed by IDs that are unique across the whole map rather than per layer.

`public string GenerationKey`

:   Cached generation identity -- generator version, mode, rules, overrides, and seed combined -- or empty; checked the same way as `RulesFingerprint`.

`public string GraphFingerprint`

:   Cached fingerprint of the graph the rows build, or empty; checked the same way as `RulesFingerprint`, and only when the rows do build a graph.

`public int MaximumCountStates`

:   Authored value of `MapGenerationSearchOptions.MaximumCountStates`.

`public int MaximumTopologyTrials`

:   Authored value of `MapGenerationSearchOptions.MaximumTopologyTrials`.

`public int MaximumTypeTrials`

:   Authored value of `MapGenerationSearchOptions.MaximumTypeTrials`.

`public MapGenerationMode Mode`

:   How much of this map the generator is allowed to invent when it is rebuilt: everything in `MapGenerationMode.Procedural`, nothing in `MapGenerationMode.Manual`, and whatever the pins leave free in `MapGenerationMode.Hybrid`. It decides which of the other fields are read at all -- Manual requires a zero `Seed` and ignores `EdgeOverrides`, deriving its overrides from the stored rows instead.

`public IReadOnlyList<BlueprintNodeAuthoring> Nodes`

:   Every persisted node, as a complete graph rather than a patch: a blueprint that carries rows at all must carry all of them. Each row may pin its identity and, independently, its type, position, or payload, and those pins become the node overrides handed to a generator.

`public string OverridesFingerprint`

:   Cached fingerprint of the node and edge overrides, or empty; checked the same way as `RulesFingerprint`.

`public MapRulesAsset Rules`

:   The rules this blueprint was generated against, and the rules it is recompiled against. Compilation requires one, and every rule diagnostic it produces is reported as the blueprint's own.

`public string RulesFingerprint`

:   Cached fingerprint of the compiled rules, or empty. When present it must equal what compilation computes, so an edited rules asset is reported as a mismatch instead of quietly changing the map.

`public uint Seed`

:   Generation seed. `MapGenerationMode.Manual` requires zero, because a manual map draws nothing at random; a non-zero seed in that mode is a compile error rather than an ignored field.

**Methods**

`public void ConfigureForNewAsset(MapRulesAsset rulesAsset, MapGenerationMode generationMode, uint generationSeed)`

:   Replaces the configure For New Asset settings used by future operations; existing immutable graphs and saves are not rewritten.
    - `rulesAsset` &mdash; Rules to compile against; required, and may not be null at compile time.
    - `generationSeed` &mdash; Seed to generate with; must be zero for `MapGenerationMode.Manual`.
    - `generationMode` &mdash; Input generation Mode consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

---

## MapBlueprintCompilation

```csharp
public sealed class MapBlueprintCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

The result of compiling one `MapBlueprintAsset`: everything a generation request
needs -- rules, mode, seed, overrides, and search budgets -- plus the graph the blueprint
authored, when it authored one. A successful compilation does not imply a graph, because
`Succeeded` is decided by `Rules` and the report alone.

**Constructors**

`public MapBlueprintCompilation()`

:   Pairs the compiled blueprint parts with the report that describes them. A null `overrides` or `searchOptions` is replaced by its empty or default value, and the locked IDs are copied and sorted, so the caller's collection is neither retained nor reordered.
    - `rules` &mdash; Input rules consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mode` &mdash; How much of the map the blueprint left to the generator.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `overrides` &mdash; Input overrides consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `searchOptions` &mdash; Input search Options consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `lockedNodeIds` &mdash; Nodes the blueprint marked as locked against editing. May be null.
    - `authoringRevision` &mdash; Input authoring Revision consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public long AuthoringRevision`

:   The blueprint's editor revision, carried through so stale-write protection can compare it against the asset before saving. It is not part of the generation key, so bumping it does not change the map.

`public MapGraph Graph`

:   The graph the blueprint authored, or null when it authored no nodes and no edges. It is also null when the rules failed to compile or the graph could not be built at all; a non-null graph says nothing on its own about `Succeeded`.

`public IReadOnlyList<StableId> LockedNodeIds`

:   Nodes the blueprint marked as locked, sorted by ID. A lock only stops Map Studio from editing that node: it creates no override and has no effect on what a generator produces.

`public MapGenerationMode Mode`

:   How much of the map the blueprint left to the generator. An authored value that names no known mode is reported as an error and compiled as `MapGenerationMode.Procedural`, so this always names a real mode -- even on a compilation that failed.

`public MapGenerationOverrides Overrides`

:   The node pins and edge overrides a generator must honour; never null, because a blueprint that authored none compiles to `MapGenerationOverrides.Empty`. A manual blueprint pins every field of every node it drew and marks every edge required, so its overrides describe the whole map on their own.

`public MapRuleSnapshot Rules`

:   Null when the blueprint's rules failed to compile.

`public MapGenerationSearchOptions SearchOptions`

:   The per-phase work caps one generation attempt may spend; never null, because a blueprint that authored none compiles to `MapGenerationSearchOptions.Default`. Budgets that are not positive are reported as an error rather than quietly raised.

`public uint Seed`

:   The authored seed, passed through unchanged. It is folded into the generation key alongside the mode, the rules, and the overrides, so two blueprints differing only here describe two unrelated maps. A manual blueprint is required to use zero, since it invents nothing.

`public bool Succeeded`

:   True only when rules compiled and no diagnostic is an error; a null `Graph` does not make it false.

`public ValidationReport Validation`

:   The blueprint's own diagnostics plus those of the rules and node types it referenced and, when a graph was built, the full `MapValidator` report for that graph against these rules and overrides -- so a blueprint whose drawn map no longer satisfies its own rules is caught here rather than at generation time.

---

## MapConstraintAsset

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public abstract class MapConstraintAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapConstraintAsset.cs</small>

The ScriptableObject base for a generation rule of your own: subclass it, author whatever
fields the rule needs in the Inspector, and hand back an `IMapConstraint` that
judges a map while it is being built. Assets of this kind are listed on a
`MapRulesAsset` and compiled into the rule snapshot beside the built-in quota,
forced-type, and adjacency families, which is how a rule those families cannot express still
prunes bad maps inside the generator's search rather than after it.

This asset is only the authored front end. The object it compiles to runs deep inside a
backtracking search and has to meet the purity and determinism requirements set out on
`IMapConstraint`, so keep the Unity-facing work here and out of the compiled rule.

**Methods**

`public abstract IMapConstraint CompileConstraint()`

:   Validates and copies constraint into immutable engine-neutral data; failure exposes diagnostics and no partial compiled value.
    - **Returns** &mdash; The compiled rule. Returning null fails the whole ruleset with a diagnostic rather than dropping this one constraint, and an exception thrown here is caught and reported the same way, so neither can leave a map generated under a rule that never ran.

---

## MapEdgeGeometryKind

```csharp
public enum MapEdgeGeometryKind
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapThemeAsset.cs</small>

How a route between two nodes is shaped when the built-in views sample it.
Straight is the single segment from source to target. Polyline runs along
the flow axis to the halfway point, steps across to the target's other
coordinate, then continues, giving right-angled routes. Bezier is a cubic
curve whose control points are pushed along the flow axis by the theme's
control offset and which is sampled into the theme's segment count.

Only Bezier reads those two Bezier fields, but the compiler range-checks
them whichever kind you pick.

| Value | Meaning |
| --- | --- |
| `Straight` | &mdash; |
| `Polyline` | &mdash; |
| `Bezier` | &mdash; |

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

Which axis a map's layers advance along once it is laid out. Vertical runs
the layers along Y and spreads each layer's nodes along X; Horizontal swaps
the two. The same graph is laid out either way, so this is a presentation
choice and never changes node identity or reachability.

BranchWeaver.Core declares an enum of the same name and the same values for
its own layout and geometry code; this is the authored form that a
`MapThemeAsset` stores.

| Value | Meaning |
| --- | --- |
| `Vertical` | &mdash; |
| `Horizontal` | &mdash; |

---

## MapNodeTypeAsset

:material-star: **Start here**

```csharp
public sealed class MapNodeTypeAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapNodeTypeAsset.cs</small>

One kind of node a map may contain: its stable identity, the label and tooltip shown for it, the
prefabs, icon, and per-state colors the built-in views draw it with, and the default payload that
says what the kind means to your game. Rules name node types by the stable ID authored here, so
that ID -- never the asset's file name -- is what weights, quotas, forced slots, and adjacency
bans are written against, and renaming or moving the asset changes nothing.

A type only exists for a map if the rules reach it: the default type, the weight table, the zone
lists, the quotas, the forced nodes, and the adjacency rules are the only routes by which an
asset gets compiled and becomes placeable. Everything below the identity is presentation and
integration, and none of it takes part in generation or in a map's identity.

**Properties**

`public Color AvailableColor`

:   Color for a node the player may enter next. Being unlocked by hand counts as available too, so a node opened outside normal progression reads the same as one reached by route.

`public GameObject CanvasPrefab`

:   Prefab the built-in canvas factory instantiates per node. When null the factory builds a plain canvas node instead; when the prefab carries no `IMapNodeView` component the factory adds the built-in one.

`public string CompleteAudioCueId`

:   Cue passed to your audio adapter when a node of this type is completed, on the same terms as `EnterAudioCueId`.

`public Color CompletedColor`

:   Color for a node whose completion result is in the progression. Completion is tested first of all six states, so this wins over current, available, and visited alike.

`public Color CurrentColor`

:   Color for the node the player is standing on. Completion is tested before position, so a current node that already has a result recorded draws in `CompletedColor`.

`public string DefaultPayloadId`

:   Optional identity of the payload that describes what a node of this type means to your game. It is content you read off the compiled type: generation never copies it into the nodes it produces, so it cannot change a map. Required as soon as `DefaultProperties` holds anything.

`public IReadOnlyList<MapPropertyAuthoring> DefaultProperties`

:   Tagged values carried alongside `DefaultPayloadId`. Keys must be unique and each value must be canonical for its kind; compilation sorts them by key.

`public string DisplayLabel`

:   Label used when `LocalizationKey` is empty or your localization adapter has no entry for it. It is a fallback, not a default that a translation is layered over.

`public string EnterAudioCueId`

:   Cue passed to your audio adapter when a session enters a node of this type. Empty, or text that is not a valid stable ID, simply plays nothing.

`public Color HiddenColor`

:   Color for a node the player has not discovered yet, and the color the built-in views fall back to for any visual state they do not recognise. Fog is applied afterwards and independently: it scales the alpha of whichever of these six colors the state selected.

`public Sprite Icon`

:   Sprite the built-in views show for the node. A styled node insets it inside the node shape; an unstyled one uses it as the node's own sprite, and falls back to a generated rounded sprite when this is null.

`public string LocalizationKey`

:   Key handed to your localization adapter for the label. The tooltip is looked up under the same key with `.tooltip` appended, so one key covers both strings; leaving this empty suppresses the lookup entirely and uses the authored fallbacks.

`public Color LockedColor`

:   Color for a node the player has discovered but cannot reach from where they stand.

`public string RendererKey`

:   Optional discriminator that separates views of this type from otherwise identical ones. It is part of the built-in factories' pool key, so changing it stops a pooled view from being reused and forces a fresh instance.

`public string StableIdText`

:   The authored identity as raw text, before it is parsed. Compilation turns it into the `StableId` that rules and graphs use, and rejects the asset outright if the text is not a valid stable ID or if a different asset already compiled under the same one.

`public string Tooltip`

:   Tooltip text used when the localized `.tooltip` lookup yields nothing.

`public Color VisitedColor`

:   Color for a node reached earlier with no completion recorded against it. It is the last of the reachable states to be tested, so a visited node that is also current or available takes those colors instead.

`public GameObject WorldPrefab`

:   Prefab the built-in world-space factory instantiates per node, with the same null and missing-component handling as `CanvasPrefab`.

**Methods**

`public void Configure()`

:   Replaces the configure settings used by future operations; existing immutable graphs and saves are not rewritten.
    - `id` &mdash; Stable ID text; a value that does not parse fails compilation rather than this call.
    - `label` &mdash; Fallback display label.
    - `payloadId` &mdash; Default payload ID; pass an empty string for no payload.
    - `properties` &mdash; Default payload properties, copied into a new list. Null is stored as an empty list.

---

## MapNodeTypeCompilation

```csharp
public sealed class MapNodeTypeCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

The result of compiling one `MapNodeTypeAsset`: the immutable node type on success,
and in every case the diagnostics the compiler gathered. Bad authoring is reported here rather
than thrown, so check `Succeeded` before reading `Value`.

**Constructors**

`public MapNodeTypeCompilation(CompiledMapNodeType value, ValidationReport validation)`

:   Pairs a compiled node type with the report that describes it.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public bool Succeeded`

:   True only when a value was produced and no diagnostic is an error; warnings alone still succeed.

`public ValidationReport Validation`

:   Everything the compiler had to say about this asset. Read it even on success: a warning does not stop `Succeeded` being true.

`public CompiledMapNodeType Value`

:   Null when compilation failed.

---

## MapPropertyAuthoring

```csharp
public sealed class MapPropertyAuthoring
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapPropertyAuthoring.cs</small>

One authored row of a tagged property: its key, which kind of value it holds, and three
value fields to hold it -- a numeric one shared by the boolean, integer, and fixed-point
kinds, plus one for text and one for a stable ID.

This is the Unity-serializable counterpart of `MapPropertyValue`, which the
authoring compiler turns each row into. Only the field `Kind` selects may
carry data: a row that leaves data in one of the others compiles to a value that is not
canonical, and is reported and dropped rather than quietly corrected. The fields are
private and serialized while the properties are read-only, so a row is edited in the
inspector rather than in code; the getters substitute an empty string for the nulls that
deserialization can leave behind. The inspector shows only the field `Kind`
names, so a row authored there cannot carry the leftover data that makes it non-canonical.

**Constructors**

`public MapPropertyAuthoring()`

:   Creates an editable Unity-serialization row; required IDs and references are checked during authoring compilation.

`public MapPropertyAuthoring()`

:   Creates an authored map Property Authoring row from the supplied fields; validation is deferred so the compiler can report every related issue together.
    - `key` &mdash; Input key consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `kind` &mdash; Which of the three value parameters is the meaningful one.
    - `numericValue` &mdash; Input numeric Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `stringValue` &mdash; Input string Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `stableIdValue` &mdash; Input stable Id Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public string Key`

:   The key this property is stored under. Never null. Compiling the row requires it to parse as a lowercase stable ID and to be unique among the keys of its payload.

`public MapPropertyKind Kind`

:   Which of `NumericValue`, `StringValue`, and `StableIdValue` holds this row's value. The other two must be left at their defaults for the row to compile.

`public long NumericValue`

:   The value for the boolean, integer, and fixed-point kinds: 1 or 0 for a boolean, the number itself for an integer, and the number already multiplied by `MapPropertyValue.FixedPointScale` for fixed point. Zero for the other kinds, since nothing here scales or converts on your behalf.

`public string StableIdValue`

:   The value for `MapPropertyKind.StableId`, and empty for every other kind. Never null. It is held as text here and parsed into a stable ID when the row is compiled, so an unusable reference is reported as a diagnostic rather than lost.

`public string StringValue`

:   The value for `MapPropertyKind.String`, and empty for every other kind. Never null.

---

## MapRulesAsset

:material-star: **Start here**

```csharp
public sealed class MapRulesAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapRulesAsset.cs</small>

The inspector-authored ruleset every BranchWeaver map is generated from: how many nodes each
layer may hold, which node types may appear and how often they are chosen, the zones that
narrow those choices over a range of layers, the quota, forced-node, and adjacency rules a
finished map has to satisfy, and the branch, merge, and crossing limits its edges must respect.
Nothing here is enforced while you edit. The asset is compiled by
`MapAuthoringCompiler.CompileRules` into an immutable
`MapRuleSnapshot`, and that is where contradictions are reported -- a ruleset that
fails to compile yields no snapshot at all, so generation never runs on half-valid rules.
The snapshot's fingerprint is folded into the generation key, which is why editing a rules
asset replaces the maps its seeds produce rather than refining them.

**Properties**

`public string ConnectionRuleId`

:   Identity carried by the compiled connection rules, never null. It has to parse as a stable ID or compilation reports the ruleset as invalid.

`public EdgeCrossingPolicy CrossingPolicy`

:   Whether edges between two layers may cross one another. Forbidding crossings is enforced with a deterministic monotone check over the topology rather than by measuring drawn positions, so the guarantee survives whatever theme, orientation, or custom layout the map is eventually drawn with -- and it constrains which edge sets exist at all, not merely how they are rendered.

`public IReadOnlyList<MapConstraintAsset> CustomConstraints`

:   Extra constraint assets compiled alongside the built-in rules. Each one is asked for its constraint at compile time, and a constraint that compiles to null or throws fails the whole ruleset rather than being skipped.

`public MapNodeTypeAsset DefaultNodeType`

:   The fallback node type. It is required -- compilation fails without it -- and it always joins the compiled type set even when no weight, zone, or rule mentions it.

`public IReadOnlyList<ForbiddenAdjacencyAuthoring> ForbiddenAdjacencies`

:   Pairs of node types that may not end up at the two ends of an edge, each either directional or symmetric. The generator applies them on both sides of the problem -- it prunes types that would break a ban while assigning them, and never adds an optional edge whose endpoints match one -- so a ban can leave a chosen topology with no legal type assignment at all rather than merely thinning its connections.

`public IReadOnlyList<ForcedNodeAuthoring> ForcedNodes`

:   Node types pinned to an exact layer and ordinal. Layers are filled contiguously from ordinal zero, so forcing ordinal n obliges that layer to hold at least n + 1 nodes: a forced node can raise a layer's effective size above its authored minimum and rule out layer sizes that would otherwise have been legal.

`public int GeneratorVersion`

:   The generator algorithm version paired with `SchemaVersion`. It is part of the generation key, so changing it changes every map these rules produce.

`public IReadOnlyList<LayerRangeAuthoring> Layers`

:   One row per layer, in layer order: the position in this list is the layer index the row describes.

`public int MaximumIncoming`

:   Merge cap: the most edges one node may receive from the layer below. It still has to leave room for a backbone that connects every layer.

`public int MaximumOutgoing`

:   Branch cap: the most edges one node may send to the layer above. It still has to leave room for a backbone that connects every layer.

`public IReadOnlyList<NodeTypeWeightAuthoring> NodeTypeWeights`

:   The node types the generator may reach for, and how often it reaches for each. This list is also the type domain: a type with no row here cannot be placed at all and cannot be named by a zone, quota, forced-node, or adjacency rule, so adding a type to the project is not enough on its own. Weights are proportional rather than ranked -- a weight of 3 is tried three times as often as a weight of 1 -- and compilation requires each to be between 1 and 1,000,000, so the zero the inspector will accept is reported as an error rather than read as "never choose this type".

`public int OptionalEdgeChance`

:   The chance out of 10,000 -- not out of 100 -- that each candidate optional edge is added, applied only after the mandatory backbone exists.

`public IReadOnlyList<QuotaAuthoring> Quotas`

:   Inclusive minimum and maximum counts for one node type, over the whole map or over a single zone. The generator treats each as a hard constraint rather than a preference, so a quota it cannot satisfy makes generation backtrack and finally fail with a diagnostic instead of returning a map that breaks the bound.

`public int SchemaVersion`

:   The rules schema version this asset was authored against; copied straight into the compiled snapshot.

`public IReadOnlyList<ZoneAuthoring> Zones`

:   Layer ranges that narrow what may appear inside them, through permitted and forbidden type lists and weight overrides that replace `NodeTypeWeights` for those layers. Ranges may not overlap, and a layer no zone covers falls back to the map-wide weights. A zone override may be zero, unlike a map-wide weight, which is how a type is kept out of one stretch of the map while staying available elsewhere.

**Methods**

`public void Configure()`

:   Overwrites the core of this ruleset in place -- default node type, layer rows, and node type weights -- and stamps the schema and generator versions this build authors. It is the code path behind generated starter assets, samples, and tests: the lists are replaced wholesale, zones, quotas, forced nodes, adjacencies, connection limits, and custom constraints are left exactly as they were, nothing is validated here, and the asset is neither marked dirty nor saved, so an editor caller still has to do that.
    - `defaultType` &mdash; Input default Type consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `layerRows` &mdash; One row per layer, in layer order; null clears the layers.
    - `weights` &mdash; Positive relative selection weight; zero or negative values are rejected by validation.

`public void ConfigureAdvanced()`

:   Overwrites every rule on this asset: everything `Configure` covers plus zones, quotas, forced nodes, forbidden adjacencies, the connection limits, and the custom constraints. Any sequence passed as null becomes an empty list, so unlike `Configure` -- which leaves the zone, quota, and connection settings untouched -- this resets every category and leaves nothing behind from an earlier configuration. It validates nothing -- contradictory rules surface when the asset is compiled -- and does not mark the asset dirty or save it.
    - `defaultType` &mdash; Input default Type consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `layerRows` &mdash; One row per layer, in layer order.
    - `weights` &mdash; Positive relative selection weight; zero or negative values are rejected by validation.
    - `zoneRows` &mdash; Layer ranges with their permitted types, forbidden types, and local weight overrides.
    - `quotaRows` &mdash; Minimum and maximum counts for a node type, optionally scoped to one zone.
    - `forcedRows` &mdash; Node types required at an exact layer and ordinal slot.
    - `adjacencyRows` &mdash; Node type pairs that may not end up adjacent.
    - `connectionId` &mdash; Stable ID for the compiled connection rules.
    - `maxOutgoing` &mdash; Branch cap: the most edges one node may send to the layer above.
    - `maxIncoming` &mdash; Merge cap: the most edges one node may receive from the layer below.
    - `optionalChance` &mdash; Chance out of 10,000 that each candidate optional edge is added.
    - `edgeCrossingPolicy` &mdash; Whether edge crossings are forbidden or allowed.
    - `constraints` &mdash; Custom constraint assets to compile alongside the built-in rules.

---

## MapRulesCompilation

```csharp
public sealed class MapRulesCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

The result of compiling one `MapRulesAsset`: the rule snapshot a generator can be
handed, every node type those rules referenced, and the diagnostics the compiler gathered.
`Value` is null when compilation failed, while `NodeTypes` still lists
whatever compiled cleanly, so a failed compilation is still worth reporting to an author.

**Constructors**

`public MapRulesCompilation(MapRuleSnapshot value, IEnumerable<CompiledMapNodeType> nodeTypes, ValidationReport validation)`

:   Pairs a rule snapshot with the node types it referenced and the report that describes both. The node types are copied and sorted by ID, so the caller's collection is neither retained nor reordered, and a null collection is stored as an empty one.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `nodeTypes` &mdash; Every node type the rules referenced. Null is treated as an empty set.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public IReadOnlyList<CompiledMapNodeType> NodeTypes`

:   Every node type the rules reached -- the default type, the weights, the zone lists, the quotas, the forced nodes, and the forbidden adjacencies -- compiled once each and ordered by ID rather than by where they were authored.

`public bool Succeeded`

:   True only when a snapshot was produced and no diagnostic is an error; warnings alone still succeed.

`public ValidationReport Validation`

:   The rules' own diagnostics together with those of every node type they referenced, so a fault in a shared node-type asset surfaces here rather than only where that asset lives.

`public MapRuleSnapshot Value`

:   The snapshot a generator can be handed, or null when compilation failed. The compiler discards a snapshot whose report holds any error rather than returning a half-built one, so a non-null value here is always one that passed rule validation.

---

## MapThemeAsset

:material-star: **Start here**

```csharp
public sealed class MapThemeAsset : ScriptableObject
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/MapThemeAsset.cs</small>

The authored asset that decides how a generated map is laid out and drawn:
layer and node spacing, which axis the layers run along, how edges are
shaped, the two colours the built-in views paint the backdrop and the routes
with, the zoom range the view allows, and how long a node state change is
given.

Create one from Assets > Create > BranchWeaver > Map Theme, then
compile it with `MapAuthoringCompiler.CompileTheme`; the
compiled theme is what the runtime, the presenters, and the input controller
actually read. Authored values are validated rather than clamped, so a value
outside the range noted on its property fails compilation with a diagnostic
instead of being quietly corrected.

None of it takes part in generation. Spacing and orientation size the
laid-out map without touching the graph the generator produced, so a theme
can be edited or swapped without invalidating a map or a save. Purely
cosmetic styling - palette, node shapes, per-state emphasis - lives in
`MapStylePreset` instead.

**Properties**

`public Color BackgroundColor`

:   Backdrop colour carried onto the compiled theme. Unlike the numeric fields it has no range, but every channel must be a finite number: a NaN or infinite channel fails compilation. A `MapStylePreset` carries its own backdrop tokens, so a project that assigns one is painted from the style rather than from here.

`public int BezierControlOffset`

:   How far along the flow axis a Bezier edge's control points are pushed away from its endpoints, in normalized map units where 10000 is the full span of the map, not in presentation units. Must be between 0 and 10000; 0 collapses the curve onto the straight line between the two nodes. Ignored unless `EdgeGeometry` is Bezier.

`public int BezierSegments`

:   How many line segments a Bezier edge is sampled into; higher is smoother and costlier. Must be between 2 and 64. Ignored unless `EdgeGeometry` is Bezier.

`public Color EdgeColor`

:   One flat colour for every route, whatever its state. The built-in presenters fall back to it only when no `MapStylePreset` is assigned; with a style in place a route is coloured by its traversal role instead, so this value stops being read. Every channel must be finite or compilation fails.

`public MapEdgeGeometryKind EdgeGeometry`

:   How a route between two nodes is shaped when the built-in views sample it. Only `MapEdgeGeometryKind.Bezier` reads `BezierSegments` and `BezierControlOffset`, but both are range-checked whichever kind is chosen, so an out-of-range Bezier field fails compilation even on a straight-edged theme.

`public int LayerSpacing`

:   Distance between two successive layers, in presentation units. Must be between 1 and `MapThemeLimits.MaximumSpacing`.

`public float MaximumZoom`

:   The highest zoom level the view allows, so the furthest it may zoom in. Must be at least `MinimumZoom` and no more than `MapThemeLimits.MaximumZoom`. Together the two bound every zoom the input controller applies.

`public float MinimumZoom`

:   The lowest zoom level the view allows, so the furthest it may zoom out. Must be greater than 0 and no greater than `MaximumZoom`.

`public int NodeSpacing`

:   Distance between two adjacent nodes inside one layer, in the same units as `LayerSpacing`. Must be between 1 and `MapThemeLimits.MaximumSpacing`, and it also drives the size the built-in views draw a node at.

`public MapLayoutOrientation Orientation`

:   Which axis the layers advance along, and so which way round the map is laid out. It sizes and orients the presentation only, so changing it redraws an existing map rather than invalidating the graph or any save taken from it.

`public string StableIdText`

:   The theme's authored identity, which survives renaming the asset. Empty rather than null when nothing was authored, and an empty or malformed ID fails compilation.

`public float StateTransitionSeconds`

:   The duration handed to a node or edge transition view each time that node or edge changes state. Must be between 0 and `MapThemeLimits.MaximumTransitionSeconds`; how a view spends it is the view's own business.

**Methods**

`public void ConfigureRuntime()`

:   Writes this theme's identity, layout, edge, zoom, and transition fields in one call, for building a theme from code instead of the Inspector - a starter or sample asset, a test fixture, or an instance made with ScriptableObject.CreateInstance. `BackgroundColor` and `EdgeColor` are not among them and keep whatever they already held, which on a freshly created instance is their authored default. Nothing is validated or clamped here: the values are stored exactly as given, and a value out of range is reported later, by `MapAuthoringCompiler.CompileTheme`. The call assigns the serialized fields directly, so it registers no undo step and does not mark the asset dirty; an editor caller that wants the change on disk must save the asset itself.
    - `id` &mdash; Input id consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `authoredLayerSpacing` &mdash; Sets `LayerSpacing`.
    - `authoredNodeSpacing` &mdash; Sets `NodeSpacing`.
    - `segments` &mdash; Sets `BezierSegments`.
    - `controlOffset` &mdash; Sets `BezierControlOffset`, in normalized map units.
    - `transitionSeconds` &mdash; Sets `StateTransitionSeconds`.
    - `layoutOrientation` &mdash; Input layout Orientation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `geometry` &mdash; Input geometry consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `minZoom` &mdash; Input min Zoom consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `maxZoom` &mdash; Input max Zoom consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

---

## MapThemeCompilation

```csharp
public sealed class MapThemeCompilation
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/RuntimeCompilation.cs</small>

The result of compiling one `MapThemeAsset`: the immutable theme on success, and in
every case the diagnostics the compiler gathered. Bad authoring is reported here rather than
thrown, so check `Succeeded` before reading `Value`.

**Constructors**

`public MapThemeCompilation(CompiledMapTheme value, ValidationReport validation)`

:   Pairs a compiled theme with the report that describes it. Pass null for `value` to record a failure.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `validation` &mdash; Input validation consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public bool Succeeded`

:   True only when a theme was produced and no diagnostic is an error; warnings alone still succeed.

`public ValidationReport Validation`

:   Everything the compiler found while reading the asset, errors and warnings alike, in the sorted order a `ValidationReport` keeps. It is the only channel bad theme authoring is reported through -- compilation does not throw -- and `MapAuthoringCompiler.CompileTheme(MapThemeAsset)` only builds a theme when this report came back completely empty, so in practice anything listed here means no theme was produced.

`public CompiledMapTheme Value`

:   Null when compilation failed.

---

## MapThemeLimits

```csharp
public static class MapThemeLimits
```

`BranchWeaver.Authoring` &middot; <small>BranchWeaver/Runtime/Authoring/AuthoringCompilation.cs</small>

The ceilings a map theme is compiled against. A `MapThemeAsset` that exceeds one
of these is rejected with a diagnostic rather than clamped, so an authoring UI of your own
should enforce them on its own fields instead of discovering them at compile time.

---

