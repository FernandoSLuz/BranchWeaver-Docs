# Create node types

A node type is a *kind of place* on the map: Rest, Combat, Gateway, Summit. It owns the
node's identity, its colour in each state, the label the player reads, and the data your game
acts on when the player arrives.

## Create the asset

**Assets > Create > BranchWeaver > Node Type**.

| Field | What it does |
| --- | --- |
| **Stable Id** | Required and unique. Renaming the asset does not change it &mdash; see [core concepts](../explanation/architecture.md#stable-ids-are-a-compatibility-contract) |
| **Display Label** | The label shown when no localisation resolves |
| **Localization Key** | Optional key handed to your localisation adapter |
| **Tooltip** | Fallback explanatory text, localised alongside the label |
| **Icon** | Optional sprite, drawn inset inside the node shape |
| **Canvas Prefab** / **World Prefab** | Optional. Your own art instead of the drawn node |
| **State Colors** | Hidden, Locked, Available, Current, Visited, Completed |
| **Renderer Key** | Optional. Separates pooled views so two types never share one |
| **Enter / Complete Audio Cue Id** | Optional IDs passed to your audio adapter |
| **Default Payload** | An ID plus tagged properties attached to every node of this type |

Every ID field here is a stable ID: lowercase ASCII letters, digits, `.`, `_`, and `-`.
Anything else is rejected when the asset is compiled rather than accepted and then
misbehaving later. The shipped samples use dotted names such as `wayfarer.summit`.

!!! warning "Two assets cannot share a stable ID"
    Compilation reports that distinct node-type assets cannot share one stable ID, and the
    Setup Wizard repeats the check across the whole list it is given. This is an error, not a
    warning, because a save refers to nodes by type ID.

## State colours and how styles present them

The node type owns each state's **identity colour**. The style owns how that colour is
*presented*: brightness, opacity, scale, glow, whether a ring is drawn, whether a label
shows. That split is why you can restyle an entire map without opening a node type, and add a
node type without it looking out of place.

Defaults are a dark neutral grey for `Hidden`, a cool desaturated grey for `Locked`, white
for `Available`, amber for `Current`, pale blue for `Visited`, and green for `Completed`.
White is a useful default: it takes the tint of whatever style is applied instead of fighting
it. Choose your own when a type must be recognisable at a glance under any style.

### Fog dims the colour you chose

Reveal state applies on top of the state colour, not instead of it. A dimmed node draws your
colour at 75% opacity; a hidden node draws it at zero opacity and stops responding to clicks,
so it cannot be selected by accident. Pick colours that read at full strength and let
[reveal and fog](reveal-and-fog.md) handle the rest.

For which state should pull the eye first, see
[Emphasise node states](style-node-states.md).

## Attach payloads

`Default Payload` is how you attach game meaning to a kind of place. A Combat type might
carry `encounter.tier = 2`. BranchWeaver never interprets payloads; they are yours.

### Author the properties

Set **Default Payload Id**, then add rows. Each row is a key plus one tagged value, and only
the field matching the chosen kind is read:

| Kind | Fill in | Notes |
| --- | --- | --- |
| `Boolean` | Numeric Value | `0` or `1` only |
| `Integer` | Numeric Value | Stored as a 64-bit integer |
| `FixedPoint` | Numeric Value | Scaled by 10000, so `1.5` is `15000` |
| `String` | String Value | Leave Numeric Value at `0` |
| `StableId` | Stable Id Value | Must itself be a valid stable ID |

Three rules are enforced at compile time. Keys must be unique within a payload. A payload
with any properties **must** also have a payload ID. Fields that do not belong to the chosen
kind must stay at their defaults, or the value is rejected as non-canonical.

### Read them from code

Properties are a sorted list of key-value pairs and there is no typed getter, so match the key
yourself. A transition event carries the node's ID, so look the node up on the graph to reach
its payload:

```csharp
using BranchWeaver.Core;

private void OnNodeEntered(MapTransitionEvent transition)
{
    MapNode node;
    if (!map.Graph.TryGetNode(transition.NodeId, out node)) return;

    foreach (MapProperty property in node.Payload.Properties)
    {
        if (property.Key.Value != "encounter.tier") continue;
        if (property.Value.Kind == MapPropertyKind.Integer)
            StartEncounter((int)property.Value.NumericValue);
        break;
    }
}
```

Wrap that loop in a helper of your own if you read payloads in more than one place. Wiring the
event up is covered in [Drive traversal from code](drive-traversal-from-code.md).

## Supply your own node art

Assign a **Canvas Prefab** or **World Prefab** to draw the node yourself. The matching factory
instantiates your prefab instead of building one, and pools it separately per prefab. Give the
prefab a component implementing `IMapNodeView` &mdash; `CanvasMapNodeView` or
`WorldMapNodeView` will do; the Setup Wizard reports a prefab without one as an error.

You keep state colours, per-state scale, and transitions. You lose the shader's shape, glow,
and ring, because those belong to the surface graphic your prefab replaced. A prefab carrying
a plain `Image` is honoured rather than overwritten: it receives the node type's icon if one
is authored, and a procedural rounded sprite otherwise.

The wizard also warns when a prefab's material uses a Universal or HDRP shader, since that
prefab then renders only under that pipeline. Everything BranchWeaver draws is neutral.

## Localise labels

Set **Localization Key** on the node type and implement `IMapLocalizationAdapter`, whose only
member is `string Resolve(string key, string fallback)`. Pass your adapter to the presenter's
`Configure(...)` call &mdash; there is no inspector field for it. Leave it out and
`PassthroughLocalizationAdapter` is used, which returns the fallback when there is one and the
key otherwise.

The presenter resolves two strings per node:

| Resolved | Key passed | Fallback |
| --- | --- | --- |
| Label | `Localization Key` | `Display Label` |
| Tooltip | `Localization Key` + `.tooltip` | `Tooltip` |

So a type keyed `wayfarer.haven.label` also asks for `wayfarer.haven.label.tooltip`. Leave
`Localization Key` empty and the tooltip key is empty too, falling back to the authored text.

!!! note "The key is not the stable ID"
    They are separate fields on purpose. A localisation key can be renamed to suit your string
    tables at any time; a stable ID cannot, because saves refer to it.

## Next

- **[Write map rules](write-map-rules.md)** &mdash; decide how many of each type a map gets.
- **[Shape and colour nodes](style-nodes.md)** &mdash; pick the silhouette these colours fill.
- **[Drive traversal from code](drive-traversal-from-code.md)** &mdash; react when a node is entered.
