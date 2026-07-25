# Drive traversal from code

`MapTraversalController` owns the graph, the session, and the derived runtime state.
Subscribe to it, move the traveller through it, or use `Core` for a graph with no scene.

---

## Subscribe to controller events

### The event list

| Event | Argument | Raised when |
| --- | --- | --- |
| `MapGenerated` | `MapGraph` | `Initialize` accepted a graph and content |
| `NodeSelectionRequested` | `StableId` | a selection reached the controller for a node in the graph, before legality is checked |
| `NodeEntered` | `MapTransitionEvent` | the traveller arrived at a node |
| `NodeCompleted` | `MapTransitionEvent` | the content on the current node resolved |
| `AvailabilityChanged` | `MapTransitionEvent` | the set of enterable nodes changed |
| `MapCompleted` | `MapTransitionEvent` | a completed node had no outgoing route |
| `SaveRequested` | `MapGraph`, `MapProgressionState` | `RequestSave()` was called |
| `ValidationFailed` | `ValidationReport` | an operation was rejected, or a listener threw |
| `StateChanged` | `MapRuntimeStateSnapshot` | per-node visual and fog state was republished |

`MapTransitionEvent` carries `Kind`, `NodeId`, `Revision`, `ResultPayload`, and the
`AvailableNodeIds` that hold after it. The controller mirrors every event above as UnityEvent
slots under **Serialized Events**, driven by the **Invoke Serialized Events** toggle; the
node events pass the node ID as a string.

### A listener component

```csharp
using BranchWeaver.Core;
using BranchWeaver.Runtime;
using UnityEngine;

public sealed class MapFlow : MonoBehaviour
{
    [SerializeField] private MapTraversalController map;

    private void OnEnable() { map.NodeEntered += OnEntered; map.ValidationFailed += OnFailed; }
    private void OnDisable() { map.NodeEntered -= OnEntered; map.ValidationFailed -= OnFailed; }

    private void OnEntered(MapTransitionEvent transition)
    {
        MapNode node;   // node.Payload holds whatever the node type author attached
        if (map.Graph.TryGetNode(transition.NodeId, out node)) StartEncounter(node);
    }
    private void OnFailed(ValidationReport report)
    {
        foreach (var diagnostic in report.Diagnostics) Debug.LogWarning(diagnostic);
    }
}
```

Subscribe in `OnEnable`, unsubscribe in `OnDisable`. A listener that throws does not roll
back committed state: it becomes a warning on `ValidationFailed`, and later listeners run.

## Read progression state

`map.State` is the authoritative traversal snapshot. It is immutable, and `null` until
`Initialize` succeeds -- which `map.IsInitialized` reports.

```csharp
MapProgressionState state = map.State;
state.CurrentNodeId       // empty while no node is being played
state.AvailableNodeIds    // sorted; what the player may enter now
state.IsAvailable(nodeId); state.IsVisited(nodeId); state.IsCompleted(nodeId);
state.TryGetCompletion(nodeId, out completion);  // the result payload you stored
state.IsMapCompleted      // true once a completed node had no outgoing route
state.Revision            // increments once per accepted transition
```

Compare `Revision` rather than diffing the snapshot yourself to detect that something moved.

`map.GetRuntimeState()` returns the derived per-node view of that same revision:
`TryGet(nodeId, out node)` gives a `VisualState` of `Hidden`, `Locked`, `Available`,
`Current`, `Visited`, or `Completed`, and a `FogState` of `Hidden`, `Dimmed`, or `Visible`.
That is what the presenter draws and what fog settings change -- see
[what the player can see](reveal-and-fog.md).

## Move the traveller

Player input is already wired: the **Map Input Controller** hit-tests the pointer or the
focused node and calls `RequestNodeSelection` for you. From code, use the same two methods
so legality stays enforced. A result payload must be canonical: give it a payload ID once it
carries properties, and keep the keys unique.

```csharp
MapSelectionResult selection = map.RequestNodeSelection(nodeId);
// WasAvailable is false when the node was not enterable, Transition null when the
// request never reached the session.
if (!selection.Succeeded) return;
var resultPayload = new MapDataPayload(new StableId("encounter.result"), new[] {
    new MapProperty(new StableId("outcome"), MapPropertyValue.Id(new StableId("victory"))) });
MapTransitionResult completion = map.CompleteCurrent(resultPayload);
if (completion == null || !completion.Succeeded) { /* completion.FailureKind says why */ }
```

Illegal moves are data, not exceptions. `FailureKind` names the reason: `NodeUnavailable`,
`CurrentNodeActive`, `CurrentNodeMissing`, `MapAlreadyCompleted`, `ResultPayloadInvalid`,
`TransitionInProgress`, or `RevisionOverflow`. `CompleteCurrent()` with no argument stores
`MapDataPayload.Empty`.

**Completing is separate from entering** on purpose. Entering means the player arrived,
completing means the content resolved. Between the two the node is current but unfinished,
which is exactly the state a mid-encounter save must represent. Completing a node makes its
outgoing neighbours available; completing one with no outgoing route completes the map.

!!! warning "Do not move the traveller from inside a controller callback"
    Rather than disturb the transition in flight, a re-entrant selection is ignored and
    returns a null `Transition`, and a re-entrant `CompleteCurrent` is rejected with
    `TransitionInProgress`. Queue the move and make it on your next frame.

## Generate without the controller

`BranchWeaver.Core` declares no engine references, so generation runs anywhere: an edit-mode
test, a build script, or a background thread. Compiling the authored assets still needs
Unity, because they are ScriptableObjects.

```csharp
var compiler = new MapAuthoringCompiler();                  // BranchWeaver.Authoring
MapRulesCompilation rules = compiler.CompileRules(rulesAsset);
if (!rules.Succeeded) return;            // rules.Validation names the offending rule
MapGenerationResult result = new LayeredMapGenerator()      // BranchWeaver.Core
    .Generate(new MapGenerationRequest(rules.Value, 12345u));
if (!result.Succeeded) return;           // result.FailureKind and result.Statistics say why
MapGraph graph = result.Graph;           // result.Manifest carries the reproduction case
var content = new MapRuntimeContent(rules.NodeTypes, compiler.CompileTheme(themeAsset).Value);
map.Initialize(graph, content);          // false if a node has no compiled node type
```

Compile once, generate many times: compilation freezes the assets, generation is the cheap part.

!!! warning "Seeds decide reproducibility"
    Do not seed from `UnityEngine.Random` or `DateTime.Now` if you want a map back. Store
    the seed: with the rules fingerprint on the graph it is the whole reproduction case.
    See [Determinism](../explanation/determinism.md).

## Next

- **[Save and load progress](save-and-load.md)** -- write the graph and progression to a slot.
- **[Input, focus, and camera framing](input-and-navigation.md)** -- what the map handles for you.
- **[Traversal and progression reference](../reference/traversal-and-progression.md)** -- full signatures.
