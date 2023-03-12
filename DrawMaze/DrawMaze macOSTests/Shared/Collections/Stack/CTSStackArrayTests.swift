//
//  CTSStackArrayTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/11/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSStackArrayTests: XCTestCase {

    func testPushingAndPopping() throws {
        let stack = CTSStackArray<Int>().apply {
            $0.push(1)
            $0.push(2)
            $0.push(3)
            $0.push(4)
        }

        // Each element is put on top of the stack, so they come out in reverse order.
        XCTAssertEqual([4, 3, 2, 1], stack.toList())
        // The last element added is returned (LIFO).
        XCTAssertEqual(4, stack.pop())
        // When an element is popped it's removed from the stack.
        XCTAssertEqual([3, 2, 1], stack.toList())
    }
}
