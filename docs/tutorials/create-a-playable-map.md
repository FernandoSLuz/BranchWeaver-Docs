# 3. Create a playable map in one click

One button builds a whole map: the assets, the Canvas or the camera, the host, the traversal
controller, the presenter, input, hit testing, and a small control panel you can press in Play
Mode. You do not need a scene root, a Canvas, an `EventSystem`, or a single asset before you
start, and you do not write any C#.

This is the fastest route from an empty scene to a map you can click.
[4. Add a map to your scene](add-a-map-to-your-scene.md) covers the other direction: fitting a
map into a scene you have already built.

## Starter walkthroughs

These two English recordings cover the starter Canvas path in Unity `6000.3.25f1`: six nodes,
seven edges, and seed `4242`. They use real mouse and keyboard actions on an isolated desktop;
pauses are trimmed, and the English captions are included in the picture. Optional caption
files and transcripts are available below. This is the starter flow,
not Experience Studio and not the optional concept art demos.

<figure class="studio-video">
  <video id="starter-authoring-video" aria-label="Create and configure a starter map" controls preload="metadata" playsinline muted poster="../../assets/images/branchweaver-authoring-neutral-720p.poster.png" aria-describedby="starter-authoring-transcript">
    <source src="../../assets/videos/branchweaver-authoring-neutral-720p.mp4" type="video/mp4">
    <track kind="captions" src="../../assets/videos/branchweaver-authoring-neutral-720p.en.vtt" srclang="en" label="English captions">
    Your browser does not support HTML video. Use the transcript below.
  </video>
  <figcaption>Author the starter map, set seed 4242, adjust the preview, and save the authored scene.</figcaption>
</figure>

<div class="studio-video-controls" aria-label="Authoring playback">
  <button type="button" data-studio-continue="starter-authoring-video" aria-controls="starter-authoring-video">Play full tutorial</button>
</div>
<p class="studio-video-status" data-studio-status="starter-authoring-video" role="status">Choose a step below to watch it on its own, or play the full tutorial.</p>

Use fullscreen to read the Unity controls. Choose a chapter with a mouse or keyboard to
play that step and pause at its end. Use **Continue full tutorial** to keep watching from
that point. The transcript timestamps work the same way.

<details>
  <summary>Choose an authoring step</summary>
<div class="studio-video-controls" aria-label="Starter authoring video chapters">
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="0" data-studio-end="2" data-studio-title="BranchWeaver Map Authoring" aria-controls="starter-authoring-video">0:00 BranchWeaver Map Authoring</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="2" data-studio-end="10" data-studio-title="Create the starter map" aria-controls="starter-authoring-video">0:02 Create the starter map</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="10" data-studio-end="13.467" data-studio-title="Configure the slot and validate" aria-controls="starter-authoring-video">0:10 Configure the slot and validate</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="13.467" data-studio-end="38.067" data-studio-title="Save the authored scene" aria-controls="starter-authoring-video">0:13 Save the authored scene</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="38.067" data-studio-end="75.5" data-studio-title="Reopen the saved scene" aria-controls="starter-authoring-video">0:38 Reopen the saved scene</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="75.5" data-studio-end="109.033" data-studio-title="Open Map Studio" aria-controls="starter-authoring-video">1:15 Open Map Studio</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="109.033" data-studio-end="129.033" data-studio-title="Select Starter Blueprint" aria-controls="starter-authoring-video">1:49 Select Starter Blueprint</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="129.033" data-studio-end="133.48" data-studio-title="Set seed 4242 and regenerate" aria-controls="starter-authoring-video">2:09 Set seed 4242 and regenerate</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="133.48" data-studio-end="148.713" data-studio-title="Select Starter Theme" aria-controls="starter-authoring-video">2:13 Select Starter Theme</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="148.713" data-studio-end="158.38" data-studio-title="Adjust the preview zoom and pan the graph" aria-controls="starter-authoring-video">2:28 Adjust preview zoom and pan</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="158.38" data-studio-end="163.813" data-studio-title="Apply and save" aria-controls="starter-authoring-video">2:38 Apply and save</button>
  <button type="button" data-studio-video="starter-authoring-video" data-studio-time="163.813" data-studio-end="167.8" data-studio-title="Authoring flow complete" aria-controls="starter-authoring-video">2:43 Authoring flow complete</button>
</div>
</details>

