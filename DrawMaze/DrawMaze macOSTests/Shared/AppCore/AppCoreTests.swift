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
            services: AppCoreConfig.Services(
                renderService: AppCoreConfig.Services.RenderService(
                    clearColor: (0.3, 0.0, 0.3, 1.0)
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
