# Determinism and diagnostics

3 types in this area.

## MapDevelopmentOverlay

```csharp
public sealed class MapDevelopmentOverlay : MonoBehaviour
```

`BranchWeaver.DevTools` &middot; <small>BranchWeaver/DevTools/MapDevelopmentOverlay.cs</small>

A draggable IMGUI window that drives the development commands of a running map: reveal
everything, unlock or teleport to a node by ID, complete the current node, force a completion
payload, reset the run, regenerate from a typed seed, and copy the generation manifest to the
system clipboard.

It is a thin front end and holds no state of its own beyond the text in its fields: every
button calls straight through to `IMapDevelopmentHost` and shows the returned
message, so a refusal reads the same here as it would in your own tooling. Text that will not
parse -- a malformed node ID, a seed that is not an unsigned integer, an invalid payload ID --
is turned down in the overlay and never reaches the host.

Add it to a scene during development only. The commands behind it move a run outside the
normal traversal rules, and the host interface exists only in a build that defines
BRANCHWEAVER_DEVTOOLS.

**Properties**

`public IMapDevelopmentHost Host`

:   The object the buttons issue their commands to. Left unset, it falls back on Awake to the `MapTraversalController` assigned in the Inspector, and the window falls back to that controller again on each repaint, so assigning this is only needed to point the overlay at a host of your own -- a wrapper that logs commands, or a stand-in in a test scene. With neither set the window draws a notice instead of its controls.

---

## MapDiagnostic

:material-star: **Start here**

