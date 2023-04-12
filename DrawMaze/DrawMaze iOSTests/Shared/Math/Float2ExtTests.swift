//
//  Created by David Kanenwisher on 02/02/23.
//

import XCTest
@testable import DrawMaze_iOS
import simd

final class Float2ExtTests: XCTestCase {

    let pTriple = F2(3.0, 4.0) // pythagorean triple 🤓

    let entityCamera: ECSCamera = {
        let worldToView: (ECSCamera) -> Float4x4 = { component in
            Float4x4.perspectiveProjection(fov: .pi/2, aspect: component.aspect, nearPlane: 0.1, farPlane: 20.0)
        }
        return ECSCamera(entityID: "camera-1", aspect: 1.0, position3d: F3(0.0, 0.0, 0.0), stationary: true, worldToView: worldToView)
    }()

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
        let camera = entityCamera

        var v = F2(-1.0, 1.0)
        var u = v.ndcToWorld(camera: camera)
        XCTAssertEqual(-0.9999998, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.9999998, u.y, accuracy: HLP.accuracy)

        v = F2(-0.5, 0.5)
        u = v.ndcToWorld(camera: camera)
        XCTAssertEqual(-0.4999999, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.4999999, u.y, accuracy: HLP.accuracy)

        v = F2(0.0, 0.0)
        u = v.ndcToWorld(camera: camera)
        XCTAssertEqual(0.0, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.0, u.y, accuracy: HLP.accuracy)

        v = F2(0.5, 0.5)
        u = v.ndcToWorld(camera: camera)
        XCTAssertEqual(0.4999999, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.4999999, u.y, accuracy: HLP.accuracy)

        v = F2(1.0, 1.0)
        u = v.ndcToWorld(camera: camera)
        XCTAssertEqual(0.9999998, u.x, accuracy: HLP.accuracy)
        XCTAssertEqual(0.9999998, u.y, accuracy: HLP.accuracy)
    }
}
