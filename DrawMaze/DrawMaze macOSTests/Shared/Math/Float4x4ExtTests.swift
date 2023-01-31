//
//  DrawMaze_macOSTests.swift
//  DrawMaze macOSTests
//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

import simd

final class Float4x4ExtTests: XCTestCase {

    func testTranslate() throws {
        var start = Float4(1.0, 0.0, 0.0, 1.0)
        var end = Float4x4.translate(x: 2.0, y: 0.0, z: 0.0) * start
        XCTAssertEqual(Float4(3.0, 0.0, 0.0, 1.0), end)

        start = Float4(0.0, 1.0, 0.0, 1.0)
        end = Float4x4.translate(x: 0.0, y: 2.0, z: 0.0) * start
        XCTAssertEqual(Float4(0.0, 3.0, 0.0, 1.0), end)

        start = Float4(0.0, 0.0, 1.0, 1.0)
        end = Float4x4.translate(x: 0.0, y: 0.0, z: 2.0) * start
        XCTAssertEqual(Float4(0.0, 0.0, 3.0, 1.0), end)

        // translate F2
        start = Float4(1.0, 0.0, 0.0, 1.0)
        end = Float4x4.translate(F2(3.0, 2.0)) * start
        XCTAssertEqual(Float4(4.0, 2.0, 0.0, 1.0), end)
    }
}
