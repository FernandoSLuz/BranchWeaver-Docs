# 6. Troubleshooting

Ordered by how often each one actually happens.

---

## The map looks flat

Nodes render as plain rectangles with no shading, gradient, glow, or ring.

**Cause:** the map surface shader could not be loaded, so the views fell back to flat
surfaces. The console will carry one warning saying so.

**Fix:** reimport `Assets/BranchWeaver/Runtime/Runtime/Resources`. The shader lives in a
`Resources` folder on purpose -- that guarantees it survives build shader stripping
without you adding it to **Always Included Shaders**.

The fallback is intentional: a missing shader degrades to flat colour rather than
rendering magenta.

## Generation fails

**Preflight rejects immediately.** A quota minimum exceeds what the layer bounds can
hold. The diagnostic names the constraint. Widen the bound or lower the quota.

**Fails on some seeds only.** Bounds are satisfiable but tight. Run **Run seed audit**
over 0-99 in Map Studio; if a handful fail, widen one range rather than adding more
rules.

**Always fails once connection rules are on.** Some node type has no legal predecessor,
so it can never be placed. Check forbidden adjacencies against your quotas.

**Succeeds but the shape is wrong.** Rules are being satisfied; you need quotas or zones
to shape pacing, not more constraints.

## The map is cropped, off-centre, or unreachable on a phone

Add **BranchWeaver > Map Viewport Frame** to the map hierarchy.

Without it the map fills whatever rect it is parented to, so on an aspect ratio you did
not design for it will crop or float. With it:

- `FitMode = Fit` guarantees the whole map is visible.
- `Margin*` fractions reserve space for your own interface.
- `RespectSafeArea` keeps it clear of notches and home indicators.
- `ClampPanToContent` stops the player dragging it away.

Then call `frame.FrameAll()` after generating a new map.

## Nodes overlap or the map is too dense

Node spacing and layer spacing live on the **Map Theme**, not the style. Raise
`LayerSpacing` and `NodeSpacing`.

Node *size* lives on the style (`Node.Size`), and per-state `Scale` multiplies it.

## Clicking a node does nothing

Check in this order:

1. Is the node actually available? `state.IsAvailable(nodeId)`. A dimmed node is dimmed
   because the session says it is locked.
2. Is the node hidden by fog? Hidden nodes have hit-testing disabled by design.
3. For a uGUI map, is there a `GraphicRaycaster` on the canvas and an `EventSystem` in
   the scene?
4. Are you asking the presenter for legality instead of the session? The presenter never
   decides.

## A save will not load

- **Stable ID changed.** Changing a node type or rules stable ID breaks saves that
  reference it. Renaming the *asset* is safe; changing the *ID* is not.
- **Schema version older than the migration chain covers.** `MapSaveMigrations` reports
  which version it could not upgrade.
- **Unsafe path.** `FileMapSaveAdapter` rejects slot IDs that would escape its root. This
  is deliberate and fails closed.

Every save API returns a result naming the failure kind. Log it rather than assuming.

## The same seed gives different maps

Something non-deterministic is feeding generation. The usual culprits:

- Seeding from `UnityEngine.Random`, `DateTime.Now`, or a frame count.
- Changing the **rules asset** between runs. The map is a function of (rules, seed) --
  both matter. The rules fingerprint on a blueprint exists to catch exactly this.
- Changing the **generator version**. That is a deliberate compatibility boundary.

`BranchWeaver.Core` cannot see Unity's RNG, so the non-determinism is always on your side
of the boundary.

## Motion feels wrong or makes testers uncomfortable

On the style's **Motion** group:

- `MotionScale = 0` snaps everything instantly.
- `ReduceMotion = true` also skips decorative motion. Wire it to a player accessibility
  setting.

## Map Studio edits vanished

Map Studio previews **without modifying your project**. Changes live in the window until
you press **Apply** (write back to the source) or **Save As** (write a new blueprint).
That is the intended safety behaviour, not a bug.

## Editor windows are empty after a script reload

Reopen the window. Map Studio and the Style Browser rebuild their state on focus; they
deliberately hold no static Unity object references, because those survive a domain
reload and then hand out destroyed objects.

## Getting help

Include:

- Unity version and render pipeline.
- The **seed** and the **rules asset** (or the exported JSON from Map Studio).
- The full console output, including any BranchWeaver warning.

Because generation is deterministic, a seed plus a rules asset usually reproduces the
problem exactly.
