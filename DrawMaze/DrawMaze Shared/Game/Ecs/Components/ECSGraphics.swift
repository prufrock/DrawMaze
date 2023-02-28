//
// Created by David Kanenwisher on 2/14/23.
//

import Foundation

struct ECSGraphics: ECSComponent {
    var entityID: String
    var color: Float4 = Float4(Color.orange)
    var uprightToWorld: Float4x4 = Float4x4.identity()
    var camera: Camera = .hud
    var hidden: Bool = false

    enum Camera {
        case hud
        case world
    }
}
