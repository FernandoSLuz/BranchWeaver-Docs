# Documentation coverage

Generated from source alongside the reference itself, so it cannot quietly drift. This page exists because a reference that hides its own gaps is worse than one that admits them.

| Scope | Documented | Total | Coverage |
| --- | --- | --- | --- |
| Public types | 175 | 175 | 100% |
| Public members | 1020 | 1067 | 96% |

Measured over the 175 types this reference publishes.

## What is excluded, and why

A further **70** public types are left out. They are public only because `internal` is per-assembly in C# and this package spans several assemblies, so publishing them would describe plumbing as API. They carry `[EditorBrowsable(Never)]` in the source.

Coverage is reported over the published surface for the same reason: documenting the excluded types would raise this percentage without helping anyone read the package.

## By area

| Area | Types | Documented | Coverage |
| --- | --- | --- | --- |
| [Getting a map](getting-a-map.md) | 12 | 12 | 100% |
| [Traversal and progression](traversal-and-progression.md) | 8 | 8 | 100% |
| [Authoring assets](authoring-assets.md) | 17 | 17 | 100% |
| [Styling and appearance](styling-and-appearance.md) | 21 | 21 | 100% |
| [Presentation and views](presentation-and-views.md) | 51 | 51 | 100% |
| [Framing, input and navigation](framing-input-and-navigation.md) | 7 | 7 | 100% |
| [Rules and constraints](rules-and-constraints.md) | 18 | 18 | 100% |
| [Graph, layout and geometry](graph-layout-and-geometry.md) | 10 | 10 | 100% |
| [Saving and migration](saving-and-migration.md) | 12 | 12 | 100% |
| [Editor tools](editor-tools.md) | 3 | 3 | 100% |
| [Determinism and diagnostics](determinism-and-diagnostics.md) | 3 | 3 | 100% |
| [Other](other.md) | 13 | 13 | 100% |

## How to read this

Low coverage in an area is usually **not** a sign that the types are unclear. Much of the surface is small immutable data carriers and enums whose names and signatures are self-describing: a `StableId Id { get; }` needs no prose.

The areas worth caring about are the ones you call directly. Those are listed first on the [reference index](index.md).

