//
//  DrawMaze_macOSTests.swift
//  DrawMaze macOSTests
//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

final class FloatExtTests: XCTestCase {

    func testConvertToRadians() throws {
        XCTAssertEqual(0, Float(0).toRadians(), accuracy: 0.0)
        XCTAssertEqual(.pi/4, Float(45).toRadians(), accuracy: 0.0000002)
        XCTAssertEqual(.pi/2, Float(90).toRadians(), accuracy: 0.0000002)
        XCTAssertEqual(.pi, Float(180).toRadians(), accuracy: 0.0000005)
        XCTAssertEqual((3 * .pi)/2, Float(270).toRadians(), accuracy: 0.0000000)
    }
}
