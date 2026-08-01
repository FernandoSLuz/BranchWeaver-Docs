# Other

14 types in this area.

!!! abstract "On this page"
    [IMapGenerator](#imapgenerator) &middot; [IMapValidator](#imapvalidator) &middot; [LayerNodeRange](#layernoderange) &middot; [MapDiagnosticSeverity](#mapdiagnosticseverity) &middot; [MapFingerprint](#mapfingerprint) &middot; [MapGenerationManifest](#mapgenerationmanifest) &middot; [MapNodePayload](#mapnodepayload) &middot; [MapProperty](#mapproperty) &middot; [MapPropertyKind](#mappropertykind) &middot; [MapPropertyValue](#mappropertyvalue) &middot; [MapRuleSnapshot](#maprulesnapshot) &middot; [SampleProceduralVisuals](#sampleproceduralvisuals) &middot; [SampleSceneBootstrap](#samplescenebootstrap) &middot; [XorShift32Random](#xorshift32random)

## IMapGenerator

:material-star: **Start here** &middot; :material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapGenerator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

The generation boundary of the package: one call turns a `MapGenerationRequest`
into either a complete map or a typed failure. Everything downstream -- Map Studio, the
samples, your own bootstrap -- holds this interface rather than a concrete generator, so
swapping `LayeredMapGenerator` for your own algorithm needs no other change.
An implementation is expected to be deterministic: the same rules, seed, mode, and overrides
must produce the same graph on every run and every platform, because rebuilding a map from a
seed is the guarantee the rest of the package is built on.

---

## IMapValidator

:material-puzzle: **Extension point** &mdash; implement this yourself to change behaviour

```csharp
public interface IMapValidator
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

The whole-graph check the generators run in addition to their own. Both shipped generators call
the validator they were constructed with on every finished candidate and merge its diagnostics
into the result, so an error reported here discards that candidate: the version-2 search
backtracks and keeps looking, and the version-1 generator abandons the seed. Implement it for
rules that can only be judged on a finished graph, and use `IMapConstraint` instead
for rules that should prune the search while node types are still being chosen.

---

## LayerNodeRange

```csharp
public readonly struct LayerNodeRange : IEquatable<LayerNodeRange>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapRules.cs</small>

How many nodes one layer may hold, as an inclusive range. The generator is free to choose any
count within it, which is where a layered map gets its silhouette variation from seed to seed;
pin a layer to a single width by giving it an equal minimum and maximum.

**Constructors**

`public LayerNodeRange(int minimum, int maximum)`

:   Declares the inclusive node count bounds of one layer. Nothing is validated here; rule validation is what requires 1 <= minimum <= maximum and caps the maximum at `MapRuleSnapshot.MaximumNodesPerLayer`.
    - `minimum` &mdash; Input minimum consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `maximum` &mdash; Input maximum consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public int Maximum`

:   Most nodes the layer may hold, itself allowed.

`public int Minimum`

:   Fewest nodes the layer may hold, itself allowed. It is a floor rather than a promise of the count: forced rules and pinned nodes that name a high ordinal can raise the number of nodes the layer actually receives above this.

**Methods**

`public bool Equals(LayerNodeRange other)`

:   Reports whether both ranges carry the same minimum and maximum.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a range with the same minimum and maximum.
    - `obj` &mdash; Input obj consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash combining the minimum and the maximum.
    - **Returns** &mdash; The requested immutable or borrowed value; ownership remains with the object documented by the return type.

---

## MapDiagnosticSeverity

```csharp
public enum MapDiagnosticSeverity
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Diagnostics.cs</small>

How much weight a `MapDiagnostic` carries. There are two levels and no third:
an error makes the `ValidationReport` holding it invalid, a warning never does.
Neither level is zero, so a defaulted severity field is not a legal value.

| Value | Meaning |
| --- | --- |
| `Warning` | Marks the diagnostic as warning; error severity makes its validation report invalid. |
| `Error` | Marks the diagnostic as error; error severity makes its validation report invalid. |

---

## MapFingerprint

```csharp
public static class MapFingerprint
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Fingerprinting.cs</small>

Versioned, domain-separated, big-endian canonical SHA-256 fingerprints.

**Methods**

`public static string ComputeGenerationKey()`

:   Folds the whole generation input into one lowercase SHA-256 hex string. Generated node and edge ids are derived from it, so anything that shifts the key -- an edited rules asset, a changed override, a different mode -- replaces the identities of the map a seed produces rather than nudging its shape, and save data keyed on the old node ids stops resolving.
    - `generatorVersion` &mdash; Input generator Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `mode` &mdash; Whether the map is procedural, manual, or a seeded search over overrides.
    - `rulesFingerprint` &mdash; Input rules Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `overridesFingerprint` &mdash; Input overrides Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static string ComputeGraph(MapGraph graph)`

:   Hashes a whole graph down to one lowercase SHA-256 hex string, for comparing two maps or checking that a rebuilt one matches what was saved. Nodes and edges are re-sorted into canonical order before hashing and every number is written big-endian, so two graphs holding the same map agree whatever order they were assembled in and whatever platform they were built on. Which fields take part is decided by the graph's format version: a version-one graph leaves out the generation mode, the overrides fingerprint, the generation key, and node payloads, so upgrading a graph's format changes its fingerprint even when the map is unchanged.
    - `graph` &mdash; Input graph consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static string ComputeOverrides(MapGenerationOverrides overrides)`

:   Hashes a set of pinned nodes and edge overrides down to one lowercase SHA-256 hex string, which then feeds `ComputeGenerationKey`. Only the fields a pin actually claims are hashed: a pin carrying a type or position it does not pin fingerprints identically to one that leaves those values at their defaults, so stray authored data that the generator would ignore cannot change the maps a seed produces.
    - `overrides` &mdash; Input overrides consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static string ComputeRules(MapRuleSnapshot rules)`

:   Hashes a compiled rule snapshot down to one lowercase SHA-256 hex string, the value that feeds `ComputeGenerationKey` and is stored on every graph built from those rules. Which layout is hashed is decided by the snapshot's own schema version, so version-one rules keep the fingerprint they have always had and maps saved against them still match. Custom constraints contribute their ID and their declared revision fingerprint, never their behaviour, which is why a constraint whose logic changes has to be given a new revision fingerprint or maps generated under the old logic still look current.
    - `rules` &mdash; Input rules consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static bool IsSha256Hex(string value)`

:   Reports whether a string has the shape every fingerprint in this package takes: exactly sixty-four characters, all of them 0-9 or lowercase a-f. Uppercase hex is rejected rather than folded to lowercase, because fingerprints are compared as text and a case difference would otherwise read as a different map.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; True only for a well-formed fingerprint. It says nothing about whether the value matches any particular rules or graph.

---

## MapGenerationManifest

```csharp
public sealed class MapGenerationManifest
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

The reproduction record of one successful generation: which generator and which random algorithm
ran, the seed and the fingerprints of the inputs they ran on, and the fingerprint of the graph
that came out. Store it beside a graph and a later rebuild can be compared field by field, which
is what separates "the rules changed" from "the generator changed" when a map stops matching.

**Constructors**

`public MapGenerationManifest()`

:   Creates an immutable map Generation Manifest snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `generatorVersion` &mdash; Input generator Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `randomAlgorithmVersion` &mdash; Input random Algorithm Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; Input rules Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `graphFingerprint` &mdash; Input graph Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

`public MapGenerationManifest()`

:   Creates an immutable map Generation Manifest snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `generatorVersion` &mdash; Input generator Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `randomAlgorithmVersion` &mdash; Input random Algorithm Version consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; Input rules Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `graphFingerprint` &mdash; Input graph Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `generationMode` &mdash; Input generation Mode consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `overridesFingerprint` &mdash; Input overrides Fingerprint consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `generationKey` &mdash; Input generation Key consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public string GenerationKey`

:   The one hash that folds generator version, mode, rules fingerprint, overrides fingerprint, and seed together, and from which version-2 generation derives its node and edge IDs. Never null, and empty on a version-1 manifest. Two attempts agreeing here ran on the same inputs.

`public MapGenerationMode GenerationMode`

:   The mode the request ran in. It is recorded because mode is folded into the generation key and into every random stream, so the same rules and seed under another mode describe an unrelated map. A version-1 manifest always reports `MapGenerationMode.Procedural`, the only mode that generator honours.

`public int GeneratorVersion`

:   Which generator algorithm produced the graph, as declared by the rule snapshot it ran on. The two generators do not agree on maps, so a rebuild under a different version is not expected to reproduce this graph.

`public string GraphFingerprint`

:   The canonical fingerprint of the graph that came out, never null. Rebuild from the same inputs and compare here: an identical digest is the proof the rebuild reproduced the map, and it is the same value a save carries to detect a tampered graph.

`public string OverridesFingerprint`

:   The fingerprint of the honoured override set, never null. Empty on a version-1 manifest.

`public int RandomAlgorithmVersion`

:   The version of the deterministic random algorithm the generator drew from. A build whose algorithm version differs is not expected to rebuild the same graph from the same seed, so compare this before treating a fingerprint mismatch as a content change.

`public string RulesFingerprint`

:   The canonical fingerprint of the rule snapshot the map was generated from, never null. Comparing it with the fingerprint of your current rules is what separates "the rules changed" from "the generator changed" when a rebuild stops matching.

`public uint Seed`

:   The seed the generator ran on. Asking for this map again also needs the rule snapshot and the override set themselves, which the manifest does not carry: beside the seed it records only the mode and the fingerprints that say which rules and which overrides to feed back in.

---

## MapNodePayload

```csharp
public sealed class MapNodePayload : IEquatable<MapNodePayload>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapNodePayload.cs</small>

The immutable set of typed properties carried by a node or a node type: how BranchWeaver lets a
map hold your game's data (rewards, difficulty, labels) without the package needing to know what
any of it means. Properties are sorted by key at construction, so two payloads built from the
same entries in different orders compare equal and hash and fingerprint alike.

**Constructors**

`public MapNodePayload(StableId payloadId, IEnumerable<MapProperty> properties)`

:   Creates an immutable map Node Payload snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `payloadId` &mdash; Identity of the payload. It may be empty only for a payload with no properties; carrying properties under an empty ID is rejected by validation.
    - `properties` &mdash; Ordered properties input; implementations copy or enumerate it without taking caller ownership.

**Properties**

`public StableId PayloadId`

:   Identity of this payload, empty only when it carries no properties.

`public IReadOnlyList<MapProperty> Properties`

:   The properties, sorted into canonical order rather than the order they were supplied in. In a validated payload each key appears once.

**Methods**

`public bool Equals(MapNodePayload other)`

:   Reports whether both payloads have the same ID and the same properties. Because both sides are canonically sorted, this is insensitive to the order the entries were originally given in.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; True when the payloads match; false when `other` is null.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a payload equal to this one.
    - `obj` &mdash; Input obj consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash over the ID and every property in canonical order. It depends only on content, and every part of it is computed with a fixed algorithm rather than with `string.GetHashCode()`, so the value is reproducible across processes and platforms.
    - **Returns** &mdash; The requested immutable or borrowed value; ownership remains with the object documented by the return type.

---

## MapProperty

```csharp
public readonly struct MapProperty : IEquatable<MapProperty>, IComparable<MapProperty>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapNodePayload.cs</small>

One entry of a node payload: a stable key paired with a tagged value. Keys must be unique
within a payload and each value must be canonical for its kind, both of which are checked when
the payload is validated rather than when the entry is made.

**Constructors**

`public MapProperty(StableId key, MapPropertyValue value)`

:   Pairs a key with a value. Neither is validated here.
    - `key` &mdash; Input key consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public StableId Key`

:   Name this entry is filed under. Keys are the only way back to a property, since a payload stores its entries in key order rather than the order they were authored in, and payload validation requires each key to appear once.

`public MapPropertyValue Value`

:   The value filed under `Key`, tagged with the kind that says which of its fields carries the data. Nothing in BranchWeaver interprets it; it is your game's data, carried through generation, saving, and loading unchanged.

**Methods**

`public int CompareTo(MapProperty other)`

:   Orders entries by key, then by every field of the value in turn: kind, numeric, string, and ID. This is the canonical order a payload stores its properties in, and comparing the whole entry rather than the key alone means duplicate keys end up adjacent, which is how payload validation is able to spot them. The string comparison is ordinal, so no culture setting can change the order.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; A negative value, zero, or a positive value as this entry sorts before, alongside, or after `other`.

`public bool Equals(MapProperty other)`

:   Reports whether both entries carry the same key and an equal value.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is an entry with the same key and an equal value.
    - `obj` &mdash; Input obj consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash combining the key and the value. Both sides hash their text with a fixed algorithm rather than with `string.GetHashCode()`, so the result is the same in every process and on every platform and may safely be persisted or compared across machines.
    - **Returns** &mdash; The requested immutable or borrowed value; ownership remains with the object documented by the return type.

---

## MapPropertyKind

```csharp
public enum MapPropertyKind
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapPropertyValue.cs</small>

Which of a `MapPropertyValue`'s fields carries the data. The numbers are deliberate
and persisted: they are written into save files and hashed into map fingerprints, so renumbering
or reusing one would invalidate existing saves and change every fingerprint.

| Value | Meaning |
| --- | --- |
| `Boolean` | A true or false value, held as 1 or 0 in the numeric field. |
| `Integer` | A whole number, held in the numeric field with the full range of a 64-bit integer. |
| `FixedPoint` | A fractional number, held in the numeric field as an integer already multiplied by `MapPropertyValue.FixedPointScale`. |
| `String` | Text, held in the string field. |
| `StableId` | A reference to something named elsewhere, held in the ID field. |

---

## MapPropertyValue

```csharp
public readonly struct MapPropertyValue : IEquatable<MapPropertyValue>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Properties/MapPropertyValue.cs</small>

A Unity-independent tagged value used by map payloads. It carries a field for each kind it can
hold, of which only the one named by `Kind` is meaningful; the others are expected to
be left at their zero. Build values through the factory methods rather than the constructor, which
will happily assemble a combination that `IsCanonical` then rejects. Storing no floats
and no engine types is what lets a payload hash to the same value on every platform.

**Constructors**

`public MapPropertyValue()`

:   Assembles a value from its parts. Prefer the factory methods, which cannot produce an inconsistent combination. A null `stringValue` is stored as an empty string.
    - `kind` &mdash; Input kind consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `numericValue` &mdash; Input numeric Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `stringValue` &mdash; Input string Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `stableIdValue` &mdash; Input stable Id Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.

**Properties**

`public bool IsCanonical`

:   Whether this value is well formed for its kind, which payload validation requires of every property. It demands that the fields the kind does not use are left at zero, and additionally that a boolean is exactly 0 or 1, that a reference is not empty, and that text is valid UTF-16 with no unpaired surrogate. A value that was never initialised has no recognised kind and so reports false rather than throwing.

`public MapPropertyKind Kind`

:   Which of the four value fields below is the meaningful one.

`public long NumericValue`

:   The numeric field, shared by three kinds: 0 or 1 for a boolean, the number itself for an integer, and the pre-scaled integer for a fixed-point value. Zero for the string and ID kinds.

`public StableId StableIdValue`

:   The reference field, meaningful only for the ID kind and empty otherwise.

`public string StringValue`

:   The text field, meaningful only for the string kind and empty otherwise. Never null: the constructor substitutes an empty string.

**Methods**

`public static MapPropertyValue Boolean(bool value)`

:   Runs boolean against validated inputs and returns a complete result rather than exposing partially updated state.
    - `value` &mdash; Whether value; false selects the documented conservative behavior.
    - **Returns** &mdash; The complete map Property Value outcome; inspect its typed status or diagnostics before consuming payload data.

`public bool Equals(MapPropertyValue other)`

:   Reports whether both values have the same kind and identical contents in every field, not only in the field the kind uses. Text is compared ordinally, so no culture setting affects the answer.
    - `other` &mdash; Input other consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a value equal to this one.
    - `obj` &mdash; Input obj consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public static MapPropertyValue FixedPoint(long scaledValue)`

:   Runs fixed Point against validated inputs and returns a complete result rather than exposing partially updated state.
    - `scaledValue` &mdash; Input scaled Value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Property Value outcome; inspect its typed status or diagnostics before consuming payload data.

`public override int GetHashCode()`

:   Returns a hash over the kind and all four fields. Text is hashed with a fixed algorithm instead of `string.GetHashCode()`, which some runtimes randomise per process, so the value is reproducible across runs, machines, and platforms.
    - **Returns** &mdash; The requested immutable or borrowed value; ownership remains with the object documented by the return type.

`public static MapPropertyValue Id(StableId value)`

:   Runs id against validated inputs and returns a complete result rather than exposing partially updated state.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Property Value outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapPropertyValue Integer(long value)`

:   Runs integer against validated inputs and returns a complete result rather than exposing partially updated state.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Property Value outcome; inspect its typed status or diagnostics before consuming payload data.

`public static MapPropertyValue String(string value)`

:   Runs string against validated inputs and returns a complete result rather than exposing partially updated state.
    - `value` &mdash; Input value consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete map Property Value outcome; inspect its typed status or diagnostics before consuming payload data.

---

## MapRuleSnapshot

:material-star: **Start here**

```csharp
public sealed class MapRuleSnapshot
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/MapRules.cs</small>

Immutable, engine-independent rules compiled from authoring assets: the layer widths, the node
type table, the zones, the quota, forced-type and forbidden-adjacency rules, the connection
limits, and any custom constraints. This is the whole of what a generator is allowed to read,
and it holds no Unity types, so the same rules can be built, validated, and generated from in a
plain test or a build pipeline as well as in the editor.
Every collection is copied and sorted into a canonical order at construction, which is what
makes `ComputeFingerprint` depend on what the rules say rather than on the order
they were authored in. That fingerprint also seeds the generator's random streams, so editing
any rule changes the map a given seed produces.

**Constructors**

`public MapRuleSnapshot()`

:   Creates an immutable map Rule Snapshot snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `schemaVersion` &mdash; Rule schema in use; must pair with `generatorVersion`.
    - `generatorVersion` &mdash; Generator to run; see `GeneratorVersion2` for the pairing requirement.
    - `layers` &mdash; Node count bounds per layer, in order; the index is the layer number.
    - `defaultNodeTypeId` &mdash; Type assigned to every node. Passing an empty ID leaves the type table empty as well, which rule validation reports rather than silently accepts.

`public MapRuleSnapshot()`

:   Creates an immutable map Rule Snapshot snapshot; invalid required identifiers, ranges, or null inputs are rejected before state is exposed.
    - `schemaVersion` &mdash; Must pair with `generatorVersion`; see `SchemaVersion2`.
    - `generatorVersion` &mdash; Must pair with `schemaVersion`; only version two enforces the rules below.
    - `layers` &mdash; Layers in order, front to back. This is the one collection whose order is preserved rather than sorted, because its index is the layer number every rule and override refers to.
    - `defaultNodeTypeId` &mdash; Type used where no rule decides otherwise; it must also appear in `nodeTypeWeights`.
    - `nodeTypeWeights` &mdash; Positive relative selection weight; zero or negative values are rejected by validation.
    - `zones` &mdash; Layer bands with their own type rules; validation requires their ranges not to overlap.
    - `quotas` &mdash; How many of a type the map, or one named zone, must and may contain.
    - `forcedNodeTypes` &mdash; Slots whose type is decided in advance rather than drawn by weight.
    - `forbiddenAdjacencies` &mdash; Type pairs that may not be joined by an edge.
    - `connectionRules` &mdash; Per-node edge limits and crossing policy; this one is taken as given rather than copied.
    - `customConstraints` &mdash; Extra constraints to evaluate. Each is wrapped so that the ID and revision fingerprint it reports now are captured and cannot drift afterwards, while evaluation still calls through to the instance supplied here. Null entries are kept rather than dropped, so that validation can report them.

**Properties**

`public MapConnectionRules ConnectionRules`

:   Per-node edge limits and the crossing policy. Unlike the rule collections around it this is stored exactly as it was handed to the constructor rather than copied, so this is the same instance the caller supplied.

`public IReadOnlyList<IMapConstraint> CustomConstraints`

:   Custom constraints, sorted by ID and revision. These are wrappers, not the instances passed to the constructor: each reports the ID and revision fingerprint captured at construction, with a null revision normalised to an empty string, and forwards evaluation to the original.

`public StableId DefaultNodeTypeId`

:   The node type used wherever no rule decides otherwise. It has to appear in `NodeTypeWeights` as well, since that table is the type domain, and validation reports it when it does not.

`public IReadOnlyList<ForbiddenAdjacencyRule> ForbiddenAdjacencies`

:   Pairs of node types that may not be joined by an edge, sorted into canonical order.

`public IReadOnlyList<ForcedNodeTypeRule> ForcedNodeTypes`

:   Slots whose node type is settled in advance rather than drawn by weight, sorted into canonical order.

`public int GeneratorVersion`

:   The generator this snapshot expects to be run through. Only `GeneratorVersion2` enforces the zones, weights, quotas, forced types, and adjacency rules; validation rejects a snapshot that pairs one version with the other schema.

`public StableId Id`

:   The wrapped constraint's ID as it read when the snapshot was built. It is captured once so a constraint that changes its own identity later cannot move the snapshot's fingerprint out from under a save.

`public IReadOnlyList<LayerNodeRange> Layers`

:   Node count bounds for each layer, in authored order. Unlike the other collections here this one is not sorted, because its index is the layer number that slots, zones, and overrides address; reordering it would silently repoint every rule in the snapshot.

`public IReadOnlyList<NodeTypeWeight> NodeTypeWeights`

:   The map-wide node type table, sorted. It doubles as the type domain: a type with no entry here cannot be placed anywhere and cannot be referenced by any other rule.

`public IReadOnlyList<NodeTypeQuotaRule> Quotas`

:   How many nodes of a type the whole map, or one named zone, must and may contain, sorted into canonical order.

`public string RevisionFingerprint`

:   The wrapped constraint's revision as it read when the snapshot was built, with null normalised to an empty string so ordering and fingerprinting never see a null.

`public int SchemaVersion`

:   The rule schema these values were authored against, which decides how much of the snapshot carries meaning: under `SchemaVersion1` only the layers and the default node type are read, and everything else here is left unvalidated.

`public IReadOnlyList<MapZoneDefinition> Zones`

:   Layer bands with their own type rules, sorted. In a valid snapshot their ranges do not overlap, so any layer is governed by at most one of them.

**Methods**

`public int Compare(IMapConstraint left, IMapConstraint right)`

:   Orders two constraints by ID and then by revision fingerprint, with nulls first. This is what gives the custom constraint list one canonical order however it was authored, so two snapshots saying the same thing fingerprint alike.
    - `left` &mdash; First constraint; may be null.
    - `right` &mdash; Second constraint; may be null.
    - **Returns** &mdash; Negative, zero, or positive as `left` sorts before, with, or after `right`.

`public string ComputeFingerprint()`

:   Hashes the whole rule set into a stable identity. Two snapshots that say the same thing hash alike however their collections were ordered on the way in, and any change to any rule changes the value, which is why this is safe to compare or cache against.
    - **Returns** &mdash; A lowercase 64-character SHA-256 hex digest, in the canonical format of this snapshot's schema version.

`public ConstraintResult Evaluate(ConstraintContext context)`

:   Forwards evaluation to the wrapped constraint, so behaviour still comes from the instance the caller supplied even though the identity above is frozen.
    - `context` &mdash; The attempt being checked, passed through untouched.

`public MapZoneDefinition FindZoneForLayer(int layer)`

:   Finds the zone governing a layer. In a valid snapshot zone ranges are disjoint, so the answer is unambiguous; if ranges do overlap the first zone in canonical order wins.
    - `layer` &mdash; Zero-based layer index; out-of-range values simply match no zone.
    - **Returns** &mdash; The zone covering that layer, or null when none does, meaning the map-wide rules apply unmodified.

---

## SampleProceduralVisuals

```csharp
public static class SampleProceduralVisuals
```

`BranchWeaver.Samples` &middot; <small>BranchWeaver/Samples/Shared/SampleProceduralVisuals.cs</small>

Creates the sample-only scenery and traveler markers from deterministic geometry at
runtime. No imported image, font, shader, material, or render-pipeline package is needed.
The deliberately small textures keep the sample lightweight and make their clean-room
origin auditable directly from this source file.

**Methods**

`public static Sprite GetBackdrop(BranchWeaverSampleKind kind)`

:   Returns one cached, code-generated backdrop for the requested sample.

`public static IReadOnlyList<Sprite[]> GetHeroFrames()`

:   Returns six cached two-frame traveler animations. Their order matches `SampleTraveler.CharacterNames`.

---

## SampleSceneBootstrap

```csharp
public sealed class SampleSceneBootstrap : MonoBehaviour
```

`BranchWeaver.Samples` &middot; <small>BranchWeaver/Samples/Shared/SampleSceneBootstrap.cs</small>

Self-contained sample host. It builds only neutral Unity primitives at runtime and keeps
gameplay ownership outside BranchWeaver: the Complete button stands in for customer content.

**Properties**

`public uint ActiveSeed`

:   The seed the map now on screen was generated from. It starts at the seed configured on the component, steps up by one with each `RegenerateNextSeed`, and is replaced by the stored seed when a save is loaded.

`public CanvasMapPresenter CanvasPresenter`

:   The Canvas presenter drawing the map, built for both samples. Switching to the world view deactivates the viewport it lives under rather than tearing it down, so this stays non-null while a sample is running.

`public MapTraversalController Controller`

:   The traversal controller this host created and initialized, or null before `StartSample` succeeds and again after `StopSample`. Every button on the sample panel drives the map through this same public controller, so anything the sample does can be done from your own code.

`public bool IsStarted`

:   Whether a sample is running, meaning the controller exists and holds an initialized map. Most of the host's own work is gated on this, so a start that failed leaves the object inert rather than half-built.

`public bool IsWorldView`

:   Whether the World2D presentation is the one being shown. Always false in Quick Start, and false again once the sample is stopped.

`public string LastMessage`

:   The latest line of operator feedback, the same text the on-screen status label shows. It carries both the sample's own refusals and the first diagnostic of any validation report the package returned, so a button press that did nothing explains itself on screen rather than only in the console.

`public BranchWeaverSampleKind SampleKind`

:   Which shipped sample this host builds. Quick Start builds the Canvas presentation only and saves into memory; the Wayfarer campaign also builds the World2D presentation and saves real files under the persistent data path.

`public SampleTraveler Traveler`

:   The sample's hero pawn, which stands on the current node in whichever presentation is showing. It is sample-owned content: BranchWeaver itself never moves a pawn.

`public WorldMapPresenter WorldPresenter`

:   The World2D presenter drawing the same map in the scene, or null in Quick Start, which deliberately builds no world view at all.

**Methods**

`public bool CompleteCurrent()`

:   Completes the node the traveller is standing on, with a fixed sample result payload carrying a single `sample.outcome` property set to `completed`. This is where the game a customer is really building would run its encounter and report what happened; the sample skips straight to the result so that nothing gameplay-shaped lives inside the package.
    - **Returns** &mdash; True when the completion was accepted. False when there is no current node or the controller rejected it, with the reason in `LastMessage`.

`public void Configure()`

:   Replaces the assets and seed this host will build from, for a scene or a test that wires the sample up in code instead of in the inspector. Only allowed while the sample is stopped. The running host holds compiled content derived from these assets, so swapping them underneath it would leave the map on screen and the content drawing it disagreeing.
    - `kind` &mdash; Which shipped sample to build, which also decides whether a world view is created and whether saves go to memory or to disk.
    - `mapBlueprint` &mdash; The blueprint whose rules and generator settings the map is built from.
    - `initialTheme` &mdash; The theme the sample starts with.
    - `orientationTheme` &mdash; The second theme `ToggleOrientation` switches to. Null leaves the sample with a single orientation and no Orientation button on the panel.
    - `initialSeed` &mdash; The seed the first map is generated from.
    - `initialWorldView` &mdash; True to open in the World2D presentation. Ignored for a sample that builds no world view.

`public bool DeleteSaveAndResetProgress()`

:   Deletes this sample's save and restarts the run on the same graph, so progression goes back to the beginning while the map itself stays exactly as it was. Nothing is regenerated, so the node ids a save or a bug report refers to still mean the same nodes afterwards.
    - **Returns** &mdash; True when the save was deleted and the controller re-initialized; on failure the reason is in `LastMessage`.

`public bool EnterFirstAvailable()`

:   Moves the traveller into the first available node in stable-id order. The available ids are sorted before one is picked so the Enter button lands on the same node every run, rather than on whichever id the traversal session happened to report first.
    - **Returns** &mdash; True when the controller accepted the move. False when nothing is available or the move was rejected, with the reason in `LastMessage`.

`public bool LoadNow()`

:   Restores the saved graph and traversal state, re-initializing the controller straight from the envelope. Nothing is regenerated from the seed, which is what makes the restored map identical rather than merely similar. The compiled content is not reloaded either, so whichever orientation is currently in force goes on drawing the restored graph. A save that simply is not there is reported as such and disables the Load button, rather than counting as a failure.
    - **Returns** &mdash; True when the controller re-initialized from the save.

`public bool RegenerateNextSeed()`

:   Builds the next map in the seed sequence -- the active seed plus one -- using the orientation currently in force, and hands it to the same controller. Progression restarts, because the nodes are not the old ones. The step refuses at the top of the seed range instead of wrapping, so walking through seeds never quietly returns to one already seen.
    - **Returns** &mdash; True when the new map compiled and the controller accepted it; on failure the map on screen is left untouched and the reason is in `LastMessage`.

`public bool SaveNow()`

:   Writes the whole graph and the traversal state to this sample's save slot, along with a small metadata payload recording which sample wrote it. Quick Start writes to an in-memory adapter that lasts only as long as the play session; the Wayfarer campaign writes files under the project's persistent data path. This also runs whenever the controller raises its own save request, which is how a save-on-progress flow is wired.
    - **Returns** &mdash; True when the write succeeded; on failure the adapter's diagnostic is left in `LastMessage`.

`public bool StartSample()`

:   Compiles the wired assets, generates the map, and builds everything the sample needs around it: the traversal controller, the presentations, the control panel, the save adapter and the hero. Failure is reported rather than thrown. Content that will not compile, or a map the controller refuses, leaves the reason in `LastMessage` and returns false, and a refused map also tears the partly built host down again so the next attempt starts from nothing. Calling it while a sample is already running does nothing and reports success.
    - **Returns** &mdash; True when a map is on screen and ready to traverse.

`public void StopSample()`

:   Tears the running sample down: detaches from the controller's events, destroys everything the host built, and drops every reference so a later `StartSample` begins from nothing. Safe to call when nothing is running, and safe outside play mode, where the objects are destroyed immediately instead of at the end of the frame.

`public bool ToggleOrientation()`

:   Recompiles the runtime content against the sample's other authored theme and re-presents the same graph with the same progression. The map changes shape and direction while its identity does not: no generation runs, no node id changes, and nothing already visited is lost. Refused when only one theme is wired, which is why the Orientation button is absent in that case.
    - **Returns** &mdash; True when the other orientation compiled and is now on screen.

`public bool TogglePresentation()`

:   Swaps between the Canvas and World2D views of the same running map. Only which presenter is showing changes: the controller, the graph, the progression and the hero all carry straight over.
    - **Returns** &mdash; True when the view was swapped. False in Quick Start, which builds the Canvas presentation only.

---

## XorShift32Random

```csharp
public sealed class XorShift32Random
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/DeterministicRandom.cs</small>

Version 1 of BranchWeaver's deterministic random stream.
The xorshift32 transition and zero-seed normalization are public compatibility contracts.

**Constructors**

`public XorShift32Random(uint seed)`

:   Starts a fresh stream from a seed. A seed of zero is quietly replaced by `ZeroSeedReplacement`, because xorshift32 can never leave zero and would otherwise repeat it forever; seeding with 0 and with that constant therefore give the same sequence.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.

`public XorShift32Random(DeterministicRandomState state)`

:   Resumes a stream from a position taken with `CaptureState`, so a restored run carries on through the same sequence instead of starting it again.
    - `state` &mdash; A previously captured position. Unlike the seed constructor this is not normalized: it is rejected rather than repaired, so a corrupt or hand-built state fails loudly instead of silently drawing a different sequence.

**Properties**

`public uint State`

:   The word the next draw will be derived from. It moves on every draw and is never zero once the instance exists, so comparing it before and after a call shows whether the stream was consumed.

**Methods**

`public DeterministicRandomState CaptureState()`

:   Takes the stream's current position so it can be stored and later handed back to `XorShift32Random(DeterministicRandomState)`. The capture carries `AlgorithmVersion` with it, so a position saved by a build with a different algorithm is refused on load rather than silently resuming a different sequence.
    - **Returns** &mdash; The complete deterministic Random State outcome; inspect its typed status or diagnostics before consuming payload data.

`public bool NextBool()`

:   Returns true or false with even odds, consuming exactly one draw. It reads the low bit of that draw and reports true for the even outcome.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public int NextInt(int exclusiveMaximum)`

:   Returns a value from zero up to but not including `exclusiveMaximum`, with every value equally likely. Draws that land in the uneven tail left over by the modulus are discarded and redrawn rather than folded back, so no value is favoured -- at the cost of consuming an unpredictable number of draws when the bound does not divide the 32-bit range evenly.
    - `exclusiveMaximum` &mdash; How many distinct values to choose between; must be positive.
    - **Returns** &mdash; The complete int outcome; inspect its typed status or diagnostics before consuming payload data.

`public int NextInt(int inclusiveMinimum, int inclusiveMaximum)`

:   Returns a value in the inclusive range. A fixed range returns immediately without consuming random state, which keeps optional fixed rules from shifting later choices.
    - `inclusiveMinimum` &mdash; Input inclusive Minimum consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - `inclusiveMaximum` &mdash; Input inclusive Maximum consumed by this operation; caller ownership is retained unless the type documents a defensive copy.
    - **Returns** &mdash; The complete int outcome; inspect its typed status or diagnostics before consuming payload data.

`public uint NextUInt()`

:   Advances the stream one step and returns the new state word. Every other draw on this class is built on it, so calling it directly shifts every later result -- which is the usual cause of two runs of one seed diverging.
    - **Returns** &mdash; The complete uint outcome; inspect its typed status or diagnostics before consuming payload data.

---

