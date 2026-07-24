# Documentation coverage

Generated from source alongside the reference itself, so it cannot quietly drift. This page exists because a reference that hides its own gaps is worse than one that admits them.

| Scope | Documented | Total | Coverage |
| --- | --- | --- | --- |
| Public types | 61 | 244 | 25% |
| Public members | 108 | 1378 | 8% |

## By area

| Area | Types | Documented | Coverage |
| --- | --- | --- | --- |
| [Getting a map](getting-a-map.md) | 12 | 1 | 8% |
| [Traversal and progression](traversal-and-progression.md) | 8 | 3 | 38% |
| [Authoring assets](authoring-assets.md) | 27 | 0 | 0% |
| [Styling and appearance](styling-and-appearance.md) | 28 | 28 | 100% |
| [Presentation and views](presentation-and-views.md) | 63 | 5 | 8% |
| [Framing, input and navigation](framing-input-and-navigation.md) | 9 | 4 | 44% |
| [Rules and constraints](rules-and-constraints.md) | 19 | 0 | 0% |
| [Graph, layout and geometry](graph-layout-and-geometry.md) | 11 | 2 | 18% |
| [Saving and migration](saving-and-migration.md) | 12 | 5 | 42% |
| [Editor tools](editor-tools.md) | 31 | 2 | 6% |
| [Determinism and diagnostics](determinism-and-diagnostics.md) | 3 | 1 | 33% |
| [Other](other.md) | 21 | 10 | 48% |

## How to read this

Low coverage in an area is usually **not** a sign that the types are unclear. Much of the surface is small immutable data carriers and enums whose names and signatures are self-describing: a `StableId Id { get; }` needs no prose.

The areas worth caring about are the ones you call directly. Those are listed first on the [reference index](index.md).

