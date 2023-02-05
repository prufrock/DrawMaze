//
//  Created by David Kanenwisher on 02/02/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSQuadTreeListTests: XCTestCase {
    func testInsert() throws {
        let t = CTSQuadTreeList(boundary: Rect(min: F2(0.0, 0.0), max: F2(5.0.f)))

        XCTAssertEqual(false, t.insert(Float2(6.0, 6.0)))
        XCTAssertEqual(true, t.insert(Float2(1.0, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.1, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.2, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.3, 1.0)))
        XCTAssertEqual(true, t.insert(Float2(1.4, 1.0)))
    }
}
