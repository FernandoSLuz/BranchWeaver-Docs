# Saving and migration

12 types in this area.

!!! abstract "On this page"
    [FileMapSaveAdapter](#filemapsaveadapter) &middot; [IMapSaveAdapter](#imapsaveadapter) &middot; [IMapSaveMigration](#imapsavemigration) &middot; [MapSaveEnvelope](#mapsaveenvelope) &middot; [MapSaveFailureKind](#mapsavefailurekind) &middot; [MapSaveOperationResult](#mapsaveoperationresult) &middot; [MapSaveReadResult](#mapsavereadresult) &middot; [MapSaveRecoverySource](#mapsaverecoverysource) &middot; [MapSaveSerializationResult](#mapsaveserializationresult) &middot; [MapSaveSerializer](#mapsaveserializer) &middot; [MapSaveV1ToV2Migration](#mapsavev1tov2migration) &middot; [MemoryMapSaveAdapter](#memorymapsaveadapter)

## FileMapSaveAdapter

```csharp
public sealed class FileMapSaveAdapter : IMapSaveAdapter
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/FileMapSaveAdapter.cs</small>

Rooted file persistence. Writes flush a temporary file and atomically replace the primary
while retaining its prior bytes as backup. Reads validate primary, then temporary, then
backup without repairing or otherwise mutating any candidate.

**Constructors**

`public FileMapSaveAdapter(string rootDirectory)`

:   Creates an immutable file Map Save Adapter snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `rootDirectory` &mdash; Absolute path of the directory slot files live in, typically a folder under the platform's persistent data path. It does not have to exist yet; it is created on the first write.

`public FileMapSaveAdapter(string rootDirectory, MapSaveSerializer serializer)`

:   Creates an immutable file Map Save Adapter snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `rootDirectory` &mdash; Absolute path of the directory slot files live in. It does not have to exist yet; it is created on the first write.
    - `serializer` &mdash; Serializer used for every read and write through this adapter.

**Properties**

`public string Backup`

:   Full path holding the bytes the previous write replaced, and the last candidate a read falls back to.

`public string Path`

:   Full path of the file this candidate would be read from.

`public string Primary`

:   Full path of the slot's committed save, and the first candidate a read tries.

`public string RootDirectory`

:   The directory every slot file is resolved inside, normalised to an absolute path with any trailing separator removed. It is a boundary rather than a hint: a slot ID whose resolved path would land outside this directory, or in a subdirectory of it, is refused instead of followed.

`public MapSaveRecoverySource Source`

:   Which of the three save files this candidate is. It is reported back to the caller when this candidate is the one that loads, and used as the context on any diagnostic raised against it, so a failure names the file it came from.

`public string Temporary`

:   Full path a write publishes to before swapping it over the committed save. One left behind means a write was interrupted after the bytes were safely on disk, so a read treats it as the second candidate.

`public string Tombstone`

:   Full path of the deletion marker. While it exists the slot reads as not found, whatever save files happen to remain beside it.

**Methods**

`public MapSaveOperationResult TryDelete(StableId slotId)`

:   Deletes a slot by committing a durable deletion marker and then removing the committed save, the temporary file, and the backup. The marker is written and flushed before anything is removed, so a crash part-way through cannot leave a stale temporary file or backup that `TryRead` would happily load as a resurrected save. While the marker is present the slot reads as `MapSaveFailureKind.NotFound`; the next successful write clears it.
    - `slotId` &mdash; Slot to delete; an empty ID is refused as an unsafe path.
    - **Returns** &mdash; Success even when the slot held no files, since the deletion marker still records the intent. Failure when one of the slot's paths is a reparse point or the wrong kind of entry, or when the marker or the cleanup throws.

`public MapSaveReadResult TryRead(StableId slotId)`

:   Attempts to read without throwing for expected invalid input; failure leaves output parameters at documented defaults.
    - `slotId` &mdash; Slot to read; an empty ID is refused as an unsafe path.
    - **Returns** &mdash; The envelope and the file it was recovered from on success. On failure the kind is the most serious one seen across the candidates, and is `MapSaveFailureKind.NotFound` both when the slot has no files at all and when it carries a deletion marker.

`public MapSaveOperationResult TryWrite(StableId slotId, MapSaveEnvelope envelope)`

:   Serialises a save and publishes it to the slot, keeping the bytes it replaced as a backup. The new save is written to a private staging file, flushed all the way to the device, promoted to the slot's temporary file, and only then swapped over the committed save. A crash at any point therefore leaves either the previous save or a complete temporary file that `TryRead` can recover from; a half-written save is never left where a read would find it. Writing to a slot that was deleted revives it and clears its deletion marker.
    - `slotId` &mdash; Slot to publish to; an empty ID is refused as an unsafe path.
    - `envelope` &mdash; Input envelope consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; Failure when the envelope will not serialise, when one of the slot's paths is a reparse point or the wrong kind of entry, or when the commit throws. In that last case any temporary file already published is deliberately left in place, because it is a valid recovery candidate.

---

## IMapSaveAdapter

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapSaveAdapter
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

The storage boundary for map saves: read, write, and delete one slot of complete save
data. BranchWeaver never calls it for you -- your code picks the slot and the moment --
so where a save lives, whether that is memory, a rooted file, or a platform service, is an
adapter decision rather than an engine one.

An implementation must report problems through the returned result instead of throwing,
must reject an empty slot ID as `MapSaveFailureKind.UnsafePath`, and must
persist serialized bytes from `MapSaveSerializer` rather than keeping live
`MapGraph` or `MapProgressionState` references -- a save that
aliases live objects is not a save. Decoding through that same serializer is what
migrates older formats and validates every field before a caller sees the envelope.

---

## IMapSaveMigration

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapSaveMigration
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

One step of the save upgrade chain: it accepts an envelope at its declared source version
and returns the same run at its target version.
`MapSaveSerializer` applies the steps in order while loading an older save,
which is how a format change ships without invalidating live campaigns.

An implementation must be deterministic and free of Unity, editor, and global state; must
declare a target exactly one above its source; must return a new envelope instead of
mutating the one it was handed; and must leave the generator version, seed, rules
fingerprint, stored graph fingerprint, and canonical graph bytes untouched. The serializer
re-checks all of that after the call, so a step that throws, drifts, or returns the wrong
version fails the load as `MapSaveFailureKind.MigrationFailed` instead of
quietly rewriting a player's save.

---

## MapSaveEnvelope

:material-star: **Start here**

```csharp
public sealed class MapSaveEnvelope
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveEnvelope.cs</small>

A complete, versioned graph and traversal snapshot.

**Constructors**

`public MapSaveEnvelope()`

:   Assembles an envelope from its parts, without checking that they agree. Prefer `CreateCurrent` for a save you are about to write, since it fills the version and manifest fields from the graph itself. This constructor exists for the two cases that must state a version rather than assume the current one: reading a save back, and migrating one forward.
    - `formatVersion` &mdash; Input format Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `generatorVersion` &mdash; Input generator Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; Input rules Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `graphFingerprint` &mdash; Input graph Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `progression` &mdash; How far the run had got on that map.
    - `customerMetadata` &mdash; Your own data to carry alongside the run. Null is stored as `MapDataPayload.Empty`.

**Properties**

`public MapDataPayload CustomerMetadata`

:   Your own data carried alongside the run; nothing in the package reads it. Never null. It must be canonical or the save is refused, and it counts against the same per-payload property limit as a node payload. Format 1 had no such field, so a save from that version reads back with `MapDataPayload.Empty` here.

`public int FormatVersion`

:   Which save format this envelope follows, and therefore which fields the reader expects to find. An envelope read from an older save keeps the version it was written at until a migration raises it; only `CurrentFormatVersion` is ever written back out.

`public int GeneratorVersion`

:   The generator version recorded with the map, repeated at the top of the save so a reader can tell which algorithm built it without walking into the graph. It must agree with the embedded graph, which is what catches an envelope assembled around the wrong map.

`public MapGraph Graph`

:   The map the run took place on, stored in full rather than as a seed to rebuild from, so a save still opens onto the map it was made on after the rules have moved on.

`public string GraphFingerprint`

:   The canonical fingerprint of `Graph`. Never null. Reading a save recomputes this from the graph it just deserialized and refuses the save when the two differ, so a hand-edited or truncated map is reported rather than loaded into a run.

`public MapProgressionState Progression`

:   How far the run had got: where the traveller stands, what may be entered next, and the results already recorded. It is checked against `Graph` when the save is read, so progression naming a node that map does not hold is reported rather than restored.

`public string RulesFingerprint`

:   The canonical fingerprint of the rules the map was generated from, repeated from the embedded graph and required to match it. Never null. Compare it against the fingerprint of your current rules to spot a save made before a rules change.

`public uint Seed`

:   The seed the map was generated from, repeated from the embedded graph and required to match it.

**Methods**

`public static MapSaveEnvelope CreateCurrent()`

:   Constructs create Current from validated inputs and returns an independently usable result without transferring caller ownership.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `progression` &mdash; How far the run has got.
    - `customerMetadata` &mdash; Your own data to carry with the run. Null is stored as `MapDataPayload.Empty`.
    - **Returns** &mdash; An envelope at the current format, ready to serialize.

---

## MapSaveFailureKind

```csharp
public enum MapSaveFailureKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

Why a save read, write, or delete did not succeed. Persistence returns these kinds
instead of throwing, and the kind is what a caller branches on:
`MapSaveFailureKind.NotFound` is a legitimate "no save here yet", while the
corrupt, version, and migration kinds mean a save exists but must not be loaded, and each
deserves its own player-facing message and support data.

| Value | Meaning |
| --- | --- |
| `None` | No failure. |
| `InvalidEnvelope` | The envelope offered for writing is invalid, or would not serialize. |
| `CorruptData` | The stored bytes are not canonical JSON, or fail validation. |
| `UnsupportedVersion` | The save was written by a newer, unsupported save format. |
| `MigrationMissing` | No contiguous migration covers this older save's version. |
| `MigrationFailed` | A migration threw, broke protected fields, or is non-contiguous. |
| `UnsafePath` | The slot ID was empty or resolved outside the storage root. |
| `NotFound` | The slot holds no save, or holds a deletion marker. |
| `IoFailure` | The storage layer failed the operation; stored data may be intact. |

---

## MapSaveOperationResult

```csharp
public sealed class MapSaveOperationResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

The outcome of a save write or delete: whether it committed, the typed reason when it did
not, and the diagnostics behind that reason. Only the persistence layer creates these, so
a caller reads a result rather than building one.

**Properties**

`public MapSaveFailureKind FailureKind`

:   `MapSaveFailureKind.None` exactly when `Succeeded` is true; a failed operation always names a kind.

`public bool Succeeded`

:   Whether the slot now holds what the call intended. False is not a promise that storage was left as it was found: only a refusal raised before storage is touched -- an unsafe slot ID, or an envelope that will not serialize -- leaves the slot alone. The shipped file adapter can also fail late, after publishing a temporary file, after committing the new save, or after writing a deletion marker, so re-read the slot rather than assuming the previous save is still the one `IMapSaveAdapter.TryRead` will return.

`public ValidationReport Validation`

:   Diagnostics for the operation. Never null; empty when nothing was reported.

---

## MapSaveReadResult

```csharp
public sealed class MapSaveReadResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

The outcome of a save read: the loaded envelope, which stored candidate supplied it, and
the diagnostics gathered on the way. A failed read carries no envelope, so check
`MapSaveReadResult.Succeeded` before touching
`MapSaveReadResult.Envelope`; a `MapSaveFailureKind.NotFound` read
is a slot with no save, not a broken one.

**Properties**

`public MapSaveEnvelope Envelope`

:   The loaded save, or null when the read failed. An adapter that decodes through `MapSaveSerializer` hands it back already migrated to the current save format and fully validated.

`public MapSaveFailureKind FailureKind`

:   `MapSaveFailureKind.None` exactly when `Succeeded` is true; a failed read always names a kind.

`public MapSaveRecoverySource RecoverySource`

:   Which candidate supplied the bytes, or `MapSaveRecoverySource.None` on failure. Anything but Primary or Memory means the primary save was unusable and a fallback was accepted, which is usually worth surfacing to the player.

`public bool Succeeded`

:   Whether a save was loaded. Check it before `Envelope`, which is null on failure; a true result may still carry warnings, since a recovery read succeeds while reporting the candidates it had to reject.

`public ValidationReport Validation`

:   Diagnostics for the read. Never null. A recovery read can succeed with warnings that name the rejected candidates, so do not discard it just because the read worked.

---

## MapSaveRecoverySource

```csharp
public enum MapSaveRecoverySource
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

Which stored candidate supplied the bytes of a successful read. Anything other than
`MapSaveRecoverySource.Primary` or `MapSaveRecoverySource.Memory`
means the primary save was missing or unusable and a validated fallback was accepted
instead; the read reports that as a warning and leaves every stored file as it found it.

| Value | Meaning |
| --- | --- |
| `None` | No candidate was accepted. |
| `Memory` | An in-process slot. |
| `Primary` | The slot's committed primary save. |
| `Temporary` | A published temporary file left behind by an interrupted write. |
| `Backup` | The bytes retained from the slot's previous successful write. |

---

## MapSaveSerializationResult

```csharp
public sealed class MapSaveSerializationResult
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

The outcome of one `MapSaveSerializer` call, in either direction. A serialize
fills `MapSaveSerializationResult.Json` and echoes the envelope it wrote; a
deserialize fills `MapSaveSerializationResult.Envelope` with the migrated,
validated save and leaves the JSON empty. A failure fills neither and names the kind
instead.

**Properties**

`public MapSaveEnvelope Envelope`

:   The envelope that was serialized, or the one that was decoded and brought up to the current save format. Null when the call failed.

`public MapSaveFailureKind FailureKind`

:   `MapSaveFailureKind.None` whenever the call succeeded.

`public string Json`

:   The canonical JSON text produced by a successful serialize. Empty for deserialize results and for failures; never null.

`public bool Succeeded`

:   Whether the call produced usable output. Which of `Json` and `Envelope` is filled depends on the direction the call ran in, so a true value alone does not tell you which to read.

`public ValidationReport Validation`

:   Diagnostics for the call. Never null; empty when nothing was reported.

---

## MapSaveSerializer

```csharp
public sealed class MapSaveSerializer
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveSerializer.cs</small>

Strict, culture-invariant JSON persistence for complete map save envelopes.

**Constructors**

`public MapSaveSerializer()`

:   Creates an immutable map Save Serializer snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.

`public MapSaveSerializer(IEnumerable<IMapSaveMigration> migrations)`

:   Creates an immutable map Save Serializer snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `migrations` &mdash; Ordered migrations input; implementations copy or enumerate it without taking caller ownership.

**Methods**

`public MapSaveSerializationResult TryDeserialize(string json)`

:   Reads saved JSON back into an envelope at the current save format, running whatever migration steps stand between the stored version and this one. The parse is strict rather than forgiving: an object carrying an unknown field, or missing one, is corrupt data rather than something to read on a best-effort basis, and so is a value of the wrong JSON type or outside its numeric range. A save written by a newer build is reported as `MapSaveFailureKind.UnsupportedVersion` instead of being read partially. Each migration step is checked after it runs, not trusted: the seed, generator version, rules fingerprint, stored graph fingerprint, and canonical graph bytes must all come back unchanged, and the step must report exactly the version it declared. A step that throws or drifts fails the load as `MapSaveFailureKind.MigrationFailed`, which is what stops a faulty upgrade from quietly rewriting a player's run. The envelope is validated both as it was stored and again after the last step, so a caller never sees a half-migrated save.
    - `json` &mdash; Input json consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The migrated, validated envelope, or the typed reason it could not be loaded. The JSON field of the result is empty either way.

`public MapSaveSerializationResult TrySerialize(MapSaveEnvelope envelope)`

:   Writes one envelope to canonical JSON. The envelope is validated at the current save format first, so an invalid one is refused rather than written out and rejected on the way back in. Field order, number formatting, and string escaping are all fixed and culture-invariant, which is what makes the text comparable byte for byte between two runs, two machines, and two locales. Text longer than `MaximumJsonLength` is refused, as is anything that throws while being written, so this never propagates an exception from the writer.
    - `envelope` &mdash; Input envelope consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The JSON text and the envelope it came from, or the typed reason nothing was produced.

---

## MapSaveV1ToV2Migration

```csharp
public sealed class MapSaveV1ToV2Migration : IMapSaveMigration
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveMigrations.cs</small>

Save format 1 had no customer metadata field. Version 2 adds it without altering graph or
progression objects, so their canonical bytes and graph fingerprint remain unchanged.

**Properties**

`public int SourceVersion`

:   Save format 1, the original format, which this step accepts.

`public int TargetVersion`

:   Save format 2, which this step produces.

**Methods**

`public MapSaveEnvelope Migrate(MapSaveEnvelope previous)`

:   Rebuilds a version 1 envelope as a version 2 one, carrying every field across unchanged and giving the new customer metadata field its empty value, since a version 1 save had nowhere to store any. The result is a new envelope; `previous` is not modified, and the graph and progression objects are shared with it rather than copied, which is what keeps the canonical graph bytes and the graph fingerprint identical across the step.
    - `previous` &mdash; Input previous consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The same run reported at version 2.

---

## MemoryMapSaveAdapter

```csharp
public sealed class MemoryMapSaveAdapter : IMapSaveAdapter
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MemoryMapSaveAdapter.cs</small>

An in-memory adapter that stores canonical JSON rather than live object references.

**Constructors**

`public MemoryMapSaveAdapter()`

:   Creates an immutable memory Map Save Adapter snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.

`public MemoryMapSaveAdapter(MapSaveSerializer serializer)`

:   Creates an immutable memory Map Save Adapter snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `serializer` &mdash; Input serializer consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Methods**

`public MapSaveOperationResult TryDelete(StableId slotId)`

:   Drops whatever the slot held. Clearing a slot that holds no save still succeeds, and nothing survives the call: this adapter keeps no backup and writes no deletion marker, so a later read of the same slot reports `MapSaveFailureKind.NotFound`.
    - `slotId` &mdash; Stable identifier for slot; invalid or empty IDs are rejected before mutation.
    - **Returns** &mdash; Success, or the typed reason the slot may still hold data.

`public MapSaveReadResult TryRead(StableId slotId)`

:   Attempts to read without throwing for expected invalid input; failure leaves output parameters at documented defaults.
    - `slotId` &mdash; Stable identifier for slot; invalid or empty IDs are rejected before mutation.
    - **Returns** &mdash; The decoded and migrated envelope on success, or the typed reason the read failed.

`public MapSaveOperationResult TryWrite(StableId slotId, MapSaveEnvelope envelope)`

:   Attempts to write without throwing for expected invalid input; failure leaves output parameters at documented defaults.
    - `slotId` &mdash; Stable identifier for slot; invalid or empty IDs are rejected before mutation.
    - `envelope` &mdash; Input envelope consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; Success, or the typed reason nothing was stored.

---

