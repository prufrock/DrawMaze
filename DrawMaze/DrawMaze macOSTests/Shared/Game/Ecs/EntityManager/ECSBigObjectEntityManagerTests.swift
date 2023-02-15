//
//  DrawMaze_iOSTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

final class ECSBigObjectEntityManagerTests: XCTestCase {

    func testBasics() throws {
        let manager = ECSBigObjectEntityManager()
        XCTAssertEqual(0, manager.entities.count, "Should not be much here yet")
    }
}
