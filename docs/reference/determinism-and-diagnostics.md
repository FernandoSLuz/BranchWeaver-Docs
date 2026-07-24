# Determinism and diagnostics

3 types in this area.

## MapDevelopmentOverlay

```csharp
public sealed class MapDevelopmentOverlay : MonoBehaviour
```

`BranchWeaver.DevTools` &middot; <small>DevTools/MapDevelopmentOverlay.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public IMapDevelopmentHost Host`

:   &mdash;

---

## MapDiagnostic

```csharp
public sealed class MapDiagnostic
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/Diagnostics.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapDiagnostic(MapDiagnosticSeverity severity, string code, string message, string context)`

:   &mdash;

`public MapDiagnostic()`

:   &mdash;

**Properties**

`public string Code`

:   &mdash;

`public string Context`

:   &mdash;

`public string Message`

:   &mdash;

`public IReadOnlyList<StableId> RelatedNodeIds`

:   &mdash;

`public IReadOnlyList<StableId> RelatedRuleIds`

:   &mdash;

`public IReadOnlyList<MapNodeSlot> RelatedSlots`

:   &mdash;

`public MapDiagnosticSeverity Severity`

:   &mdash;

**Methods**

`public override string ToString()`

:   &mdash;

---

## StableId

```csharp
public readonly struct StableId : IEquatable<StableId>, IComparable<StableId>
```

`BranchWeaver.Core` &middot; <small>Runtime/Core/StableId.cs</small>

A stable, serialization-safe identifier. Valid characters are lowercase ASCII letters,
digits, period, underscore, and hyphen.

**Constructors**

`public StableId(string value)`

:   &mdash;

**Properties**

`public bool IsEmpty`

:   &mdash;

`public string Value`

:   &mdash;

**Methods**

`public int CompareTo(StableId other)`

:   &mdash;

`public bool Equals(StableId other)`

:   &mdash;

`public override bool Equals(object obj)`

:   &mdash;

`public override int GetHashCode()`

:   &mdash;

`public static bool IsValid(string value)`

:   &mdash;

`public static StableId Parse(string value)`

:   &mdash;

`public override string ToString()`

:   &mdash;

`public static bool TryCreate(string value, out StableId stableId)`

:   &mdash;

`public static bool TryParse(string value, out StableId stableId)`

:   &mdash;

---

