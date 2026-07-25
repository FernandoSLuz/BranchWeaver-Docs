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

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## LayeredMapLayoutStrategy

```csharp
public sealed class LayeredMapLayoutStrategy : IMapLayoutStrategy
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public int Compare(MapNode left, MapNode right)`

:   &mdash;

`public MapLayout Layout(MapGraph graph, MapLayoutRequest request)`

:   &mdash;

---

## MapEdge

```csharp
public readonly struct MapEdge : IEquatable<MapEdge>, IComparable<MapEdge>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGraph.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapEdge(StableId id, StableId sourceId, StableId targetId)`

:   &mdash;

**Properties**

`public StableId Id`

:   &mdash;

`public StableId SourceId`

:   &mdash;

`public StableId TargetId`

:   &mdash;

**Methods**

`public int CompareTo(MapEdge other)`

:   &mdash;

`public bool Equals(MapEdge other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public override string ToString()`

:   &mdash;

---

## MapGraph

:material-star: **Start here**

```csharp
public sealed class MapGraph
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGraph.cs</small>

An immutable graph snapshot. Constructor inputs are defensively copied, and all exposed
collections are read-only views over private arrays.

**Constructors**

`public MapGraph()`

:   &mdash;

`public MapGraph()`

:   &mdash;

**Properties**

`public IReadOnlyList<MapEdge> Edges`

:   &mdash;

`public int FormatVersion`

:   &mdash;

`public string GenerationKey`

:   &mdash;

`public MapGenerationMode GenerationMode`

:   &mdash;

`public int GeneratorVersion`

:   &mdash;

`public IReadOnlyList<MapNode> Nodes`

:   &mdash;

`public string OverridesFingerprint`

:   &mdash;

`public string RulesFingerprint`

:   &mdash;

`public uint Seed`

:   &mdash;

**Methods**

`public IReadOnlyList<StableId> GetOutgoing(StableId sourceId)`

:   &mdash;

`public bool TryGetNode(StableId id, out MapNode node)`

:   &mdash;

---

## MapLayout

```csharp
public sealed class MapLayout
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapLayout(MapLayoutOrientation orientation, IEnumerable<MapLayoutNode> nodes)`

:   &mdash;

**Properties**

`public IReadOnlyList<MapLayoutNode> Nodes`

:   &mdash;

`public MapLayoutOrientation Orientation`

:   &mdash;

**Methods**

`public bool TryGetPosition(StableId nodeId, out NormalizedMapPosition position)`

:   &mdash;

---

## MapLayoutNode

```csharp
public readonly struct MapLayoutNode : IEquatable<MapLayoutNode>, IComparable<MapLayoutNode>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapLayoutNode(StableId nodeId, NormalizedMapPosition position)`

:   &mdash;

**Properties**

`public StableId NodeId`

:   &mdash;

`public NormalizedMapPosition Position`

:   &mdash;

**Methods**

`public int CompareTo(MapLayoutNode other)`

:   &mdash;

`public bool Equals(MapLayoutNode other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

---

## MapLayoutOrientation

```csharp
public enum MapLayoutOrientation
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Vertical` | &mdash; |
| `Horizontal` | &mdash; |

---

## MapLayoutRequest

```csharp
public readonly struct MapLayoutRequest
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Layout/MapLayout.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapLayoutRequest()`

:   &mdash;

**Properties**

`public int CrossEnd`

:   &mdash;

`public int CrossStart`

:   &mdash;

`public static MapLayoutRequest Horizontal`

:   &mdash;

`public int LayerEnd`

:   &mdash;

`public int LayerStart`

:   &mdash;

`public MapLayoutOrientation Orientation`

:   &mdash;

`public static MapLayoutRequest Vertical`

:   &mdash;

---

## MapNode

:material-star: **Start here**

```csharp
public sealed class MapNode
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGraph.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapNode()`

:   &mdash;

`public MapNode()`

:   &mdash;

**Properties**

`public StableId Id`

:   &mdash;

`public int Layer`

:   &mdash;

`public int Ordinal`

:   &mdash;

`public MapNodePayload Payload`

:   &mdash;

`public NormalizedMapPosition Position`

:   &mdash;

`public StableId TypeId`

:   &mdash;

---

## NormalizedMapPosition

```csharp
public readonly struct NormalizedMapPosition : IEquatable<NormalizedMapPosition>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapGeometry.cs</small>

An integer-normalized map position. The conventional valid range is 0..Scale on each axis.
Values are not clamped so validators can report malformed imported data without losing it.

**Constructors**

`public NormalizedMapPosition(int x, int y)`

:   &mdash;

**Properties**

`public bool IsWithinBounds`

:   &mdash;

`public int X`

:   &mdash;

`public int Y`

:   &mdash;

**Methods**

`public static int EndpointCoordinateForIndex(int index, int count)`

:   Spans a layered axis from exactly zero to exactly `cale`.

`public bool Equals(NormalizedMapPosition other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public static int InteriorCoordinateForOrdinal(int ordinal, int nodeCount)`

:   Places a node inside an axis without touching its endpoints.

`public override string ToString()`

:   &mdash;

---

