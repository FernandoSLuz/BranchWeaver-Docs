# Install the optional Tidebound Landmarks demos

The Tidebound Landmarks packages are a **technical preview candidate** for BranchWeaver. They are
separate from the base product and add presentation assets and demo scenes; they do not change
the Core graph, save schema, or progression rules. Art acceptance and commercial redistribution
clearance are still pending, so treat these packages as local technical material and do not
redistribute them.

The public demo name is **Tidebound Landmarks**. Package IDs, scene filenames, folders and C#
types retain the existing `marcos` / `MarcosDaMare` identifiers shown below so references keep
working.

## Packages and requirements

Install the base BranchWeaver package first. These optional preview packages target Unity
`6000.3.25f1`, the Editor used for their current installation and runtime validation.

| Package | Version | Archive size | Adds |
| --- | --- | ---: | --- |
| `branchweaver.marcos-runtime` | `0.1.0-rc.1` | about 6.6 KB | shared runtime components and scene instructions |
| `branchweaver.marcos-2d` | `0.1.0-rc.1` | about 20.6 MB | generated 2D art and the 2D demo scene |
| `branchweaver.marcos-3d` | `0.1.0-rc.1` | about 27.0 MB | generated 3D art and the 3D demo scene |

The sizes above are compressed `.unitypackage` archive sizes from the manifests. After import,
the 2D and 3D asset payloads occupy about 20.1 MB and 28.1 MB respectively; the shared runtime
payload is about 24.8 KB. The 2D and 3D packages depend on the shared runtime, BranchWeaver, and
Unity's `com.unity.ugui` host package. Rive, DOTween, PrimeTween, Meshy, and other third-party
tools are not required to consume these packages.

## Import the candidate

1. Import and verify the BranchWeaver base package. Keep the base product under
   `Assets/BranchWeaver/`.
2. In Unity, choose **Assets > Import Package > Custom Package** and import
   `branchweaver.marcos-runtime-0.1.0-rc.1.unitypackage` once.
3. Import either or both presentation packages with the same menu:
   `branchweaver.marcos-2d-0.1.0-rc.1.unitypackage` and/or
   `branchweaver.marcos-3d-0.1.0-rc.1.unitypackage`.
4. Before importing each archive, compare its SHA-256 with the matching candidate manifest.
   The current candidate hashes are runtime `d1440e6270cdd2478ea31663eceb01898bab06bc59a15e946c5d203744765207`,
   2D `53067ce3b32d8f42a1042ad3ed07a0d63c6f54912b7d96e067c1c95596279cd9`, and 3D
   `7469904a553b8d72b3fd892280ed582029f74f2897a5ea9345b96c38fd110cf5`.
   The manifests are the source of the package names, versions, hashes, and owned paths.
5. Open one of the scenes for the package you imported. The available scene paths are:

    - `Assets/BranchWeaver/OptionalDemos/MarcosDaMare/Scenes/Marcos2D/Marcos da Mare 2D.unity`
    - `Assets/BranchWeaver/OptionalDemos/MarcosDaMare/Scenes/Marcos3D/Marcos da Mare 3D.unity`

   Enter Play Mode, choose **Porto**, confirm travel, then confirm the visit. The shared runtime
   has no playable scene of its own; it is consumed by one or both presentation packages.

The current candidate was imported into an empty project in Unity `6000.3.25f1`. The base,
shared runtime, 2D, and 3D files and GUIDs matched their manifests, with no missing scripts.
The native runtime checks passed for travel, visit confirmation, return and branch changes,
save restoration, and delayed callbacks. Each optional module was then removed in the order
below; the base remained intact and its runtime tests passed again.

## Native scene preview

These captures show the two optional presentation paths using the current candidate packages.
The frames show GameView after the scene was opened and Play Mode started; those menu actions
precede the recording. The preview documents technical flow and composition.

<figure markdown id="optional-marcos-2d">
  <img class="shot" src="../../assets/images/optional-marcos-2d-scene.png" alt="Native Tidebound Landmarks 2D optional demo scene in Play Mode">
  <figcaption>The installed 2D scene after confirming the Porto visit, with adjacent destinations available.</figcaption>
