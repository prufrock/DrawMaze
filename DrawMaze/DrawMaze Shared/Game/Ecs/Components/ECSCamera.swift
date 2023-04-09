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
        let velocity: F2 = rotation2d * speed

        position3d = position3d + F3(velocity.x, velocity.y, 0.0) * input.externalInput.timeStep
        if var collision = entity.collision, entityID == "floating-camera" {
            collision.position = F2(position3d.x, position3d.y)

            world.entityManager.collides(with: collision.rect, prefix: "wall").filter { $0.entityID != entityID }.forEach {
                print("thump! collided with \($0.entityID)")
                var limit = 10

                while (limit > 0) {
                    let intersection = collision.rect.intersection(with: $0.rect)
                    if let intersection = intersection {
                        collision.position -= intersection
                    }
                    limit -= 1
                }
                entity.collision = collision
                position3d = F3(collision.position.x, collision.position.y, position3d.z)
            }
        }

        if var graphics = entity.graphics, let collision = entity.collision {
            graphics.uprightToWorld = Float4x4.translate(F2(position3d.x, position3d.y)) * Float4x4.scale(x: collision.radius, y: collision.radius, z: 1.0)
            entity.graphics = graphics
        }
    }

    mutating func receive(message: ECSMessage) {
        switch message {
        case .UpdateAspectRatio(let aspect):
            self.aspect = aspect
        case .UpdateSpeed(let speed):
            self.speed = speed
        case .UpdateRotation(let rotation2d, let rotation3d):
            self.rotation2d = rotation2d * self.rotation2d
            self.rotation3d *= rotation3d
        }
    }
}
