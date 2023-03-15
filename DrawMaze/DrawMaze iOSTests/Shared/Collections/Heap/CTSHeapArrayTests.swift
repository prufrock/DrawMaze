//
//  CTSStackArrayTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/11/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSHeapArrayTests: XCTestCase {

    func testRemoveElementsInMinPriorityOrder() throws {
        let array = [1, 12, 3, 4, 1, 6, 8, 7]
        let comparotor: (Int, Int) -> Int = { $0 > $1 ? -1 : $0 == $1 ? 0 : 1 }
        let minHeap = CTSHeapArray<Int>.create(elements: array, comparator: comparotor)
        var ordered = [Int]()

        while(!minHeap.isEmpty) {
            ordered.append(minHeap.remove()!)
        }

        XCTAssertEqual([1, 1, 3, 4, 6, 7, 8, 12], ordered)
    }

    func testHeapMerge() {
        let comparotor: (Int, Int) -> Int = { $0 > $1 ? -1 : $0 == $1 ? 0 : 1 }
        let minHeapOne = CTSHeapArray<Int>.create(elements: [1, 12, 3], comparator: comparotor)
        let minHeapTwo = CTSHeapArray<Int>.create(elements: [4, 1, 6, 8, 7], comparator: comparotor)
        minHeapOne.merge(minHeapTwo)
        var ordered = [Int]()

        while(!minHeapOne.isEmpty) {
            ordered.append(minHeapOne.remove()!)
        }

        XCTAssertEqual([1, 1, 3, 4, 6, 7, 8, 12], ordered)
    }
}
