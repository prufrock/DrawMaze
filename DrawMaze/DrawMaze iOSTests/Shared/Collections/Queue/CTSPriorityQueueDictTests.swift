//
//  CTSQueueTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/13/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSPriorityQueueDictTests: XCTestCase {

    func testItStartsOutEmpty() throws {
        let queue = CTSPriorityQueueDict<String>()
        XCTAssertTrue(queue.isEmpty())
    }

    func testItIsNotEmptyAfterAddingAnItem() throws {
        let queue = CTSPriorityQueueDict<String>().apply {
            $0.push("Cid")
        }
        XCTAssertFalse(queue.isEmpty())
    }

    func testItemsCanBeRemovedFromIt() throws {
        let queue = CTSPriorityQueueDict<String>().apply {
            $0.push("Cid")
        }
        XCTAssertEqual("Cid", queue.pop())
        XCTAssertTrue(queue.isEmpty())
    }

    func testAnItemWithAHigherPriorityIsRemovedFirst() throws {
        let queue = CTSPriorityQueueDict<String>().apply {
            $0.push("Celes", priority: 3)
            $0.push("Veronica", priority: 2)
            $0.push("Cid", priority: 1)
        }
        XCTAssertEqual("Cid", queue.pop())
        XCTAssertEqual("Veronica", queue.pop())
        XCTAssertEqual("Celes", queue.pop())
    }

    func testGetTheSizeOfThePriorityQueue() {
        let queue = CTSPriorityQueueDict<String>().apply {
            $0.push("Celes", priority: 3)
            $0.push("Veronica", priority: 2)
            $0.push("Cid", priority: 1)
        }

        XCTAssertEqual(3, queue.count)
    }
}