<details id="starter-authoring-transcript">
  <summary>Authoring transcript and chapters</summary>
  <ol>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="0" data-studio-end="2" data-studio-title="BranchWeaver Map Authoring" aria-controls="starter-authoring-video">0:00</button> BranchWeaver Map Authoring.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="2" data-studio-end="10" data-studio-title="Create the starter map" aria-controls="starter-authoring-video">0:02</button> Click Create Complete Starter Map. The wizard builds the scene and starter assets.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="10" data-studio-end="13.467" data-studio-title="Configure the slot and validate" aria-controls="starter-authoring-video">0:10</button> Configure the slot and validate. Validation catches setup errors early.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="13.467" data-studio-end="38.067" data-studio-title="Save the authored scene" aria-controls="starter-authoring-video">0:13</button> Save the authored scene. The scene becomes the editable handoff.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="38.067" data-studio-end="75.5" data-studio-title="Reopen the saved scene" aria-controls="starter-authoring-video">0:38</button> Reopen the saved scene. This confirms the authoring result persists.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="75.5" data-studio-end="109.033" data-studio-title="Open Map Studio" aria-controls="starter-authoring-video">1:15</button> Open Map Studio. The editor exposes the map controls.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="109.033" data-studio-end="129.033" data-studio-title="Select Starter Blueprint" aria-controls="starter-authoring-video">1:49</button> Select Starter Blueprint. The picker connects the demo to its source asset.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="129.033" data-studio-end="133.48" data-studio-title="Set seed 4242 and regenerate" aria-controls="starter-authoring-video">2:09</button> Set seed 4242 and regenerate. A fixed seed makes the result repeatable.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="133.48" data-studio-end="148.713" data-studio-title="Select Starter Theme" aria-controls="starter-authoring-video">2:13</button> Select Starter Theme. The theme applies the demo look consistently.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="148.713" data-studio-end="158.38" data-studio-title="Adjust the preview zoom and pan the graph" aria-controls="starter-authoring-video">2:28</button> Adjust the preview zoom, then pan the graph. The overview checks the generated layout.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="158.38" data-studio-end="163.813" data-studio-title="Apply and save" aria-controls="starter-authoring-video">2:38</button> Apply and save. This records the authored map for reuse.</li>
    <li><button type="button" data-studio-video="starter-authoring-video" data-studio-time="163.813" data-studio-end="167.8" data-studio-title="Authoring flow complete" aria-controls="starter-authoring-video">2:43</button> Authoring flow complete.</li>
  </ol>
</details>

<figure class="studio-video">
  <video id="starter-runtime-video" aria-label="Save and restore a route" controls preload="metadata" playsinline muted poster="../../assets/images/branchweaver-runtime-neutral-720p.poster.png" aria-describedby="starter-runtime-transcript">
    <source src="../../assets/videos/branchweaver-runtime-neutral-720p.mp4" type="video/mp4">
    <track kind="captions" src="../../assets/videos/branchweaver-runtime-neutral-720p.en.vtt" srclang="en" label="English captions">
    Your browser does not support HTML video. Use the transcript below.
  </video>
  <figcaption>Run the starter map, save checkpoints, restore the route, and exit Play Mode.</figcaption>
</figure>

<div class="studio-video-controls" aria-label="Runtime playback">
  <button type="button" data-studio-continue="starter-runtime-video" aria-controls="starter-runtime-video">Play full tutorial</button>
</div>
<p class="studio-video-status" data-studio-status="starter-runtime-video" role="status">Choose a step below to watch it on its own, or play the full tutorial.</p>

<details>
  <summary>Choose a runtime step</summary>
