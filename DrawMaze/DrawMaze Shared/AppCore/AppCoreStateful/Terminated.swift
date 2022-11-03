//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    /**
     Going to skip "Terminating" for now and go straight ot "Terminated" since the final
     state of "Terminated" is how I want it to be serialized. It presents a weird problem
     if the application isn't in the final state when it's serialized though I think there
     could be a way around it. I also, don't think there's a need to delay Termination just
     yet even though it does seem fun to have it handled on threads.
     */
    struct Terminated: AppCoreState {
        let name = "Terminated"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            AppCoreStateful.Loading(controller: controller)
        }

        func activate() -> AppCoreState {
            self
        }

        func enterBackground() -> AppCoreState {
            fatalError("enterBackground() has not been implemented")
        }

        func terminate() -> AppCoreState {
            self
        }

        func transition() -> AppCoreState? {
            nil
        }

        func initialize() -> AppCoreState {
            self
        }
    }
}