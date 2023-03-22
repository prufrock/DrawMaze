//
//  CTSRIngBufferTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/21/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSRingBufferTests: XCTestCase {

    func testPushingAndPopping() throws {
        let ring = CTSRingBufferArray<Int>(size: 3)
        XCTAssertEqual([], ring.toArray())
        XCTAssertTrue(ring.write(1))
        XCTAssertEqual([1], ring.toArray())
        XCTAssertTrue(ring.write(2))
        XCTAssertEqual([1,2], ring.toArray())
        XCTAssertTrue(ring.write(3))
        XCTAssertEqual([1,2,3], ring.toArray())
        XCTAssertFalse(ring.write(4), "You shouldn't be able to add more elements once the ring buffer is bigger than it's initial size.")
        XCTAssertEqual([1,2,3], ring.toArray())
        XCTAssertEqual(3, ring.count)
        XCTAssertEqual(1, ring.read())
        XCTAssertEqual(2, ring.read())
        XCTAssertEqual(3, ring.read())
        XCTAssertNil(ring.read())
    }
}