<div class="studio-video-controls" aria-label="Starter runtime video chapters">
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="0" data-studio-end="2" data-studio-title="BranchWeaver Runtime Flow" aria-controls="starter-runtime-video">0:00 BranchWeaver Runtime Flow</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="2" data-studio-end="8" data-studio-title="Start a run and enter the Gateway" aria-controls="starter-runtime-video">0:02 Start a run and enter the Gateway</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="8" data-studio-end="14" data-studio-title="Save and complete the Gateway" aria-controls="starter-runtime-video">0:08 Save and complete the Gateway</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="14" data-studio-end="24" data-studio-title="Focus the available Route" aria-controls="starter-runtime-video">0:14 Focus the available Route</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="24" data-studio-end="30.5" data-studio-title="Enter the selected Route" aria-controls="starter-runtime-video">0:24 Enter the selected Route</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="30.5" data-studio-end="34.3" data-studio-title="Save and complete the Route" aria-controls="starter-runtime-video">0:30 Save and complete the Route</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="34.3" data-studio-end="37.3" data-studio-title="Enter the Landmark" aria-controls="starter-runtime-video">0:34 Enter the Landmark</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="37.3" data-studio-end="42.3" data-studio-title="Load the restored state" aria-controls="starter-runtime-video">0:37 Load the restored state</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="42.3" data-studio-end="46.3" data-studio-title="Save the restored state and exit" aria-controls="starter-runtime-video">0:42 Save the restored state and exit</button>
  <button type="button" data-studio-video="starter-runtime-video" data-studio-time="46.3" data-studio-end="50.3" data-studio-title="Runtime flow complete" aria-controls="starter-runtime-video">0:46 Runtime flow complete</button>
</div>
</details>

<details id="starter-runtime-transcript">
  <summary>Runtime transcript and chapters</summary>
  <ol>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="0" data-studio-end="2" data-studio-title="BranchWeaver Runtime Flow" aria-controls="starter-runtime-video">0:00</button> BranchWeaver Runtime Flow.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="2" data-studio-end="8" data-studio-title="Start a run and enter the Gateway" aria-controls="starter-runtime-video">0:02</button> Start a fresh run and enter the Gateway. This creates the first playable state.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="8" data-studio-end="14" data-studio-title="Save and complete the Gateway" aria-controls="starter-runtime-video">0:08</button> Save the Gateway, then complete it. Saving records progress before traversal continues.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="14" data-studio-end="24" data-studio-title="Focus the available Route" aria-controls="starter-runtime-video">0:14</button> Focus the Game view and press Up. Keyboard focus moves to the available Route.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="24" data-studio-end="30.5" data-studio-title="Enter the selected Route" aria-controls="starter-runtime-video">0:24</button> Press Return to enter the Route. The selected node becomes the current content.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="30.5" data-studio-end="34.3" data-studio-title="Save and complete the Route" aria-controls="starter-runtime-video">0:30</button> Save the Route checkpoint, then complete it. The checkpoint preserves the new progress.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="34.3" data-studio-end="37.3" data-studio-title="Enter the Landmark" aria-controls="starter-runtime-video">0:34</button> Enter the Landmark. The completed Route unlocks its destination.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="37.3" data-studio-end="42.3" data-studio-title="Load the restored state" aria-controls="starter-runtime-video">0:37</button> Load the saved map and route. The HUD shows Route pending, Gateway completed, and Landmark locked.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="42.3" data-studio-end="46.3" data-studio-title="Save the restored state and exit" aria-controls="starter-runtime-video">0:42</button> Save the restored state, then exit Play Mode. The captured runtime flow is complete.</li>
    <li><button type="button" data-studio-video="starter-runtime-video" data-studio-time="46.3" data-studio-end="50.3" data-studio-title="Runtime flow complete" aria-controls="starter-runtime-video">0:46</button> Runtime flow complete.</li>
  </ol>
</details>

<details markdown="1">
<summary>Video files and captions</summary>

- Authoring: [MP4](../assets/videos/branchweaver-authoring-neutral-720p.mp4),
  [English captions](../assets/videos/branchweaver-authoring-neutral-720p.en.vtt),
  [capture receipt](../assets/videos/branchweaver-authoring-neutral-720p.receipt.json).
- Runtime: [MP4](../assets/videos/branchweaver-runtime-neutral-720p.mp4),
  [English captions](../assets/videos/branchweaver-runtime-neutral-720p.en.vtt),
  [capture receipt](../assets/videos/branchweaver-runtime-neutral-720p.receipt.json).

</details>

These recordings use the Canvas starter. The wizard creates its own camera with a neutral
solid-color background; existing camera components keep their settings. The World2D starter
uses its own orthographic camera. Switching the presentation does not change the map graph.

