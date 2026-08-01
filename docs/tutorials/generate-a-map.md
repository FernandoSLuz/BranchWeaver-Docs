# 2. Generate a map in Map Studio

Map Studio turns a rule set into a graph you can inspect, reproduce from a seed, and test
across hundreds of seeds before a player sees one. Everything here happens in the editor, from
menus, dropdowns, and buttons. If the package is not imported yet, start with
[1. Install and run the samples](install-and-samples.md).

Nothing on this page asks you to type an identifier. Node types and edge endpoints are chosen
from dropdowns, and the one ID you can type has a button that fills it in for you.

---

## 1. Open Map Studio

**Tools > BranchWeaver > Map Studio**. With nothing assigned, the graph area shows a welcome
card offering two ways in: a playable starter set, or the Quick Start sample. The toolbar
actions stay disabled until something is compiled, and the panes down the right side, node and
edge authoring, seed history, and validation, fill in as you work.

## 2. Create a playable starter set

Press **Create playable starter set** on that card and choose a folder inside your project's
`Assets` folder. A folder outside `Assets` is refused and nothing is written. Eight assets are
created:

| Asset | What it holds |
| --- | --- |
| `Route`, `Rest`, `Landmark`, `Gateway` | One node type each: a stable ID such as `starter.route`, and a display label. No payload. |
| `Starter Rules` | Four layers holding exactly 1, 2, 2 and 1 nodes; type weights Route 6, Rest 2, Landmark 2, Gateway 1; at most two routes out of and into any node; crossing routes forbidden. |
| `Starter Theme` | Vertical layout, curved routes, layer spacing 150, node spacing 110, zoom clamped to 0.65 - 2.2. |
| `Starter Blueprint` | Those rules, procedural mode, preview seed 20260801. |
| `Starter Content Pool` | Three weighted rows, each filtered by node type, ready for a runtime host to route content from. |

The new rules and blueprint are assigned to the **Rules** and **Blueprint** fields, the
blueprint is selected in the Project window, and a preview is compiled immediately. The status
line at the bottom of the window names the folder and the number of assets written.

!!! note "Nothing else in this window writes to your project"
    Creating starter assets, **Apply**, and **Save As** are the only actions that touch an
    asset. Compiling, regenerating, editing, and auditing all stay inside the window.

## 3. Regenerate from a seed

To preview a rules asset you already own, assign it to **Rules** and press **Compile / Load**.
If the rules cannot compile, the diagnostics pane fills instead and the status line says so; no
preview is produced.

1. Type a number into **Seed**. Decimal and `0x` hexadecimal are both accepted, up to
   4,294,967,295. Anything else is rejected with a status message.
2. Press **Regenerate**. The map changes.
3. Type the *same* number again and regenerate. The identical map returns. This is the property
   everything else on this page rests on.
4. Press **Validate**. The bottom-right pane lists each diagnostic as `code - message`. Click
   one and the nodes it concerns turn amber in the graph.

**Undo** and **Redo** move through preview snapshots, and answer to ++ctrl+z++ /
++ctrl+shift+z++ (++cmd+z++ / ++cmd+shift+z++ on macOS). An asset you have already applied or
saved is not affected by them.

## 4. Select a node and set its type

Click any node in the graph. The panel on the right fills with that node's details.

<figure markdown>
  ![Map Studio showing a six node graph on the left and a node panel on the right headed "Node: Route L1 / S1", with a Node type dropdown, a row of Gateway, Landmark, Rest and Route palette buttons, an Apply type button, Locked and Pinned fields controls, and a seed history row reading 20260722 PASS](../assets/images/map-studio-typed-palette.png){ .shot }
  <figcaption>The selected node is named by what it is and where it sits, <strong>Route - L1 /
  S1</strong>, never by its stable ID. The <strong>Type palette</strong> row is every type the
  compiled rules allow, one button each.</figcaption>
</figure>

1. Read the heading. **Node: Route - L1 / S1** means a Route node in layer 1, slot 1. The layer
   and slot are the ones you can count on screen. Hover it to see the underlying stable ID,
   which is a generated fingerprint you never have to read or type.
2. Pick a type. **Node type** is a dropdown of the types your rules compiled, and the **Type
   palette** under it is the same list as buttons, for the common ones.
3. Press **Apply type**. Nothing changes until you do.
4. Optionally tick **Locked** to stop this node moving, changing type, or being removed, or set
   **Pinned fields** and press **Pin identity** to declare what a regeneration must preserve.
   Lock and pin are independent, and both are undoable.

A node whose fields are pinned is drawn with a `[P]` prefix in the graph, and a locked one with
`[L]`. Every node is otherwise labelled with its type's display label and tinted with that
type's colour, so the type mix is legible without selecting anything. Scroll to zoom, drag with
the middle mouse button to pan, and click a route to select it.

## 5. Connect two nodes yourself

Procedural mode generates every route from the rules, so it refuses edits. Set **Mode** to
**Hybrid** first: it starts from the same reproducible graph but keeps whatever you change as an
override.

