# Troubleshooting

Match a symptom to its cause, apply the fix, then file a report that reproduces the problem from a
seed. Entries are ordered by how often each one actually happens.

## The map looks flat

**Symptom.** Nodes draw as plain quads with no gradient, stroke, glow, or ring.

**Cause.** The map surface shader could not be loaded, so every surface fell back to its default
material. One console warning names the resource path it tried.

**Fix.** Reimport `Assets/BranchWeaver/Runtime/Runtime/Resources`. The shader lives in a `Resources`
folder on purpose: that keeps it out of build shader stripping without you editing
**Always Included Shaders**.

The fallback is deliberate: a missing shader degrades to flat colour rather than magenta.
[Shape and colour nodes](style-nodes.md) lists what each token would otherwise draw.

## Generation fails

Every failure carries a kind and a diagnostic, and Map Studio prints the kind beside each seed in a
seed audit.

| Failure kind | What it means | What to change |
| --- | --- | --- |
| `InvalidInput` | Preflight rejected the request before any search ran, usually a quota minimum larger than the layer bounds can hold. | Widen the bound or lower the quota. The diagnostic names the constraint. |
| `Unsatisfiable` | No graph satisfies the hard constraints. This is proven, not guessed. | Remove a constraint. A node type with no legal predecessor can never be placed. |
| `SearchBudgetExhausted` | The search ran out of budget without proving anything either way. | Loosen the tightest rule, or raise `MaximumTopologyTrials` and `MaximumTypeTrials`. |
| `PostValidationFailed` | Complete candidates were found and every one failed post-generation validation. | Relax the post-validation rule rather than the shape rules. |

If generation succeeds but the shape is wrong, the rules are being satisfied and you need quotas or
zones to shape pacing, not more constraints. See [Write map rules](write-map-rules.md).

## The map is cropped or off-centre

Add **BranchWeaver > Map Viewport Frame** to the map hierarchy. Without it the map fills whatever rect
it is parented to, so an aspect ratio you did not design for crops it or leaves it floating. The frame
reads its values from the assigned style's **Framing** group, not from fields on the component:

- `FitMode = Fit` keeps the whole map visible.
- `MarginLeft`, `MarginRight`, `MarginTop` and `MarginBottom` are fractions of the area, so one style
  reserves interface space at every resolution.
- `RespectSafeArea` insets the map clear of notches and home indicators.
- `ClampPanToContent` stops the player dragging the map fully off screen.

Call `frame.FrameAll()` after generating a new map. Full detail in
[Place the map on screen](place-the-map-on-screen.md).

## Nodes overlap or the map is too dense

Spacing is a layout decision, so `LayerSpacing` and `NodeSpacing` live on the **Map Theme**, not on
the style. Raise both. Node *size* is a presentation decision, so `Node.Size` lives on the style and
each state's `Scale` multiplies it; changing size never moves a node. See
[Style, theme, and the presenter boundary](../explanation/style-and-theme.md).

## Clicking a node does nothing

Check in this order.

1. **Is the node available?** `controller.State.IsAvailable(nodeId)`. A dimmed node is dimmed because
   the session says it is locked.
2. **Is it hidden by fog?** A view in `MapFogState.Hidden` has its raycast target turned off by
   design. See [Control what the player can see](reveal-and-fog.md).
3. **Is the input plumbing there?** A uGUI map needs a `GraphicRaycaster` on the canvas and an
   `EventSystem` in the scene &mdash; see [Input, focus, and camera framing](input-and-navigation.md).
4. **Are you asking the presenter?** It never decides legality. Ask the controller, as in
   [Drive traversal from code](drive-traversal-from-code.md).

## A save will not load

Every save call returns a result carrying a `MapSaveFailureKind`. Log it rather than guessing.

