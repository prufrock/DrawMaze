import XCTest
@testable import DrawMaze_iOS

import simd

final class Float4x4ExtTests: XCTestCase {

    private let accuracy: Float = HLP.accuracy

    func testTranslate() throws {
        var start = Float4(1.0, 0.0, 0.0, 1.0)
        var end = Float4x4.translate(x: 2.0, y: 0.0, z: 0.0) * start
        XCTAssertEqual(Float4(3.0, 0.0, 0.0, 1.0), end)

        start = Float4(0.0, 1.0, 0.0, 1.0)
        end = Float4x4.translate(x: 0.0, y: 2.0, z: 0.0) * start
        XCTAssertEqual(Float4(0.0, 3.0, 0.0, 1.0), end)

        start = Float4(0.0, 0.0, 1.0, 1.0)
        end = Float4x4.translate(x: 0.0, y: 0.0, z: 2.0) * start
        XCTAssertEqual(Float4(0.0, 0.0, 3.0, 1.0), end)

        // translate F2
        start = Float4(1.0, 0.0, 0.0, 1.0)
        end = Float4x4.translate(F2(3.0, 2.0)) * start
        XCTAssertEqual(Float4(4.0, 2.0, 0.0, 1.0), end)
    }

    func testScale() throws {
        var start = Float4(3.0, 0.0, 0.0, 1.0)
        var end = Float4x4.scale(x: 2.0, y: 1.0, z: 1.0) * start
        XCTAssertEqual(Float4(6.0, 0.0, 0.0, 1.0), end)
        end = Float4x4.scaleX(2.0) * start
        XCTAssertEqual(Float4(6.0, 0.0, 0.0, 1.0), end)

        start = Float4(0.0, 1.0, 0.0, 1.0)
        end = Float4x4.scale(x: 1.0, y: 3.0, z: 1.0) * start
        XCTAssertEqual(Float4(0.0, 3.0, 0.0, 1.0), end)
        end = Float4x4.scaleY(3.0) * start
        XCTAssertEqual(Float4(0.0, 3.0, 0.0, 1.0), end)

        start = Float4(0.0, 0.0, -1.0, 1.0)
        end = Float4x4.scale(x: 1.0, y: 1.0, z: 3.0) * start
        XCTAssertEqual(Float4(0.0, 0.0, -3.0, 1.0), end)
        end = Float4x4.scaleZ(3.0) * start
        XCTAssertEqual(Float4(0.0, 0.0, -3.0, 1.0), end)
    }

    func testRotateX() {
        let start = Float4(1.0, 2.0, 1.0, 1.0)
        let end = Float4x4.rotateX(90.0.f.toRadians()) * start
        XCTAssertEqual(1.0.f, end.x)
        XCTAssertEqual(-1.0.f, end.y, accuracy: accuracy)
        XCTAssertEqual(2.0.f, end.z, accuracy: accuracy)
        XCTAssertEqual(1.0.f, end.w)
    }

    func testRotateY() {
        let start = Float4(2.0, 1.0, 3.0, 1.0)
        let end = Float4x4.rotateY(90.0.f.toRadians()) * start
        XCTAssertEqual(3.0.f, end.x, accuracy: accuracy)
        XCTAssertEqual(1.0.f, end.y)
        XCTAssertEqual(-2.0.f, end.z, accuracy: accuracy)
        XCTAssertEqual(1.0.f, end.w)
    }

    func testRotateZ() {
        let start = Float4(2.0, -3.0, 1.0, 1.0)
        let end = Float4x4.rotateZ(90.0.f.toRadians()) * start
        XCTAssertEqual(3.0.f, end.x, accuracy: accuracy)
        XCTAssertEqual(2.0.f, end.y, accuracy: accuracy)
        XCTAssertEqual(1.0.f, end.z)
        XCTAssertEqual(1.0.f, end.w)
    }

    func testPerspectiveProjection() {
        let start = Float4(0.2, 0.3, 0.5, 1.0)
        let end = Float4x4.perspectiveProjection(fov: 60.0.f.toRadians(), aspect: 1.0, nearPlane: 0.1, farPlane: 10.0) * start
        XCTAssertEqual(0.34641019.f, end.x, accuracy: accuracy)
        XCTAssertEqual(0.5196153.f, end.y, accuracy: accuracy)
        XCTAssertEqual(0.40404043.f, end.z, accuracy: accuracy)
        XCTAssertEqual(0.5.f, end.w, accuracy: accuracy)
    }

    func testUpperLeft() {
        XCTAssertEqual(
            Float3x3(
                [2.0, 3.0, 4.0],
                [2.1, 3.1, 4.1],
                [2.2, 3.2, 4.2]
            ),
            Float4x4(
                [2.0, 3.0, 4.0, 1.0],
                [2.1, 3.1, 4.1, 1.0],
                [2.2, 3.2, 4.2, 1.0],
                [2.3, 3.3, 4.3, 1.0]).upperLeft()
        )
    }
}
