//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

final class FloatExtTests: XCTestCase {

    private let accuracy = HLP.accuracy

    func testRoundDown() throws {
        XCTAssertEqual(1, Float(1.6).roundDown())
    }

    func testConvertToRadians() throws {
        XCTAssertEqual(0, Float(0).toRadians())
        XCTAssertEqual(.pi/4, Float(45).toRadians(), accuracy: accuracy)
        XCTAssertEqual(.pi/2, Float(90).toRadians(), accuracy: accuracy)
        XCTAssertEqual(.pi, Float(180).toRadians(), accuracy: accuracy)
        XCTAssertEqual((3 * .pi)/2, Float(270).toRadians(), accuracy: accuracy)
    }
}