</figure>

<figure markdown id="optional-marcos-3d">
  <img class="shot" src="../../assets/images/optional-marcos-3d-scene.png" alt="Native Tidebound Landmarks 3D optional demo scene in Play Mode">
  <figcaption>The installed 3D scene after confirming Porto, with Iara on its island and the actor anchor following the map.</figcaption>
</figure>

<figure class="studio-video" id="optional-marcos-video">
  <video id="studio-authoring-video" controls preload="metadata" poster="../../assets/images/optional-marcos-2d-scene.png" aria-describedby="optional-marcos-video-transcript">
    <source src="../../assets/videos/optional-marcos-scene-flow.mp4" type="video/mp4">
    <track kind="captions" src="../../assets/videos/optional-marcos-scene-flow.en.vtt" srclang="en" label="English captions" default>
    Your browser does not support HTML video. Use the transcript below.
  </video>
  <div class="studio-video-controls" aria-label="Video timestamps">
    <button type="button" data-studio-time="0.000">2D scene</button>
    <button type="button" data-studio-time="4.363">2D confirm</button>
    <button type="button" data-studio-time="8.327">2D return</button>
    <button type="button" data-studio-time="9.543">3D scene</button>
    <button type="button" data-studio-time="13.900">3D confirm</button>
    <button type="button" data-studio-time="18.040">3D return</button>
  </div>
  <p class="studio-video-help">Use the player controls or fullscreen view to inspect the native
  scene flow. The recording uses the Submit command for confirmation; it does not demonstrate
  physical touch or gamepad input.</p>
  <details id="optional-marcos-video-transcript">
    <summary>Accessible transcript and chapters</summary>
    <ol>
      <li>0:00 — 2D: The installed scene has auto-started in Play Mode with Porto focused.</li>
      <li>0:01 — 2D: Porto is entered through the visible Submit button; the actor plays its skill and effect.</li>
      <li>0:04 — 2D: The visit is confirmed and adjacent destinations remain available.</li>
      <li>0:05 — 2D: Travel to a neighbouring location; the actor plays its skill there.</li>
      <li>0:08 — 2D: Return to Porto along the existing link. Its completed content does not repeat.</li>
      <li>0:09 — 3D: The installed scene has auto-started in Play Mode with Porto focused.</li>
      <li>0:10 — 3D: Porto is entered through the visible Submit button; the actor plays its skill and effect.</li>
      <li>0:13 — 3D: The visit is confirmed and adjacent destinations remain available.</li>
      <li>0:14 — 3D: Travel to a neighbouring location; the actor plays its skill there.</li>
      <li>0:18 — 3D: Return to Porto along the existing link. Its completed content does not repeat.</li>
    </ol>
  </details>
</figure>

The silent recording uses native GameView frames and measured frame timestamps. Captions describe
the visible actions. See the [technical media receipt](../assets/videos/optional-marcos-scene-flow.receipt.json)
for capture scope and hashes.

## Adapt the presentation without editing package code

The demo scene is an example host. Its map data and progression remain owned by BranchWeaver;
the optional package supplies the presentation and connects example content to the host.

### Replace art and presentation settings

