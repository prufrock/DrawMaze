//
// Created by David Kanenwisher on 1/11/23.
//

import simd

struct Button: Actor {
    var radius: Float = 0.5
    var position: F2 = F2(0.0, 0.0)
    var model: BasicModels

    var color: Float3 = Float3(0.0, 0.5, 1.0)

    init(centeredIn: F2, model: BasicModels = .square, color: Float3) {
        self.position = centeredIn + F2(0.5, 0.5)
        self.model = model
        self.color = color
    }

    var modelToUpright:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.translate(x: position.x, y: position.y, z: 0.0) *
                Float4x4.scale(x: radius, y: radius, z: radius)
        }
    }
}