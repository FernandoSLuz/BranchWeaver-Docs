# Editor tools

3 types in this area.

## MapStudioCommandResult

```csharp
public sealed class MapStudioCommandResult
```

`BranchWeaver.Editor.MapStudio` &middot; <small>BranchWeaver/Editor/MapStudio/MapStudioModels.cs</small>

What one Map Studio command did: whether it was accepted, the snapshot to display afterwards,
and the error that explains a rejection. A session returns its current snapshot either way, so
a rejected command still hands back the state to keep showing rather than nothing. Rejection
does not always mean nothing moved -- a generation that fails keeps the previous graph but
still records the attempt in the seed history -- so drive the UI from
`Snapshot` rather than from `Succeeded` alone.

**Constructors**

`public MapStudioCommandResult(bool succeeded, MapStudioSnapshot snapshot, MapDiagnostic diagnostic)`

:   Records the outcome of one command.
    - `succeeded` &mdash; Whether the command was accepted.
    - `snapshot` &mdash; The session's snapshot after the command, accepted or not.
    - `diagnostic` &mdash; The error explaining a rejection; null when the command was accepted.

**Properties**

`public MapDiagnostic Diagnostic`

:   The first error behind a rejection, and null whenever `Succeeded` is true.

`public MapStudioSnapshot Snapshot`

:   The session's snapshot as it stands after the command, whether or not the command was accepted.

`public bool Succeeded`

:   Whether the command was accepted. It is not a statement about whether anything changed: a generation that fails is a rejection that still leaves a new attempt in the seed history, and a command asked to do what is already the case is an acceptance that changes nothing.

---

## MapStudioSession

```csharp
public sealed class MapStudioSession
```

`BranchWeaver.Editor.MapStudio` &middot; <small>BranchWeaver/Editor/MapStudio/MapStudioSession.cs</small>

The editing model behind the Map Studio window: it holds one `MapStudioSnapshot` at
a time and turns each authoring gesture -- regenerate, move, retype, pin, connect, undo -- into
the next one. No command throws when an edit is refused; each returns a
`MapStudioCommandResult` carrying both the snapshot to keep displaying and the
diagnostic that explains the refusal, so a window can render either outcome the same way.

A session is pinned to the one `MapRuleSnapshot` it was built around and never
swaps it, so recompiled rules mean a new session. What a command will accept depends on
`MapStudioSnapshot.Mode`: Procedural refuses graph edits outright, Hybrid turns an
edit into an override and re-runs the generator, which may itself reject it, and Manual
rebuilds the graph straight from the edited nodes and edges.

**Constructors**

`public MapStudioSession(MapRuleSnapshot rules)`

:   Starts an empty preview over the given rules, driven by the shipped `LayeredMapGenerator` and carrying no node types. Nothing is generated yet, so `MapStudioSnapshot.Graph` stays null until `Regenerate` or a Manual edit produces one. Without node types nothing resolves a type ID back to its definition, which suits a headless or test session rather than one behind a window.
    - `rules` &mdash; The compiled rules every command in this session is measured against.

`public MapStudioSession(MapRuleSnapshot rules, IEnumerable<CompiledMapNodeType> nodeTypes)`

:   Starts an empty preview over the given rules and node types, driven by the shipped `LayeredMapGenerator`. This is the usual way to open a session that is not backed by a blueprint asset; use `Load` when it is.
    - `rules` &mdash; The compiled rules every command in this session is measured against.
    - `nodeTypes` &mdash; The compiled node types the graph's type IDs resolve against, in any order. May be null.

`public MapStudioSession(MapRuleSnapshot rules, IMapGenerator generator)`

:   Starts an empty preview driven by your own generator instead of the shipped one, carrying no node types. Every command that produces a generated graph goes through this instance, including the Hybrid edits, which re-run generation to honour the override they just added.
    - `rules` &mdash; The compiled rules every command in this session is measured against.
    - `generator` &mdash; The generator the session drives.

`public MapStudioSession(MapRuleSnapshot rules, IMapGenerator generator, IEnumerable<CompiledMapNodeType> nodeTypes)`

