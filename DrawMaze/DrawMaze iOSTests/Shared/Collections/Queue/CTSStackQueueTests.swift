//
//  CTSQueueTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/13/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSStackQueueTests: XCTestCase {

    func testAddAndRemoveItemsFromTheQueue() {
        let queue = CTSStackQueue<String>().apply {
            $0.enqueue("Ondro")
            $0.enqueue("Ilya")
            $0.enqueue("Tamiko")
        }

        XCTAssertEqual(["Ondro", "Ilya", "Tamiko"], queue.toArray())
        XCTAssertEqual("Ondro", queue.dequeue())
        XCTAssertEqual(["Ilya", "Tamiko"], queue.toArray())
        XCTAssertEqual("Ilya", queue.peek())
    }
}
