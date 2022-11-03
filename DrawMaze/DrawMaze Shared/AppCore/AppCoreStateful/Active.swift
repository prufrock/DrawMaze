//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    struct Active: AppCoreState {
        let name = "Active"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            self
        }

        func activate() -> AppCoreState {
            self
        }

        func terminate() -> AppCoreState {
            // Shutdown code here.
            print("shutting down")
            controller.save()
            return AppCoreStateful.Terminated(controller: controller)
        }

        func transition() -> AppCoreState? {
            // start the party
            print("activated!")
            return nil
        }

        func initialize() -> AppCoreState {
            self
        }
    }
}