:   Starts an empty preview with every input stated. The node types are copied, so the caller may reuse or mutate the sequence afterwards, and the session keeps that one set -- as it keeps the one rule snapshot -- for its whole lifetime.
    - `rules` &mdash; The compiled rules every command in this session is measured against.
    - `generator` &mdash; The generator the session drives.
    - `nodeTypes` &mdash; The compiled node types the graph's type IDs resolve against, in any order. May be null.

**Properties**

`public bool CanRedo`

:   Whether an undone edit is still there to reapply. Committing any new edit clears the redo history, so an undone edit is recoverable only until the next change.

`public bool CanUndo`

:   Whether there is a committed preview edit to step back to. Only edits enter the history: `Validate`, `FocusDiagnostic`, and `MarkSaved` rewrite `Current` in place and leave this untouched.

`public MapStudioSnapshot Current`

:   The preview as it stands. Every command replaces it with a new snapshot rather than editing this one, so a reference you keep goes stale instead of changing underneath you -- read it again, or take it from the command result, after each call.

**Methods**

`public MapStudioCommandResult AddManualNode(StableId id, StableId typeId, MapNodeSlot slot,)`

:   Adds an authored node at a chosen layer and ordinal. Manual mode only: the other modes have a generator deciding how many nodes each layer holds. The whole graph is then re-pinned -- every node to all of its fields, every edge as a required override -- and revalidated, because that is what Manual mode means. The new node arrives with no edges of its own, so expect the report to object about reachability until `Connect` has joined it to its neighbours.
    - `id` &mdash; The stable ID of the new node. It must be non-empty and must not already be in the graph.
    - `typeId` &mdash; The stable ID of its node type. It must be non-empty.
    - `slot` &mdash; The layer and ordinal to occupy. The layer must exist in the rules, the ordinal must be below that layer's authored maximum, and the slot must be unoccupied.
    - `position` &mdash; The node's position. Both axes must lie between 0 and 10,000 inclusive.
    - `payload` &mdash; The node's payload. Pass `MapNodePayload.Empty` for a node that carries nothing; null is rejected rather than treated as empty.
    - **Returns** &mdash; Failure outside Manual mode, or for an empty ID, an out-of-range or occupied slot, a duplicate node ID, a position outside bounds, or an invalid payload.

`public MapStudioCommandResult Connect(StableId sourceId, StableId targetId, string edgeIdText)`

:   Joins two nodes with a forward edge between adjacent layers. Manual mode adds the edge to the graph outright. Hybrid instead records it as a required edge override and pins both endpoints' identities first, so the override has stable slots to name, then regenerates -- which is what lets the connection survive later regenerations, and also what lets the generator refuse it.
    - `sourceId` &mdash; The node the edge leaves. It must exist and must not be locked.
    - `targetId` &mdash; The node the edge enters. It must exist, must not be locked, and must sit on the layer immediately after `sourceId`.
    - `edgeIdText` &mdash; The stable ID to give the edge. Leave it null or empty to have one derived from the two endpoint IDs, which makes the same pair yield the same edge ID on every run and across machines.
    - **Returns** &mdash; Failure in Procedural mode, for an unknown or locked endpoint, for endpoints that are not on adjacent layers, for a connection or edge ID that already exists, for text that is not a valid stable ID, or when a Hybrid regeneration rejects the edge.

`public MapStudioCommandResult Disconnect(StableId edgeId)`

:   Removes an edge. Manual mode drops it from the graph. Hybrid instead records a forbidden edge override for that pair of slots and regenerates, so the connection stays suppressed on later regenerations rather than being rebuilt by the next search; the override outlives the edge, and connecting the same pair again is what replaces it with a required one. Switching mode also drops it, since `SetMode` rewrites the override set wholesale.
    - `edgeId` &mdash; The edge to remove. It must exist, and neither of its endpoints may be locked.
    - **Returns** &mdash; Failure in Procedural mode, for an unknown edge, for a locked endpoint, or when regenerating without the edge fails.

`public MapStudioCommandResult FocusDiagnostic(int index)`

:   Points the preview's highlight at one diagnostic from the current report, gathering what the message is about: its rule IDs, its node IDs, its slots, and the nodes that currently occupy those slots. Resolving slots to nodes here is what lets a diagnostic raised against a slot rather than an identity still light something up on screen. Only the highlight moves. The graph, overrides, and report are untouched, so this is neither an undoable edit nor a reason to save.
    - `index` &mdash; Zero-based index into the current snapshot's validation diagnostics.
    - **Returns** &mdash; Failure when the index falls outside that list; success otherwise.

