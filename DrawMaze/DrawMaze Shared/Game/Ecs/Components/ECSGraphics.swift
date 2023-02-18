//
// Created by David Kanenwisher on 2/14/23.
//

import Foundation

struct ECSGraphics: ECSComponent {
    var entityID: String
    var color: Float4 = Float4(Color.orange)
    var uprightToWorld: Float4x4
}
