//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    struct Backgrounded: AppCoreState {
        let name = "Backgrounded"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            self
        }

        func enterBackground() -> AppCoreState {
            fatalError("enterBackground() has not been implemented")
        }

        func enterForeground() -> AppCoreState {
            _ = controller.restore()
            return  AppCoreStateful.Active(controller: controller)
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