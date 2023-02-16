//
//  DrawMaze_iOSTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

import simd

final class ECSBigObjectEntityManagerTests: XCTestCase {

    func testBasics() throws {
        let manager = ECSBigObjectEntityManager()
        XCTAssertEqual(0, manager.entities.count, "Should not be much here yet")
    }

    func testCreateDecoration() throws {
        var manager = ECSBigObjectEntityManager()
        _ = manager.createDecoration(id: "d1", position: F2(2.0, 2.0))

        let graphic = manager.sceneGraph.first!

        let v = graphic.uprightToWorld * F4(0.0, 0.0, 0.0, 1.0)

        XCTAssertEqual(2.0, v.x, "")
        XCTAssertEqual(2.0, v.y, "")
        XCTAssertEqual(0.0, v.z, "")
        XCTAssertEqual(1.0, v.w, "")
    }
}
