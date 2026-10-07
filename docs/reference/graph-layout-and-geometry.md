# Graph, layout and geometry

10 types in this area.

!!! abstract "On this page"
    [IMapLayoutStrategy](#imaplayoutstrategy) &middot; [LayeredMapLayoutStrategy](#layeredmaplayoutstrategy) &middot; [MapEdge](#mapedge) &middot; [MapGraph](#mapgraph) &middot; [MapLayout](#maplayout) &middot; [MapLayoutNode](#maplayoutnode) &middot; [MapLayoutOrientation](#maplayoutorientation) &middot; [MapLayoutRequest](#maplayoutrequest) &middot; [MapNode](#mapnode) &middot; [NormalizedMapPosition](#normalizedmapposition)

## IMapLayoutStrategy

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapLayoutStrategy
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

Turns a graph's topology into normalized node positions. Implement this to replace the
shipped layered layout without touching graph identity: a presenter calls it only when
the graph or the compiled content instance changes, never per frame.

**Methods**

`public MapLayout Layout(MapGraph graph, MapLayoutRequest request)`

:   Produces the positions for one graph. Implementations must be deterministic - the same graph and request must yield the same positions in the same order, on every machine and under every culture - because node placement, edge endpoints, and directional focus navigation are all derived from these numbers. Do not mutate `graph` and do not keep per-call state on the instance; one strategy instance serves every graph a presenter shows. Every position must satisfy `NormalizedMapPosition.IsWithinBounds` and each node may appear once, or `MapLayout` will reject the result.
    - `graph` &mdash; Graph to lay out; read it only.
    - `request` &mdash; Orientation and the normalized band to fill. Validate it yourself if your strategy honours the bounds.
    - **Returns** &mdash; A layout built for the request's orientation. Must never be null.

---

## LayeredMapLayoutStrategy

:material-star: **Start here**

```csharp
public sealed class LayeredMapLayoutStrategy : IMapLayoutStrategy
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

The shipped layout. Nodes are grouped by `MapNode.Layer`, the layers are
spread in ascending order from the request's layer start to its layer end inclusive, and
the nodes of one layer are placed at interior cross coordinates that never touch the
cross bounds. Within a layer the order is `MapNode.Ordinal` then node id, and
every coordinate is integer arithmetic, so the same graph lays out identically run to run
and culture to culture. The instance holds no mutable state and can be reused.

**Methods**

`public MapLayout Layout(MapGraph graph, MapLayoutRequest request)`

:   Lays the graph out layer by layer. It validates the request's bounds and requires at least two distinct layers, because a single layer leaves no span to advance along.
    - `graph` &mdash; Graph to lay out; it is only read. Node ids must be non-empty and unique.
    - `request` &mdash; Orientation and normalized band to fill. Vertical puts the cross axis on X and the layers on Y; Horizontal is the transpose.
    - **Returns** &mdash; A layout holding one entry per graph node, ordered by node id.

---

## MapEdge

:material-star: **Start here**

```csharp
public readonly struct MapEdge : IEquatable<MapEdge>, IComparable<MapEdge>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGraph.cs</small>

A directed connection from one node to another, with a stable identity of its own so a route can
be recorded and reloaded by edge rather than by node pair. It is a value type compared on all
three ids, and it sorts by source, then target, then id -- which is the order
`MapGraph.Edges` is held in, so equal edge sets always enumerate identically.

**Constructors**

`public MapEdge(StableId id, StableId sourceId, StableId targetId)`

:   Records a directed edge exactly as supplied; graph validation later checks identities and endpoint membership.
    - `id` &mdash; The edge identity, which distinguishes parallel edges with the same endpoints.
    - `sourceId` &mdash; Id of the node the edge leaves.
    - `targetId` &mdash; Id of the node the edge arrives at, normally one layer further on.

**Properties**

`public StableId Id`

:   The edge's own identity, unique within the graph and independent of its endpoints. Two edges joining the same pair of nodes are distinct values because of it, so a recorded route should key on this rather than on the node pair.

`public StableId SourceId`

:   Id of the node the edge leaves. It is the first key edges sort on, so `MapGraph.Edges` arrives grouped by source node.

`public StableId TargetId`

:   Id of the node the edge arrives at, one layer further on in a valid graph. Nothing on this struct checks that the node exists or that the layers are adjacent; graph validation does.

**Methods**

`public int CompareTo(MapEdge other)`

:   Orders edges canonically: source id first, then target id, then edge id. This is the ordering `MapGraph` sorts its edge list into, and it is what makes an exported or fingerprinted graph byte-stable across runs.
    - `other` &mdash; The edge placed before or after this one using source, target, then edge identity.
    - **Returns** &mdash; Negative, zero or positive in the usual comparison sense.

`public bool Equals(MapEdge other)`

:   Compares all three ids. Two edges that join the same pair of nodes under different edge ids are therefore not equal.
    - `other` &mdash; The edge whose id and endpoints are compared with this value.
    - **Returns** &mdash; True when id, source and target all match.

`public override bool Equals(object obj)`

:   Value equality against another `MapEdge`; anything else is never equal.
    - `obj` &mdash; The object to test; non-`MapEdge` values compare unequal.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   A hash over all three ids, matching `Equals(MapEdge)`.
    - **Returns** &mdash; A deterministic combined hash of the edge id, source id, and target id.

`public override string ToString()`

:   Renders the edge as `id:source->target`. Diagnostics use this form, so it is the string to search for when tracing a reported edge back to its data.
    - **Returns** &mdash; The diagnostic form `id:source->target` using each stable id's canonical text.

---

## MapGraph

:material-star: **Start here**

```csharp
public sealed class MapGraph
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGraph.cs</small>

An immutable graph snapshot. Constructor inputs are defensively copied, and all exposed
collections are read-only views over private arrays. It is also the canonical form of a map: the
constructor sorts nodes and edges into a fixed order and indexes them, so the same rules and seed
give a graph that enumerates, fingerprints and exports identically on every run and platform --
which is what lets a game store a seed instead of a map. Nothing here mutates, so a graph can be
handed to the runtime, the views and the save layer at once without copying.

**Constructors**

`public MapGraph( int formatVersion, int generatorVersion, uint seed, string rulesFingerprint, IEnumerable<MapNode> nodes, IEnumerable<MapEdge> edges)`

:   Copies and canonically sorts a procedural graph, leaving generation-key and override metadata empty. Null node or edge sequences throw; individual entries remain for validation to diagnose.
    - `formatVersion` &mdash; The serialized graph schema revision that selects the canonical node comparer.
    - `generatorVersion` &mdash; The generation algorithm revision recorded with the graph.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; Lowercase SHA-256 of the rule snapshot used. Null becomes an empty string; the value is stored as given and not recomputed.
    - `nodes` &mdash; Nodes to defensively copy and sort; null throws `ArgumentNullException`.
    - `edges` &mdash; Edges to defensively copy and sort; null throws `ArgumentNullException`.

`public MapGraph( int formatVersion, int generatorVersion, uint seed, string rulesFingerprint, MapGenerationMode generationMode, string overridesFingerprint, string generationKey, IEnumerable<MapNode> nodes, IEnumerable<MapEdge> edges)`

:   Copies and canonically sorts graph contents, then builds node and outgoing-edge indexes. Duplicate or empty node identities are deliberately omitted from lookup so validation can report them.
    - `formatVersion` &mdash; The serialized graph schema revision that selects the canonical node comparer.
    - `generatorVersion` &mdash; The generation algorithm revision recorded with the graph.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; Lowercase SHA-256 of the rule snapshot used. Null becomes an empty string; the value is stored as given and not recomputed.
    - `generationMode` &mdash; How the map was produced: procedural, manual, or hybrid.
    - `overridesFingerprint` &mdash; Lowercase SHA-256 of the overrides applied, or empty when there were none. Null becomes empty.
    - `generationKey` &mdash; The canonical generation-input hash; null is normalized to an empty string.
    - `nodes` &mdash; Nodes to defensively copy and sort; null throws `ArgumentNullException`.
    - `edges` &mdash; Edges to defensively copy and sort; null throws `ArgumentNullException`.

**Properties**

`public IReadOnlyList<MapEdge> Edges`

:   Every edge, sorted by source, then target, then edge id. Read-only, and stable for the same reason `Nodes` is.

`public int FormatVersion`

:   Which graph format this snapshot follows, and therefore which canonical node order and which metadata rules apply to it.

`public string GenerationKey`

:   One hash over the whole generation input: generator version, mode, rules fingerprint, overrides fingerprint and seed. Generated node and edge ids are derived from it, so two runs that share a key produce the same identities.

`public MapGenerationMode GenerationMode`

:   How the map was produced: from rules and seed alone, from overrides alone, or by a seeded search that had to honour the overrides it was given. It is hashed into `GenerationKey`, so two maps differing only in mode are different maps with different node ids.

`public int GeneratorVersion`

:   The generator version of the rules this graph was built from. Validation requires it to match the rules it is checked against, which is how a graph built against older rules is caught.

`public IReadOnlyList<MapNode> Nodes`

:   Every node, in canonical order: layer, then ordinal, then id, then position, then type -- and, on a version-two graph, payload. Read-only, and the order is part of the contract, so an index into this list means the same thing on every run.

`public string OverridesFingerprint`

:   Lowercase SHA-256 of the overrides that shaped the map, empty when there were none -- always empty on a version-one graph.

`public string RulesFingerprint`

:   Lowercase SHA-256 of the rule snapshot the map was generated from, or empty when none was recorded. Compare it against the current rules to detect a map that predates a rules change.

`public uint Seed`

:   The seed the map was generated from. With the same rules and overrides it reproduces this exact graph, so storing the seed is enough to rebuild the map.

**Fields**

`public const int CurrentFormatVersion`

:   The newest format, `FormatVersion2`. A graph's own version is fixed by the generator version of the rules it was built from, so version-one rules still yield version-one graphs and validation rejects any other pairing.

`public const int FormatVersion1`

:   The original graph format: procedural generation only, with no overrides, generation key or node payloads, and a node order that ignores payloads.

`public const int FormatVersion2`

:   The current graph format, which adds the generation mode, the overrides fingerprint, the generation key and per-node payloads, and folds payloads into the canonical node order.

`public const int LatestFormatVersion`

:   The newest format this build understands; the same value as `CurrentFormatVersion`.

**Methods**

`public IReadOnlyList<StableId> GetOutgoing(StableId sourceId)`

:   The ids of the nodes reachable in one step from `sourceId`, in ascending id order. Returns a cached read-only list -- an unknown or terminal node gives an empty list rather than null, and no call allocates, so this is safe to walk every frame.
    - `sourceId` &mdash; The source node identity whose edge targets are requested; unknown or empty identities return the shared empty list.
    - **Returns** &mdash; Target node ids, not edge ids; one entry per outgoing edge, so a repeated edge shows its target more than once.

`public bool TryGetNode(StableId id, out MapNode node)`

:   Looks a node up by id through the index built at construction, without scanning `Nodes`. An id that is empty, or that more than one node claims, is deliberately not indexed, so this returns false for it even though the node is present -- treat a false here on a validated graph as an unknown id, not as a duplicate.
    - `id` &mdash; The node identity to resolve through the construction-time index.
    - `node` &mdash; Receives the indexed node, or null when the identity is absent, empty, or ambiguous.
    - **Returns** &mdash; True when a single node owns that id.

---

## MapLayout

:material-star: **Start here**

```csharp
public sealed class MapLayout
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

The immutable result of one layout pass: every laid-out node with its normalized
position, plus the orientation those positions were built for. Input nodes are copied
and sorted on construction and no member mutates afterwards, so a layout can be held
and read while the graph it came from is presented. It keeps no reference to that graph:
positions are presentation data, and replacing a layout cannot change graph identity.

**Constructors**

`public MapLayout(MapLayoutOrientation orientation, IEnumerable<MapLayoutNode> nodes)`

:   Validates, copies, and sorts positioned nodes, then indexes them by id. Invalid orientation, null input, duplicate or empty ids, and coordinates outside the normalized square throw.
    - `orientation` &mdash; Orientation the positions were computed for; must be Vertical or Horizontal.
    - `nodes` &mdash; Positioned nodes, copied on entry. Ids must be non-empty and unique, and every position must satisfy `NormalizedMapPosition.IsWithinBounds`.

**Properties**

`public IReadOnlyList<MapLayoutNode> Nodes`

:   Read-only view over the laid-out nodes, ordered by node id rather than by layer.

`public MapLayoutOrientation Orientation`

:   The orientation these positions were computed for. Presentation needs it because a normalized position does not say which of its two axes carries progress, and the flow direction a style asks for is applied relative to that axis.

**Methods**

`public bool TryGetPosition(StableId nodeId, out NormalizedMapPosition position)`

:   Looks up one node's position without allocating. It returns false for any id this pass did not lay out, including graph nodes a custom strategy chose to skip.
    - `position` &mdash; Receives the stored normalized coordinates, or the default position when lookup fails.
    - `nodeId` &mdash; The graph-node identity whose laid-out coordinates are requested.
    - **Returns** &mdash; True when this layout holds `nodeId`.

---

## MapLayoutNode

:material-star: **Start here**

```csharp
public readonly struct MapLayoutNode : IEquatable<MapLayoutNode>, IComparable<MapLayoutNode>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

One node paired with the position a layout pass gave it. Ordering uses
`NodeId` alone while equality also compares `Position`, so
sorting a set of these never depends on where the nodes ended up.

**Constructors**

`public MapLayoutNode(StableId nodeId, NormalizedMapPosition position)`

:   Pairs a node with a position. Nothing is validated here; `MapLayout` rejects empty ids and out-of-range positions when the entry is handed to it.
    - `nodeId` &mdash; The graph-node identity being placed; this value may be empty until a `MapLayout` validates it.
    - `position` &mdash; The integer normalized coordinates assigned by the layout strategy.

**Properties**

`public StableId NodeId`

:   Identity of the node this entry places, and the only key ordering considers.

`public NormalizedMapPosition Position`

:   Where the pass put the node, in normalized units. It takes part in equality but not in ordering, so two runs of a layout produce entries that sort into the same sequence even when the positions inside them differ.

**Methods**

`public int CompareTo(MapLayoutNode other)`

:   Orders by `NodeId` only. Two entries for the same node compare equal even when their positions differ.
    - `other` &mdash; The layout entry whose node identity determines ordering.
    - **Returns** &mdash; A negative value, zero, or a positive value from comparing node identities only.

`public bool Equals(MapLayoutNode other)`

:   Value equality over both `NodeId` and `Position`, unlike `CompareTo(MapLayoutNode)`, which ignores the position.
    - `other` &mdash; The layout entry whose node identity and normalized coordinates are compared.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Value equality against a boxed entry, on the same terms as `Equals(MapLayoutNode)`.
    - `obj` &mdash; Candidate to compare with; anything that is not a `MapLayoutNode`, null included, is unequal.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Combines the node id with the position, matching `Equals(MapLayoutNode)`. Two entries for the same node at different positions therefore hash apart, even though `CompareTo(MapLayoutNode)` treats them as equal.
    - **Returns** &mdash; A deterministic combined hash of node identity and normalized coordinates.

---

## MapLayoutOrientation

:material-star: **Start here**

```csharp
public enum MapLayoutOrientation
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

Which axis a layout advances its layers along. Vertical stacks the layers up Y and spreads
the nodes of one layer across X; Horizontal is the transpose. Whichever axis is left over
is the cross axis the request's cross bounds describe.

This is a property of the positions a layout produced rather than of the graph, which is
why a `MapLayout` records the orientation it was built for: a normalized
position on its own does not say which of its two numbers carries progress.

| Value | Meaning |
| --- | --- |
| `Vertical` | Layers advance from bottom to top on Y while nodes in each layer spread across X. |
| `Horizontal` | Layers advance from left to right on X while nodes in each layer spread across Y. |

---

## MapLayoutRequest

:material-star: **Start here**

```csharp
public readonly struct MapLayoutRequest
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

The band a layout is asked to fill, in normalized
0..`NormalizedMapPosition.Scale` units: layers advance along the
orientation's axis between the layer bounds, and the nodes sharing a layer spread
across the cross bounds. Constructing one never validates, so a malformed band
surfaces from `LayeredMapLayoutStrategy.Layout(MapGraph, MapLayoutRequest)`
rather than here.

**Constructors**

`public MapLayoutRequest( MapLayoutOrientation orientation, int layerStart = 0, int layerEnd = NormalizedMapPosition.Scale, int crossStart = 0, int crossEnd = NormalizedMapPosition.Scale)`

:   Records an orientation and normalized layout band without validating either; the strategy rejects malformed bounds when used.
    - `orientation` &mdash; Axis layers advance along: Vertical advances along Y, Horizontal along X.
    - `layerStart` &mdash; Where the layer band begins; the shipped strategy places the first layer exactly here.
    - `layerEnd` &mdash; Where the layer band ends; the shipped strategy places the last layer exactly here.
    - `crossStart` &mdash; Where the cross band begins; the shipped strategy keeps nodes strictly inside it.
    - `crossEnd` &mdash; Where the cross band ends.

**Properties**

`public int CrossEnd`

:   End of the cross band, left clear on the same terms as `CrossStart`.

`public int CrossStart`

:   Where the cross band begins. The shipped strategy places nodes at interior coordinates only, so no node ever lands on this bound however many share a layer.

`public static MapLayoutRequest Horizontal`

:   A horizontal request covering the full normalized range on both axes.

`public int LayerEnd`

:   Where the layer band ends, capped at `NormalizedMapPosition.Scale`. The shipped strategy puts the first and last layers exactly on the two bounds, so this pair fixes the visible extent of the map along the orientation's axis.

`public int LayerStart`

:   Where the layer band begins. It must be at least zero and strictly below `LayerEnd`, or the shipped strategy rejects the request.

`public MapLayoutOrientation Orientation`

:   Axis layers advance along; the remaining axis is the cross axis.

`public static MapLayoutRequest Vertical`

:   A vertical request covering the full normalized range on both axes.

---

## MapNode

:material-star: **Start here**

```csharp
public sealed class MapNode
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGraph.cs</small>

One node of a generated map: its identity, the node type chosen for it, its slot in the layered
grid, and any authored payload. It is immutable and holds no scene or view state, so the same
instance can be shared by the runtime, the presentation layer and save data at the same time.
`Id` is the value a game should persist and hang its own progress off, and positions
are normalized integers rather than world units, so a graph never depends on resolution, camera
or layout choices.

**Constructors**

`public MapNode( StableId id, StableId typeId, int layer, int ordinal, NormalizedMapPosition position)`

:   Records a node with an empty payload; identifiers, indices, and position are stored without validation.
    - `id` &mdash; The node identity to store; uniqueness and non-empty requirements are checked by graph validation.
    - `typeId` &mdash; The authored node-type identity to store; rule membership is checked by graph validation.
    - `layer` &mdash; Zero-based index of the layer the node sits in, counting from the start layer.
    - `ordinal` &mdash; Zero-based slot of the node within its layer.
    - `position` &mdash; Normalized placement, each axis in 0..`NormalizedMapPosition.Scale`. Generators spread ordinals along X and layers along Y; nothing here enforces that.

`public MapNode( StableId id, StableId typeId, int layer, int ordinal, NormalizedMapPosition position, MapNodePayload payload)`

:   Records all node fields, replacing a null payload with `MapNodePayload.Empty` and otherwise retaining the payload reference.
    - `id` &mdash; The node identity to store; uniqueness and non-empty requirements are checked by graph validation.
    - `typeId` &mdash; The authored node-type identity to store; rule membership is checked by graph validation.
    - `layer` &mdash; Zero-based index of the layer the node sits in, counting from the start layer.
    - `ordinal` &mdash; Zero-based slot of the node within its layer.
    - `position` &mdash; Normalized placement, each axis in 0..`NormalizedMapPosition.Scale`. Generators spread ordinals along X and layers along Y; nothing here enforces that.
    - `payload` &mdash; Authored per-node data. Only version-two graphs may carry a non-empty payload.

**Properties**

`public StableId Id`

:   The node's stable identity, unique within the graph. Generated ids are derived from the graph's `MapGraph.GenerationKey`, so the same rules, overrides and seed yield the same ids again -- which is what makes this the value to persist and to hang a game's own per-node progress off, rather than a list index.

`public int Layer`

:   Zero-based index of the layer this node sits in. A valid graph only contains edges from one layer to the next, so this doubles as the node's distance from the start of the map.

`public int Ordinal`

:   Zero-based slot of this node within its layer. Layer plus ordinal is what the canonical node order sorts on first, so it is stable across runs of the same seed.

`public MapNodePayload Payload`

:   Authored per-node data. Never null: a node built without one carries `MapNodePayload.Empty`.

`public NormalizedMapPosition Position`

:   Normalized placement, each axis in 0..`NormalizedMapPosition.Scale` rather than world or pixel units. A layout strategy maps it onto the space it draws into.

`public StableId TypeId`

:   The node type assigned to this node. It names an entry in the rules the map was generated against, so resolving it to content is the consumer's job, not the graph's.

---

## NormalizedMapPosition

:material-star: **Start here**

```csharp
public readonly struct NormalizedMapPosition : IEquatable<NormalizedMapPosition>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGeometry.cs</small>

An integer-normalized map position. The conventional valid range is 0..Scale on each axis.
Values are not clamped so validators can report malformed imported data without losing it.

**Constructors**

`public NormalizedMapPosition(int x, int y)`

:   Raw integer coordinates are retained without clamping; use `IsWithinBounds` to test the conventional normalized square.
    - `x` &mdash; Horizontal coordinate, conventionally 0 to `Scale` inclusive.
    - `y` &mdash; Vertical coordinate, conventionally 0 to `Scale` inclusive.

**Properties**

`public bool IsWithinBounds`

:   True when both coordinates lie in the inclusive 0 to `Scale` range. This is the only place the range is enforced -- construction accepts anything -- so validators and compilers call it to reject a malformed position rather than trusting the type.

`public int X`

:   Horizontal coordinate, 0 at the left edge of the map and `Scale` at the right. Presentation divides it by `Scale` to get a fraction of the laid-out width.

`public int Y`

:   Vertical coordinate, 0 at the bottom edge of the map and `Scale` at the top. Presentation divides it by `Scale` to get a fraction of the laid-out height.

**Fields**

`public const int Scale`

:   The integer value representing one full normalized axis, giving positions four decimal places of precision.

**Methods**

`public static int EndpointCoordinateForIndex(int index, int count)`

:   Spans a layered axis from exactly zero to exactly `Scale`.
    - `index` &mdash; Zero-based index used for deterministic ordering; negative values are invalid.
    - `count` &mdash; The total number of endpoint-inclusive positions; it must be at least two.
    - **Returns** &mdash; The truncated integer coordinate `index * Scale / (count - 1)`, including exact endpoints for first and last.

`public bool Equals(NormalizedMapPosition other)`

:   Reports whether both positions hold the same pair of coordinates. Being integers, they compare exactly -- there is no tolerance to worry about.
    - `other` &mdash; The position whose raw X and Y integers are compared.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a position with the same coordinates.
    - `obj` &mdash; The object to test; only a normalized position with identical integer coordinates can match.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash combining both coordinates. It is derived from the two integers alone, so it is the same in every process and on every platform and may safely be persisted or compared across machines.
    - **Returns** &mdash; A deterministic combined hash of the raw X and Y coordinates.

`public static int InteriorCoordinateForOrdinal(int ordinal, int nodeCount)`

:   Places a node inside an axis without touching its endpoints.
    - `ordinal` &mdash; Zero-based ordinal used for deterministic ordering; negative values are invalid.
    - `nodeCount` &mdash; The positive number of evenly spaced interior positions sharing the axis.
    - **Returns** &mdash; The truncated integer coordinate `(ordinal + 1) * Scale / (nodeCount + 1)`, strictly between both endpoints.

`public override string ToString()`

:   Returns the coordinates as `x,y`. It is meant for diagnostic context and logs, not for display to players.
    - **Returns** &mdash; The decimal diagnostic form `x,y` without applying scale or localization.

---

