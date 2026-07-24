# Framing, input and navigation

9 types in this area.

!!! abstract "On this page"
    [InputSystemMapInputBridge](#inputsystemmapinputbridge) &middot; [MapAspectClass](#mapaspectclass) &middot; [MapFrameResult](#mapframeresult) &middot; [MapFrameUtility](#mapframeutility) &middot; [MapSafeAreaController](#mapsafeareacontroller) &middot; [MapViewportFrame](#mapviewportframe) &middot; [MapViewportResult](#mapviewportresult) &middot; [MapViewportUtility](#mapviewportutility) &middot; [MapWorldViewportUtility](#mapworldviewportutility)

## InputSystemMapInputBridge

```csharp
public sealed class InputSystemMapInputBridge : MonoBehaviour
```

`BranchWeaver.Integrations.InputSystem` &middot; <small>Runtime/Integrations/InputSystem/InputSystemMapInputBridge.cs</small>

Optional PlayerInput UnityEvent bridge compiled only when com.unity.inputsystem is installed.

**Properties**

`public InputSystemSignalAdapter Signals`

:   &mdash;

**Methods**

`public void Bind(InputSystemSignalAdapter adapter)`

:   &mdash;

`public void OnNavigate(InputAction.CallbackContext context)`

:   &mdash;

`public void OnPan(InputAction.CallbackContext context)`

:   &mdash;

`public void OnPinch(InputAction.CallbackContext context)`

:   &mdash;

`public void OnPointer(InputAction.CallbackContext context)`

:   &mdash;

`public void OnPointerPress(InputAction.CallbackContext context)`

:   &mdash;

`public void OnSubmit(InputAction.CallbackContext context)`

:   &mdash;

`public void OnZoom(InputAction.CallbackContext context)`

:   &mdash;

`public void SignalNavigatePhase(bool performed, bool canceled, Vector2 value)`

:   &mdash;

`public void SignalPanPhase(bool performed, Vector2 value)`

:   &mdash;

`public void SignalPinchPhase(bool performed, bool canceled, float scale)`

:   &mdash;

`public void SignalPointerPhase(bool performed, Vector2 value)`

:   &mdash;

`public void SignalZoomPhase(bool performed, float value)`

:   &mdash;

---

## MapAspectClass

```csharp
public enum MapAspectClass
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewport.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

| Value | Meaning |
| --- | --- |
| `Invalid` | &mdash; |
| `FourByThree` | &mdash; |
| `SixteenByTen` | &mdash; |
| `SixteenByNine` | &mdash; |
| `Ultrawide` | &mdash; |
| `TallMobile` | &mdash; |
| `Other` | &mdash; |

---

## MapFrameResult

```csharp
public readonly struct MapFrameResult
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewportFrame.cs</small>

The resolved on-screen placement of a map: the rectangle it may occupy, the
scale that fits its content into that rectangle, and the pan limits that
keep it reachable.

**Constructors**

`public MapFrameResult()`

:   &mdash;

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

## MapFrameUtility

```csharp
public static class MapFrameUtility
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewportFrame.cs</small>

Pure framing maths, separated from the component so it can be tested
without a scene, a canvas, or a device.

**Methods**

`public static MapFrameResult Resolve()`

:   Resolves the area, scale, and pan limits for a map. `availablePixels` is the full rectangle the map is allowed to consider, normally the canvas rect or the screen. `safeAreaPixels` is the device safe area in the same space; pass the full rectangle when there is none.

---

## MapSafeAreaController

```csharp
public sealed class MapSafeAreaController : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewport.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Properties**

`public MapViewportResult Current`

:   &mdash;

**Methods**

`public bool Apply(int screenWidth, int screenHeight, Rect safeAreaPixels)`

:   &mdash;

---

## MapViewportFrame

```csharp
public sealed class MapViewportFrame : MonoBehaviour
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewportFrame.cs</small>

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

:   Player zoom multiplier over the fitted scale.

**Methods**

`public void Apply()`

:   Recomputes and applies the framing.

`public bool FocusOn(BranchWeaver.Core.StableId nodeId)`

:   Centres the view on a node without changing zoom, clamped so the map cannot be pushed out of reach.

`public void FrameAll()`

:   Resets zoom and pan so the whole map is framed again.

---

## MapViewportResult

```csharp
public readonly struct MapViewportResult
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewport.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Constructors**

`public MapViewportResult(bool valid, Rect normalizedSafeArea, MapAspectClass aspectClass)`

:   &mdash;

**Properties**

`public MapAspectClass AspectClass`

:   &mdash;

`public bool IsValid`

:   &mdash;

`public Rect NormalizedSafeArea`

:   &mdash;

---

## MapViewportUtility

```csharp
public static class MapViewportUtility
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapViewport.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static MapAspectClass Classify(int width, int height)`

:   &mdash;

`public static MapViewportResult Evaluate(int screenWidth, int screenHeight, Rect safeAreaPixels)`

:   &mdash;

---

## MapWorldViewportUtility

```csharp
public static class MapWorldViewportUtility
```

`BranchWeaver.Runtime` &middot; <small>Runtime/Runtime/MapWorldViewportUtility.cs</small>

!!! warning "Not yet documented"
    This type has no summary comment in the source. Its name and signature are accurate; the description is missing.

**Methods**

`public static Rect Intersect(Rect first, Rect second)`

:   &mdash;

`public static bool TryGetPresentationBounds(Camera camera, Transform contentParent, Rect safeAreaPixels,)`

:   &mdash;

---

