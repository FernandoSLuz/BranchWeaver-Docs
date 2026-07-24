# 1. Getting started

Goal: a generated map on screen that you can walk, then the same map reproduced
exactly. About fifteen minutes.

Everything here is done from menus and the inspector. No code until
[guide 5](../how-to/runtime-integration.md).

---

## Install

1. Import the BranchWeaver package into a Unity **2022.3 LTS or newer** project.
2. That is all. There are no dependencies to add, no packages to install, and no
   render-pipeline setup. Built-in, URP, and HDRP all work as-is.

Everything ships under a single root, `Assets/BranchWeaver/`. Nothing is written
outside it.

## Five-minute first success

**Tools > BranchWeaver > Open Quick Start Sample**, then press Play.

You should see a small branching map. Click a highlighted node to travel to it.
Nodes you cannot reach yet are dimmed; the node you occupy is ringed and breathes
gently; routes leading somewhere reachable are emphasized.

Then try the larger one: **Tools > BranchWeaver > Open Wayfarer Sample**. It shows the
same map in both presenters (screen-space uGUI and in-scene World2D), vertical and
horizontal orientations, and a traveller walking between nodes.

If nodes render as flat rectangles with no shading, see
[Troubleshooting > the map looks flat](../how-to/troubleshooting.md#the-map-looks-flat).

## Generate your own map, no code

**Tools > BranchWeaver > Map Studio**.

This window previews and edits maps **without modifying your project**. Nothing you
do here touches an asset until you press Apply or Save As.

1. Press **Create starter node types + rules** in the empty-state card. You now have a
   usable rule set in your project.
2. Assign that rules asset to the **Rules** field and press **Compile / Load**.
3. Type a number into **Seed** and press **Regenerate**. The map changes.
4. Type the *same* number again. The identical map comes back. This is the property
   everything else rests on.
5. Press **Validate**. Diagnostics appear in the bottom pane, each naming the rule and
   node it concerns.

### Understanding what you just made

Your rules asset describes *constraints*, not a map: how many layers, how wide each
layer may be, which node types may follow which, how many of each type must appear.
The generator searches for a graph satisfying all of it.

If it cannot find one, you get a **preflight failure** naming the unsatisfiable
constraint, rather than a hang or a silently broken map. Widening one bound usually
resolves it -- see [guide 3](../how-to/author-maps.md#when-generation-fails).

## Run a seed audit

Still in Map Studio: set **Audit first** to 0 and **last** to 99, then press **Run seed
audit**.

It generates 100 maps and reports which seeds failed and what the statistics look
like across all of them. This is how you find out that your rules work for seed 7 but
are impossible for seed 42 -- before a player does.

## Put a map in your own scene

**Tools > BranchWeaver > Setup Wizard**.

The wizard builds a working map hierarchy in the current scene: a canvas, a presenter,
a traversal controller, and the viewport frame that positions it. Assign your rules
asset, choose the uGUI or World2D presenter, and press Play.

You now have a functioning map in your own scene, with no code written.

## Make it look like your game

**Tools > BranchWeaver > Style Browser**. Pick a shipped style, press **Create editable
copy**, and edit the resulting asset. The inspector previews changes live.

Full detail in [guide 4](../tutorials/styling-your-map.md).

## Next

- **[Core concepts](../explanation/architecture.md)** -- what the pieces are and why they are split
  the way they are. Read this before writing code against the package.
- **[Authoring maps](../how-to/author-maps.md)** -- node types, rules, and hand-authored
  blueprints.
