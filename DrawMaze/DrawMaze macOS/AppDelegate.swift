//
//  AppDelegate.swift
//  DrawMaze macOS
//
//  Created by David Kanenwisher on 10/24/22.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var core: AppCore? 

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let coreCore = AppCoreStateful(state: AppCoreStateful.NeverLoaded(controller: AppCoreController()))
        core = AppCoreGcd(appCore: coreCore, queue: DispatchQueue(label: "com.dkanen.background"))
        core?.launch()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        print("applicationWillTerminate")
        core?.terminate()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}

