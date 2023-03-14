//
//  Created by David Kanenwisher on 02/01/23.
//

import XCTest
@testable import DrawMaze_iOS
import simd

final class Float2x2ExtTests: XCTestCase {

    private let accuracy = HLP.accuracy

    func testScale() throws {
        let start = F3(2.1, 2.2, 2.3)
        let end = Float3x3.scale(x: 2.0, y: 3.0, z: 1.0) * start
        XCTAssertEqual(4.2, end.x, accuracy: accuracy)
        XCTAssertEqual(6.6, end.y, accuracy: accuracy)
        XCTAssertEqual(2.3, end.z, accuracy: accuracy)
    }

    func testTranslate() throws {
        let start = F3(2.1, 2.2, 1.0)
        let end = Float3x3.translate(x: 2.0, y: 3.0, z: 1.0) * start
        XCTAssertEqual(4.1, end.x, accuracy: accuracy)
        XCTAssertEqual(5.2, end.y, accuracy: accuracy)
        XCTAssertEqual(1.0, end.z, accuracy: accuracy)
    }
}
