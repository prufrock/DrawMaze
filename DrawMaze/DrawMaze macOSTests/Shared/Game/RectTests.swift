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
}
