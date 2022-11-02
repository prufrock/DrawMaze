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

    func initialize()
}

/**
 A wrapper around AppCore that allows it run on separate thread managed by Grand Central Dispatch.
 */
class AppCoreGcd: AppCore {
    private let appCore: AppCore
    private let queue: DispatchQueue
    private var currentTask: DispatchWorkItem?

    /**
     - Parameters:
       - appCore: The AppCore requests forward to.
       - queue: Should be a serial queue to ensure access to variables is thread safe.
     */
    init(appCore: AppCore, queue: DispatchQueue) {
        self.appCore = appCore
        self.queue = queue
    }

    func launch() {
        dispatch {
            self.appCore.launch()
        }
    }

    func activate() {
        dispatch {
            self.appCore.activate()
        }
    }

    /**
     * For now `terminate()` is not async since it should happen immediately.
     */
    func terminate() {
        // It's time to terminate so if anything is running shut it down!
        if let runningTask = currentTask {
            print("canceling task")
            runningTask.cancel()
        }
        // Terminate on the main thread because when the app closes it can *close* now.
        appCore.terminate()
    }

    func initialize() {
        appCore.initialize()
    }

    /**
     The annotations came from those on DispatchWorkItem. I'm not sure sure what `@convention` means but it works...
     - Parameter block:
     */
    private func dispatch(block: @escaping @convention(block) () -> Void) {
        // Replace with scope function if added later
        currentTask = {
            let work = DispatchWorkItem(block: block)

            work.notify(queue: queue) {
                self.currentTask = nil
            }

            queue.async(execute: work)
            return work
        }()
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

    func initialize() {
        state = state.initialize()
        transition()
    }

    /**
     Transition is a trampoline that prevents threads from re-entering AppCoreStateful and
     has a bonus of keeping the stack shallow.
     */
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

    let filename: URL

    init() {
        // find a better home for this
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        filename = paths[0].appendingPathComponent("AppCore.txt")
    }

    func addService(_ element: String) {
        serviceList.append(element)
        print("loaded service \(element)")
    }

    func save() {
        try! "Terminated".write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        print("wrote to \(filename)")
    }

    func restore() -> Bool {
        let manager = FileManager()
        return manager.fileExists(atPath: filename.path)
    }
}

protocol AppCoreState {
    var name: String { get }
    var controller: AppCoreController { get }

    func launch() -> AppCoreState

    func terminate() -> AppCoreState

    func activate() -> AppCoreState

    func transition() -> AppCoreState?

    func initialize() -> AppCoreState
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

        private func load() -> AppCoreState {
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

        func initialize() -> AppCoreState {
            self
        }
    }
}
