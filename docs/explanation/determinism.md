# Determinism, seeds, and fingerprints

The same rules and the same seed always produce the same graph, on every machine and every
platform. Here is what makes that true, which fingerprints record it, and which edits make
an old seed stop reproducing its map.

---

## Why it holds

Determinism here is structural rather than promised. `BranchWeaver.Core` is compiled with
`noEngineReferences: true` and no assembly references at all, so generation cannot reach
`UnityEngine.Random`, `Time`, or a frame counter even by accident.

Three further properties do the rest:

- **One random source.** Every choice comes from `XorShift32Random`, seeded explicitly. Its
  transition and its zero-seed normalisation are documented compatibility contracts, so a
  seed of `0u` is as reproducible as any other value.
- **Integer geometry.** A node's position is two integers on a 0 to
  `NormalizedMapPosition.Scale` (10000) axis, computed with integer arithmetic. A graph holds
  no floating-point value that could drift between platforms.
- **Culture-free hashing.** Fingerprints are big-endian canonical SHA-256 over UTF-8 strings
  written with explicit lengths, so the current culture changes nothing.

A bug report carrying a seed and a rules asset therefore reproduces the problem exactly.

## What a seed pins

A seed alone pins nothing. The graph is a function of five inputs, and all five are hashed
into one identity:

| Input | Set by |
| --- | --- |
| Seed (`uint`) | `MapGenerationRequest`, or the blueprint's stored seed |
| Rules snapshot | the compiled `MapRulesAsset` |
| Overrides | pinned nodes and edges on a blueprint |
| Generation mode | `Procedural`, `Hybrid`, or `Manual` |
| Generator version | the rules asset (currently 2) |

Everything else sits outside that identity. Style presets, theme spacing, node-type labels,
colours, icons and prefabs, localisation, fog depth, and the choice of presenter cannot
change a graph -- see [style, theme, and the presenter boundary](style-and-theme.md).

Two consequences that surprise people:

- **Row order does not matter.** Weights, zones, quotas, forced types and forbidden
  adjacencies are sorted when the snapshot is built, so dragging a row up the list leaves
  every fingerprint unchanged.
- **Search budgets are not part of the identity.** Raising `MaximumTopologyTrials` can turn a
  `SearchBudgetExhausted` failure into a success; it cannot turn one successful map into a
  different map.

!!! note
    A `Manual` blueprint uses seed `0`, and compilation rejects any other value. Nothing is
    drawn from a random stream when every node and edge is pinned.

## Fingerprints and the generation key

Four SHA-256 values describe a generation, each domain-separated by its own label so one
kind can never be mistaken for another.

| Fingerprint | Covers | Answers |
| --- | --- | --- |
| Rules | every hashed rule field, plus each custom constraint's ID and revision | Are these the same rules? |
| Overrides | pinned node fields, edge dispositions, pinned IDs | Are these the same pins? |
| Generation key | generator version, mode, rules, overrides, seed | Is this the same request? |
| Graph | seed, provenance, and every node and edge | Is this the same map? |

The generation key is the reproduction case in one string: two requests with the same key
produce the same graph. The graph fingerprint is the receipt, and it ignores the order nodes
and edges arrived in, because both are sorted canonically before hashing.

### Where they surface

`MapGenerationResult.Manifest` carries all four as `RulesFingerprint`,
`OverridesFingerprint`, `GenerationKey` and `GraphFingerprint`, alongside the `Seed`,
`GeneratorVersion` and `RandomAlgorithmVersion` that produced them.

A `MapGraph` keeps its own `Seed`, `RulesFingerprint`, `OverridesFingerprint` and
`GenerationKey`, so a loaded map still knows where it came from. Blueprint assets store the
same values; compiling one recomputes them and raises
`bw.authoring.blueprint-metadata-mismatch` when a stored value disagrees. That is how an
edited rules asset gets caught before it reaches a build.

### Per-decision streams

Nothing draws from one long sequence. Each decision -- a layer count, the topology for one
layer pair, the type for one slot, one optional edge -- gets its own stream, seeded by
hashing the request identity with a phase name and a stable phase key. Backtracking during
the search therefore cannot shift a decision made anywhere else.

## What breaks reproducibility

| Change | Effect on an old seed |
| --- | --- |
| Any hashed rule field: layer bounds, weights, zones, quotas, forced types, forbidden adjacencies, connection rules, default node type | Rules fingerprint changes, every stream reseeds, the map changes |
| A referenced node type's stable ID | Same as above |
| Pinning, unpinning, or moving a pinned node or edge | Overrides fingerprint changes |
| Switching generation mode | Generation key changes |
| Bumping the generator version | A deliberate compatibility boundary |
| Renaming an asset, restyling, retheming, changing fog | Nothing |

!!! warning "Custom constraints"
    A custom constraint contributes only its stable ID and its `RevisionFingerprint` to the
    rules fingerprint -- never its code. Change what `Evaluate` does without bumping
    `RevisionFingerprint` and every fingerprint will agree while the maps quietly differ.
    A constraint that reads the clock, `UnityEngine.Random`, or unordered iteration breaks
    determinism the same way.

The other way to lose reproducibility is never to have had it. Seeding from
`UnityEngine.Random`, `DateTime.Now`, or a frame count gives you a map you cannot ask for
again. Draw the seed however you like, then store it.

## Generating off the main thread

Generation is synchronous, allocates its own state, and touches no Unity API, so it can run
on a worker. Map Studio's seed audit does exactly that, generating a range of up to 100,000
seeds on a background task. Compile on the main thread, generate on the worker, and return
before touching anything presentational:

```csharp
// Main thread: compilation reads ScriptableObjects.
MapRulesCompilation compiled = new MapAuthoringCompiler().CompileRules(rulesAsset);
if (!compiled.Succeeded) return;
MapRuleSnapshot rules = compiled.Value; // immutable, safe to hand across threads

// Worker: no Unity API is touched. Create the generator here.
MapGenerationResult result = await Task.Run(() => new LayeredMapGenerator().Generate(
    new MapGenerationRequest(
        rules, seed, MapGenerationMode.Procedural, MapGenerationOverrides.Empty,
        MapGenerationSearchOptions.Default, cancellationToken)));

// Main thread again.
if (result.Succeeded) controller.Initialize(result.Graph, content);
```

Cancellation is co-operative and quiet: a cancelled request returns a result whose
`FailureKind` is `Cancelled`, not an exception. An unsatisfiable rule set comes back the same
way, as data you can inspect.

## Next

- **[Core concepts](architecture.md)** -- where generation sits in the pipeline.
- **[Write map rules](../how-to/write-map-rules.md)** -- the fields that feed the rules fingerprint.
- **[Troubleshooting](../how-to/troubleshooting.md)** -- when the same seed gives different maps.
