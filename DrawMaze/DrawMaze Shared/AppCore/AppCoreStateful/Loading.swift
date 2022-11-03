//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

extension AppCoreStateful {
    struct Loading: AppCoreState {
        let name = "Loading"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            self
        }

        func activate() -> AppCoreState {
            AppCoreStateful.Active(controller: controller)
        }

        func terminate() -> AppCoreState {
            // Stop loading and shutdown.
            AppCoreStateful.Terminated(controller: controller)
        }

        func transition() -> AppCoreState? {
            load()
        }

        func initialize() -> AppCoreState {
            self
        }

        func enterBackground() -> AppCoreState {
            //TODO: When reactivating need to start loading again.
            controller.save()
            return AppCoreStateful.Backgrounded(controller: controller)
        }

        private func load() -> AppCoreState {
            let services = ["render", "sound", "http"];

            for i in 0..<services.count {
                if (!Thread.isMainThread) {
                    sleep(10)
                }
                controller.addService(services[i])
            }
            return AppCoreStateful.Active(controller: controller)
        }
    }
}