//
//  Created by David Kanenwisher on 02/02/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSQuadTreePointTests: XCTestCase {
    func testInsert() throws {
        let t = CTSQuadTreePoint(boundary: Rect(min: F2(0.0, 0.0), max: F2(5.0.f)))

        XCTAssertEqual(false, t.insert(Float2(6.0, 6.0)))
        XCTAssertEqual(true, t.insert(Float2(1.0, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.1, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.2, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.3, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.4, 1.0)))
    }

    func testFindWhenThereIsOnlyOneNode() throws {
        let t = CTSQuadTreePoint(boundary: Rect(min: F2(0.0, 0.0), max: F2(5.0.f)))
        t.insert(Float2(1.0, 1.0))

        let result = t.find(Rect(min: F2(0.75, 0.75), max: F2(1.25, 1.25)))

        XCTAssertEqual(1, result.count)
        XCTAssertEqual(F2(1.0, 1.0), result.first)
    }

    func testFindWhenTheMatchIsInAPartition() throws {
        let t = CTSQuadTreePoint(boundary: Rect(min: F2(0.0, 0.0), max: F2(5.0.f)))
        t.insert(Float2(5.0, 5.0))
        t.insert(Float2(3.0, 3.0))
        t.insert(Float2(2.0, 2.0))
        t.insert(Float2(2.1, 2.1))
        t.insert(Float2(1.0, 1.0))

        let result = t.find(Rect(min: F2(0.75, 0.75), max: F2(1.25, 1.25)))

        XCTAssertEqual(1, result.count)
        XCTAssertEqual(F2(1.0, 1.0), result.first)
    }
}
