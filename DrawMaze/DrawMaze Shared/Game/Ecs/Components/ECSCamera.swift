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
    var rotation2d = Float2(0.0,-1.0)
    var rotation3d = Float4x4.identity()
    var speed: Float = 0

    private let worldToView: (Self) -> Float4x4

    init(entityID: String, aspect: Float, speed: Float = 0, position3d: Float3, worldToView: @escaping (Self) -> Float4x4) {
        self.entityID = entityID
        self.aspect = aspect
        self.worldToView = worldToView
        self.position3d = position3d
        self.speed = speed
    }

    func projection() -> Float4x4 {
        worldToView(self)
    }

    mutating func update(input: GameInput, entity: inout ECSEntity, world: inout World) {
        aspect = input.externalInput.aspect
        rotation3d *= input.externalInput.rotation3d

        rotation2d = input.externalInput.rotation * rotation2d
        let velocity: F2 = rotation2d * input.externalInput.speed * speed
        if (entityID == "floating-camera") {
            print("rotation2d \(rotation2d)")
            print("input speed \(input.externalInput.speed)")
            print("speed \(speed)")
            print("velocity \(velocity)")
        }
        position3d = position3d + F3(velocity.x, velocity.y, 0.0) * input.externalInput.timeStep
    }
}
