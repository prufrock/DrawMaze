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
            return AppCoreStateful.BackgroundedNotLoaded(controller: controller)
        }

        func enterForeground() -> AppCoreState {
            self
        }

        private func load() -> AppCoreState {
            let services = ["render", "sound", "http"];

            for i in 0..<services.count {
                if (controller.hasService(services[i])) {
                    print("already loaded \(services[i])")
                    continue
                }

                // What if loading services was added to the queue?
                if let workItem = controller.workItem {
                    if (workItem.isCancelled) {
                        print("!stop loading!")
                        controller.workItem = nil
                        // stop loading services if the work item has been cancelled
                        return AppCoreStateful.NoChange(controller: controller)
                    }
                }
                if (!Thread.isMainThread) {
                    sleep(5)
                }
                controller.addService(services[i])
            }

            if controller.serviceCount != services.count {
                return AppCoreStateful.NoChange(controller: controller)
            }
            return AppCoreStateful.Active(controller: controller)
        }
    }
}