The soundtrack is **Exploration Theme** by Cleyton Kauffman, released under CC0 on
[OpenGameArt](https://opengameart.org/content/exploration-theme), under
[CC0](https://creativecommons.org/publicdomain/zero/1.0/).

## 1. Open the Setup Wizard

**Tools > BranchWeaver > Setup Wizard**. Nothing has to be selected in the Hierarchy, and the
scene can be empty.

<figure markdown>
  ![The BranchWeaver Setup window, with a ticked Canvas Presenter checkbox and a tall Create Complete Starter Map button under the heading Fastest path](../assets/images/setup-wizard-start.png){ .shot }
  <figcaption>The window as it opens. <strong>Create Complete Starter Map</strong> sits under
  <strong>Fastest path</strong> and is the only control this page uses. The validation issue below
  reports that the manual setup path has no scene root; the one-click path does not need one.</figcaption>
</figure>

## 2. Choose Canvas or World2D

**Canvas Presenter** is ticked by default and gives you a screen-space uGUI map that scales
with the window. Untick it for World2D, an in-scene map drawn in front of a camera.

Everything below is the same either way. Running the wizard again with the other setting
rebuilds the presentation for that renderer.

## 3. Press Create Complete Starter Map

The wizard creates a new folder, `Assets/BranchWeaverStarter`, and writes eight assets into
it. If that folder name is taken it uses `BranchWeaverStarter1`, `BranchWeaverStarter2`, and so
on, so pressing the button twice never overwrites the first result.

| Asset | What it holds |
| --- | --- |
| `Route`, `Rest`, `Landmark`, `Gateway` | One node type each, with a stable ID such as `starter.route` and a display label. |
| `Starter Rules` | Four layers holding 1, 2, 2 and 1 nodes; type weights Route 6, Rest 2, Landmark 2, Gateway 1; at most two routes out of and into any node; crossing routes forbidden. |
| `Starter Theme` | Vertical layout, curved routes, layer spacing 150, node spacing 110, zoom clamped to 0.65 - 2.2. |
| `Starter Blueprint` | The rules above, procedural mode, preview seed 20260801. This is what the host generates from. |
| `Starter Content Pool` | Three weighted rows filtered by node type, so every node you enter hands your game a content ID. |

In the scene it then builds the hierarchy, adds the components, points them at each other,
writes the new assets into the host, and validates the result. A save slot is derived from the
folder name, so this map is `branchweaver.branchweaverstarter` and cannot collide with another
map's save.

The whole thing is one undo step named *Create BranchWeaver Playable Map*. If any part of it
fails, the objects and the asset folder are removed again and the validation report at the
bottom of the window says what stopped it. It never installs a package or changes a project
setting.

The status line reports success: *Playable starter created. Enter Play Mode, select a node,
then use the starter controls to complete, save, and load.*

## 4. Look at what you got

The new **BranchWeaver Playable Map** object is selected for you.

<figure markdown>
  ![The Unity Hierarchy after the one-click Canvas build, with the selected BranchWeaver Playable Map root, Event System, Safe Area, Map Content and expanded Starter Controls](../assets/images/completed-scene-hierarchy.png){ .shot }
  <figcaption>The Canvas object tree created in one step. The selected playable-map root owns the
  runtime components; its presentation and removable sample controls are visible below it.</figcaption>
</figure>

=== "Canvas presenter"

    ```text
    BranchWeaver Canvas                     Canvas, CanvasScaler, GraphicRaycaster
      BranchWeaver Canvas Background Camera  neutral solid-color clear
      BranchWeaver Playable Map             the five components below
        BranchWeaver Safe Area              MapSafeAreaController
          BranchWeaver Map Content          CanvasMapPresenter
        BranchWeaver Starter Controls       MapHostStarterPanel
    ```

    A `BranchWeaver Event System` object is added under the map root when the scene has none,
    because keyboard, controller, and pointer navigation need one. A scene that already has an
    `EventSystem` keeps it.

=== "World2D presenter"

    ```text
    BranchWeaver Playable Map               the five components below
      BranchWeaver Camera                   owned orthographic camera, neutral solid-color background
      BranchWeaver World Content            WorldMapPresenter
      BranchWeaver Controls Canvas          Canvas, CanvasScaler, GraphicRaycaster
        BranchWeaver Starter Controls       MapHostStarterPanel
    ```

    The starter controls get their own screen-space Canvas here, since the map itself is not
    drawn on one. A `BranchWeaver Event System` object is added under the map root when the
    scene has none.

Five components go on the root object: `BranchWeaverMapHost`, `MapTraversalController`,
`MapInputController`, `DefaultMapNodeHitTester`, and `MapSetupHierarchyBinding`, which is the
record of what the wizard created and owns.

## 5. Read the host

Select the root and look at **Branch Weaver Map Host**. This is the one component you will
touch again, and every field on it was filled in for you.

<figure markdown>
  ![The Branch Weaver Map Host inspector, grouped into Map with a blueprint and theme, Scene with the traversal controller and presenter, Content routing with a content pool, Persistence with a save slot and folder, and empty Inspector event lists](../assets/images/map-host-inspector.png){ .shot }
  <figcaption>The host holds the recipe (blueprint, theme, style, seed policy), the scene wiring
  it drives, where node content comes from, and where a run is saved. The event lists at the
  bottom are how your own scripts and buttons hook in later.</figcaption>
</figure>

| Group | What it decides |
| --- | --- |
| **Map** | Which blueprint and theme are compiled, the optional style preset, and whether the seed comes from the blueprint or from **Fixed Seed**. |
| **Scene** | The controller and presenter the host drives, and **Auto Start**: load the save slot on Play, and generate a new map only when there is nothing saved. |
| **Content routing** | The content pool that answers "what is in this node", or your own resolver component. |
| **Persistence** | **Save Adapter Kind** (File by default, written under a folder of your naming inside Unity's persistent data path), and the save slot for this map. |
| **Inspector events** | `Host Ready`, `Content Requested`, `Save Completed`, and `Host Failed`, wired from the inspector like any UnityEvent. |

## 6. Press Play

The map generates and draws itself. Available nodes are bright, locked nodes are dimmed, and
the node you occupy is ringed.

<figure markdown>
  ![The Quick Start sample after one traversal action, with one amber current Route node, two dim locked Route nodes, sample controls and a customer callback message](../assets/images/canvas-runtime-focused-node.png){ .shot }
  <figcaption>This recorded frame is the shipped Quick Start sample and shows the Canvas node
  states after traversal. It illustrates the presenter and state styling, not the exact contents
  of the generated starter panel.</figcaption>
</figure>

1. Click a bright node, or move focus with the arrow keys and press ++enter++.
2. Read the panel. The line beginning **Content requested:** names the content ID the pool chose
   for that node, `starter.encounter` on a Route or Landmark node from the starter set. That ID
   is BranchWeaver telling your game which encounter to open. It does not open anything itself,
   load a scene, or grant a reward.
3. Press **Complete Current**. That stands in for your content finishing, and it unlocks
   whatever the completed node leads to.

## 7. Save, then load

1. Press **Save**. The whole run is written to the slot: the graph, your route through it, the
   selection history, and the content that is active right now.
2. Press **Load**.

<figure markdown>
  ![The Quick Start sample after loading from memory, with the panel confirming an identical complete graph and traversal state and the same amber node current](../assets/images/save-reload-active-content.png){ .shot }
  <figcaption>The sample confirms that the complete graph and traversal state came back from
  memory, with the same node still current.</figcaption>
</figure>

A save that cannot be trusted is refused rather than repaired: a corrupt file, a save written
against a different blueprint, or content that no longer exists all fail closed and report why.
The live run is left alone in every one of those cases.

## 8. Make it yours

The starter panel is ordinary uGUI and is not part of the package's runtime. Delete
**BranchWeaver Starter Controls** whenever you want and drive the host from your own interface
instead: its `Start New`, `Complete Current`, `Save`, and `Load` are public host operations, and
`Content Requested` carries the ID of the thing your game should open.

The assets in `Assets/BranchWeaverStarter` are yours too. Edit the rules to change the shape of
the map, the node types to change what a node means, and the content pool to change what each
node hands you.

!!! tip "Keep the save slot stable once you ship"
    A saved run remembers which blueprint and which content pool produced it. Renaming a
    blueprint recipe or changing a resolver after players have saves is a migration decision,
    not a free edit. Give each map its own slot and leave it alone.

## Next

- **[4. Add a map to your scene](add-a-map-to-your-scene.md)** - the same components, added to a
  scene root you already own, with your own assets.
- **[5. Restyle your map](restyle-your-map.md)** - the starter map draws with the shipped
  default. This is how you make it yours.
- **[Save and load progress](../how-to/save-and-load.md)** - slots, adapters, and what a save
  envelope actually contains.
- **[Drive traversal from code](../how-to/drive-traversal-from-code.md)** - when you are ready
  to replace the starter panel with your own flow.
