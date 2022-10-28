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

    func activate()
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

    func activate() {
        queue.async {
            self.appCore.activate()
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
    var state: AppCoreState {
        didSet {
            print("State -> \(state.name)")
        }
    }


    init(state: AppCoreState) {
        self.state = state
    }

    var name: String {
        get {
            state.name
        }
    }

   func launch() {
       state = state.launch()
       transition()
    }

    func activate() {
        state = state.activate()
        transition()
    }

    func terminate() {
        state = state.terminate()
    }

    private func transition() {
        var nextState: AppCoreState? = nil
        repeat {
            nextState = state.transition()
            if nextState != nil {
                state = nextState!
            }
        } while (nextState != nil)
    }
}

class AppCoreController {
    var appCore: AppCore?
    private var serviceList: [String] = []

    func addService(_ element: String) {
        serviceList.append(element)
        print("loaded service \(element)")
    }
}

protocol AppCoreState {
    var name: String { get }
    var controller: AppCoreController { get }

    func launch() -> AppCoreState

    func terminate() -> AppCoreState

    func activate() -> AppCoreState

    mutating func transition() -> AppCoreState?
}

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

       func terminate() -> AppCoreState {
            self
        }

        mutating func transition() -> AppCoreState? {
            nil
        }
    }

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

        mutating func transition() -> AppCoreState? {
            load()
        }

        // Is it strange that the value of the semaphore changes but it's a *let*?
        let mainSemaphore = DispatchSemaphore(value: 0)

        mutating private func load() -> AppCoreState {
            let services = ["render", "sound", "http"];

            for i in 0..<services.count {
                if(!Thread.isMainThread) {
                    sleep(1)
                }
                controller.addService(services[i])
            }
            return AppCoreStateful.Active(controller: controller)
        }
    }

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
            AppCoreStateful.Terminated(controller: controller)
        }

        func transition() -> AppCoreState? {
            // start the party
            print("activated!")
            return nil
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

        func activate() -> AppCoreState {
            self
        }

        func transition() -> AppCoreState? {
            nil
        }
    }
}
