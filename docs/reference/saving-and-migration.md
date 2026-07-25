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

:   &mdash;

`public FileMapSaveAdapter(string rootDirectory, MapSaveSerializer serializer)`

:   &mdash;

**Properties**

`public string Backup`

:   &mdash;

`public string Path`

:   &mdash;

`public string Primary`

:   &mdash;

`public string RootDirectory`

:   &mdash;

`public MapSaveRecoverySource Source`

:   &mdash;

`public string Temporary`

:   &mdash;

`public string Tombstone`

:   &mdash;

**Methods**

`public MapSaveOperationResult TryDelete(StableId slotId)`

:   &mdash;

`public MapSaveReadResult TryRead(StableId slotId)`

:   &mdash;

`public MapSaveOperationResult TryWrite(StableId slotId, MapSaveEnvelope envelope)`

:   &mdash;

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
must reject an empty slot ID as `apSaveFailureKind.UnsafePath`, and must
persist serialized bytes from `apSaveSerializer` rather than keeping live
`apGraph` or `apProgressionState` references -- a save that
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
`apSaveSerializer` applies the steps in order while loading an older save,
which is how a format change ships without invalidating live campaigns.

An implementation must be deterministic and free of Unity, editor, and global state; must
declare a target exactly one above its source; must return a new envelope instead of
mutating the one it was handed; and must leave the generator version, seed, rules
fingerprint, stored graph fingerprint, and canonical graph bytes untouched. The serializer
re-checks all of that after the call, so a step that throws, drifts, or returns the wrong
version fails the load as `apSaveFailureKind.MigrationFailed` instead of
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

:   &mdash;

**Properties**

`public MapDataPayload CustomerMetadata`

:   &mdash;

`public int FormatVersion`

:   &mdash;

`public int GeneratorVersion`

:   &mdash;

`public MapGraph Graph`

:   &mdash;

`public string GraphFingerprint`

:   &mdash;

`public MapProgressionState Progression`

:   &mdash;

`public string RulesFingerprint`

:   &mdash;

`public uint Seed`

:   &mdash;

**Methods**

`public static MapSaveEnvelope CreateCurrent()`

:   &mdash;

---

## MapSaveFailureKind

```csharp
public enum MapSaveFailureKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

Why a save read, write, or delete did not succeed. Persistence returns these kinds
instead of throwing, and the kind is what a caller branches on:
`apSaveFailureKind.NotFound` is a legitimate "no save here yet", while the
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

:   `apSaveFailureKind.None` exactly when `ucceeded` is true; a failed operation always names a kind.

`public bool Succeeded`

:   &mdash;

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
`apSaveReadResult.Succeeded` before touching
`apSaveReadResult.Envelope`; a `apSaveFailureKind.NotFound` read
is a slot with no save, not a broken one.

**Properties**

`public MapSaveEnvelope Envelope`

:   The loaded save, or null when the read failed. An adapter that decodes through `apSaveSerializer` hands it back already migrated to the current save format and fully validated.

`public MapSaveFailureKind FailureKind`

:   `apSaveFailureKind.None` exactly when `ucceeded` is true; a failed read always names a kind.

`public MapSaveRecoverySource RecoverySource`

:   Which candidate supplied the bytes, or `apSaveRecoverySource.None` on failure. Anything but Primary or Memory means the primary save was unusable and a fallback was accepted, which is usually worth surfacing to the player.

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   Diagnostics for the read. Never null. A recovery read can succeed with warnings that name the rejected candidates, so do not discard it just because the read worked.

---

## MapSaveRecoverySource

```csharp
public enum MapSaveRecoverySource
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MapSaveContracts.cs</small>

Which stored candidate supplied the bytes of a successful read. Anything other than
`apSaveRecoverySource.Primary` or `apSaveRecoverySource.Memory`
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

The outcome of one `apSaveSerializer` call, in either direction. A serialize
fills `apSaveSerializationResult.Json` and echoes the envelope it wrote; a
deserialize fills `apSaveSerializationResult.Envelope` with the migrated,
validated save and leaves the JSON empty. A failure fills neither and names the kind
instead.

**Properties**

`public MapSaveEnvelope Envelope`

:   The envelope that was serialized, or the one that was decoded and brought up to the current save format. Null when the call failed.

`public MapSaveFailureKind FailureKind`

:   `apSaveFailureKind.None` whenever the call succeeded.

`public string Json`

:   The canonical JSON text produced by a successful serialize. Empty for deserialize results and for failures; never null.

`public bool Succeeded`

:   &mdash;

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

:   &mdash;

`public MapSaveSerializer(IEnumerable<IMapSaveMigration> migrations)`

:   &mdash;

**Methods**

`public MapSaveSerializationResult TryDeserialize(string json)`

:   &mdash;

`public MapSaveSerializationResult TrySerialize(MapSaveEnvelope envelope)`

:   &mdash;

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

:   &mdash;

`public int TargetVersion`

:   &mdash;

**Methods**

`public MapSaveEnvelope Migrate(MapSaveEnvelope previous)`

:   &mdash;

---

## MemoryMapSaveAdapter

```csharp
public sealed class MemoryMapSaveAdapter : IMapSaveAdapter
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Persistence/MemoryMapSaveAdapter.cs</small>

An in-memory adapter that stores canonical JSON rather than live object references.

**Constructors**

`public MemoryMapSaveAdapter()`

:   &mdash;

`public MemoryMapSaveAdapter(MapSaveSerializer serializer)`

:   &mdash;

**Methods**

`public MapSaveOperationResult TryDelete(StableId slotId)`

:   &mdash;

`public MapSaveReadResult TryRead(StableId slotId)`

:   &mdash;

`public MapSaveOperationResult TryWrite(StableId slotId, MapSaveEnvelope envelope)`

:   &mdash;

---