1. Select the demo preset in Unity's **Project** window and use **Edit > Duplicate** (Ctrl+D).
   Assign the copy in Experience Studio before making a project-specific variant. The copy
   retains shared asset references; duplicate a theme, style or blueprint separately before
   changing that referenced asset. See the [preset-copy walkthrough](../tutorials/experience-studio.md#make-a-project-specific-preset-copy).
2. In the preset's **Style** and **Asset Mappings**, replace node icons and node prefabs. In your
   copy of the demo prefab, replace background sprites, actor prefabs, materials, Animator clips,
   and state effects with project-owned assets.
3. Keep the node type and stable node ID mappings when the visual change should preserve the same
   map. For 3D, adjust the presentation camera, lighting, prefab scale, and
   `OptionalMarcosActorAnchor` in the demo prefab; the layout graph remains the source of
   destinations. Change the anchor's serialized **Offset** (`offset`) to adjust where it stands,
   or pass `localOffset` to `Configure`; moving an anchored actor's Transform alone is overwritten
   by the anchor. `fixedNodeId` pins an actor to a stable node ID, while an empty value follows the
   host's current node.
4. Use the Inspector event components on the example actors to connect your own UI or gameplay
   callbacks. Keep presentation-only callbacks in the optional layer and keep game-owned rewards
   in the host game.

The 2D and 3D packages do not promise automatic conversion between prefabs and UXML. Replace the
assets in the renderer that you selected, then preview the result in that renderer.

### Connect game-owned visit content

The example visit component listens for the host's content request, captures the active visit
token, plays the configured idle/skill presentation, and exposes an Inspector completion event.
`CompletePendingVisit()` confirms only the captured token. A delayed callback is ignored after the
host moves to another visit, so the component cannot complete a later visit accidentally.

Use `MarcosVisitDemo.DemoCompletionEvent` for an Inspector callback (the serialized field is
`demoCompletion`); code can subscribe to the matching `MarcosVisitDemo.DemoCompletion` event.
For one-time rewards, connect your game to `MapExperienceHost.FirstNodeCompleted` or its Inspector
adapter `FirstNodeCompletedEvent`. It fires after the first successful content completion of each
node in the current run, so record any reward in your game's save. The optional component does not
grant rewards, own the save, or change progression. For a revisitable map, the host still decides
whether content repeats and how resume state is stored; the visual layer only reports the
presentation and confirmation result.

### Optional runtime API

The candidate runtime exposes five public types for this presentation module. They are documented
here rather than in the base API reference because the module is versioned and optional.

| Type | Contract used by a host |
| --- | --- |
| `MarcosVisitDemo` | Presentation component. Use `Configure(MapExperienceHost, Animator, Animator, string, string, string, float, bool, string)`, `ConfigureFeedback(AudioSource, AudioClip, float)`, `CompletePendingVisit()`, `IsPending`, `Status`, `PendingToken`, `DemoCompletion`, and `DemoCompletionEvent`. Completion accepts only the captured visit token. |
| `MarcosVisitDemoStatus` | Status values: `Idle`, `PlayingSkill`, `AwaitingConfirmation`, and `Completed`. |
| `MarcosVisitDemoCompletionEvent` | Serializable parameterless `UnityEvent` exposed through `DemoCompletionEvent` for Inspector callbacks. |
| `OptionalMarcosActorAnchor` | Follows the current or `fixedNodeId` node. `Configure(MapExperienceHost, Transform, float, bool, string, Vector3, float)` sets the presentation root, 2D/3D projection, node pin, offset, and smoothing. |
| `MarcosParticleFeedback` | Token-gated particle burst. `Configure(MapExperienceHost, ParticleSystem, string)` assigns the host, particle system, and optional node filter. |

These components own presentation feedback only. `MapExperienceHost` remains responsible for graph,
progression, save, and content completion. The game remains responsible for its rewards.

## Remove an optional demo

Remove only the optional roots and preserve the base product and your own assets:

1. Close the optional demo scene and any scene that references its prefabs.
2. Remove the selected demo's `Scenes/Marcos2D` folder, then its `Art2D` folder; for the 3D demo,
   remove `Scenes/Marcos3D`, then `Art3D`.
3. After both demos and any project-owned consumers of their shared components are removed,
   remove `Runtime` and `Scenes/Readme`. Remove the empty `MarcosDaMare` and `OptionalDemos`
   folders only when no other optional modules use them.
4. Never delete `Assets/BranchWeaver/` or the base package while removing an optional demo.
   Preserve project-owned assets, scenes, and saves.

## Candidate status

These packages are technical candidates for the current Unity 6000.3.25f1 workflow. The preview
does not constitute art approval, source or license clearance, a cross-version compatibility
claim, or a performance/platform result. Recheck the package
manifests and the release notes before using a later candidate.
