//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

class AppCoreStateful: AppCore {
    var state: AppCoreState {
        didSet {
            print("State -> \(state.name)")
        }
    }

    var name: String {
        get {
            state.name
        }
    }

    init(state: AppCoreState) {
        self.state = state
    }

    func launch() {
        transition(state.launch())
    }

    func activate() {
        transition(state.activate())
    }

    func enterBackground() {
        transition(state.enterBackground())
    }

    func enterForeground() {
        transition(state.enterForeground())
    }

    func terminate() {
        transition(state.terminate())
    }

    func initialize() {
        transition(state.initialize())
    }

    func setWorkItem(workItem: DispatchWorkItem?) {
        state.controller.workItem = workItem
    }

    /**
     Transition is a trampoline that prevents threads from re-entering AppCoreStateful and
     has a bonus of keeping the stack shallow.
     */
    private func transition(_ newState: AppCoreState) {
        // Don't change states or transition if the new state is the same as the old.
        guard newState.name == "NoChange" || state.name != newState.name else {
            return
        }
        state = newState
        var nextState: AppCoreState? = nil
        repeat {
            nextState = state.transition()
            // nil may be better than no change
            if nextState != nil && nextState?.name != "NoChange" {
                state = nextState!
            }
        } while (nextState != nil)
    }
}
