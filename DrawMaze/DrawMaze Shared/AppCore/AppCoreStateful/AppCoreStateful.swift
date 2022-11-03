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


    init(state: AppCoreState) {
        self.state = state
    }

    var name: String {
        get {
            state.name
        }
    }

    func launch() {
        state = state.launch()
        transition()
    }

    func activate() {
        state = state.activate()
        transition()
    }

    func terminate() {
        state = state.terminate()
    }

    func initialize() {
        state = state.initialize()
        transition()
    }

    /**
     Transition is a trampoline that prevents threads from re-entering AppCoreStateful and
     has a bonus of keeping the stack shallow.
     */
    private func transition() {
        var nextState: AppCoreState? = nil
        repeat {
            nextState = state.transition()
            if nextState != nil {
                state = nextState!
            }
        } while (nextState != nil)
    }
}
