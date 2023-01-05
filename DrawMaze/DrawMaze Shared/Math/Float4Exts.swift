//
// Created by David Kanenwisher on 1/4/23.
//

import Foundation
import simd

typealias Float4 = SIMD4<Float>

public extension Float4 {
    var xyz: Float3 {
        Float3(x: x, y: y, z: z)
    }

    /**
     * Converts a position from a Float2.
     * w=1.0 so it can be translated.
     */
    init(position value: Float2) {
        self.init(value.x, value.y, 0.0, 1.0)
    }
}