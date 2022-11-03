//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    // There might be a case to be made for a parallel state machine
    struct BackgroundedNotLoaded: AppCoreState {
        let name = "BackgroundedNotLoaded"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            self
        }

        func enterBackground() -> AppCoreState {
            fatalError("enterBackground() has not been implemented")
        }

        func terminate() -> AppCoreState {
            self
        }

        func activate() -> AppCoreState {
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