| Failure kind | Cause |
| --- | --- |
| `MigrationMissing` | The envelope's schema version has no registered migration towards the current one. |
| `MigrationFailed` | A migration threw, or produced an envelope that no longer validates. |
| `UnsafePath` | `FileMapSaveAdapter` refused a slot ID that would resolve outside its root. It fails closed on purpose. |
| `InvalidEnvelope`, `CorruptData` | The bytes did not parse, or parsed into something invalid. |
| `NotFound`, `IoFailure` | No primary, temporary, or backup file exists for the slot; or the file system refused the operation. |

A save also stops resolving when a **stable ID** it references changes. Renaming a node type or rules
*asset* is safe; changing its *ID* is not, because the save stores the ID. Treat IDs as a
compatibility contract ([Core concepts](../explanation/architecture.md)) and plan the change with
[Save and load progress](save-and-load.md).

## The same seed gives different maps

The map is a function of rules and seed together, so both have to hold still.

- **A non-deterministic seed**, taken from `UnityEngine.Random`, `DateTime.Now`, or a frame count.
  `BranchWeaver.Core` compiles with no engine references, so it cannot see Unity's RNG at all: the
  non-determinism is always on your side of the boundary.
- **The rules changed.** A blueprint stores a `RulesFingerprint`, and recompiling it after a rules
  edit raises a metadata mismatch error naming which fingerprint moved.
- **The generator version changed.** That is a deliberate compatibility boundary, not a bug.

[Determinism, seeds, and fingerprints](../explanation/determinism.md) covers which edits break a seed.

## Map Studio edits vanished

Map Studio previews without modifying your project. Edits live in the window until you press
**Apply**, which writes back to the source asset, or **Save As**, which writes a new blueprint. The
window's **Undo** and **Redo** move through preview history. This is the intended safety behaviour.
See [Author a map by hand](author-by-hand.md).

## The development overlay

`MapDevelopmentOverlay` draws a draggable window with reveal, unlock, teleport, complete current,
reset, force result, regenerate, and copy manifest commands, so you can reach a late-run state without
playing to it. Add it to a scene object and assign an initialised controller.

It only exists when `BRANCHWEAVER_DEVTOOLS` is a scripting define symbol: the `BranchWeaver.DevTools`
assembly carries that define as a constraint, and `MapTraversalController` implements
`IMapDevelopmentHost` under the same define, so a production build has no development surface to
find. Every command returns a result, and the window shows the message when one is refused.

| Message in the window | Cause |
| --- | --- |
| No development host assigned. | No controller in the field and no `Host` set from code. |
| The map is not initialized. | `Initialize` has not run on the controller yet. |
| Enter a valid node ID. / The node ID is not present in the graph. | The typed text is not a stable ID in this graph. |
| No regeneration handler is registered. | Nothing is subscribed to `DevelopmentRegenerateRequested`. The overlay asks; your code regenerates. |
| The regeneration handler did not synchronously initialize a valid replacement map. | The handler deferred the work. It has to initialise the controller before returning. |

!!! warning "Do not ship the define"
    **Teleport** writes a progression state directly rather than walking a legal transition, and
    **Reveal all** and **Unlock** override what the fog rules would show. Add
    `BRANCHWEAVER_DEVTOOLS` to development configurations only, and check that a release build
    compiles without the assembly.

## Getting help

Include all of the following. Because generation is deterministic, a seed plus the rules that
produced it usually reproduces the problem exactly.

- Unity version and render pipeline.
- The **seed** and the **rules asset**, or the file from Map Studio's **Export JSON**.
- The full console output, including any BranchWeaver warning.
- The generation manifest, if the overlay is available. **Copy generation manifest** puts the
  generator version, graph format version, seed, rules fingerprint, graph fingerprint, and generation
  key on the clipboard as one line.

## Next

- **[Determinism, seeds, and fingerprints](../explanation/determinism.md)** &mdash; why an old seed stops reproducing its map.
- **[Save and load progress](save-and-load.md)** &mdash; adapters, failure kinds, and planning a migration.
- **[Generate a map in Map Studio](../tutorials/generate-a-map.md)** &mdash; running a seed audit before you change rules.