`public static MapStudioSession Load(MapBlueprintCompilation compilation, string sourceToken,)`

:   Opens a session on an already compiled blueprint, adopting its mode, seed, graph, overrides, search budgets, locks, and validation report as the first snapshot. The preview starts clean rather than dirty, and its seed history starts empty: whatever the blueprint was generated from is not replayable history until this session generates something itself. The session drives the shipped `LayeredMapGenerator`; construct one directly to supply your own.
    - `compilation` &mdash; The compiled blueprint to open. Its rules become the session's rules.
    - `sourceToken` &mdash; Opaque token for the blueprint asset's stored state, carried so a later save can tell that the asset has moved on.
    - `nodeTypes` &mdash; The compiled node types the graph's type IDs resolve against, in any order. May be null.
    - **Returns** &mdash; A session whose first snapshot is the blueprint exactly as compiled, undo history empty.

`public void MarkSaved(long sourceRevision, string sourceToken)`

:   Records that the preview has been written to a blueprint asset: it clears the dirty flag and adopts the revision and token that save produced, which is what a later save compares against to tell whether the asset has been changed by something else in the meantime. It writes nothing itself -- call it after the save has succeeded. The current snapshot is rewritten in place rather than committed, so saving is not an undoable step. The snapshots already on the undo stack keep the save state they were built with, which means stepping back past a save shows the preview as dirty again.
    - `sourceRevision` &mdash; The blueprint asset's authoring revision as of the save.
    - `sourceToken` &mdash; Opaque token for that asset's stored state as of the save. Null is kept as an empty token.

`public MapStudioCommandResult MoveNode(StableId nodeId, NormalizedMapPosition position)`

:   Moves a node to a new normalized position and pins the position, so a later regeneration cannot put it back. In Hybrid mode the pin is handed to the generator and the map is rebuilt around it, which can fail and leave the preview as it was; in Manual mode the graph is rebuilt directly from the edited nodes.
    - `nodeId` &mdash; The node to move. It must exist and must not be locked.
    - `position` &mdash; The new position. Both axes must lie between 0 and 10,000 inclusive.
    - **Returns** &mdash; Failure in Procedural mode, for an unknown or locked node, for a position outside those bounds, or when a Hybrid regeneration rejects the pin.

`public MapStudioCommandResult Redo()`

:   Reapplies the most recently undone edit and returns the snapshot being left to the undo stack. Committing any new edit clears the redo stack, so an undone edit survives only until the next change is made.
    - **Returns** &mdash; Failure when there is nothing to redo; success carrying the reinstated snapshot otherwise.

`public MapStudioCommandResult Regenerate(uint seed, CancellationToken cancellationToken)`

:   Runs the generator for one seed and commits the outcome as the new preview. Manual mode ignores `seed` and generates against zero, because a manual graph is authored rather than seeded. A failed attempt is still committed. The previous graph, seed, and locks are kept, but the attempt is recorded in `MapStudioSnapshot.SeedHistory` and the failure's diagnostics become the snapshot's report -- so a rejected command here has still changed what the window should draw. Holding the old seed next to the old graph is deliberate: it keeps the pair consistent so the preview still round-trips when it is saved. A cancelled attempt is the exception and commits nothing at all.
    - `seed` &mdash; The seed to generate from. Ignored in Manual mode, which always uses zero.
    - `cancellationToken` &mdash; Cancels the attempt. Cancellation leaves the preview exactly as it was and is reported as a diagnostic, not thrown.
    - **Returns** &mdash; Success with the new graph, or failure carrying the first diagnostic explaining why generation produced none.

`public MapStudioCommandResult RemoveManualNode(StableId id)`

:   Removes an authored node together with every edge that touched it, and re-pins and revalidates what is left. Manual mode only. The surviving nodes keep the layers and ordinals they had, so a hole is left in the numbering rather than closed up, and the removed node's lock is released with it. Removing the last node leaves the preview holding no graph at all rather than an empty one, with a report saying the manual graph is empty.
    - `id` &mdash; The node to remove. It must exist and must not be locked.
    - **Returns** &mdash; Failure outside Manual mode, for a locked node, or for a node that is not in the graph.

