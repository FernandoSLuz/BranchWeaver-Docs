# Control what the player can see

Fog decides which nodes and routes are drawn, drawn dim, or not drawn at all. It is derived
from progression every time runtime state is read and never stored, so changing it
re-reveals an existing save correctly with no migration.

## Fog settings

The `MapTraversalController` serializes one `MapFogSettings` value, under **Fog of war** in
the inspector.

| Field | Effect | Default |
| --- | --- | --- |
| **Reveal Depth** | How many edges ahead of a reached node stay visible, drawn dimmed. Negative values are clamped to 0. | `1` |
| **Reveal Incoming** | Also reveals the nodes that lead *into* a reached node, for maps a traveller can move back through. | off |
| **Reveal All** | Reveals every node regardless of progress. Overrides Reveal Depth. | off |

Each node comes out of that in one of three fog states.

| Fog state | What the player sees |
| --- | --- |
| **Visible** | The node's state colour at full strength. |
| **Dimmed** | The node type's **Locked** colour at 75% of its alpha. A hint that something is there. |
| **Hidden** | Nothing: the colour is drawn at zero alpha, hit-testing is off, and keyboard focus skips it. |

Routes follow their ends. An edge takes the more fogged of its two nodes, so a route is
never more visible than what it leads to, and a fogged map stops the line at the edge of
what is known. There is no separate edge-fog setting. A dimmed route is drawn in the style
palette's **Edge Locked** colour, at 75% alpha.

### What fog does not touch

Fog is presentation of progression, not part of the map. Reveal depth is not in the rules
fingerprint, so changing it does not change which graph a seed produces — see
[Determinism, seeds, and fingerprints](../explanation/determinism.md). It never appears in a
save file either, which is why it needs no migration.

## Choose a reveal depth

The same map at the same position, three settings. The amber node is where the traveller
stands.

<div class="grid-2" markdown>

<figure markdown>
  ![Reveal depth 1](../assets/images/fog-reveal-1.png){ .shot }
  <figcaption><strong><code>RevealDepth = 1</code></strong> &mdash; the next choices, then dark. The default.</figcaption>
</figure>

<figure markdown>
  ![Reveal depth 2](../assets/images/fog-reveal-2.png){ .shot }
  <figcaption><strong><code>RevealDepth = 2</code></strong> &mdash; one more layer, enough to plan a step ahead.</figcaption>
</figure>

<figure markdown>
  ![Reveal all](../assets/images/fog-reveal-all.png){ .shot }
  <figcaption><strong><code>RevealAll = true</code></strong> &mdash; the whole route to the summit.</figcaption>
</figure>

</div>

- **0** — only what the traveller has reached plus what is immediately available. Nothing
  ahead. Maximum mystery.
- **1** — the next choices show as dimmed nodes. The classic run-based-map behaviour, and
  the default.
- **2 or more** — look further ahead, one layer at a time.
- At or above the layer count, effectively the whole map.

Depth counts edges outwards from every node the traveller has reached, breadth-first, so
on a wide map one step of depth can uncover several branches at once. With **Reveal
Incoming** on, each step also walks backwards along incoming edges.

!!! note "A fresh map always shows its start"
    Before the first move, every node with no incoming edge is on screen whatever the
    depth is, because those nodes are the map's available starting choices.

## Change fog during a run

`FogSettings` is settable at runtime. Assigning it clamps the value and drops the
controller's cached snapshot.

```csharp
// Wider look-ahead, for a map where planning several steps matters.
controller.FogSettings = new MapFogSettings
{
    RevealDepth = 3,
    RevealIncoming = false,
    RevealAll = false
};

// Or reveal everything, for example after the player buys a map item.
// MapFogSettings.Revealed is the default with Reveal All on.
controller.FogSettings = MapFogSettings.Revealed;
```

Assigning `FogSettings` does not publish a state change by itself, so the map redraws when
the controller next publishes — usually the next transition. To show the change at once,
refresh the presenter:

```csharp
controller.FogSettings = MapFogSettings.Revealed;
presenter.Refresh();   // CanvasMapPresenter or WorldMapPresenter
```

Nodes and routes whose fog state changed fade between the two appearances over the theme's
**State Transition Seconds** rather than popping.

## Per-node exceptions

Depth is a global rule. For "this one node is revealed by an item", pass explicit unlocked
node IDs to the deriver instead of widening the depth for the whole map.

```csharp
var snapshot = MapRuntimeStateDeriver.Derive(
    controller.Graph,
    controller.State,
    controller.FogSettings,
    new[] { new StableId("shrine-a") });
```

An unlocked ID resolves to **Available**, not to dimmed, so the node reads as somewhere the
player can act. The snapshot is yours to read: use it for your own interface, such as a
legend or a route summary.

The presented map is a separate matter. In a shipping build the controller derives its own
snapshot with no unlocked IDs, so what is drawn honours depth, incoming, and reveal-all
only. In a build that defines `BRANCHWEAVER_DEVTOOLS`, `controller.DevelopmentUnlock(id)`
and the development overlay's **Unlock** button add one node to the controller's unlocked
set and republish at once; **Reset** clears it. That path is for testing.

!!! warning "Revealing is not permission"
    The session decides what may be entered. A move to a node that progression does not
    list as available is rejected with `NodeUnavailable`, whatever a derived snapshot shows.
    Unlocked IDs change what a node looks like, not what the traveller may do.

## Next

- **[Emphasise node states](style-node-states.md)** — how the Locked state is treated, so
  dimmed nodes read as a hint rather than as clutter.
- **[Drive traversal from code](drive-traversal-from-code.md)** — publishing state, reading
  progression, and moving the traveller legally.
- **[Input, focus, and camera framing](input-and-navigation.md)** — why focus and
  hit-testing skip hidden nodes, and how to reframe on what is revealed.
