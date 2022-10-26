//
//  AppCore.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 10/24/22.
//

import Foundation

struct AppCore {
    var state: AppCoreState {
        didSet {
            print("State -> \(state)")
        }
    }

    var name: String {
        get {
            state.name
        }
    }

    mutating func launch() {
        state = state.launch()
        state.transition()
    }

    mutating func terminate() {
        state = state.terminate()
    }
}

struct AppCoreController {
    var descriptors = [0,1,2];
}

protocol AppCoreState {
    var name: String { get }
    var controller: AppCoreController { get }

    func launch() -> AppCoreState

    func terminate() -> AppCoreState

    func transition()
}

extension AppCore {
    struct NeverLoaded: AppCoreState {
        let name = "NeverLoaded"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            AppCore.Loading(controller: controller)
        }

       func terminate() -> AppCoreState {
            self
        }

        func transition() {

        }
    }

    struct Loading: AppCoreState {
        let name = "Loading"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            self
        }

        func terminate() -> AppCoreState {
            // Stop loading and shutdown.
            AppCore.Terminated(controller: controller)
        }

        func transition() {
            load()
        }

        // Is it strange that the value of the semaphore changes but it's a *let*?
        let mainSemaphore = DispatchSemaphore(value: 0)

        private func load() {

            let queue = DispatchQueue(
                label: "drawmaze",
                attributes: [.concurrent]
            )

            for i in 0..<controller.descriptors.count {
                queue.async {
                    sleep(3)
                    print("loading descriptors: \(controller.descriptors[i])")
                    mainSemaphore.signal()
                }
            }
        }
    }

    struct Active: AppCoreState {
        let name = "Active"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            self
        }

        func terminate() -> AppCoreState {
            // Shutdown code here.
            AppCore.Terminated(controller: controller)
        }

        func transition() {

        }
    }

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
            AppCore.Loading(controller: controller)
        }

        func terminate() -> AppCoreState {
            self
        }

        func transition() {

        }
    }
}
