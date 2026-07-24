# Saving and migration

12 types in this area.

!!! abstract "On this page"
    [FileMapSaveAdapter](#filemapsaveadapter) &middot; [IMapSaveAdapter](#imapsaveadapter) &middot; [IMapSaveMigration](#imapsavemigration) &middot; [MapSaveEnvelope](#mapsaveenvelope) &middot; [MapSaveFailureKind](#mapsavefailurekind) &middot; [MapSaveOperationResult](#mapsaveoperationresult) &middot; [MapSaveReadResult](#mapsavereadresult) &middot; [MapSaveRecoverySource](#mapsaverecoverysource) &middot; [MapSaveSerializationResult](#mapsaveserializationresult) &middot; [MapSaveSerializer](#mapsaveserializer) &middot; [MapSaveV1ToV2Migration](#mapsavev1tov2migration) &middot; [MemoryMapSaveAdapter](#memorymapsaveadapter)

## FileMapSaveAdapter

```csharp
public sealed class FileMapSaveAdapter : IMapSaveAdapter
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/FileMapSaveAdapter.cs</small>

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

```csharp
public interface IMapSaveAdapter
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## IMapSaveMigration

```csharp
public interface IMapSaveMigration
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

---

## MapSaveEnvelope

```csharp
public sealed class MapSaveEnvelope
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveEnvelope.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `InvalidEnvelope` | &mdash; |
| `CorruptData` | &mdash; |
| `UnsupportedVersion` | &mdash; |
| `MigrationMissing` | &mdash; |
| `MigrationFailed` | &mdash; |
| `UnsafePath` | &mdash; |
| `NotFound` | &mdash; |
| `IoFailure` | &mdash; |

---

## MapSaveOperationResult

```csharp
public sealed class MapSaveOperationResult
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public MapSaveFailureKind FailureKind`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

---

## MapSaveReadResult

```csharp
public sealed class MapSaveReadResult
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public MapSaveEnvelope Envelope`

:   &mdash;

`public MapSaveFailureKind FailureKind`

:   &mdash;

`public MapSaveRecoverySource RecoverySource`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

---

## MapSaveRecoverySource

```csharp
public enum MapSaveRecoverySource
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `None` | &mdash; |
| `Memory` | &mdash; |
| `Primary` | &mdash; |
| `Temporary` | &mdash; |
| `Backup` | &mdash; |

---

## MapSaveSerializationResult

```csharp
public sealed class MapSaveSerializationResult
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveContracts.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public MapSaveEnvelope Envelope`

:   &mdash;

`public MapSaveFailureKind FailureKind`

:   &mdash;

`public string Json`

:   &mdash;

`public bool Succeeded`

:   &mdash;

`public ValidationReport Validation`

:   &mdash;

---

## MapSaveSerializer

```csharp
public sealed class MapSaveSerializer
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveSerializer.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MapSaveMigrations.cs</small>

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

`BranchWeaver.Core` &middot; <small>Runtime/Core/Persistence/MemoryMapSaveAdapter.cs</small>

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

