# Documentation coverage

Generated from source alongside the reference itself, so it cannot quietly drift. This page exists because a reference that hides its own gaps is worse than one that admits them.

| Scope | Documented | Total | Coverage |
| --- | --- | --- | --- |
| Public types | 100 | 169 | 59% |
| Public members | 219 | 1009 | 22% |

Measured over the 169 types this reference publishes.

## What is excluded, and why

A further **77** public types are left out. They are public only because `internal` is per-assembly in C# and this package spans several assemblies, so publishing them would describe plumbing as API. They carry `[EditorBrowsable(Never)]` in the source.

Coverage is reported over the published surface for the same reason: documenting the excluded types would raise this percentage without helping anyone read the package.

## By area

| Area | Types | Documented | Coverage |
| --- | --- | --- | --- |
| [Getting a map](getting-a-map.md) | 12 | 7 | 58% |
| [Traversal and progression](traversal-and-progression.md) | 8 | 3 | 38% |
| [Authoring assets](authoring-assets.md) | 17 | 1 | 6% |
| [Styling and appearance](styling-and-appearance.md) | 19 | 19 | 100% |
| [Presentation and views](presentation-and-views.md) | 48 | 35 | 73% |
| [Framing, input and navigation](framing-input-and-navigation.md) | 6 | 3 | 50% |
| [Rules and constraints](rules-and-constraints.md) | 18 | 12 | 67% |
| [Graph, layout and geometry](graph-layout-and-geometry.md) | 10 | 2 | 20% |
| [Saving and migration](saving-and-migration.md) | 12 | 12 | 100% |
| [Editor tools](editor-tools.md) | 3 | 0 | 0% |
| [Determinism and diagnostics](determinism-and-diagnostics.md) | 3 | 1 | 33% |
| [Other](other.md) | 13 | 5 | 38% |

## How to read this

Low coverage in an area is usually **not** a sign that the types are unclear. Much of the surface is small immutable data carriers and enums whose names and signatures are self-describing: a `StableId Id { get; }` needs no prose.

The areas worth caring about are the ones you call directly. Those are listed first on the [reference index](index.md).

