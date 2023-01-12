//
// Created by David Kanenwisher on 1/10/23.
//

import simd

struct TouchLocation: Actor {
    var position = F2(0.0, 0.0)
    var model: BasicModels
    var radius: Float = 0.12

    var color: Float3 = Float3(0.5, 0.5, 0.0)

    var modelToUpright:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.translate(x: position.x, y: position.y, z: 0.0)
                * Float4x4.scale(x: radius, y: radius, z: 0.0)
        }
    }
}
