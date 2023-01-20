//
//  AppDelegate.swift
//  DrawMaze iOS
//
//  Created by David Kanenwisher on 10/24/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var core: AppCore?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Insert code here to initialize your application
        let config = AppCoreConfig(
            services: AppCoreConfig.Services(
                renderService: AppCoreConfig.Services.RenderService(
                    clearColor: (0.3, 0.0, 0.3, 1.0)
                ),
                fileService: AppCoreConfig.Services.FileService(
                    levelsFile: AppCoreConfig.Services.FileService.FileDescriptor(name: "levels", ext: "json")
                )
            ),
            game: AppCoreConfig.Game(
                world: AppCoreConfig.Game.World()
            )
        )
        core = AppCore(config)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Insert code here to tear down your application
        print("applicationWillTerminate")
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("applicationDidReceiveMemoryWarning")
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

