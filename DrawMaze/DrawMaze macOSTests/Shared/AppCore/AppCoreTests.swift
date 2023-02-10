//
//  DrawMaze_macOSTests.swift
//  DrawMaze macOSTests
//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

final class AppCoreTests: XCTestCase {

    func testAppCoreConfigAccess() throws {
        let config = AppCoreConfig(
            game: AppCoreConfig.Game(
                world: AppCoreConfig.Game.World()
            ),
            platform: AppCoreConfig.Platform(
                maximumTimeStep: 1 / 20, // don't step bigger than this (minimum of 20 fps)
                worldTimeStep: 1 / 120 // 120 steps a second
            ),
            services: AppCoreConfig.Services(
                renderService: AppCoreConfig.Services.RenderService(
                    type: .ersatz,
                    clearColor: (0.3, 0.0, 0.3, 1.0)
                ),
                fileService: AppCoreConfig.Services.FileService(
                    levelsFile: AppCoreConfig.Services.FileService.FileDescriptor(name: "levels", ext: "json")
                )
            )
        )
        let core = AppCore(config)
        XCTAssertEqual(0.3, core.config.services.renderService.clearColor.0)
        XCTAssertEqual(0.0, core.config.services.renderService.clearColor.1)
        XCTAssertEqual(0.3, core.config.services.renderService.clearColor.2)
        XCTAssertEqual(1.0, core.config.services.renderService.clearColor.3)
    }
}
