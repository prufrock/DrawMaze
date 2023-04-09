//
// Created by David Kanenwisher on 2/17/23.
//

import Foundation

struct ECSCollision: ECSComponent {
    mutating func update(input: GameInput, entity: inout ECSEntity, world: inout World) {
    }

    var entityID: String
    var radius: Float = 0.5
    var position: F2 = F2(0.0, 0.0)
    var hidden = false

    var rect: Rect {
        let halfSize = Float2(radius, radius)
        // the rectangle is centered on the position
        return Rect(min: position - halfSize, max: position + halfSize)
    }

    func intersection(with other: Rect) -> Float2? {
        rect.intersection(with: other)
    }
}