`public MapStudioCommandResult ReplayHistory(int index, CancellationToken cancellationToken)`

:   Regenerates from the seed of one entry in `MapStudioSnapshot.SeedHistory`, which is how a map that has since been generated over is brought back. It replays the seed and not the stored result: the graph is produced afresh from the rules and overrides in force now, so it can differ from the fingerprint that entry recorded, and the replay is itself pushed onto the history as a new attempt.
    - `index` &mdash; Zero-based index into the current snapshot's seed history, which is ordered newest first.
    - `cancellationToken` &mdash; Cancels the attempt, exactly as for `Regenerate`.
    - **Returns** &mdash; The outcome of the regeneration, or failure when the index falls outside the history.

`public MapStudioCommandResult SetMode(MapGenerationMode mode)`

:   Switches the preview between Procedural, Hybrid, and Manual, converting whatever is already there rather than starting over. Asking for the mode already in force is accepted and leaves the preview alone. The conversions are not symmetric, so this is not a setting you can flick back and forth without loss. Procedural discards the graph and every override, because it is only allowed to hold none. Hybrid pins each existing node's identity and nothing else -- type, position, and payload go back to the generator -- and then regenerates, which can refuse the conversion and leave the preview untouched. Manual pins every field of every node, turns each edge into a required override, and forces the seed to zero.
    - `mode` &mdash; The mode to move to.
    - **Returns** &mdash; Failure when the value is none of the three supported modes, or when a Hybrid conversion cannot be generated; success otherwise.

`public MapStudioCommandResult SetNodeLocked(StableId nodeId, bool locked)`

:   Locks or unlocks a node against further editing. A lock is editor bookkeeping and nothing more: it makes the session refuse to move, retype, repayload, or remove that node and to touch any edge that ends on it, but it creates no override and changes nothing about what the generator may produce. That is also why regenerating quietly drops the locks whose nodes are not in the new graph.
    - `nodeId` &mdash; The node to lock or unlock. It must exist in the current graph.
    - `locked` &mdash; True to lock the node, false to release it.
    - **Returns** &mdash; Failure only when there is no graph or the node is unknown. Setting the state the node already has is accepted and still counts as a preview edit.

`public MapStudioCommandResult SetNodePayload(StableId nodeId, MapNodePayload payload)`

:   Replaces a node's payload and pins it. Unlike the type, the payload is checked before anything is committed: it must be non-null, must carry a payload ID once it has any properties at all, and every property must have a non-empty key, a canonical value, and no duplicate of that key elsewhere in the payload.
    - `nodeId` &mdash; The node to edit. It must exist and must not be locked.
    - `payload` &mdash; The new payload. Pass `MapNodePayload.Empty` for a node that carries nothing; null is rejected rather than treated as empty.
    - **Returns** &mdash; Failure in Procedural mode, for an unknown or locked node, for a payload that fails those checks, or when a Hybrid regeneration rejects the pin.

`public MapStudioCommandResult SetNodeType(StableId nodeId, StableId typeId)`

:   Retypes a node and pins the type. The type ID is only checked for being non-empty here; whether the rules actually allow that type in that slot is settled afterwards, by the Hybrid regeneration or by the validation report a Manual edit produces, so a bad type comes back as a rejected command or an invalid preview rather than as an argument error.
    - `nodeId` &mdash; The node to retype. It must exist and must not be locked.
    - `typeId` &mdash; The stable ID of the new node type. It must be non-empty.
    - **Returns** &mdash; Failure in Procedural mode, for an unknown or locked node, for an empty type ID, or when a Hybrid regeneration rejects the pin.

`public MapStudioCommandResult SetPinnedFields(StableId nodeId, PinnedNodeFields fields)`

:   Sets exactly which of a node's fields the generator must reproduce, replacing whatever was pinned before instead of adding to it. Clearing a flag hands that field back to the generator, so this is how a node pinned harder than it needed to be is loosened again -- and it takes the node's current type, position, and payload as the pinned values, so setting a flag freezes what is on screen now. Identity is pinned either way. A node with no fields pinned still binds its slot to its node ID, which is why `PinnedNodeFields.None` is a useful value here and why removing the pin altogether is `UnpinNode` rather than this. A lock does not block this command, just as it does not block `UnpinNode`: locks stop a node's own fields and its edges from being edited, not its pin.
    - `nodeId` &mdash; The node to re-pin. It must exist; a locked node is accepted, because only the pin is being changed.
    - `fields` &mdash; The fields to pin, and only those. Manual mode accepts nothing but `PinnedNodeFields.All`.
    - **Returns** &mdash; Failure in Procedural mode, for an unknown node, for flags outside `PinnedNodeFields.All`, for anything short of every field in Manual mode, or when a Hybrid regeneration rejects the pins.

