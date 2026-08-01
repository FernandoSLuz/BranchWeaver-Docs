# Core concepts

A map passes through six stages between a rules asset and something on screen. After
this page you can name each stage, say what it decides, and treat stable IDs as the one
thing you do not change casually.

## The pipeline

```
MapRulesAsset + MapNodeTypeAsset    what is allowed
        |
        v
MapAuthoringCompiler                reads assets into immutable snapshots
        |
        v
IMapGenerator + seed                deterministic search
        |
        v
MapGraph                            nodes, edges, layers -- immutable
        |
        v
MapSession                          where the traveller is, what is legal now
        |
        v
MapPresenterBase + MapStylePreset   draws it, decides nothing
```

Every stage above is something you can select. In a scene built by the Setup Wizard, the rules and
blueprint sit in the **Blueprint** field, the session lives inside `MapTraversalController`, and the
presenter is the child object drawing the nodes you see in the Game view.

![A Unity scene with BranchWeaver Playable Map selected, its Map Traversal Controller and Branch Weaver Map Host components in the Inspector, and the generated map running in the Game view](../assets/images/completed-scene-hierarchy.png){ .shot }

### What each stage decides

| Stage | Decides |
| --- | --- |
| `MapRulesAsset` | Which maps are acceptable at all |
| `IMapGenerator` | Which acceptable map this seed produces |
| `MapGraph` | What exists: nodes, their types, edges between adjacent layers |
| `MapSession` | Where the traveller is and which nodes may be entered now |
| Presenter and style | Where things sit on screen and what they look like |

### One-way by construction

Every arrow runs one way, and the assembly layout enforces it. `BranchWeaver.Core` is
compiled with `noEngineReferences: true` and references nothing at all.
`BranchWeaver.Authoring` references Core; `BranchWeaver.Runtime` references both; the
Canvas and World2D presentation assemblies sit on top of those. The generator cannot
see a style asset, so restyling a map cannot change it.

## Rules describe constraints, not maps

A `MapRulesAsset` holds one **layer row** per layer, each row an inclusive minimum and
maximum node count. The number of rows sets how many layers the map has; each row's
range sets how wide that layer may come out. Around that sit per-type weights, zones
(non-overlapping layer ranges with permitted or forbidden types and local weight
overrides), quotas, forced slots, forbidden type adjacency, incoming and outgoing edge
caps, an optional-edge chance, an edge-crossing policy, and any custom constraint assets.

None of it says where a particular node goes. The generator searches for a graph that
satisfies all of it, and the seed pins which satisfying graph you get. That indirection
is the point: one rules asset produces endless valid maps.

When nothing satisfies the rules you get a failed `MapGenerationResult` rather than a
broken map. `FailureKind` separates the cases that need different fixes: `Unsatisfiable`
means the constraints contradict each other, `SearchBudgetExhausted` means the search ran
out of trials. See [Write map rules](../how-to/write-map-rules.md) for the diagnostic.

## MapGraph is immutable

`MapGraph` is a snapshot. Its constructor copies the nodes and edges it is handed, sorts
them into a canonical order, and exposes read-only views over private arrays. Nothing
changes it afterwards.

- A node carries its ID, its type ID, its layer, its ordinal within that layer, a
  normalised position, and an optional payload.
- An edge carries its own ID plus a source and a target, and always runs from one layer
  to the next.

Traversal never writes to the graph. It tracks state *about* the graph in a separate
`MapProgressionState`. That is why progress can be replayed from a save, why two
sessions can share one graph, and why nothing on screen can corrupt the map.

## MapSession owns legality

`MapSession` is the only authority on traversal. It answers from the graph and the
progression state, never from anything visual.

### What the session decides

- Every node with no incoming edge is available at the start.
- `TryEnter` succeeds only for a node the current state lists as available.
- While a node is current, nothing else is available. Completing it publishes that
  node's outgoing neighbours.
- Completing a node with no outgoing edges completes the map.
- The alternatives you passed over do not become available again.

### Reading a refusal

```csharp
MapTransitionResult result = session.TryEnter(nodeId);
if (!result.Succeeded)
{
    // result.FailureKind names what refused -- NodeUnavailable, CurrentNodeActive,
    // MapAlreadyCompleted. result.Validation carries the diagnostic.
}
```

Illegal moves are data, not exceptions, so "the player clicked an unreachable node" is
an ordinary branch in your code rather than an error path.

!!! warning "Never ask the presenter whether a move is legal"
    A node is dimmed because the session said it was locked. The dimming is a
    consequence, not a source of truth. In a scene, `MapTraversalController` owns one
    session and forwards `RequestNodeSelection` to `TryEnter` -- see
    [Drive traversal from code](../how-to/drive-traversal-from-code.md).

## Stable IDs are a compatibility contract

Node types, themes and styles each carry an explicit **Stable Id** field, held separately
from the asset name. Rule rows -- zones, quotas, forced nodes, adjacency pairs,
connections -- carry their own rule IDs, and a blueprint's node and edge rows carry the
IDs the graph itself will use. A stable ID may contain lowercase ASCII letters, digits,
`.`, `_` and `-`.

Asset names, paths, GUIDs and instance IDs take no part in map identity, so renaming or
moving an asset is safe. Editing a stable ID is not.

| Change | Effect |
| --- | --- |
| Rename or move the asset | Nothing. The ID is serialized data, not the name. |
| Change a node type or rule ID | The rules fingerprint changes, so old seeds stop reproducing their maps. |
| Change a node type ID with saves in the wild | A saved graph still holds the old ID. A node whose type no longer resolves is skipped and never drawn. |

Treat a stable ID the way you treat a database column name. Plan the migration before
you change one -- see [Save and load progress](../how-to/save-and-load.md).

## Next

- **[Determinism, seeds, and fingerprints](determinism.md)** -- why the same rules and
  seed always return the same graph, and what makes an old seed stop reproducing it.
- **[Style, theme, and the presenter boundary](style-and-theme.md)** -- which setting
  belongs to the theme, which to the style, and why the presenter decides nothing.
- **[Drive traversal from code](../how-to/drive-traversal-from-code.md)** -- events,
  progression state, and moving the traveller legally.
