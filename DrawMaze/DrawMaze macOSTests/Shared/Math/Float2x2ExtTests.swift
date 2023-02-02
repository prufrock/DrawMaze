//
//  Created by David Kanenwisher on 02/01/23.
//

import XCTest
@testable import DrawMaze_iOS
import simd

final class Float3x3ExtTests: XCTestCase {

    private let accuracy = HLP.accuracy

    func testScale() throws {
        let start = F2(2.1, 2.2)
        let end = Float2x2.scale(x: 2.0, y: 3.0) * start
        XCTAssertEqual(4.2, end.x, accuracy: accuracy)
        XCTAssertEqual(6.6, end.y, accuracy: accuracy)
    }

    func testRotate() throws {
        let start = F2(2.1, 2.2)
        var end = Float2x2.rotate(90.f.toRadians()) * start
        XCTAssertEqual(-2.2, end.x, accuracy: accuracy)
        XCTAssertEqual(2.1, end.y, accuracy: accuracy)

        end = Float2x2.rotate(sine: sin(90.f.toRadians()), cosine: cos(90.f.toRadians())) * start
        XCTAssertEqual(-2.2, end.x, accuracy: accuracy)
        XCTAssertEqual(2.1, end.y, accuracy: accuracy)
    }
}
