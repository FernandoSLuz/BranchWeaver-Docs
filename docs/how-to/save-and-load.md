# Save and load progress

A save holds the whole map, not the seed that produced it. After this page you can write and read
a slot, pick an adapter, and see why no migration repairs a save whose node types stopped resolving.

## Write and read a slot

Build an envelope from the `MapTraversalController`'s graph and state, hand it to an adapter, and
restore both on load.

```csharp
var adapter = new FileMapSaveAdapter(Application.persistentDataPath);
var slot = new StableId("campaign.slot-1");

// Save. On failure, FailureKind names the cause and Validation carries the diagnostics.
MapSaveOperationResult written = adapter.TryWrite(
    slot, MapSaveEnvelope.CreateCurrent(map.Graph, map.State));

// Load. The graph and the progression are restored together.
MapSaveReadResult read = adapter.TryRead(slot);
if (read.Succeeded)
    map.Initialize(read.Envelope.Graph, read.Envelope.Progression, map.Content);
```

Every operation is a `Try*` returning a result, so a missing slot, an unsafe path, or a corrupt
file is an ordinary branch rather than an exception. `map.Content` is the compiled
`MapRuntimeContent` the controller was last initialised with; pass your own if it has not run yet,
as in [Drive traversal from code](drive-traversal-from-code.md). A slot is a `StableId`: lowercase
ASCII letters, digits, `.`, `_` and `-`.

### Choosing when to save

`RequestSave()` raises `SaveRequested(graph, state)`, exposed for inspector wiring as
`SaveRequestedUnityEvent`. Write the envelope in the handler. Entering and completing a node are
separate transitions, so "arrived, not yet finished" is a state a save can hold.

### Reading a failure

| `MapSaveFailureKind` | Reasonable response |
| --- | --- |
| `NotFound` -- no save, or a deletion marker is present | Start a new run |
| `CorruptData` -- JSON, schema, or an integrity check failed | Offer a fresh run; keep the file for a report |
| `UnsupportedVersion` -- written by a newer save format | Ask the player to update the game |
| `IoFailure` -- the file could not be read or committed | Retry, and surface the path |
| `UnsafePath`, `InvalidEnvelope`, `MigrationMissing`, `MigrationFailed` | Fix your own code: the slot ID or root, the envelope, or the migration set |

## Choose an adapter

| Adapter | Use it for | Durable |
| --- | --- | --- |
| `FileMapSaveAdapter` | Shipped builds writing under one absolute root | Yes |
| `MemoryMapSaveAdapter` | Tests, tutorials, session-only state | No, it lives with the instance |
| Your own `IMapSaveAdapter` | Cloud saves, console save APIs, encrypted containers | Up to you |

The interface is three methods: `TryRead`, `TryWrite`, `TryDelete`. The memory adapter keeps
canonical JSON per slot rather than live references, so a load returns a fresh graph.

### What the file adapter guarantees

- A write flushes a private staging file, publishes it as `.tmp`, then atomically replaces the
  primary and keeps the previous bytes as `.bak`. An interrupted write cannot lose the last save.
- A read validates the primary, then `.tmp`, then `.bak`, reports which it accepted in
  `read.RecoverySource`, and never rewrites a candidate. A non-primary one adds a warning.
- `TryDelete` writes a durable deletion marker before removing the candidates, so an interrupted
  delete cannot revive a backup. The slot reads as `NotFound` until a later write clears it.

!!! warning "The root is checked at construction"
    The constructor throws `ArgumentException` for a relative root, a filesystem root, a root that
    is an existing file, or one at or below a symlink or junction. It also needs a single writer, so
    cloud sync and console save services want a custom adapter.

## The envelope and canonical JSON

`MapSaveEnvelope` stores the save format version; the generator version, seed, rules fingerprint and
graph fingerprint; the complete graph, with generation mode, node and edge IDs, positions and
payloads; the progression, with the current node, available and visited IDs and the ordered
completions with their result payloads; and metadata of your own.

A seed is not durable persistence. Edit a rule, move a pin, or ship a new generator version and the
same seed yields a different map, which is why the graph itself travels inside the save -- see
[Determinism, seeds, and fingerprints](../explanation/determinism.md).

A read verifies more than syntax: manifest fields must match the embedded graph, the graph is
re-fingerprinted against the stored fingerprint, the progression must be legal for that graph, and
collection counts must be within the supported limits. A hand-edited save is refused, not loaded.

!!! warning "Canonical bytes are not a security boundary"
    Strict JSON catches corruption and casual edits, but it is neither encryption nor
    authentication. If a save can be changed by someone you do not trust, wrap the payload in your
    own authentication or encryption inside a custom adapter.

### Your own metadata

Pass a `MapDataPayload` as the third argument, and read it back from `read.Envelope.CustomerMetadata`:

```csharp
var metadata = new MapDataPayload(
    new StableId("campaign.meta"),
    new[] { new MapProperty(new StableId("chapter"), MapPropertyValue.Integer(3)) });
adapter.TryWrite(slot, MapSaveEnvelope.CreateCurrent(map.Graph, map.State, metadata));
```

The payload must be canonical: a non-empty payload ID once it holds properties, and non-empty
unique keys. Anything else fails the write as `InvalidEnvelope`.

## Migrations and compatibility

Writes always use the current format version. A read accepts format 1 and migrates it forward with
`MapSaveV1ToV2Migration`, which the default serializer registers for you; a file claiming a higher
version fails as `UnsupportedVersion` rather than being guessed at. To add a step, implement
`IMapSaveMigration` with `TargetVersion` equal to `SourceVersion + 1`, return a new envelope, then
register the set:

```csharp
var serializer = new MapSaveSerializer(new IMapSaveMigration[]
    { new MapSaveV1ToV2Migration(), new YourV2ToV3Migration() });
var adapter = new FileMapSaveAdapter(Application.persistentDataPath, serializer);
```

The chain must be contiguous and free of duplicates. After each step the serializer re-checks that
the graph fingerprint, generator version, seed and rules fingerprint are unchanged, so a migration
that rewrites graph bytes fails as `MigrationFailed`.

### Before you change something a save refers to

| Change | Effect on saves already written |
| --- | --- |
| Rename or move an asset | Nothing. Identity is the stable ID field, not the name. |
| Edit rules, weights, zones, or pins | Nothing. The graph travels inside the save; only old seeds stop reproducing. |
| Change or delete a node type's stable ID | `Initialize` fails with `bw.runtime.node-type-missing`, because the saved graph still names the old type. |
| Restyle or retheme | Nothing. Styles and themes are not part of a save. |

!!! warning "A migration cannot rename a saved node type"
    Since migrations may not alter graph bytes, none can rewrite a saved node's type ID. Keep the
    old node type asset, with its original stable ID, until the saves naming it are gone -- see
    [Core concepts](../explanation/architecture.md).

## Next

- **[Drive traversal from code](drive-traversal-from-code.md)** -- the events and state a save is built from.
- **[Troubleshooting](troubleshooting.md)** -- matching a save failure to its cause.
- **[Saving and migration reference](../reference/saving-and-migration.md)** -- the full API surface.
