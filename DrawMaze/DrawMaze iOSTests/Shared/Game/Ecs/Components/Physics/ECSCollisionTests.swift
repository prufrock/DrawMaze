//
// Created by David Kanenwisher on 2/17/23.
//

import Foundation

import XCTest
@testable import DrawMaze_iOS

final class ECSCollisionTests: XCTestCase {

    func testRect() {
        let c = ECSCollision(entityID: "c1", radius: 0.5, position: F2(0.0,0.0))
        let r = c.rect

        XCTAssertEqual(-0.5, r.min.x)
        XCTAssertEqual(-0.5, r.min.y)
        XCTAssertEqual(0.5, r.max.x)
        XCTAssertEqual(0.5, r.max.y)
    }
}