<figure markdown>
  ![Map Studio in Hybrid mode with the Edge authoring foldout open, showing a Source node dropdown set to "Route L1 / S1", a Target node dropdown reading "Select a node...", an optional Edge ID override field, a Connect source to target button, and a list of seven existing edges written as "Route L1 / S1 -> Route L2 / S1"](../assets/images/map-studio-connections.png){ .shot }
  <figcaption>Both endpoints are dropdowns of nodes that exist, listed the same way the graph
  names them. The edge list under the button reads as sentences, so you can see the whole shape
  of the map without opening a single asset.</figcaption>
</figure>

1. Open **Edge authoring** on the right.
2. Choose **Source node**. It is pre-filled with the node you have selected.
3. Choose **Target node**. It is pre-filled with a node one layer down that is not connected
   yet, which is usually the one you wanted.
4. Leave **Edge ID override (optional)** blank. BranchWeaver derives a deterministic ID for you,
   and the hint under the field says so. Fill it in only when you need a specific ID, and it is
   validated as you type and must be unique.
5. Press **Connect source to target**.

To remove a route, click it on the map or click its row in the list, then press **Disconnect
selected edge**. You can also drag from a node's output port to a compatible input port instead
of using the dropdowns.

In Hybrid mode, reconnecting a pair you previously disconnected replaces the forbidden override
with a required one, rather than keeping two rules that contradict each other. **Manual** mode
goes further and stores the entire graph by hand; there, **Manual node authoring** adds nodes,
and **Suggest available ID** fills the node ID in from the layer and ordinal you chose and
re-suggests whenever you change either.

## 6. Read the seed history

Under the node details, **Seed history** lists the last 32 generation attempts, newest first. Each
entry shows the seed, `PASS` or `FAIL`, and the graph fingerprint, which is the SHA-256 hash of
the generated graph.

- Click an entry to regenerate that seed. The result is prepended to the list, so replaying a
  seed gives you two rows to compare.
- Two rows with the same seed and the same fingerprint mean the map reproduced exactly.
- The same seed with a different fingerprint means the inputs changed underneath it. Which
  changes do that is set out in
  [Determinism, seeds, and fingerprints](../explanation/determinism.md).
- A failed attempt is recorded as `FAIL` but does not replace the preview: the previous graph
  and its seed stay in place, so the window never shows an empty map after a failed search.

## 7. Audit a range of seeds

The strip below the graph audits a whole range at once. Set **Audit first** to 0 and **last** to
99, then press **Run seed audit**. It generates 100 maps, reports which seeds failed, and lets
you jump to any of them. The range is inclusive and must contain between 1 and 100,000 seeds; a
range in Manual mode is refused with `bw.studio.audit-range-invalid`.

The audit runs off the main thread. The progress bar counts completed seeds and **Cancel** stops
it, keeping the rows already finished and reporting the stop as a warning.

Results appear as two summary lines and one row per seed:

| Line | What it tells you |
| --- | --- |
| Summary | Attempts, successes and failures; node and edge counts as `min..max` across the successful seeds; the mean of each, shown multiplied by 10,000 so it stays an integer, so divide by 10,000 to read it; the largest branch and merge seen. |
| Fingerprint | One hash over every row, so two audit runs can be compared with a string equality check. |
| Seed row | Seed, `PASS` or the failure kind, and that graph's fingerprint. Click the row to preview that seed. |

At most 250 rows are drawn; a wider range keeps the rest in memory and says how many. Any edit,
any regenerate, and any change to the **Rules** or **Blueprint** field clears the results, so
what you are reading always describes the inputs currently loaded.

!!! tip "Audit before you ship a rule set"
    An audit is how you learn that your rules work for seed 7 but are unsatisfiable for seed 42,
    before a player rolls seed 42.

## What the rules fix and what varies

A rules asset describes constraints, not a map: how many layers, how wide each layer may be,
which types may appear and how often, how many routes may leave or enter a node. The generator
searches for a graph that satisfies all of it, using the seed as its only source of variation.

With the starter rules every layer has a fixed width, so every seed produces the same six nodes.
What changes between seeds is which type lands in which slot and which routes are drawn: each
permitted optional route is taken 35 times in a hundred, then dropped if it would exceed the
two-in / two-out limit or cross another route.

When no graph satisfies the rules you get a failure naming the unsatisfiable constraint rather
than a hang or a half-built map. Widening one bound usually resolves it: see
[Write map rules](../how-to/write-map-rules.md).

## Next

- **[3. Create a playable map in one click](create-a-playable-map.md)** - the fastest way to see
  a generated map running in a scene.
- **[Author a map by hand](../how-to/author-by-hand.md)** - manual and hybrid authoring in full,
  including payloads and overrides.
- **[Write map rules](../how-to/write-map-rules.md)** - shape, type mix, zones and connections,
  and the diagnostics when a rule set cannot be satisfied.
- **[Determinism, seeds, and fingerprints](../explanation/determinism.md)** - why the same seed
  reproduces the same graph, and what breaks that.
