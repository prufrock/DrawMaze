//
//  Created by David Kanenwisher on 02/01/23.
//

import XCTest
@testable import DrawMaze_iOS

final class Float3ExtTests: XCTestCase {

    func testLength() throws {
        let f3 = F3(2.0, 3.0, 6.0) // pythagorean quadruple 🤓
        XCTAssertEqual(7.0, f3.length)
    }

    func testToFloat2() throws {
        let f3 = F3(2.0, 3.0, 6.0)
        XCTAssertEqual(F2(2.0, 3.0), f3.f2)
    }
}
