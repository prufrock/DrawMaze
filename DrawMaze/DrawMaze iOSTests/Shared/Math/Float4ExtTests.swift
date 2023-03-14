//
//  Created by David Kanenwisher on 02/01/23.
//

import XCTest
@testable import DrawMaze_iOS

final class Float4ExtTests: XCTestCase {

    func testXyz() throws {
        let f4 = F4(2.1, 2.2, 2.3, 1.0)
        XCTAssertEqual(F3(2.1, 2.2, 2.3), f4.xyz)
    }
}
