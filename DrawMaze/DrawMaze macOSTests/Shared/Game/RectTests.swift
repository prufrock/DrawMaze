//
//  Created by David Kanenwisher on 02/02/23.
//

import XCTest
@testable import DrawMaze_iOS

final class RectTests: XCTestCase {
    func testContains() throws {
        let r = Rect(min: Float2(0.0, 0.0), max: Float2(5.0, 5.0))

        XCTAssertEqual(false, r.contains(Float2(6.0, 6.0)))
        XCTAssertEqual(false, r.contains(Float2(6.0, 4.0)))
        XCTAssertEqual(true, r.contains(Float2(1.0, 1.0)))
    }

    func testDivide() throws {
        let r = Rect(min: Float2(0.0, 0.0), max: Float2(5.0, 5.0))

        let (ar, br): (Rect, Rect) = r.divide(.vertical)
        XCTAssertEqual(0, ar.min.x)
        XCTAssertEqual(0, ar.min.y)
        XCTAssertEqual(2.5, ar.max.x)
        XCTAssertEqual(5.0, ar.max.y)
        XCTAssertEqual(2.5, br.min.x)
        XCTAssertEqual(0, br.min.y)
        XCTAssertEqual(5.0, br.max.x)
        XCTAssertEqual(5.0, br.max.y)

        let (cr, dr): (Rect, Rect) = r.divide(.horizontal)
        XCTAssertEqual(0, cr.min.y)
        XCTAssertEqual(2.5, cr.max.y)
        XCTAssertEqual(2.5, dr.min.y)
        XCTAssertEqual(5.0, dr.max.y)
    }
}
