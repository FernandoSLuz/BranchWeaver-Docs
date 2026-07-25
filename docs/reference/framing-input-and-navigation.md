# Framing, input and navigation

6 types in this area.

!!! abstract "On this page"
    [InputSystemMapInputBridge](#inputsystemmapinputbridge) &middot; [MapAspectClass](#mapaspectclass) &middot; [MapFrameResult](#mapframeresult) &middot; [MapSafeAreaController](#mapsafeareacontroller) &middot; [MapViewportFrame](#mapviewportframe) &middot; [MapViewportResult](#mapviewportresult)

## InputSystemMapInputBridge

```csharp
public sealed class InputSystemMapInputBridge : MonoBehaviour
```

`BranchWeaver.Integrations.InputSystem` &middot; <small>BranchWeaver/Runtime/Integrations/InputSystem/InputSystemMapInputBridge.cs</small>

Optional PlayerInput UnityEvent bridge compiled only when com.unity.inputsystem is installed.

**Properties**

`public InputSystemSignalAdapter Signals`

:   The adapter this bridge posts to, as assigned in the inspector or through `Bind`. It can read null on a bridge that works perfectly well: nothing is resolved until the first signal arrives, at which point the bridge looks for an adapter on this GameObject and adds one if there is none. A caller that needs the adapter before any input has happened should assign it rather than wait for this to become non-null.

**Methods**

`public void Bind(InputSystemSignalAdapter adapter)`

:   Points the bridge at an adapter from code, for a rig assembled at runtime rather than wired in the inspector.
    - `adapter` &mdash; The adapter to post to. Null puts the bridge back to resolving one from this GameObject when the next signal arrives.

`public void OnNavigate(InputAction.CallbackContext context)`

:   Handler for the directional action: it posts the stick or D-pad vector while the action is performed, and a zero vector when it is cancelled. The zero on cancel is what stops a released stick from walking the focus onward, because the adapter holds the last axis it was given until told otherwise. Wire this to the action's UnityEvent on `PlayerInput`.
    - `context` &mdash; The context PlayerInput supplies. Only the performed and cancelled phases are acted on; the value is read as a `Vector2`.

`public void OnPan(InputAction.CallbackContext context)`

:   Handler for dragging the map about, posting the action's value as a pan movement. Bind it to an action that reports movement per event. Deltas are accumulated until the next frame is captured, so an action that reports an absolute pointer position instead would pan the map by that whole position on every event.
    - `context` &mdash; The context PlayerInput supplies. Read as a `Vector2` delta in the performed phase.

`public void OnPinch(InputAction.CallbackContext context)`

:   Handler for a two-finger pinch: the action's value is read as a scale factor while the gesture is performed, and the gesture is ended when it is cancelled. Ending it matters. While a pinch is marked active the adapter refuses pointer presses, so an action that never reaches its cancelled phase leaves the map ignoring taps for good.
    - `context` &mdash; The context PlayerInput supplies. Read as a scale factor in the performed phase; 1 leaves the zoom alone.

`public void OnPointer(InputAction.CallbackContext context)`

:   Handler for the pointer position, in screen pixels. Position only: moving the pointer over a node never selects it, which is what `OnPointerPress` is for.
    - `context` &mdash; The context PlayerInput supplies. Read as a `Vector2` in the performed phase and ignored otherwise.

`public void OnPointerPress(InputAction.CallbackContext context)`

:   Handler for a click or tap on the map, acted on in the performed phase. The press is only queued here; the map decides what it hit when the next input frame is captured. The adapter drops it while a pinch is running, so a second finger landing on a node cannot select it.
    - `context` &mdash; The context PlayerInput supplies; its value is not read.

`public void OnSubmit(InputAction.CallbackContext context)`

:   Handler for activating the focused node. Only the performed phase counts, so the same press is not acted on again when the action starts and when it is released. The request is queued for the next captured frame rather than sent straight to the map.
    - `context` &mdash; The context PlayerInput supplies; its value is not read.

`public void OnZoom(InputAction.CallbackContext context)`

:   Handler for a scroll wheel or zoom axis. The action's value is added to the zoom accumulated for the next captured frame, so several events between frames add up rather than replacing one another.
    - `context` &mdash; The context PlayerInput supplies. Read as a `float` delta in the performed phase.

`public void SignalNavigatePhase(bool performed, bool canceled, Vector2 value)`

:   The phase-only form of `OnNavigate`, on the same terms as `SignalPinchPhase`. Cancellation wins over performed and posts a zero axis rather than nothing, because the adapter holds the last axis it was given until it is told the control was released.
    - `performed` &mdash; True while the control is held at `value`.
    - `canceled` &mdash; True when the control has been released.
    - `value` &mdash; The directional axis. Ignored unless `performed` is the only flag set.

`public void SignalPanPhase(bool performed, Vector2 value)`

:   The phase-only form of `OnPan`. The value is added to the pan accumulated for the next captured frame, so it has to be movement for this event and never an absolute position.
    - `performed` &mdash; True when `value` carries a new delta; nothing is posted otherwise.
    - `value` &mdash; How far the map should move for this event.

`public void SignalPinchPhase(bool performed, bool canceled, float scale)`

:   The phase-only form of `OnPinch`, for a caller that already knows where the gesture is up to - a custom recognizer, a touch layer of your own, a test - and has no `InputAction.CallbackContext` to hand over. Cancellation wins when both flags are set, so a gesture that ends in the same call it reports a scale still ends.
    - `performed` &mdash; True while the gesture is producing a new scale.
    - `canceled` &mdash; True when the gesture has finished, which lets pointer presses through again.
    - `scale` &mdash; Scale factor for this event: 1 leaves the zoom alone, 1.1 zooms in a tenth. Ignored unless `performed` is the only flag set.

`public void SignalPointerPhase(bool performed, Vector2 value)`

:   The phase-only form of `OnPointer`. Nothing is posted unless the value is fresh, so a caller can call it unconditionally without the map acting on a stale position.
    - `performed` &mdash; True when `value` carries a new pointer position.
    - `value` &mdash; Pointer position in screen pixels.

`public void SignalZoomPhase(bool performed, float value)`

:   The phase-only form of `OnZoom`, adding to the zoom accumulated for the next captured frame. Unlike `SignalPinchPhase` this takes a plain delta rather than a scale factor, so zero means no change.
    - `performed` &mdash; True when `value` carries a new delta; nothing is posted otherwise.
    - `value` &mdash; How far to zoom for this event.

---

## MapAspectClass

```csharp
public enum MapAspectClass
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapViewport.cs</small>

Coarse bucket for a screen's shape, so framing and layout can be chosen per display class
instead of per resolution. The ratio measured is always the long side over the short side,
which is why the three named buckets match in either orientation; the two extreme buckets
then split by orientation.

| Value | Meaning |
| --- | --- |
| `Invalid` | No usable classification: a width or height that was not positive. |
| `FourByThree` | Within 0.035 of 4:3, in either orientation. |
| `SixteenByTen` | Within 0.035 of 16:10, in either orientation. |
| `SixteenByNine` | Within 0.035 of 16:9, in either orientation. |
| `Ultrawide` | Landscape with a long-to-short ratio of 2.2 or wider. |
| `TallMobile` | Portrait with a long-to-short ratio of 2.0 or taller. |
| `Other` | A usable screen size that matched none of the buckets above. |

---

## MapFrameResult

```csharp
public readonly struct MapFrameResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapViewportFrame.cs</small>

The resolved on-screen placement of a map: the rectangle it may occupy, the
scale that fits its content into that rectangle, and the pan limits that
keep it reachable.

**Constructors**

`public MapFrameResult()`

:   Captures an already-resolved framing. Normally read from `MapViewportFrame.Frame` rather than constructed by hand; nothing here is validated or clamped.

**Properties**

`public Rect AreaPixels`

:   The rectangle the map may draw into, in pixels.

`public Vector2 ContentSizePixels`

:   The map content size in pixels before scaling.

`public bool IsValid`

:   False when the inputs could not produce a usable rectangle.

`public Vector2 MaximumPan`

:   Highest allowed pan offset, in pixels.

`public Vector2 MinimumPan`

:   Lowest allowed pan offset, in pixels.

`public float Scale`

:   The scale that fits the content into the area.

**Methods**

`public Vector2 ClampPan(Vector2 pan)`

:   Clamps a pan offset into the allowed range.

---

## MapSafeAreaController

```csharp
public sealed class MapSafeAreaController : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapViewport.cs</small>

Keeps the RectTransform it sits on inside the device safe area, so notches, rounded corners,
and gesture bars never cover the map. Attach it to the RectTransform that parents the map UI.

It re-applies itself when enabled and again whenever the screen size or the reported safe area
changes, driving that transform's anchors and zeroing its offsets. Because it owns those four
values, nothing else should animate or author them on the same transform; put your own layout
on a child instead.

**Properties**

`public MapViewportResult Current`

:   The measurement currently in force. A failed `Apply` leaves this untouched, so it always describes the layout the transform is actually in; before the first successful apply it is a default result whose `MapViewportResult.IsValid` is false.

**Methods**

`public bool Apply(int screenWidth, int screenHeight, Rect safeAreaPixels)`

:   Measures a screen size and safe area and, when the measurement is usable, stretches this RectTransform to it. Called for you on enable and when the screen metrics change; call it yourself only to drive the component from values of your own, such as in a test.
    - `screenWidth` &mdash; Screen width in pixels. Zero or less makes the call fail.
    - `screenHeight` &mdash; Screen height in pixels. Zero or less makes the call fail.
    - `safeAreaPixels` &mdash; Safe area in the same pixel space as UnityEngine.Screen.safeArea, which is what the automatic calls pass. An inverted rect makes the call fail.
    - **Returns** &mdash; True when the transform and `Current` were updated. False when the inputs did not measure, and then nothing at all is changed.

---

## MapViewportFrame

```csharp
public sealed class MapViewportFrame : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapViewportFrame.cs</small>

Places a map on screen: reserves margins for your own interface, fits the
content, insets into the device safe area, and clamps pan and zoom.

Before this existed the map filled whatever rect it was parented to, so a
buyer had no supported way to reserve screen space or keep a large map
reachable on a phone. Every value here is presentation-only: moving,
scaling, or panning the map cannot change a generated graph, a save
envelope, or a fingerprint.

Attach to the same object as a presenter's content rect. Framing values come
from the assigned style, so a designer adjusts the map by editing a style
asset rather than by hand-positioning transforms.

**Properties**

`public MapFrameResult Frame`

:   The framing most recently resolved and applied.

`public Vector2 Pan`

:   Player pan offset in pixels, clamped to the resolved limits.

`public float Zoom`

:   Player zoom multiplier over the fitted scale. Assigning it reframes immediately; a value of zero or less is stored as 1.

**Methods**

`public void Apply()`

:   Recomputes and applies the framing. Already runs on enable and whenever the screen size or device safe area changes, so call it only after changing the presenter's style or content size from code.

`public bool FocusOn(BranchWeaver.Core.StableId nodeId)`

:   Centres the view on a node without changing zoom, clamped so the map cannot be pushed out of reach.
    - `nodeId` &mdash; The node to centre on. It must be present in the presenter's current layout.
    - **Returns** &mdash; True when the pan was updated and the framing reapplied. False, leaving the view untouched, when no presenter is assigned or found in the parents, or when that presenter has no presentation position for the node yet.

`public void FrameAll()`

:   Resets zoom and pan so the whole map is framed again.

---

## MapViewportResult

```csharp
public readonly struct MapViewportResult
```

`BranchWeaver.Runtime` &middot; <small>BranchWeaver/Runtime/Runtime/MapViewport.cs</small>

The outcome of measuring one screen: whether the measurement succeeded, the safe area as
fractions of the screen, and the aspect bucket. Test `IsValid` first - when it is
false the other two members hold an empty rect and `MapAspectClass.Invalid`
rather than a usable fallback.

**Constructors**

`public MapViewportResult(bool valid, Rect normalizedSafeArea, MapAspectClass aspectClass)`

:   Creates a result. No relationship between the three values is enforced here.
    - `valid` &mdash; Whether the measurement produced usable values.
    - `normalizedSafeArea` &mdash; Safe area as fractions of the screen, not pixels.

**Properties**

`public MapAspectClass AspectClass`

:   The bucket this screen's shape falls into, measured as the long side over the short side. Because that ratio ignores which way round the screen is, a portrait and a landscape display of the same proportions share one bucket; only `MapAspectClass.Ultrawide` and `MapAspectClass.TallMobile` tell the two orientations apart. A default value and every result this package measures pair a false `IsValid` with `MapAspectClass.Invalid`, but the constructor enforces no link between the two, so branch on the bucket only once you have checked `IsValid` yourself.

`public bool IsValid`

:   Whether the screen size and safe area could be measured. False means the other members carry nothing usable, so treat the result as a no-op rather than as a layout to apply.

`public Rect NormalizedSafeArea`

:   The safe area in normalized screen space, ready to assign to a RectTransform's anchors: every edge is a 0-1 fraction of the screen rather than a pixel count. As measured by this package the edges are clamped into 0-1 and rounded to four decimals, so two screens of the same size always yield the same rect.

---

