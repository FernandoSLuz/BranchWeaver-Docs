# Write map rules

A Map Rules asset describes which maps are legal, not which map you get: the shape, the type
mix, and how routes may connect. Create one from
**Assets > Create > BranchWeaver > Map Rules**, then assign it to Map Studio's **Rules** field
so you can see what each change does.

## Shape: layers and widths

**Layers** is one row per layer, in map order. Each row holds an inclusive **Minimum** and
**Maximum** node count, so the number of rows is the layer count and each row is the width of
one layer.

Equal minimum and maximum fix a layer's width; a range hands the choice to the seed. The
starter rules use `1, 2, 2, 1`, which is why every starter seed produces the same six nodes
and varies only in the types and the routes.

| Limit | Accepted | Diagnostic when broken |
| --- | --- | --- |
| Layer count | 2 to 256 rows | `bw.rules.layer-count-invalid` |
| Layer width | `1 <= minimum <= maximum`, maximum at most 256 | `bw.rules.layer-range-invalid`, `bw.rules.layer-capacity-exceeded` |
| Whole map | the layer maxima must sum to 10,000 or fewer | `bw.rules.total-capacity-exceeded` |

**Default Node Type** is required, and it must also appear in **Node Type Weights**; if it
does not, compilation stops with `bw.rules.type-reference-unknown`.

## Type weights, quotas, and forced slots

Three mechanisms, in ascending order of firmness: a weight expresses a preference, a quota
demands a count, a forced node names a slot.

### Weights choose, quotas count

**Node Type Weights** is the set of types this rule set may place, one row each. A type with
no row is never chosen. Weights are relative and applied per slot: a Route at 6 against a
Gateway at 1 is tried first far more often, but nothing guarantees a ratio in the finished map.

Use a **Quota** when you need a count. A quota names a type, an inclusive **Minimum** and
**Maximum**, and optionally a **Zone Id** to scope it. Capacity is checked before the search
starts, so a minimum larger than its scope can hold is reported immediately instead of failing
seed by seed.

!!! note "0 is not a global weight"
    The inspector accepts a weight of 0, but compilation rejects any global weight below 1
    (`bw.rules.type-weight-invalid`). To keep a type out of part of the map, give it a zone
    weight override of 0 or list it among a zone's forbidden types.

### Forced slots and forbidden pairs

**Forced Nodes** pins a type to an exact **Layer** and **Ordinal**. A forced ordinal raises
that layer's effective minimum, so forcing ordinal 2 obliges the layer to hold at least three
nodes; an ordinal beyond the layer's maximum is `bw.rules.forced-slot-conflict`.

**Forbidden Adjacencies** rejects a pair of types at the two ends of a route. `Forward`
forbids the first type followed by the second in layer order. `Either` forbids the pair in
both directions.

Every rule row carries a stable **Rule Id**. Those IDs share one namespace with the connection
rule ID and any custom constraints, and a repeat is an error (`bw.rules.duplicate-rule-id`)
&mdash; which is what lets a failure diagnostic point at the rule that caused it.

## Zones

A zone is a named inclusive layer range with its own type domain, which is how you separate
early-game pacing from late-game pacing.

| Field | Effect |
| --- | --- |
| **First Layer** / **Last Layer** | The inclusive range the zone covers. Zones may sit next to each other but may not share a layer (`bw.rules.zone-overlap`), and must lie inside the map (`bw.rules.zone-range-invalid`). |
| **Permitted Types** | Empty means every declared type. A non-empty list restricts the zone to exactly those types. |
| **Forbidden Types** | Removes types from the zone, including ones the permitted list allowed. |
| **Weight Overrides** | Replaces the global weight inside the zone. A weight of 0 removes the type from the zone entirely. |

At least one type must survive all three lists, or the zone is rejected with
`bw.rules.zone-domain-empty`. Layers that no zone covers keep the global weights and the full
type set.

A zone also narrows quota capacity: layers where the quota's type is not permitted do not
count towards it. That is the usual reason a quota which looks satisfiable is rejected.

## Connection rules and crossing

**Maximum Outgoing** and **Maximum Incoming** cap how many routes may leave and enter one
node, from 1 to 256. Both are checked against the layer widths before any search: a layer of 1
followed by a layer of 4 needs **Maximum Outgoing** of at least 4, or preflight reports
`bw.rules.topology-capacity-conflict`.

**Optional Edge Chance** runs from 0 to 10,000 and applies after the connected backbone is in
place. Each remaining candidate route is taken with that chance out of 10,000 &mdash; 3,500 is
35 routes in 100 &mdash; and is dropped anyway if it would exceed a degree cap, break an
adjacency rule, or cross another route while crossings are forbidden.

| `Crossing Policy` | Meaning |
| --- | --- |
| **`Forbid`** | Routes may merge at a shared node but never intersect between layers. **The default.** |
| `Allow` | Routes may cross freely, giving denser, more tangled maps. |

`Forbid` is enforced while the map is built rather than cleaned up afterwards: the generator
only enumerates non-crossing route sets, so a map that comes back is crossing-free by
construction. Every map screenshot on this site was generated under `Forbid`.

!!! warning "Every field here is part of the fingerprint"
    Layer rows, weights, zones, quotas, connection limits and the crossing policy are all
    hashed into the rules fingerprint, so editing any of them changes which map a seed
    produces. See [Determinism, seeds, and fingerprints](../explanation/determinism.md).

## When generation fails

Failure has two moments: preflight, before any search, and the end of the search. A failed
generation reports a kind, search statistics, and at most one conflict diagnostic &mdash; the
deepest point the search reached before it gave up.

| Kind | Meaning | Response |
| --- | --- | --- |
| `InvalidInput` | Preflight rejected the rules. Each broken rule appears as its own `bw.rules.*` diagnostic. | Fix the named rule. No seed will help. |
| `Unsatisfiable` | The search finished and no graph satisfies the rules for this seed. | Relax the rule named in the conflict diagnostic. |
| `SearchBudgetExhausted` | The search ran out of trials. Unsatisfiability was *not* proven. | Narrow the space: fix a layer width, drop a constraint, run again. |
| `PostValidationFailed` | Every complete candidate failed validation. | Usually a custom constraint or a pinned override that contradicts the rules. |

The conflict diagnostic is specific enough to act on: a quota that cannot be met reports how
many nodes it has, the most it can reach, and its allowed range. Each diagnostic names the
rules and slots involved, which Map Studio highlights in the graph when you click it.

Common causes, in the order they usually bite:

| Symptom | Usual cause |
| --- | --- |
| Rejected before any seed runs | A quota minimum exceeds its scope's capacity, or adjacent layer widths cannot meet the degree caps |
| Every seed fails on the same quota | The scope is smaller than it looks: a zone forbids the type, or a weight override of 0 removes those layers from the capacity |
| A handful of seeds fail, most pass | Bounds are satisfiable but tight. Widen one layer range or raise one degree cap |
| Satisfied, but the map reads wrong | Nothing is broken. The shape wants a quota or a zone, not another constraint |

!!! tip "Start with shape only"
    Author the layer rows, audit a hundred seeds, then add one constraint at a time and
    re-audit. A rule set that is too tight is unsatisfiable and one that is too loose produces
    mush; the audit is what tells you which you have.

## Next

- **[2. Generate a map in Map Studio](../tutorials/generate-a-map.md)** &mdash; audit a range
  of seeds against the rules you just wrote.
- **[Create node types](create-node-types.md)** &mdash; the types weights and quotas refer to.
- **[Author a map by hand](author-by-hand.md)** &mdash; pin the beats no rule set can express.
