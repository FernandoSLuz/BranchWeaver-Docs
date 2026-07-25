# Input, focus, and camera framing

A wired map answers a mouse, a keyboard, a gamepad, and a touchscreen with no code from you.
This page names the bindings, explains how focus moves and recovers, and shows how to pan,
zoom, and reframe the map from your own scripts.

## The built-in input source

`MapInputController`, which the [Setup Wizard](../tutorials/add-a-map-to-your-scene.md) puts
on the setup root, reads one input frame per `Update` and turns it into focus moves, selection
requests, pan, and zoom. It picks its source in this order: a source you passed to
`SetSource`, the `InputSystemSignalAdapter` serialized on the component, then Unity's legacy
`Input` class. A scene with nothing wired therefore still walks with a mouse and a keyboard.

| Action | Mouse and keyboard | Touch |
| --- | --- | --- |
| Select a node | Left click, or `Return`, `Space`, or **Submit** on the focused node | Tap |
| Move focus | The **Horizontal** and **Vertical** axes | — |
| Pan | Middle-button drag | One-finger drag, or two fingers moving together |
| Zoom | Scroll wheel | Two-finger pinch |

A tap selects only while the finger stays within 12 pixels of where it went down; beyond that
it pans instead. Taps are ignored while a pinch is in progress, and after one finger of a
pinch lifts, the finger left down neither pans nor selects until it lifts too. Zooming
therefore cannot enter a node by accident.

Selection hit-tests the node views themselves, topmost first. Nodes hidden by fog and nodes
whose graphic or renderer is disabled are skipped, which is why revealing a node is all it
takes to make it clickable — see [Control what the player can see](reveal-and-fog.md). If a
click does nothing, work through
[Troubleshooting](troubleshooting.md#clicking-a-node-does-nothing).

## Focus and directional navigation

Focus is the keyboard and gamepad cursor: one node, drawn with the style's focus ring, and the
node **Submit** enters. `MapInputController.FocusChanged` reports every change, and the
presenter is told at the same time so the ring follows without extra wiring.

### How a direction resolves

An axis reading below 0.5 counts as no direction at all, and the larger of the two axes wins,
so a diagonal stick never moves focus twice. From the focused node the map picks the nearest
visible node lying in that direction, breaking a tie by the smaller sideways offset and then
by node ID — which makes the same press move the same way every run.

Holding a direction moves focus once, waits 0.35 seconds, then steps every 0.12 seconds.
`ConfigureNavigationRepeat(initialDelaySeconds, intervalSeconds)` changes both at runtime.
When the new focus would sit outside the viewport, the map pans just far enough to bring it
back inside, then clamps that pan like any other.

!!! note "Directions are layout directions"
    Navigation compares the graph's layout positions, and the style's `FlowDirection` is
    applied later, when positions are drawn. With `TopToBottom` the layout's up is the
    screen's down, so **Up** walks the map toward its start.

### Focus recovery

Focus never points at something the player cannot see. It is re-resolved before each frame is
processed, so after a regeneration, a load, or a change of fog it lands on the first of these
that is visible: the node already focused, the current node, an available node, a visited
node, any node at all. Only a map with nothing visible clears focus.

## Pan, zoom, and framing from code

`MapInputController.Pan` and `Zoom` are the live player view, read-only from outside because
both are clamped as they change. Zoom stays between the active theme's **Minimum Zoom** and
**Maximum Zoom** — 0.5 and 2.5 on a new theme asset — and is anchored: the point under the
pointer stays put, or the focused node does when there is no pointer. Pan is clamped so
content cannot be dragged out of reach. **Pan Sensitivity** (1) and **Zoom Sensitivity** (0.2)
scale the incoming deltas.

Deliberate framing is a separate component. Add **BranchWeaver > Map Viewport Frame** to the
map hierarchy and the rect it sits on becomes the area the map may use.

```csharp
[SerializeField] private MapViewportFrame frame;

frame.FrameAll();                     // reset pan and zoom, refit the whole map
frame.FocusOn(nodeId);                // centre a node; false when it has no position
frame.Zoom = 1.5f;                    // 1.5x the fitted scale, clamped to 0.5-2.5
frame.Pan = new Vector2(-120f, 40f);  // pixels, clamped on assignment
```

`frame.Frame` exposes what was resolved — the area in pixels, the fitted scale, the content
size, and the pan limits — which is the value to log when a map lands somewhere unexpected.
Margins, fit mode, padding, and the pan limits come from the assigned style, so placement is
edited in a style asset rather than by dragging transforms:
[Place the map on screen](place-the-map-on-screen.md).

!!! warning "One owner per content rect"
    The frame and the input controller both write the content rect's scale and position, so a
    rect driven by both will fight on the frame's next refit. The style's `AllowPan` and
    `AllowZoom` gate the frame, not the input controller: to stop the player moving a map that
    `MapInputController` drives, disable that component or bind a source that reports no pan
    or zoom.

## The optional Input System bridge

Both input backends are supported. `InputSystemSignalAdapter` ships in `BranchWeaver.Runtime`
and is an input source in its own right: call `SignalNavigate`, `SignalSubmit`,
`SignalPointer`, `SignalPointerPress`, `SignalPan`, `SignalZoom`, `SignalPinch`, or
`EndPinch` from anything at all, and the controller reads the result on its next frame. A
pinch cancels any press in the same frame, so the touch guarantee above holds here too.

`InputSystemMapInputBridge` is the convenience layer for `PlayerInput` UnityEvents, with one
handler per action: `OnNavigate`, `OnSubmit`, `OnPointer`, `OnPointerPress`, `OnPan`, `OnZoom`,
and `OnPinch`. It lives in its own assembly, `BranchWeaver.Integrations.InputSystem`, which
compiles only when `com.unity.inputsystem` 1.0.0 or newer is installed, so a project without
that package is never broken by it. Turning on **Optional Input System** in the Setup Wizard
adds the adapter and the bridge and binds them to the controller; turning it off removes both.

## Drive selection from your own input

To replace the bindings wholesale, implement `IMapInputSource` and hand it over once.

```csharp
public sealed class PadMapInput : MonoBehaviour, IMapInputSource
{
    [SerializeField] private MapInputController input;

    private void OnEnable() => input.SetSource(this);

    // The last argument is hasPointerPosition: false anchors zoom on the focused node.
    public MapInputFrame Capture() => new MapInputFrame(
        ReadStick(), ReadConfirm(), Vector2.zero, false, Vector2.zero, 0f, false, false);
}
```

For one-off moves, skip input entirely. `map.RequestNodeSelection(nodeId)` is exactly what a
click does, legality included, and
`input.Navigation.TrySetFocus(nodeId, map.GetRuntimeState())` moves focus without entering
anything — it refuses a hidden node, which is why it takes the runtime state.

## Next

- **[Place the map on screen](place-the-map-on-screen.md)** — the framing tokens the viewport
  frame reads: direction, fit mode, margins, and the pan and zoom limits.
- **[Drive traversal from code](drive-traversal-from-code.md)** — what happens after a
  selection request: events, progression state, and completing a node.
- **[Framing, input, and navigation reference](../reference/framing-input-and-navigation.md)**
  — the full signatures.
