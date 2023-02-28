//
// Created by David Kanenwisher on 2/23/23.
//

import simd

public struct ECSCamera: ECSComponent {
    var entityID: String

    var aspect: Float
    var fov: Float = .pi / 2
    var nearPlane: Float = 0.1
    var farPlane: Float = 20
    var position3d: F3 = F3(0.0, 0.0, 0.0)

    private let worldToView: (Self) -> Float4x4

    init(entityID: String, aspect: Float, position3d: Float3, worldToView: @escaping (Self) -> Float4x4) {
        self.entityID = entityID
        self.aspect = aspect
        self.worldToView = worldToView
        self.position3d = position3d
    }

    func projection() -> Float4x4 {
        worldToView(self)
    }

    mutating func update(input: GameInput, entity: inout ECSEntity, world: inout World) {
        aspect = input.externalInput.aspect
    }
}
