//
//  Created by David Kanenwisher on 02/02/23.
//

import XCTest
@testable import DrawMaze_iOS
import simd

final class Float2ExtTests: XCTestCase {

    let pTriple = F2(3.0, 4.0) // pythagorean triple 🤓

    func testLength() throws {
        XCTAssertEqual(5.0, pTriple.length)
    }

    func testOrthogonal() throws {
        let f2 = F2(3.0, 4.0)
        XCTAssertEqual(F2(-4.0, 3.0), f2.orthogonal)
    }

    func testFromIntegers() throws {
        XCTAssertEqual(F2(2.0, 3.0), F2(2, 3))
    }

    func testToFloat3() throws {
        XCTAssertEqual(F3(3.0, 4.0, 0.0), pTriple.toFloat3())
        XCTAssertEqual(F3(3.0, 4.0, 0.0), pTriple.f3)
    }

    func testRotatedBy() throws {
        let rotated = pTriple.rotated(by: Float2x2.rotate(90.f.toRadians()))
        XCTAssertEqual(-4.0, rotated.x, accuracy: HLP.accuracy)
        XCTAssertEqual(3.0, rotated.y, accuracy: HLP.accuracy)
    }

    func testToTranslation() throws {
        let translation = pTriple.toTranslation()
        let point = F4(1.0, 1.0, 1.0, 1.0)
        let result = translation * point
        XCTAssertEqual(4.0, result.x)
        XCTAssertEqual(5.0, result.y)
        XCTAssertEqual(1.0, result.z)
        XCTAssertEqual(1.0, result.w)
    }

    func testScreenToNdc() throws {
        var v = F2(0.0, 0.0)
        XCTAssertEqual(F2(-1.0, 1.0), v.screenToNdc(screenWidth: 100.0, screenHeight: 100))
        XCTAssertEqual(F2(-1.0, -1.0), v.screenToNdc(screenWidth: 100.0, screenHeight: 100, flipY: false))

        v = F2(25.0, 25.0)
        XCTAssertEqual(F2(-0.5, 0.5), v.screenToNdc(screenWidth: 100.0, screenHeight: 100))
        XCTAssertEqual(F2(-0.5, -0.5), v.screenToNdc(screenWidth: 100.0, screenHeight: 100, flipY: false))

        v = F2(50.0, 50.0)
        XCTAssertEqual(F2(0.0, 0.0), v.screenToNdc(screenWidth: 100.0, screenHeight: 100))
        XCTAssertEqual(F2(0.0, 0.0), v.screenToNdc(screenWidth: 100.0, screenHeight: 100, flipY: false))

        v = F2(75.0, 75.0)
        XCTAssertEqual(F2(0.5, -0.5), v.screenToNdc(screenWidth: 100.0, screenHeight: 100))
        XCTAssertEqual(F2(0.5, 0.5), v.screenToNdc(screenWidth: 100.0, screenHeight: 100, flipY: false))

        v = F2(100.0, 100.0)
        XCTAssertEqual(F2(1.0, -1.0), v.screenToNdc(screenWidth: 100.0, screenHeight: 100))
        XCTAssertEqual(F2(1.0, 1.0), v.screenToNdc(screenWidth: 100.0, screenHeight: 100, flipY: false))
    }

    func testNdcToWorld() {
        let camera = TestCamera()

        var v = F2(-1.0, 1.0)
        var u = v.ndcToWorld(camera: camera, aspect: 1.0)
        XCTAssertEqual(-0.9999998, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.9999998, u.y, accuracy: HLP.accuracy)

        v = F2(-0.5, 0.5)
        u = v.ndcToWorld(camera: camera, aspect: 1.0)
        XCTAssertEqual(-0.4999999, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.4999999, u.y, accuracy: HLP.accuracy)

        v = F2(0.0, 0.0)
        u = v.ndcToWorld(camera: camera, aspect: 1.0)
        XCTAssertEqual(0.0, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.0, u.y, accuracy: HLP.accuracy)

        v = F2(0.5, 0.5)
        u = v.ndcToWorld(camera: camera, aspect: 1.0)
        XCTAssertEqual(0.4999999, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.4999999, u.y, accuracy: HLP.accuracy)

        v = F2(1.0, 1.0)
        u = v.ndcToWorld(camera: camera, aspect: 1.0)
        XCTAssertEqual(0.9999998, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.9999998, u.y, accuracy: HLP.accuracy)
    }

    struct TestCamera: Camera {
        var position3d: DrawMaze_iOS.F3 = F3()

        func worldToView(fov: Float, aspect: Float, nearPlane: Float, farPlane: Float) -> DrawMaze_iOS.Float4x4 {
            Float4x4.perspectiveProjection(fov: fov, aspect: aspect, nearPlane: nearPlane, farPlane: farPlane)
        }

        var position: DrawMaze_iOS.F2 = F2()

        var model: DrawMaze_iOS.BasicModels = .square

        var color: DrawMaze_iOS.Float3 = F3()

        var radius: Float = 0.5

        var modelToUpright: DrawMaze_iOS.Float4x4 = Float4x4()

        var uprightToWorld: DrawMaze_iOS.Float4x4 = Float4x4()
    }
}
