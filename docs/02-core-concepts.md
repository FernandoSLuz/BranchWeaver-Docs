# 2. Core concepts

Six pieces. Understanding where the boundaries sit will save you from the two mistakes
that cause almost every integration problem: asking the presenter what is legal, and
expecting a style change to be reproducible state.

---

## The pipeline

```
MapRulesAsset          what is allowed
      |                (layers, widths, node types, connection rules)
      v
  Generator  + seed    deterministic search
      |
      v
   MapGraph            nodes, edges, layers -- immutable
      |
      v
  MapSession           where the traveller is, what is legal now
      |
      v
 MapPresenterBase      draws it (never decides anything)
      |
      v
  MapStylePreset       what it looks like (never changes the map)
```

Each arrow is one-way. Nothing downstream can affect anything upstream.

## 1. Rules describe constraints, not maps

A `MapRulesAsset` says "between 5 and 7 layers, each 2 to 4 nodes wide, a Rest node
may not follow another Rest node, at least one Gateway must appear". It does not say
where anything goes.

The generator searches for a graph satisfying all of it. That indirection is the point:
one rules asset produces endless valid maps, and a seed pins which one you get.

## 2. Determinism is structural, not promised

`BranchWeaver.Core` is compiled with `noEngineReferences: true`. It has no access to
`UnityEngine` at all -- not `Random`, not `Time`, not `GameObject`. Generation uses
`DeterministicRandom` seeded explicitly.

The practical consequence: **the same (rules, seed) always yields the same graph** on
every machine, platform, and Unity version. A bug report with a seed is a bug report
you can reproduce exactly.

## 3. MapGraph is immutable

Once generated, a graph does not change. Nodes have stable IDs; edges connect them;
layers order them. Traversal does not mutate the graph -- it tracks state *about* the
graph.

This is why saving is cheap and why replaying progress is reliable.

## 4. MapSession owns legality

`MapSession` is the authority on traversal:

```csharp
MapTransitionResult result = session.TryEnter(nodeId);
if (!result.Succeeded)
{
    // result tells you why. Illegal moves are data, not exceptions.
}
```

`TryEnter` returns a result rather than throwing, so "the player clicked an unreachable
node" is an ordinary branch in your code, not an error path.

**Never ask the presenter whether a move is legal.** The presenter dims a node because
the session said it is locked; the dimming is not the source of truth.

## 5. The presenter draws and nothing else

`MapPresenterBase` takes the graph plus runtime state and produces views. It has no
opinion about rules. Two implementations ship:

| Presenter | Space | Use when |
| --- | --- | --- |
| `CanvasMapPresenter` | Screen-space uGUI | The map is an overlay or a menu screen |
| `WorldMapPresenter` | World-space | The map lives in the scene, with a camera |

Both are driven by the same session and the same style. Swapping presenters does not
change behaviour.

### Fog of war

Nodes carry a fog state (`Visible`, `Dimmed`, `Hidden`) independently of their visual
state (`Locked`, `Available`, `Current`, `Visited`, `Completed`). Fog is about what the
player *knows*; visual state is about what they *can do*. The style composes both.

## 6. Style is presentation-only

A `MapStylePreset` holds the whole look: palette, node shape and size, per-state
emphasis, edge stroke, backdrop, typography, motion, and on-screen framing.

It never enters a graph, a save envelope, or a fingerprint. Restyling a map cannot
change the map. This is enforced, not merely intended.

### Style versus theme

Both exist, and they are not redundant:

| | Owns | Feeds compilation |
| --- | --- | --- |
| `MapThemeAsset` | Layer spacing, orientation, edge geometry, zoom limits | **Yes** |
| `MapStylePreset` | Colour, shape, stroke, glow, motion, framing | No |

Theme values participate in producing presentation positions, so they are part of the
compiled content. Style values are pure appearance. Keeping them apart is why adding
the style system required no migration of existing themes or saved blueprints.

---

## Stable IDs are a compatibility contract

Every node type, rule set, and blueprint carries a **stable ID** that is independent of
its asset name.

- Renaming the asset is safe.
- Changing the stable ID is a breaking change: saves referencing the old ID will not
  resolve.

Treat stable IDs the way you treat a database column name.

## Saving

`MapSaveSerializer` writes a versioned envelope; `MapSaveMigrations` upgrades older
envelopes on load. `FileMapSaveAdapter` provides file-backed slots with a fail-closed
unsafe-path guard, and `MemoryMapSaveAdapter` is the in-memory equivalent for tests.

Details in [guide 5](05-runtime-integration.md#saving-and-loading).

## Next

- **[Authoring maps](03-authoring-maps.md)** -- create the assets.
- **[API reference](api-reference.md)** -- exact signatures.
