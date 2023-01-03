//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    /**
     When a state wants to indicate the current state shouldn't change.
     TODO: nil may be a better choice...
     */
    struct NoChange: AppCoreState {
        let name = "NoChange"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            fatalError("not implemented")
        }

        func activate() -> AppCoreState {
            fatalError("not implemented")
        }

        func enterBackground() -> AppCoreState {
            fatalError("not implemented")
        }

        func enterForeground() -> AppCoreState {
            fatalError("not implemented")
        }

        func terminate() -> AppCoreState {
            fatalError("not implemented")
        }

        func transition() -> AppCoreState? {
            fatalError("not implemented")
        }

        func initialize() -> AppCoreState {
            fatalError("not implemented")
        }
    }
}