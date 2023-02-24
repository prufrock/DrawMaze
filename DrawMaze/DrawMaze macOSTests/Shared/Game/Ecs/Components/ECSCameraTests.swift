//
// Created by David Kanenwisher on 2/18/23.
//

import Foundation
import simd

import XCTest
@testable import DrawMaze_iOS

final class ECSCameraTests: XCTestCase {

    func testDynamicallyAdjustTheAspectRatio() throws {

        var entity = ECSEntity(id: "c1")
        let worldToView: (ECSCamera) -> Float4x4 = { component in
            Float4x4.translate(x: -1, y: 1, z: 0.0) * // 0,0 in world space should be -1, 1 or the upper left corner in NDC.
                Float4x4.scale(x: 0.1, y: 0.1, z: 1.0) *
                Float4x4.scale(x: 1 / component.aspect, y: -1.0, z: 1.0)
        }
        var camera = ECSCamera(entityID: "c1", aspect: 1.0, worldToView: worldToView)

        XCTAssertEqual("c1", camera.entityID)
        let result = camera.projection() * F4(1.0)
        XCTAssertEqual(result.x, -0.9, accuracy: HLP.accuracy)
        XCTAssertEqual(result.y, 0.9, accuracy: HLP.accuracy)
        XCTAssertEqual(result.z, 1.0, accuracy: HLP.accuracy)
        XCTAssertEqual(result.w, 1.0, accuracy: HLP.accuracy)

        // Change the aspect ratio from input
        var world = HLP.world
        var input = HLP.input
        input.aspect = 0.5
        var gameInput = GameInput(externalInput: input)
        camera.update(input: gameInput, entity: &entity, world: &world)

        let resultTwo = camera.projection() * F4(1.0)
        XCTAssertEqual(resultTwo.x, -0.8, accuracy: HLP.accuracy)
        XCTAssertEqual(resultTwo.y, 0.9, accuracy: HLP.accuracy)
        XCTAssertEqual(resultTwo.z, 1.0, accuracy: HLP.accuracy)
        XCTAssertEqual(resultTwo.w, 1.0, accuracy: HLP.accuracy)
    }
}