`public MapStudioCommandResult Undo()`

:   Steps back to the snapshot from before the last committed edit, and puts the one being left within reach of `Redo`. It restores an earlier snapshot whole -- graph, overrides, locks, seed history, and save state alike -- rather than reversing one field, so `MapStudioSnapshot.ChangeOrdinal` goes back down with it. Only edits are on the stack. Validating, focusing a diagnostic, and recording a save replace the preview without entering the history, so none of them can be undone. A failed regeneration, on the other hand, does commit and therefore is undoable.
    - **Returns** &mdash; Failure when there is nothing to undo; success carrying the restored snapshot otherwise.

`public MapStudioCommandResult UnpinNode(StableId nodeId)`

:   Drops a node's pin entirely -- identity included, not just its fields -- and regenerates. The generator is then free to fill that slot however the rules allow, so the node that comes back need not be the one that was there and need not carry the same ID. It is refused while any edge override still names the node's slot, because such an override would otherwise be left pointing at a slot nothing pins any more. Disconnect or reroute those edges first.
    - `nodeId` &mdash; The node whose pin is to be removed. It must exist in the current graph.
    - **Returns** &mdash; Failure outside Hybrid mode, for an unknown node, while an edge override still references the node's slot, or when regenerating without the pin fails.

`public MapStudioCommandResult Validate()`

:   Re-runs whole-graph validation against the rules, mode, and overrides in force now and stores the report on the preview. With no graph yet it reports that one must be generated or authored first, rather than passing on an empty map. Nothing about the graph changes, so this is not an undoable edit and does not mark the preview dirty. It does clear any highlight left by `FocusDiagnostic`, since the diagnostic that highlight pointed at may no longer be the one at that index.
    - **Returns** &mdash; Success when the report holds no error -- warnings alone still pass -- otherwise failure carrying the first diagnostic.

---

## MapStudioSnapshot

```csharp
public sealed class MapStudioSnapshot
```

`BranchWeaver.Editor.MapStudio` &middot; <small>BranchWeaver/Editor/MapStudio/MapStudioModels.cs</small>

Immutable picture of one Map Studio preview: the compiled rules the preview is pinned to, the
generation mode and seed, the graph as it currently stands, the overrides and search budget
behind it, the locked nodes, the latest validation report, and the editor bookkeeping -- seed
history, change ordinal, and save state. Every session command produces a new instance instead
of mutating one, so a snapshot you are holding stays readable, and stays stale, once the next
command runs. `Graph` is null until something has been generated or authored, so
read it defensively.

**Constructors**

`public MapStudioSnapshot(MapRuleSnapshot rules, IEnumerable<CompiledMapNodeType> nodeTypes,)`

:   Builds a snapshot and normalizes its optional parts: null overrides, search options, validation, focus, and statistics fall back to their empty or default values, the node types are copied and sorted by type ID with nulls dropped, the locked IDs are de-duplicated and sorted, and `GraphStatistics` is measured from `graph` here rather than passed in.
    - `rules` &mdash; The compiled rules this preview is pinned to.
    - `nodeTypes` &mdash; The compiled node types the graph's type IDs resolve against, in any order.
    - `mode` &mdash; The generation mode the preview is running in.
    - `seed` &mdash; The seed behind `graph`; zero in Manual mode.
    - `graph` &mdash; The current graph, or null when nothing has been generated or authored yet.
    - `overrides` &mdash; The pins and edge overrides the graph was built with.
    - `searchOptions` &mdash; The generator's search budget for this preview.
    - `lockedNodeIds` &mdash; Nodes the session refuses to edit or remove, in any order.
    - `validation` &mdash; The report from the most recent validation or generation pass.
    - `focus` &mdash; The rules, nodes, and slots the window should highlight.
    - `generationStatistics` &mdash; Search counters from the most recent generation attempt.
    - `seedHistory` &mdash; Recent generation attempts, newest first.
    - `changeOrdinal` &mdash; Count of preview edits committed so far.
    - `sourceRevision` &mdash; Authoring revision of the blueprint asset this preview came from or was last saved to; zero when there is none.
    - `sourceToken` &mdash; Opaque token for that blueprint's stored state; empty when the preview is not backed by an asset.
    - `isDirty` &mdash; Whether the preview holds edits that have not been written to a blueprint asset.

