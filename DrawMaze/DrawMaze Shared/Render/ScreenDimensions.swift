//
// Created by David Kanenwisher on 1/7/23.
//

import Foundation

struct ScreenDimensions {
    let width: Float
    let height: Float

    init(width: Double, height: Double) {
        self.width = width.f
        self.height = height.f
    }
}
