# 5. Runtime integration

Now the code. Signatures here are taken from the shipped public surface; look anything
up in the [API reference](api-reference.md).

---

## The component you talk to

`MapTraversalController` is the runtime entry point. The Setup Wizard adds one. It owns
the graph, the session, and the runtime state, and it raises events you subscribe to.

```csharp
using BranchWeaver.Core;
using BranchWeaver.Runtime;
using UnityEngine;

public sealed class MapFlow : MonoBehaviour
{
    [SerializeField] private MapTraversalController map;

    private void OnEnable()
    {
        map.MapGenerated       += OnMapGenerated;
        map.NodeEntered        += OnNodeEntered;
        map.NodeCompleted      += OnNodeCompleted;
        map.MapCompleted       += OnMapCompleted;
        map.ValidationFailed   += report => Debug.LogError("Invalid map: " + report);
    }

    private void OnDisable()
    {
        map.MapGenerated     -= OnMapGenerated;
        map.NodeEntered      -= OnNodeEntered;
        map.NodeCompleted    -= OnNodeCompleted;
        map.MapCompleted     -= OnMapCompleted;
    }

    private void OnMapGenerated(MapGraph graph)
        => Debug.Log($"Map ready: {graph.Nodes.Count} nodes");

    private void OnNodeEntered(MapTransitionEvent transition)
    {
        // The player just arrived. Read your payload and start your content.
        var payload = transition.EnteredNode.Payload;
        if (payload.TryGetInt("encounter.tier", out var tier))
            StartEncounter(tier);
    }

    private void OnNodeCompleted(MapTransitionEvent transition)
        => Debug.Log("Finished " + transition.EnteredNode.Id.Value);

    private void OnMapCompleted(MapTransitionEvent transition)
        => Debug.Log("Run complete");

    private void StartEncounter(int tier) { /* your game */ }
}
```

Subscribe in `OnEnable` and unsubscribe in `OnDisable`. The controller outlives
individual listeners.

## Reading state

```csharp
MapProgressionState state = map.State;

state.CurrentNodeId              // where the traveller is
state.IsAvailable(nodeId)        // may the player enter it now
state.IsVisited(nodeId)
state.IsCompleted(nodeId)
state.IsMapCompleted
state.Revision                  // bumps on every change; cheap change detection
```

Use `Revision` rather than diffing state yourself when you need to know something moved.

## Moving the traveller

Player clicks are wired for you: the presenter raises a selection request, the
controller validates it against the session, and the transition happens only if it is
legal.

To move from code, go through the session so legality is still enforced:

```csharp
MapTransitionResult result = session.TryEnter(nodeId);
if (!result.Succeeded)
{
    // Illegal moves are data, not exceptions. Inspect result and react.
    return;
}
```

Then mark content finished when your encounter ends:

```csharp
session.CompleteCurrent();
// or, to attach a result payload:
session.CompleteCurrent(resultPayload);
```

**Completing is separate from entering** on purpose. Entering a node means the player
arrived; completing means the content resolved. Between the two, the node is current but
unfinished -- which is exactly the state a mid-combat save has to represent.

## Generating without the controller

For tooling, tests, or a custom flow, generate directly. `Core` has no Unity
dependency, so this runs anywhere, including in a plain unit test:

```csharp
var compiler = new MapAuthoringCompiler();
MapRulesCompilation rules = compiler.CompileRules(rulesAsset);
if (!rules.Succeeded)
{
    // rules.Validation names the offending rule
    return;
}

var generator = new LayeredMapGenerator();
MapGenerationResult result = generator.Generate(
    new MapGenerationRequest(rules.Value, seed: 12345u));

if (result.Succeeded)
{
    MapGraph graph = result.Graph;
}
else
{
    // result carries the failure kind and statistics, never an exception
}
```

Compile once, generate many times. Compilation freezes the authored assets into
immutable content; generation is the cheap part.

## Saving and loading

Serialize the envelope, then hand it to an adapter:

```csharp
using BranchWeaver.Core;

var serializer = new MapSaveSerializer();
var adapter = new FileMapSaveAdapter(Application.persistentDataPath);
var slot = new StableId("slot.autosave");

// Save
MapSaveEnvelope envelope = /* built from graph + progression */;
MapSaveOperationResult written = adapter.TryWrite(slot, envelope);
if (!written.Succeeded) { /* written names the failure kind */ }

// Load
MapSaveReadResult read = adapter.TryRead(slot);
if (read.Succeeded)
{
    MapSaveEnvelope loaded = read.Envelope;
}
```

Everything is `Try*` returning a result. Nothing throws on a bad path, a missing slot, or
a corrupt file.

`FileMapSaveAdapter` keeps primary, temporary, backup, and tombstone paths per slot, so
an interrupted write cannot destroy the previous save. It also **fails closed on unsafe
paths**: a slot ID that would escape the root directory is rejected rather than
followed.

For tests, swap in `MemoryMapSaveAdapter` -- same interface, no filesystem.

### Migrations

`MapSaveMigrations` upgrades older envelopes on load. Save schema versions, generator
versions, and stable IDs are **public compatibility contracts**: if you change a stable
ID, old saves will not resolve it. Plan an explicit migration when you do.

## Input

Player input works out of the box through the presenter. Two integration points if you
need more:

- **Legacy Input Manager** and **Input System** are both supported. The Input System
  bridge lives in `BranchWeaver.Integrations.InputSystem` and is only compiled when that
  package is present, so it never breaks a project without it.
- To drive selection from your own input, raise the selection request on the presenter
  or call `session.TryEnter` directly.

## Localization

Implement the localization adapter interface and assign it to the presenter. Node types
carry a `LocalizationKey`; the adapter resolves it, falling back to `DisplayLabel`. The
default adapter passes text through unchanged.

## Threading and determinism

Generation is synchronous and deterministic. It uses no Unity API, so you may run it off
the main thread if you keep the result crossing back before touching a presenter.

Do not seed from `UnityEngine.Random` or `DateTime.Now` if you want reproducible maps --
that is the one easy way to give up determinism by accident. Store the seed you used;
it is the whole reproduction case.

## Next

- **[Troubleshooting](06-troubleshooting.md)**
- **[API reference](api-reference.md)**
