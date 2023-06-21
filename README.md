# SynchronizeStateTCA

SynchronizeStateTCA is a library that builds on top of pointfreeco's [`swift-composable-architecture`](https://github.com/pointfreeco/swift-composable-architecture) to allow a way to
sync state between multiple `Reducers`.

## Motivation
This is motivated by the need to have different reducers that are composed together keep a synced up state.
Consider you have a reducer that is composed of different sub-reducers, there are cases when you have some piece of 
state which need to be accessed (and maybe even mutated) by a couple of them. Composing a state which can be 
scoped/pulledback to allow each and everyone of them to work off of the same piece of state can prove to be challenging.
An easier approach for those times is to have local copy of the state and manually try to keep it all in sync via 
the parent reducer.
This update is syntactic sugar to remove the boilerplate needed to achieve that effect

#### Example usage:
```
struct Child: ReducerProtocol {
    struct State {
       var sharedState: Foo
       // ..
     }
     enum Action ...
}


  struct Parent: ReducerProtocol {
     struct State {
       var sharedState: Foo
       var child: Child.State
       // ...
     }
     enum Action {
       case child(Child.Action)
       // ...
     }
     var body: some ReducerProtocol<State, Action> {
       Reduce { state, action in
         Scope(state: \.child, action: /Action.child) {
           Child()
         }
         // Core logic for parent feature
       }
       .synchronizeState(
           over: SynchronizationParameters(
               parent: .observeOnly(\State.sharedState),
               children: [
                    .synchronize(\State.child.sharedState)
               ]
           )
       )
     }
   }

```
This would ensure that whenever `sharedState` changes on `Parent` it also syncs with the copy help by `Child`
With a bunch of different child reducers you just avoid the issue of keeping it all up to date. I think this should scale much easier.

## Limitation
A limitation of this approach is that you are indeed maintaining multiple state copies so if the state is "heavy" you could use up a lot of memory.
