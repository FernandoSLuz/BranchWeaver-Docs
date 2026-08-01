# 1. Install and run the samples

Import BranchWeaver, open the two shipped sample scenes, and walk a generated map with a mouse,
a keyboard, a gamepad, or a touchscreen. No code is involved.

## Install

1. Import BranchWeaver into a Unity project. That is the whole install: no third-party
   dependency, no render-pipeline package, no setup step. Everything ships under
   `Assets/BranchWeaver/` without writing anything outside it.
2. Check that uGUI (`com.unity.ugui`) is present. It is in standard Unity projects already, and
   it is the only package BranchWeaver requires. `com.unity.inputsystem` is optional: install it
   and the typed input bridge compiles in, leave it out and nothing is missing.

!!! note "What has actually been verified"
    Unity 2022.3.62f1 is the verified editor version and the Built-in render pipeline is the
    verified pipeline. Other editor versions, pipelines, and platforms are treated as pending
    rather than assumed. The recorded evidence and the pending list ship in the package, at
    `Assets/BranchWeaver/Documentation/Compatibility-and-Release.md`.

Both sample scenes open from the **Tools > BranchWeaver** menu, so you never have to find them
in the Project window.

| Sample | Menu item | Scene |
| --- | --- | --- |
| Quick Start | **Open Quick Start Sample** | `Samples/QuickStart/BranchWeaverQuickStart.unity` |
| Wayfarer | **Open Wayfarer Sample** | `Samples/Wayfarer/BranchWeaverWayfarer.unity` |

Each scene holds exactly one object, carrying a `SampleSceneBootstrap` component. There is no
camera, no canvas, and no map until you press Play: the bootstrap builds the traversal
controller, the presenter, the input controller, and its own control panel in code, so nothing
there is a prefab you have to take apart to understand.

