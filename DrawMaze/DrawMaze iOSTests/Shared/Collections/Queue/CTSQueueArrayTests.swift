//
//  CTSQueueTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/13/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSQueueArrayTests: XCTestCase {

    func testAddAndRemoveItemsFromTheQueue() throws {
        let queue = CTSQueueArray<String>().apply {
            $0.enqueue("Cid")
            $0.enqueue("Veronica")
            $0.enqueue("Celes")
        }
        XCTAssertEqual(["Cid", "Veronica", "Celes"], queue.toArray())
        XCTAssertEqual("Cid", queue.dequeue())
        XCTAssertEqual("Veronica", queue.peek())
    }
}
