//
//  Created by David Kanenwisher on 02/02/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSQuadTreeRectTests: XCTestCase {

    func testAddRectInBounds() {
        let tree = CTSQuadTreeRect(boundary: Rect(0.0, 0.0, 5.0, 5.0), maxElements: 2)

        XCTAssertTrue(tree.insert(Rect(1.0, 1.0, 2.0, 2.0)), "1.0, 1.0, 2.0, 2.0 fits.")
        XCTAssertTrue(tree.insert(Rect(2.5, 2.5, 3.0, 3.0)), "2.5, 2.5, 3.0, 3.0 fits.")
        XCTAssertTrue(tree.insert(Rect(2.8, 2.8, 2.9, 2.9)), "2.8, 2.8, 2.9, 2.9 fits.")

        let result = tree.find(Rect(0.9, 0.9, 2.1, 2.1))

        XCTAssertEqual(1, result.count, "Finds 1 rectangle.")
        XCTAssertEqual(Rect(1.0, 1.0, 2.0, 2.0), result.first, "Finds 1.0, 1.0, 2.0, 2.0")
    }

    func testAddRectNotInBounds() {
        let tree = CTSQuadTreeRect(boundary: Rect(0.0, 0.0, 5.0, 5.0), maxElements: 2)

        XCTAssertFalse(tree.insert(Rect(6.0, 6.0, 6.1, 6.1)), "It should've been added.")
    }

    func testSearchForOneMatchingRect() {
        let tree = CTSQuadTreeRect(boundary: Rect(0.0, 0.0, 5.0, 5.0), maxElements: 2)

        XCTAssertTrue(tree.insert(Rect(1.0, 1.0, 2.0, 2.0)), "Something went wrong inserting the rectangle.")
    }

    func testAddOneMoreThanMaxObjectsAtALevelAndStillFindIt() {
        let tree = CTSQuadTreeRect(boundary: Rect(0.0, 0.0, 5.0, 5.0), maxElements: 2)

        XCTAssertTrue(tree.insert(Rect(1.0, 1.0, 2.0, 2.0)), "Something went wrong inserting the first rectangle.")
        XCTAssertTrue(tree.insert(Rect(2.5, 2.5, 3.0, 3.0)), "Something went wrong inserting the second rectangle.")
        XCTAssertTrue(tree.insert(Rect(2.8, 2.8, 2.9, 2.9)), "Something went wrong inserting the third rectangle.")

        let result = tree.find(Rect(2.7, 2.7, 3.0, 3.0))

        XCTAssertEqual(1, result.count, "Strange, did not find the rectangle.")
        XCTAssertEqual(Rect(2.8, 2.8, 2.9, 2.9), result.first, "The rectangles should match.")
    }

    func testAddARectOnTheBoundaryBetweenSplitsAndStillFindIt() {
        let tree = CTSQuadTreeRect(boundary: Rect(0.0, 0.0, 5.0, 5.0), maxElements: 2)

        // Fill up level 0
        XCTAssertTrue(tree.insert(Rect(1.0, 1.0, 2.0, 2.0)), "Fits on the first level.")
        XCTAssertTrue(tree.insert(Rect(2.5, 2.5, 3.0, 3.0)), "Fits on the first level.")

        // Add a rectangle on the boundary
        XCTAssertTrue(tree.insert(Rect(2.4, 2.4, 2.6, 2.6)), "After the split goes on the first level.")

        // Search on the boundary
        let result = tree.find(Rect(2.4, 2.4, 2.7, 2.7))

        XCTAssertEqual(1, result.count, "Should find the one rectangle")
        XCTAssertEqual(Rect(2.4, 2.4, 2.6, 2.6), result.first, "Finds the rectangle on the boundary")
    }
}