```csharp
public sealed class MapDiagnostic
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/Diagnostics.cs</small>

One problem found while compiling authoring assets, running generation preflight, validating
a graph, or loading a save: a severity, a stable machine-readable code, a message written for
a human, and the rules, nodes, and slots the problem involves.

Instances are immutable, and each related collection is copied and sorted when the
diagnostic is built, so the same problem always reads the same way however the caller
assembled it. Diagnostics are handed back on result objects - usually inside a
`ValidationReport` - rather than logged for you, which leaves you free to
present them in an editor window, a console, or a test assertion.

**Constructors**

`public MapDiagnostic(MapDiagnosticSeverity severity, string code, string message, string context)`

:   Creates a diagnostic that names no rules, nodes, or slots.
    - `code` &mdash; Stable code identifying the problem; matched by ordinal comparison.
    - `message` &mdash; Human-readable explanation. Null becomes an empty string.
    - `context` &mdash; Where the problem was found. Null becomes an empty string.

`public MapDiagnostic()`

:   Creates a diagnostic that also names the rules, nodes, and slots it concerns.
    - `code` &mdash; Stable code identifying the problem; matched by ordinal comparison.
    - `message` &mdash; Human-readable explanation. Null becomes an empty string.
    - `context` &mdash; Where the problem was found. Null becomes an empty string.
    - `relatedRuleIds` &mdash; Rules implicated in the problem. Null is treated as none.
    - `relatedNodeIds` &mdash; Nodes implicated in the problem. Null is treated as none.
    - `relatedSlots` &mdash; Slots implicated in the problem. Null is treated as none.

**Properties**

`public string Code`

:   Stable dotted code for the kind of problem, such as "bw.node.duplicate-id". This is the part to branch on or to assert against in a test: it does not change with the wording of the message and it is not localized. Never null; empty only if it was built that way.

`public string Context`

:   Short free-form locator for where the problem was found: a generation phase, a seed, a rule or node ID, or an asset name, depending on what produced the diagnostic. Never null, and often empty when the code alone is enough.

`public string Message`

:   Explanation written for a person to read. Wording is not part of the contract - match on `Code` instead. Never null.

`public IReadOnlyList<StableId> RelatedNodeIds`

:   Nodes this problem implicates, sorted. Never null; empty when none apply.

`public IReadOnlyList<StableId> RelatedRuleIds`

:   Rules this problem implicates, sorted. Never null; empty when none apply.

`public IReadOnlyList<MapNodeSlot> RelatedSlots`

:   Slots this problem implicates, sorted. Never null; empty when none apply.

`public MapDiagnosticSeverity Severity`

:   How much weight this diagnostic carries. An error makes the `ValidationReport` holding it invalid and so blocks whatever was being validated; a warning is advice that travels with a successful result and blocks nothing. It is also the primary sort key of a report, which is why every error appears before any warning.

**Methods**

`public override string ToString()`

:   Formats the diagnostic for a log line or a test failure message.
    - **Returns** &mdash; The code, then the context in square brackets when the context is not empty, then a colon and the message. Severity and the related ID lists are not included.

---

## StableId

:material-star: **Start here**

```csharp
public readonly struct StableId : IEquatable<StableId>, IComparable<StableId>
```

`BranchWeaver.Core` &middot; <small>BranchWeaver/Runtime/Core/StableId.cs</small>

A stable, serialization-safe identifier. Valid characters are lowercase ASCII letters,
digits, period, underscore, and hyphen.

**Constructors**

`public StableId(string value)`

:   Wraps text as an identifier, refusing anything outside the permitted alphabet.
    - `value` &mdash; Identifier text. Uppercase letters, spaces, and punctuation other than '.', '_', and '-' are rejected rather than folded or stripped.

**Properties**

`public bool IsEmpty`

:   Reports whether this is the default value rather than a real identifier. Since empty text cannot be constructed, this is the only way an unset ID reaches a caller.

`public string Value`

:   The identifier text, or an empty string when this is the default value. It is never null, so it can be compared, concatenated, or written out without a guard.

**Methods**

`public int CompareTo(StableId other)`

:   Orders identifiers by their text ordinally, so a sorted list comes out the same on every machine regardless of its culture. The default value sorts first.
    - **Returns** &mdash; Negative, zero, or positive as this identifier sorts before, with, or after `other`.

`public bool Equals(StableId other)`

:   Reports whether both identifiers hold the same text, compared ordinally rather than by the current culture.

`public override bool Equals(object obj)`

:   Reports whether `obj` is an identifier holding the same text. Anything else, including null and a bare string, is not equal.

`public override int GetHashCode()`

:   Returns an FNV-1a hash of the identifier text. It is computed here instead of being delegated to the string's own hash because some runtimes randomise those per process. The same ID therefore hashes to the same value in every process and every build, which is what makes it safe to persist or compare across runs.

`public static bool IsValid(string value)`

:   Reports whether text would be accepted as an identifier: non-empty, and built only from lowercase ASCII letters, digits, '.', '_', and '-'. The alphabet is deliberately narrow because these IDs are written into save files, file names, and hashes, where case folding or an encoding change would otherwise turn one ID into another.
    - `value` &mdash; Text to test; null and empty both fail.

`public static StableId Parse(string value)`

:   Builds an identifier from text that is expected to be well formed, such as a literal written in code, and throws when it is not.
    - `value` &mdash; Text matching the permitted alphabet.

`public override string ToString()`

:   Returns `Value`, so an unset identifier prints as an empty string rather than as the type name.

`public static bool TryCreate(string value, out StableId stableId)`

:   Builds an identifier from untrusted text without throwing, which is what to use for anything that came from a save file, a config, or a user field.
    - `value` &mdash; Text to accept or reject.
    - `stableId` &mdash; Receives the identifier, or the default value when the text is rejected.
    - **Returns** &mdash; True when the text was accepted.

`public static bool TryParse(string value, out StableId stableId)`

:   Builds an identifier from text without throwing. Behaves exactly as `TryCreate`; both names exist so the type offers the usual Parse and TryParse pair.
    - `value` &mdash; Text to accept or reject.
    - `stableId` &mdash; Receives the identifier, or the default value when the text is rejected.
    - **Returns** &mdash; True when the text was accepted.

---