!!! note "Both samples draw with the default style"
    Neither sample assigns a `MapStylePreset`, so both render with the shipped default, Slate
    Nocturne. If nodes appear as flat rectangles with no shading, see
    [Troubleshooting](../how-to/troubleshooting.md#the-map-looks-flat).

## Run the Quick Start sample

### 1. Open Quick Start and press Play

**Tools > BranchWeaver > Open Quick Start Sample**, then press Play.

You get a six-node map running vertically, drawn by the screen-space Canvas presenter and
generated procedurally from seed `20260722`. Its rules ask for four layers, one, two, two, and
one node wide, mixing four node types, Route, Rest, Landmark, and Gateway, with a Route forced
first, a Gateway forced last, one or two Rest nodes in total, and no two Rest nodes adjacent.

### 2. Click a highlighted node

Locked nodes are dimmed and slightly smaller, the node you occupy is ringed and pulses gently,
and a route is widened and brightened when the node it leads to is available, so the next legal
choice reads at a glance.

| | State | What you are looking at |
| --- | --- | --- |
| ![A dim, slightly shrunken node](../assets/images/node-state-locked.png){ width="70" } | **Locked** | Visible, not reachable. |
| ![A fully bright node with a soft glow](../assets/images/node-state-available.png){ width="70" } | **Available** | Click this one. |
| ![A large bright node inside an amber ring](../assets/images/node-state-current.png){ width="70" } | **Current** | Where you are standing. |
| ![A slightly dimmed, slightly smaller node](../assets/images/node-state-visited.png){ width="70" } | **Visited** | Entered, not finished. |
| ![A plain bright node with no glow](../assets/images/node-state-completed.png){ width="70" } | **Completed** | Finished, and what follows it is unlocked. |

Those are the default style's per-state settings rather than fixed behaviour;
[tutorial 5](restyle-your-map.md) changes them.

### 3. Use the control panel

The panel docked down the left is sample scaffolding, not part of the package. The map viewport
reserves the strip it occupies, so nodes never render underneath it at any aspect ratio.

| Button | Effect |
| --- | --- |
| **Enter available** | Enters the first available node in ID order |
| **Complete current** | Marks the current node complete, which unlocks what follows it |
| **Next seed** | Regenerates the map at seed + 1 |
| **Save** / **Load** | Writes and reads the whole graph together with traversal state |
| **Delete + reset** | Deletes the save and restarts traversal on the same graph |
| **Hero: ...** | Cycles the six idle-animated characters standing on the current node |

**Enter available**, **Complete current**, and **Load** grey out when they do not apply. Below
them, a status line reports the last thing that happened, a metrics line shows the seed, the
state revision, and the visited and completed counts, and a legend gives the colour each node
state draws with.

### 4. Finish the map

Completing the final node reports that the map is finished and that BranchWeaver neither loaded
a scene nor granted a reward. **Complete current** stands in for your own gameplay: the package
tracks progression and nothing else. Quick Start saves into memory, so its save is gone once you
leave Play mode.

## Run the Wayfarer sample

### 5. Open Wayfarer and press Play

**Tools > BranchWeaver > Open Wayfarer Sample**, then press Play.

A fifteen-node map across seven layers, one to three nodes wide, built from six node types:
Path, Haven, Crossing, Archive, Observatory, and Summit. Three zones restrict which types may
appear where:
`wayfarer.zone.shore` covers the first three layers, `wayfarer.zone.highlands` the next two, and
`wayfarer.zone.peak` the last two. Summit is permitted only in the peak zone, so it can never
turn up early.

### 6. Press Next seed and watch what survives

Its blueprint is hybrid rather than fully procedural. Four landmarks, `wayfarer.harbor`,
`wayfarer.trailhead`, `wayfarer.observatory`, and `wayfarer.summit`, are authored by hand with
pinned identity, and the generator fills in everything around them. Press **Next seed** and
those four keep their IDs while the rest of the map changes.

### 7. Swap the presenter and the theme

Wayfarer adds two buttons Quick Start does not have.

| Button | Effect |
| --- | --- |
| **Canvas / World** | Swaps the screen-space Canvas presenter for the in-scene World2D one, showing the same graph and the same progress |
| **Orientation** | Swaps the vertical theme for the horizontal one, which also changes routes from curves to polylines |

Neither button touches the graph. The presenter decides how a map is drawn and the theme decides
how it is laid out; your progress through it is unaffected either way. See
[Style, theme, and the presenter boundary](../explanation/style-and-theme.md). Wayfarer also
writes real files, under `BranchWeaverSamples/Wayfarer` inside Unity's
`Application.persistentDataPath`, so its save survives leaving Play mode.

## Controls

Both samples read Unity's legacy `Input` class, which is what `MapInputController` falls back to
when no other source is bound.

=== "Mouse"

    | Action | Input |
    | --- | --- |
    | Select a node | Left click |
    | Pan | Middle-button drag |
    | Zoom | Scroll wheel |

=== "Keyboard and gamepad"

    | Action | Input |
    | --- | --- |
    | Move focus | The **Horizontal** and **Vertical** axes: arrow keys, `WASD`, or the left stick |
    | Enter the focused node | `Return`, `Space`, or the **Submit** button |

    Holding a direction moves focus once, waits 0.35 seconds, then steps every 0.12 seconds.

=== "Touch"

    | Action | Input |
    | --- | --- |
    | Select a node | Tap. Moving more than 12 pixels pans instead of selecting |
    | Pan | One-finger drag, or two fingers moving together |
    | Zoom | Two-finger pinch |

    Taps are ignored while a pinch is in progress, so zooming never selects a node by accident.

Zoom is clamped to the active theme's limits: 0.65 to 2.2 in Quick Start, 0.55 to 2.5 in
Wayfarer. Focus survives regeneration and loading: when the node you had focused no longer
exists, focus recovers to a legal node instead of being lost. Full detail in
[Input, focus, and camera framing](../how-to/input-and-navigation.md).

## Next

- **[2. Generate a map in Map Studio](generate-a-map.md)** - write your own rules, reproduce a
  map from its seed, and audit a range of seeds before a player finds a bad one.
- **[3. Create a playable map in one click](create-a-playable-map.md)** - one button builds the
  scene, the assets, and a map you can click, with no code.
- **[Core concepts](../explanation/architecture.md)** - what each stage of the pipeline decides.
