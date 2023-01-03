//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    struct NeverLoaded: AppCoreState {
        let name = "NeverLoaded"
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

        func enterForeground() -> AppCoreState {
            fatalError("enterForeground() not implemented")
        }

        func terminate() -> AppCoreState {
            self
        }

        func transition() -> AppCoreState? {
            nil
        }

        func initialize() -> AppCoreState {
            // if a saved file exists load it and change state to Terminated
            if controller.restore() {
                return AppCoreStateful.Terminated(controller: controller)
            }
            // if there isn't a file continue in NeverLoaded
            return self
        }
    }
}