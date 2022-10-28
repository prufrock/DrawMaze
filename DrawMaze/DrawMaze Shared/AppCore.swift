//
//  AppCore.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 10/24/22.
//

import Foundation


protocol AppCore {
    func launch()

    func terminate()
}

class AppCoreGcd: AppCore {
    private let appCore: AppCore
    private let queue: DispatchQueue

    init(appCore: AppCore, queue: DispatchQueue) {
        self.appCore = appCore
        self.queue = queue
    }

    func launch() {
        queue.async {
            self.appCore.launch()
        }
    }

    /**
     * For now terminate is not async since it should happen immediately.
     * Might need to look into making launch cancelable.
     */
    func terminate() {
        appCore.terminate()
    }
}

class AppCoreStateful: AppCore {
    private let dispatchQueue: DispatchQueue

    var state: AppCoreState {
        didSet {
            print("State -> \(state)")
        }
    }


    init(state: AppCoreState) {
        self.state = state

        // Use a serial queue because that should limit access to state.
        dispatchQueue = DispatchQueue(label: "background")
    }

    var name: String {
        get {
            state.name
        }
    }

   func launch() {
       dispatchQueue.async {
           self.state = self.state.launch()
           self.state.transition()
       }
    }

    func terminate() {
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

extension AppCoreStateful {
    struct NeverLoaded: AppCoreState {
        let name = "NeverLoaded"
        var controller: AppCoreController

        func launch() -> AppCoreState {
            AppCoreStateful.Loading(controller: controller)
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
            AppCoreStateful.Terminated(controller: controller)
        }

        func transition() {
            load()
        }

        // Is it strange that the value of the semaphore changes but it's a *let*?
        let mainSemaphore = DispatchSemaphore(value: 0)

        private func load() {

            for i in 0..<controller.descriptors.count {
                sleep(3)
                print("loading descriptors: \(controller.descriptors[i])")
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
            AppCoreStateful.Terminated(controller: controller)
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
            AppCoreStateful.Loading(controller: controller)
        }

        func terminate() -> AppCoreState {
            self
        }

        func transition() {

        }
    }
}
