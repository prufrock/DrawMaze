//
// Created by David Kanenwisher on 2/23/23.
//

import simd

public struct ECSCamera: ECSComponent {
    var entityID: String

    var aspect: Float

    private let worldToView: (Self) -> Float4x4

    init(entityID: String, aspect: Float, worldToView: @escaping (Self) -> Float4x4) {
        self.entityID = entityID
        self.aspect = aspect
        self.worldToView = worldToView
    }

    func projection() -> Float4x4 {
        worldToView(self)
    }

    mutating func update(input: GameInput, entity: inout ECSEntity, world: inout World) {
        aspect = input.externalInput.aspect
    }
}