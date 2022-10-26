//
//  AppDelegate.swift
//  DrawMaze macOS
//
//  Created by David Kanenwisher on 10/24/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var core: AppCore = AppCore(state: AppCore.NeverLoaded(controller: AppCoreController()))

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        core.launch()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        // Does it need to be torn down when this function returns?
        // Then it might need to go directly to "Terminated"
        print("applicationWillTerminate")
        core.terminate()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

