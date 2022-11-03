//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

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
        // Start processing work on the queue again
        queue.activate()
        dispatch {
            self.appCore.activate()
        }
    }

    /**
     * There's limited time to get into the background so do it on the main thread.
     */
    func enterBackground() {
        // Stop anything that's running when entering the background
        if let runningTask = currentTask {
            print("canceling task")
            runningTask.cancel()
        }
        // stop processing work on the queue
        queue.suspend()
        appCore.enterBackground()
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
        // stop processing work on the queue
        queue.suspend()
        // Terminate on the main thread because when the app closes it can *close* now.
        appCore.terminate()
    }

    func initialize() {
        appCore.initialize()
    }

    func setWorkItem(workItem: DispatchWorkItem?) {
        appCore.setWorkItem(workItem: workItem)
    }

    /**
     The annotations came from those on DispatchWorkItem. I'm not sure sure what `@convention` means but it works...
     - Parameter block:
     */
    private func dispatch(block: @escaping @convention(block) () -> Void) {
        // Replace with scope function if added later
        currentTask = {
            let work = DispatchWorkItem(block: block)

            self.setWorkItem(workItem: work)

            work.notify(queue: queue) {
                self.currentTask = nil
                self.setWorkItem(workItem: nil)
            }

            queue.async(execute: work)
            return work
        }()
    }
}