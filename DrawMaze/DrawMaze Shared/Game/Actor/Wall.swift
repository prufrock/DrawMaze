//
// Created by David Kanenwisher on 1/7/23.
//

import Foundation

import simd

struct Wall: Actor {
    var radius: Float = 0.5
    var position = F2(0.0, 0.0) // world
    var model: BasicModels

    var color: Float3 = Float3(0.0, 0.0, 1.0)

    var modelToUpright:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.translate(x: position.x, y: position.y, z: 0.0) *
                Float4x4.scale(x: 0.5, y: 0.5, z: 0.5)
        }
    }
}