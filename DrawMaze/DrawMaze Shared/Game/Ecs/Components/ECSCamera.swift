//
// Created by David Kanenwisher on 2/23/23.
//

import simd

struct ECSCamera: ECSComponent {
    var entityID: String

    var aspect: Float

    let worldToView: (Self) -> Float4x4

    func projection() -> Float4x4 {
        worldToView(self)
    }

    mutating func update(input: GameInput, entity: inout ECSEntity, world: inout World) {
        aspect = input.externalInput.aspect
    }
}