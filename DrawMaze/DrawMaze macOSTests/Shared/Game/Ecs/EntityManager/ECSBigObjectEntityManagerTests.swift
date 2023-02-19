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

        let graphic = manager.scene.first { $0.entityID == "d1" }

        let v = graphic!.uprightToWorld * F4(0.0, 0.0, 0.0, 1.0)

        XCTAssertEqual(2.0, v.x, "")
        XCTAssertEqual(2.0, v.y, "")
        XCTAssertEqual(0.0, v.z, "")
        XCTAssertEqual(1.0, v.w, "")
    }

    func testCreateToggleButton() throws {
        var manager = ECSBigObjectEntityManager()
        _ = manager.createToggleButton(id: "b1", position: F2(2.0))

        let found = manager.collides(with: Rect(min: F2(1.0), max: F2(3.0)))

        XCTAssertEqual(1, found.count, "Should collide with the one button")
    }

    func testUpdate() throws {
        var manager = ECSBigObjectEntityManager()
        var button = manager.createToggleButton(id: "b1", position: F2(2.0))

        button.collision?.position = F2(1.0)
        button.graphics?.color = Float4(Color.grey)

        manager.update(button)

        let updatedButton = manager.entities.first { $0.id == button.id }!
        XCTAssertEqual(Float4(Color.grey), updatedButton.graphics?.color , "color updated to grey")
        XCTAssertEqual(F2(1.0), updatedButton.collision?.position , "position updated to 1.0")
    }
}
