# Other

12 types in this area.

!!! abstract "On this page"
    [IMapGenerator](#imapgenerator) &middot; [IMapValidator](#imapvalidator) &middot; [LayerNodeRange](#layernoderange) &middot; [MapDiagnosticSeverity](#mapdiagnosticseverity) &middot; [MapFingerprint](#mapfingerprint) &middot; [MapGenerationManifest](#mapgenerationmanifest) &middot; [MapNodePayload](#mapnodepayload) &middot; [MapProperty](#mapproperty) &middot; [MapPropertyKind](#mappropertykind) &middot; [MapPropertyValue](#mappropertyvalue) &middot; [MapRuleSnapshot](#maprulesnapshot) &middot; [XorShift32Random](#xorshift32random)

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

**Methods**

`public MapGenerationResult Generate(MapGenerationRequest request)`

:   Produces one map from the request. Return a complete graph or a typed failure and never anything in between: callers read `MapGenerationResult.Succeeded` and then go straight to `MapGenerationResult.Graph`, and they neither null-check the result nor catch exceptions around this call. Report bad input, unsatisfiable rules, an exhausted search budget, and cancellation through `MapGenerationFailureKind` instead of throwing -- no shipped code path raises an exception for a cancelled request.
    - `request` &mdash; The complete generation inputs. Implementations read its rules, seed, mode, overrides, search budgets, and cancellation token without taking ownership of the request.
    - **Returns** &mdash; The outcome of the attempt. Never null.

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

**Methods**

`public ValidationReport Validate(MapGraph graph, MapRuleSnapshot rules)`

:   Judges one candidate graph against the rules it was generated from. Must be deterministic, must not mutate the graph or the rules, and must return a report even when handed a null graph -- callers read `ValidationReport.IsValid` off the return value directly. A version-2 search calls this once per complete candidate, which for one request can be many times, so keep it cheap.
    - `graph` &mdash; The finished candidate to inspect without mutation; may be null so validation can report invalid input.
    - `rules` &mdash; The rule snapshot the candidate is expected to satisfy; the validator must not modify it.
    - **Returns** &mdash; The diagnostics for this graph. Any error-severity diagnostic rejects the candidate; warnings are kept and travel with the successful result.

---

## LayerNodeRange

:material-star: **Start here**

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
    - `minimum` &mdash; The inclusive lower node-count bound, stored without checking positivity or ordering.
    - `maximum` &mdash; The inclusive upper node-count bound, stored without checking per-layer limits.

**Properties**

`public int Maximum`

:   Most nodes the layer may hold, itself allowed.

`public int Minimum`

:   Fewest nodes the layer may hold, itself allowed. It is a floor rather than a promise of the count: forced rules and pinned nodes that name a high ordinal can raise the number of nodes the layer actually receives above this.

**Methods**

`public bool Equals(LayerNodeRange other)`

:   Reports whether both ranges carry the same minimum and maximum.
    - `other` &mdash; The range whose inclusive minimum and maximum are compared.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a range with the same minimum and maximum.
    - `obj` &mdash; The object to test; only another range with both bounds equal can match.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash combining the minimum and the maximum.
    - **Returns** &mdash; A deterministic combined hash of the inclusive minimum and maximum.

---

## MapDiagnosticSeverity

:material-star: **Start here**

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

:material-star: **Start here**

```csharp
public static class MapFingerprint
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Fingerprinting.cs</small>

Versioned, domain-separated, big-endian canonical SHA-256 fingerprints.

**Fields**

`public const int FingerprintFormatVersion`

:   The default fingerprint schema emitted by version-two canonical hash operations.

`public const int FingerprintFormatVersion1`

:   The legacy canonical-hash schema used by version-one rules and graphs.

`public const int FingerprintFormatVersion2`

:   The canonical-hash schema that includes version-two rules, payloads, modes, overrides, and generation keys.

`public const int LatestFingerprintFormatVersion`

:   The newest fingerprint schema understood by this package build.

**Methods**

`public static string ComputeGenerationKey( int generatorVersion, MapGenerationMode mode, string rulesFingerprint, string overridesFingerprint, uint seed)`

:   Folds the whole generation input into one lowercase SHA-256 hex string. Generated node and edge ids are derived from it, so anything that shifts the key -- an edited rules asset, a changed override, a different mode -- replaces the identities of the map a seed produces rather than nudging its shape, and save data keyed on the old node ids stops resolving.
    - `generatorVersion` &mdash; The map algorithm revision whose generated identities the key will namespace.
    - `mode` &mdash; Whether the map is procedural, manual, or a seeded search over overrides.
    - `rulesFingerprint` &mdash; The canonical digest of the compiled rules; null is encoded identically to empty text.
    - `overridesFingerprint` &mdash; The canonical digest of the honoured override set; null is encoded identically to empty text.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static string ComputeGraph(MapGraph graph)`

:   Hashes a whole graph down to one lowercase SHA-256 hex string, for comparing two maps or checking that a rebuilt one matches what was saved. Nodes and edges are re-sorted into canonical order before hashing and every number is written big-endian, so two graphs holding the same map agree whatever order they were assembled in and whatever platform they were built on. Which fields take part is decided by the graph's format version: a version-one graph leaves out the generation mode, the overrides fingerprint, the generation key, and node payloads, so upgrading a graph's format changes its fingerprint even when the map is unchanged.
    - `graph` &mdash; The graph snapshot to re-sort and hash using the schema selected by its `MapGraph.FormatVersion`.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static string ComputeOverrides(MapGenerationOverrides overrides)`

:   Hashes a set of pinned nodes and edge overrides down to one lowercase SHA-256 hex string, which then feeds `ComputeGenerationKey`. Only the fields a pin actually claims are hashed: a pin carrying a type or position it does not pin fingerprints identically to one that leaves those values at their defaults, so stray authored data that the generator would ignore cannot change the maps a seed produces.
    - `overrides` &mdash; The immutable, canonically ordered pin and edge-override set to encode.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static string ComputeRules(MapRuleSnapshot rules)`

:   Hashes a compiled rule snapshot down to one lowercase SHA-256 hex string, the value that feeds `ComputeGenerationKey` and is stored on every graph built from those rules. Which layout is hashed is decided by the snapshot's own schema version, so version-one rules keep the fingerprint they have always had and maps saved against them still match. Custom constraints contribute their ID and their declared revision fingerprint, never their behaviour, which is why a constraint whose logic changes has to be given a new revision fingerprint or maps generated under the old logic still look current.
    - `rules` &mdash; The immutable rule snapshot to encode using the schema selected by its `MapRuleSnapshot.SchemaVersion`.
    - **Returns** &mdash; Sixty-four lowercase hexadecimal characters.

`public static bool IsSha256Hex(string value)`

:   Reports whether a string has the shape every fingerprint in this package takes: exactly sixty-four characters, all of them 0-9 or lowercase a-f. Uppercase hex is rejected rather than folded to lowercase, because fingerprints are compared as text and a case difference would otherwise read as a different map.
    - `value` &mdash; The candidate digest text; null, uppercase, non-hex, or any length other than 64 fails.
    - **Returns** &mdash; True only for a well-formed fingerprint. It says nothing about whether the value matches any particular rules or graph.

---

## MapGenerationManifest

:material-star: **Start here**

```csharp
public sealed class MapGenerationManifest
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/GenerationContracts.cs</small>

The reproduction record of one successful generation: which generator and which random algorithm
ran, the seed and the fingerprints of the inputs they ran on, and the fingerprint of the graph
that came out. Store it beside a graph and a later rebuild can be compared field by field, which
is what separates "the rules changed" from "the generator changed" when a map stops matching.

**Constructors**

`public MapGenerationManifest( int generatorVersion, int randomAlgorithmVersion, uint seed, string rulesFingerprint, string graphFingerprint)`

:   Records a procedural generation made without override or generation-key fingerprints. String fingerprints are normalized to empty strings when null.
    - `generatorVersion` &mdash; The map algorithm revision declared by the rules used for this run.
    - `randomAlgorithmVersion` &mdash; The deterministic random-stream revision used to draw the graph.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; The lowercase SHA-256 digest of the generation rules, or null to record an empty digest.
    - `graphFingerprint` &mdash; The lowercase SHA-256 digest of the produced graph, or null to record an empty digest.

`public MapGenerationManifest( int generatorVersion, int randomAlgorithmVersion, uint seed, string rulesFingerprint, string graphFingerprint, MapGenerationMode generationMode, string overridesFingerprint, string generationKey)`

:   Records the exact versions and canonical identifiers needed to compare or reproduce a generation run. Null string inputs are stored as empty strings rather than rejected.
    - `generatorVersion` &mdash; The map algorithm revision declared by the rules used for this run.
    - `randomAlgorithmVersion` &mdash; The deterministic random-stream revision used to draw the graph.
    - `seed` &mdash; Explicit unsigned deterministic seed; equal inputs and seed produce equal canonical output.
    - `rulesFingerprint` &mdash; The lowercase SHA-256 digest of the generation rules, or null to record an empty digest.
    - `graphFingerprint` &mdash; The lowercase SHA-256 digest of the produced graph, or null to record an empty digest.
    - `generationMode` &mdash; The procedural, hybrid, or manual mode used by the request.
    - `overridesFingerprint` &mdash; The canonical digest of the honoured overrides, or null to record an empty digest.
    - `generationKey` &mdash; The canonical hash combining algorithm, mode, rules, overrides, and seed, or null to record no key.

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

:material-star: **Start here**

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

:   Copies and canonically sorts property entries. Null input becomes an empty collection; payload identity, key uniqueness, and value canonicality are intentionally deferred to validation.
    - `payloadId` &mdash; Identity of the payload. It may be empty only for a payload with no properties; carrying properties under an empty ID is rejected by validation.
    - `properties` &mdash; Properties to defensively copy and sort by key and value; null means no properties.

**Properties**

`public StableId PayloadId`

:   Identity of this payload, empty only when it carries no properties.

`public IReadOnlyList<MapProperty> Properties`

:   The properties, sorted into canonical order rather than the order they were supplied in. In a validated payload each key appears once.

**Fields**

`public static readonly MapNodePayload Empty`

:   The shared payload that carries nothing: an empty ID and no properties. It is what every API here substitutes for a null payload, so prefer it over null when a payload is required but there is nothing to say.

**Methods**

`public bool Equals(MapNodePayload other)`

:   Reports whether both payloads have the same ID and the same properties. Because both sides are canonically sorted, this is insensitive to the order the entries were originally given in.
    - `other` &mdash; The payload whose identity and canonically ordered properties are compared.
    - **Returns** &mdash; True when the payloads match; false when `other` is null.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a payload equal to this one.
    - `obj` &mdash; The object to test; null and non-payload instances compare unequal.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash over the ID and every property in canonical order. It depends only on content, and every part of it is computed with a fixed algorithm rather than with `string.GetHashCode()`, so the value is reproducible across processes and platforms.
    - **Returns** &mdash; A process-stable ordered hash of the payload identity and every property.

---

## MapProperty

:material-star: **Start here**

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
    - `key` &mdash; The stable lookup key; empty or duplicate keys remain representable until payload validation.
    - `value` &mdash; The tagged payload value; non-canonical field combinations remain representable until validation.

**Properties**

`public StableId Key`

:   Name this entry is filed under. Keys are the only way back to a property, since a payload stores its entries in key order rather than the order they were authored in, and payload validation requires each key to appear once.

`public MapPropertyValue Value`

:   The value filed under `Key`, tagged with the kind that says which of its fields carries the data. Nothing in BranchWeaver interprets it; it is your game's data, carried through generation, saving, and loading unchanged.

**Methods**

`public int CompareTo(MapProperty other)`

:   Orders entries by key, then by every field of the value in turn: kind, numeric, string, and ID. This is the canonical order a payload stores its properties in, and comparing the whole entry rather than the key alone means duplicate keys end up adjacent, which is how payload validation is able to spot them. The string comparison is ordinal, so no culture setting can change the order.
    - `other` &mdash; The property entry to order against this value by key and then every value field.
    - **Returns** &mdash; A negative value, zero, or a positive value as this entry sorts before, alongside, or after `other`.

`public bool Equals(MapProperty other)`

:   Reports whether both entries carry the same key and an equal value.
    - `other` &mdash; The property entry whose key and tagged value are compared.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is an entry with the same key and an equal value.
    - `obj` &mdash; The object to test; only a `MapProperty` with equal key and value can match.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override int GetHashCode()`

:   Returns a hash combining the key and the value. Both sides hash their text with a fixed algorithm rather than with `string.GetHashCode()`, so the result is the same in every process and on every platform and may safely be persisted or compared across machines.
    - **Returns** &mdash; A process-stable combined hash of the key and complete tagged value.

---

## MapPropertyKind

:material-star: **Start here**

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

:material-star: **Start here**

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

`public MapPropertyValue( MapPropertyKind kind, long numericValue, string stringValue, StableId stableIdValue)`

:   Assembles a value from its parts. Prefer the factory methods, which cannot produce an inconsistent combination. A null `stringValue` is stored as an empty string.
    - `kind` &mdash; The tag identifying which stored field consumers should interpret.
    - `numericValue` &mdash; The raw 64-bit field used by Boolean, Integer, and FixedPoint kinds.
    - `stringValue` &mdash; The ordinal text field for the String kind; null is normalized to empty.
    - `stableIdValue` &mdash; The reference field for the StableId kind; empty values remain possible until canonical validation.

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

**Fields**

`public const long FixedPointScale`

:   The agreed multiplier between a real number and the integer a `MapPropertyKind.FixedPoint` value stores, so 1.5 is held as 15000 and four decimal places survive. This is a convention for callers to apply and undo: nothing in the package scales by it on your behalf.

**Methods**

`public static MapPropertyValue Boolean(bool value)`

:   Encodes a Boolean property with numeric storage set to exactly zero or one and all unused fields cleared.
    - `value` &mdash; The Boolean payload; false maps to 0 and true maps to 1.
    - **Returns** &mdash; A canonical Boolean-tagged property value.

`public bool Equals(MapPropertyValue other)`

:   Reports whether both values have the same kind and identical contents in every field, not only in the field the kind uses. Text is compared ordinally, so no culture setting affects the answer.
    - `other` &mdash; The tagged value whose kind and all backing fields are compared with this value.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public override bool Equals(object obj)`

:   Reports whether `obj` is a value equal to this one.
    - `obj` &mdash; The object to test; non-`MapPropertyValue` instances compare unequal.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public static MapPropertyValue FixedPoint(long scaledValue)`

:   Encodes an already-scaled fixed-point integer; no multiplication, rounding, or bounds check is performed.
    - `scaledValue` &mdash; The caller-scaled payload, conventionally real value times `FixedPointScale`.
    - **Returns** &mdash; A canonical FixedPoint-tagged property value containing the supplied raw integer.

`public override int GetHashCode()`

:   Returns a hash over the kind and all four fields. Text is hashed with a fixed algorithm instead of `string.GetHashCode()`, which some runtimes randomise per process, so the value is reproducible across runs, machines, and platforms.
    - **Returns** &mdash; A process-stable hash derived from the tag, numeric field, ordinal text bytes, and stable id.

`public static MapPropertyValue Id(StableId value)`

:   Encodes a stable reference identity while clearing numeric and text storage.
    - `value` &mdash; The referenced identity; an empty id is retained but makes `IsCanonical` false.
    - **Returns** &mdash; A StableId-tagged property value containing the supplied identity.

`public static MapPropertyValue Integer(long value)`

:   Encodes a signed 64-bit integer property while clearing the text and identifier fields.
    - `value` &mdash; The unscaled integer payload across the full `long` range.
    - **Returns** &mdash; A canonical Integer-tagged property value.

`public static MapPropertyValue String(string value)`

:   Encodes ordinal text, normalizing null to empty and leaving UTF-16 well-formedness for `IsCanonical`.
    - `value` &mdash; The text payload to retain verbatim, or null to store an empty string.
    - **Returns** &mdash; A String-tagged property value with numeric and identifier fields cleared.

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

`public MapRuleSnapshot( int schemaVersion, int generatorVersion, IEnumerable<LayerNodeRange> layers, StableId defaultNodeTypeId)`

:   Builds the compact rule form: authored layer order is copied, the non-empty default type receives weight one, and all version-two rule collections start empty.
    - `schemaVersion` &mdash; Rule schema in use; must pair with `generatorVersion`.
    - `generatorVersion` &mdash; Generator to run; see `GeneratorVersion2` for the pairing requirement.
    - `layers` &mdash; Node count bounds per layer, in order; the index is the layer number.
    - `defaultNodeTypeId` &mdash; Type assigned to every node. Passing an empty ID leaves the type table empty as well, which rule validation reports rather than silently accepts.

`public MapRuleSnapshot( int schemaVersion, int generatorVersion, IEnumerable<LayerNodeRange> layers, StableId defaultNodeTypeId, IEnumerable<NodeTypeWeight> nodeTypeWeights, IEnumerable<MapZoneDefinition> zones, IEnumerable<NodeTypeQuotaRule> quotas, IEnumerable<ForcedNodeTypeRule> forcedNodeTypes, IEnumerable<ForbiddenAdjacencyRule> forbiddenAdjacencies, MapConnectionRules connectionRules, IEnumerable<IMapConstraint> customConstraints)`

:   Copies rule collections into canonical order while preserving layer order, freezes each custom constraint's identity and revision, and defers semantic validation to `MapRulesValidator`.
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

`public IReadOnlyList<LayerNodeRange> Layers`

:   Node count bounds for each layer, in authored order. Unlike the other collections here this one is not sorted, because its index is the layer number that slots, zones, and overrides address; reordering it would silently repoint every rule in the snapshot.

`public IReadOnlyList<NodeTypeWeight> NodeTypeWeights`

:   The map-wide node type table, sorted. It doubles as the type domain: a type with no entry here cannot be placed anywhere and cannot be referenced by any other rule.

`public IReadOnlyList<NodeTypeQuotaRule> Quotas`

:   How many nodes of a type the whole map, or one named zone, must and may contain, sorted into canonical order.

`public int SchemaVersion`

:   The rule schema these values were authored against, which decides how much of the snapshot carries meaning: under `SchemaVersion1` only the layers and the default node type are read, and everything else here is left unvalidated.

`public IReadOnlyList<MapZoneDefinition> Zones`

:   Layer bands with their own type rules, sorted. In a valid snapshot their ranges do not overlap, so any layer is governed by at most one of them.

**Fields**

`public const int CurrentGeneratorVersion`

:   Generator version new content should be written against. Same value as `LatestGeneratorVersion`.

`public const int CurrentSchemaVersion`

:   Schema version new content should be written against. Same value as `LatestSchemaVersion`.

`public const int GeneratorVersion1`

:   The original generator, which fills layers and connects them without consulting the version-two rule families. It must be paired with `SchemaVersion1`.

`public const int GeneratorVersion2`

:   The current generator, the one that actually enforces zones, weights, quotas, forced types and adjacency rules. It must be paired with `SchemaVersion2`; validation rejects a snapshot that mixes a schema version with the other generator version.

`public const int LatestGeneratorVersion`

:   Highest generator version this build understands. Same value as `CurrentGeneratorVersion`.

`public const int LatestSchemaVersion`

:   Highest schema version this build understands. Same value as `CurrentSchemaVersion`.

`public const int MaximumLayers`

:   Most layers a map may declare. Validation also requires at least two.

`public const int MaximumNodesPerLayer`

:   Ceiling on the maximum of any single `LayerNodeRange`.

`public const int MaximumTotalNodes`

:   Ceiling on the whole graph. Validation applies it to the sum of the layer maxima rather than to the node count a particular seed happens to produce, so a rule set is rejected for being able to exceed this even if no generated map would have.

`public const int SchemaVersion1`

:   The original rule schema, which describes a map by its layer ranges and one default node type only. Zones, weights, quotas, forced types, adjacency rules and custom constraints are not part of it and are left unvalidated when it is in use.

`public const int SchemaVersion2`

:   The current rule schema, which adds the node type table, zones, quotas, forced types, forbidden adjacencies, connection rules and custom constraints. New content should use this.

**Methods**

`public string ComputeFingerprint()`

:   Hashes the whole rule set into a stable identity. Two snapshots that say the same thing hash alike however their collections were ordered on the way in, and any change to any rule changes the value, which is why this is safe to compare or cache against.
    - **Returns** &mdash; A lowercase 64-character SHA-256 hex digest, in the canonical format of this snapshot's schema version.

`public MapZoneDefinition FindZoneForLayer(int layer)`

:   Finds the zone governing a layer. In a valid snapshot zone ranges are disjoint, so the answer is unambiguous; if ranges do overlap the first zone in canonical order wins.
    - `layer` &mdash; Zero-based layer index; out-of-range values simply match no zone.
    - **Returns** &mdash; The zone covering that layer, or null when none does, meaning the map-wide rules apply unmodified.

---

## XorShift32Random

:material-star: **Start here**

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

**Fields**

`public const int AlgorithmVersion`

:   The serialized revision number for BranchWeaver's xorshift32 transition and state layout.

`public const uint ZeroSeedReplacement`

:   The non-zero word substituted for seed zero so xorshift32 can advance.

**Methods**

`public DeterministicRandomState CaptureState()`

:   Takes the stream's current position so it can be stored and later handed back to `XorShift32Random(DeterministicRandomState)`. The capture carries `AlgorithmVersion` with it, so a position saved by a build with a different algorithm is refused on load rather than silently resuming a different sequence.
    - **Returns** &mdash; A value snapshot that restores this exact next-draw position under algorithm version 1.

`public bool NextBool()`

:   Returns true or false with even odds, consuming exactly one draw. It reads the low bit of that draw and reports true for the even outcome.
    - **Returns** &mdash; only when all preconditions are satisfied; otherwise with no partial mutation.

`public int NextInt(int exclusiveMaximum)`

:   Returns a value from zero up to but not including `exclusiveMaximum`, with every value equally likely. Draws that land in the uneven tail left over by the modulus are discarded and redrawn rather than folded back, so no value is favoured -- at the cost of consuming an unpredictable number of draws when the bound does not divide the 32-bit range evenly.
    - `exclusiveMaximum` &mdash; How many distinct values to choose between; must be positive.
    - **Returns** &mdash; An unbiased integer in the half-open interval [0, `exclusiveMaximum`).

`public int NextInt(int inclusiveMinimum, int inclusiveMaximum)`

:   Returns a value in the inclusive range. A fixed range returns immediately without consuming random state, which keeps optional fixed rules from shifting later choices.
    - `inclusiveMinimum` &mdash; The lowest integer that may be returned.
    - `inclusiveMaximum` &mdash; The highest integer that may be returned; it must be at least the minimum and span at most `int.MaxValue` values.
    - **Returns** &mdash; An unbiased integer in the closed interval [`inclusiveMinimum`, `inclusiveMaximum`].

`public uint NextUInt()`

:   Advances the stream one step and returns the new state word. Every other draw on this class is built on it, so calling it directly shifts every later result -- which is the usual cause of two runs of one seed diverging.
    - **Returns** &mdash; The next non-zero 32-bit state word after one xorshift32 transition.

---

