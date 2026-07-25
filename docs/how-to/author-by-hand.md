# Author a map by hand

Map Studio can hold the beats you care about in place and let the generator fill in the rest, or
drop generation entirely so you place every node yourself. This page covers the editing half of
**Tools > BranchWeaver > Map Studio**; compiling, regenerating and auditing are covered in
[2. Generate a map in Map Studio](../tutorials/generate-a-map.md).

---

## Choose a mode

The **Mode** field decides what you are allowed to change. Switching mode rebuilds the preview,
and the switch itself is undoable.

| Mode | What you can edit | What the seed does |
| --- | --- | --- |
| **Procedural** | Nothing. The graph comes from the rules and the seed alone. | Chooses the whole map. |
| **Hybrid** | Node type, position, payload, and routes. Every edit re-runs generation around what you pinned. | Chooses everything you have not pinned. |
| **Manual** | The same, plus adding and removing nodes. The graph is exactly what you author. | Forced to `0` and ignored. |

What each switch does to the preview you already have:

- **To Procedural** &mdash; the graph, every pin and every lock are discarded. Press
  **Regenerate** to get a graph back.
- **To Hybrid** &mdash; every node gains an identity pin, so node IDs survive a regenerate, and
  the map is regenerated once to confirm the rules still admit it. If they do not, the switch is
  refused and you stay where you were.
- **To Manual** &mdash; the seed becomes `0` and every node is pinned on all three fields.

## Pin and lock nodes

A pin is an instruction to the generator. A lock is a guard against your own editing. They are
independent, and the node caption shows both: `[P]` for pinned, `[L]` for locked.

Select a node and set **Pinned fields**:

| Pinned | Held across a regenerate |
| --- | --- |
| *nothing* | The node's stable ID stays at that layer and ordinal. |
| **Type** | Its node type. |
| **Position** | Its normalized position. |
| **Payload** | Its payload ID and properties. |

A pin also guarantees its slot exists: pinning a node at ordinal 3 forces that layer to be at
least four nodes wide. An ordinal beyond the layer's authored maximum is refused with
`bw.overrides.node-capacity-conflict`, and a pinned type that a zone forbids is refused too.

**Unpin identity** works in Hybrid mode only, and is refused while a route override still refers
to the node. Editing a node re-pins the field you edited, so unpin last.

!!! warning "A lock is not a generation constraint"
    Locking refuses edits to that node, refuses removing it, and refuses editing any route with a
    locked endpoint &mdash; all with `bw.studio.node-locked`. It is never passed to the generator,
    so **Regenerate** can still replace a locked node. Pin what has to survive generation; lock
    what you do not want to nudge by accident.

## Edit nodes and edges

### Nodes

Drag a node on the canvas to move it. Releasing writes its new normalized position and pins
**Position**. In the panel on the right, **Type ID** with **Apply type** changes the type and pins
**Type**; **Payload ID**, the property rows and **Apply payload** change the payload and pin
**Payload**. What a payload means to your game is covered in
[Create node types](create-node-types.md).

A refused edit leaves the previous preview exactly as it was, so a node you were not allowed to
move springs back to where it started.

The **Manual node authoring** foldout adds and removes nodes in Manual mode. A new node needs a
stable **Node ID** and **Type ID**, a **Layer** and **Ordinal** inside the capacity your rules
allow for that layer, and **Normalized X** and **Y** between 0 and 10,000. Removing a locked node
is refused.

### Edges

Under **Edge authoring**, fill in **Source node ID** and **Target node ID** and press **Connect
source to target**. The edge ID is optional; left empty, a stable one is derived from the two
endpoint IDs. A route must run forward exactly one layer, and a duplicate connection is refused.
To remove one, click it on the canvas or in the list below, then press **Disconnect selected
edge**.

In Hybrid mode a connection is recorded as a required route and a disconnection as a forbidden
one, then the map is regenerated around them. If the rules cannot accommodate the change you get
`bw.studio.generation-failed` and the preview does not move.

!!! note "Hand-edited maps can be invalid"
    Nothing forces an edit to satisfy the rules the way generation does, and neither save button
    checks. Press **Validate** and read the diagnostics pane first; clicking a diagnostic
    highlights the nodes it names.

## Save a blueprint

Both save buttons write the current preview &mdash; nodes, routes, pins, locks, mode, seed, search
budgets and fingerprints &mdash; into a **Map Blueprint** asset, along with a reference to the
rules asset it came from.

| Button | Behaviour |
| --- | --- |
| **Apply** | Overwrites the asset in the **Blueprint** field, raises its authoring revision, and registers the change with Unity's undo system. The asset is left dirty, so save the project to put it on disk. |
| **Save As** | Creates a new `.asset` below `Assets` and saves that one asset, leaving anything else dirty in your project untouched. An existing path is refused with `bw.studio.save-path-invalid`; use **Apply** to overwrite. If any step fails, the partly created asset is deleted. |

Both need a graph in the preview. Both refuse to write if the rules asset no longer matches the
snapshot this preview compiled from (`bw.studio.save-rules-mismatch`) or if the blueprint changed
since it was loaded (`bw.studio.save-stale`). Press **Compile / Load** again in either case.

Assigning a blueprint to the **Blueprint** field and pressing **Compile / Load** brings an
authored map back with its mode, pins and locks intact; the blueprint's own rules asset is used,
whatever is in the **Rules** field. In your own code the same asset compiles straight to a graph,
with no generator involved:

```csharp
var compilation = new MapAuthoringCompiler().CompileBlueprint(blueprintAsset);
var graph = compilation.Succeeded ? compilation.Graph : null;
```

## Export JSON

**Copy JSON** puts the current preview on the clipboard. **Export JSON** writes it as UTF-8 to a
file you choose. The dump is canonical and covers the manifest, search budgets, nodes, routes,
node and route overrides, locked node IDs, diagnostics and statistics, and ends with a
`contentFingerprint` taken over everything above it.

Two exports are therefore comparable with a plain text diff. That makes this the quickest way to
see what an edit actually changed, and the right thing to attach to a bug report.

## Next

- **[Write map rules](write-map-rules.md)** &mdash; the constraints your pins and manual nodes
  have to satisfy.
- **[Drive traversal from code](drive-traversal-from-code.md)** &mdash; turn a blueprint into a
  map your game walks.
- **[Determinism, seeds, and fingerprints](../explanation/determinism.md)** &mdash; which changes
  stop an old seed reproducing its map.