**Properties**

`public long ChangeOrdinal`

:   How many preview edits had been committed when this snapshot was built: each committed command raises it by one over the snapshot it was based on. Undo and redo move between snapshots that already exist, so this is not a session-wide clock and can go back down.

`public MapStudioFocus Focus`

:   The rule IDs, node IDs, and slots the window should highlight, never null; empty unless a diagnostic was focused.

`public MapGenerationStatistics GenerationStatistics`

:   Search counters from the most recent generation attempt, never null. Edits that do not run the generator carry the previous attempt's counters forward unchanged.

`public MapGraph Graph`

:   The graph this preview is showing, or null before anything has been generated or authored.

`public MapStudioGraphStatistics GraphStatistics`

:   Node, edge, branch, merge, and reachability counts measured from `Graph` when this snapshot was built.

`public bool IsDirty`

:   Whether the preview holds edits not yet written to a blueprint asset. Once set it stays set until the session is told the preview was saved.

`public IReadOnlyList<StableId> LockedNodeIds`

:   The nodes the session refuses to move, retype, or remove until they are unlocked, sorted and de-duplicated. Regeneration drops any lock whose node is gone from the new graph.

`public MapGenerationMode Mode`

:   How much of the preview the generator is allowed to invent, and therefore which commands the session will accept: Procedural refuses graph edits outright, Hybrid turns an edit into an override and re-runs the generator, and Manual rebuilds the graph straight from the edited nodes and edges. A session can be switched between modes, and the switch rewrites the overrides and may drop the graph, so read the mode from the snapshot rather than remembering what it was.

`public IReadOnlyList<CompiledMapNodeType> NodeTypes`

:   The compiled node types, sorted by type ID rather than left in the order supplied.

`public MapGenerationOverrides Overrides`

:   The pinned nodes and required or forbidden edges the current graph was built under, never null. In Hybrid mode an edit is recorded here rather than written onto the graph, which is what lets the same seed be regenerated and still land the edited nodes where they were put. Manual mode instead rebuilds the graph from the edited rows and re-derives these overrides from it, pinning every field of every node and turning every edge into a required override. Empty in Procedural mode, where no edit is allowed to survive.

`public MapRuleSnapshot Rules`

:   The compiled rules every command in this preview is measured against. A session is created around one ruleset and never replaces it, so recompiling changed rules means a new session.

`public MapGenerationSearchOptions SearchOptions`

:   The per-phase trial budgets the generator may spend on this preview, never null. A search that exhausts them is a failed generation that leaves the previous graph on screen and records the attempt in `SeedHistory`, so a seed that will not generate is sometimes a budget question rather than an unsatisfiable ruleset.

`public uint Seed`

:   The seed behind `Graph`. Always zero in Manual mode, where nothing is seeded.

`public IReadOnlyList<MapStudioSeedHistoryEntry> SeedHistory`

:   The recent generation attempts, newest first, failures included. The session caps how many it keeps, so this is a window on recent history rather than the whole session.

`public long SourceRevision`

:   The authoring revision of the blueprint asset this preview came from or was last saved to; zero when it is backed by no asset.

`public string SourceToken`

:   Opaque token for the stored state of that blueprint asset when the preview was loaded or last saved, never null. Empty when there is no backing asset.

`public ValidationReport Validation`

:   The diagnostics from the most recent validation or generation pass, never null.

**Methods**

`public bool TryGetNodeType(StableId typeId, out CompiledMapNodeType type)`

:   Resolves a node type ID against the compiled types this snapshot carries -- the same set a node on `Graph` refers to by ID.
    - `typeId` &mdash; The stable ID of the wanted node type.
    - `type` &mdash; The matching node type, or null when there is no match.
    - **Returns** &mdash; True when a node type with that ID is present.

---

