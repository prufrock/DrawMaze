//
// Created by David Kanenwisher on 2/14/23.
//

import Foundation
import simd

/**
 * Manages Entities that are big objects composed of all their components rather than
 * all separate objects.
 */
struct ECSBigObjectEntityManager: ECSEntityManager {
    var entities: [ECSEntity] = []

    var scene = ECSSceneGraph()

    //TODO: convert to a quad tree
    private var collisions: [ECSCollision] = []

    mutating func createDecoration(id: String, position: Float2) -> ECSEntity {
        let graphics = ECSGraphics(entityID: id, uprightToWorld: Float4x4.translate(position))
        let entity = ECSEntity(id: id, graphics: graphics)

        entities.append(entity)
        scene.addChild(data: graphics)

        return entity
    }

    mutating func createToggleButton(id: String, position: Float2) -> ECSEntity {
        let radius: Float = 0.5
        let graphics = ECSGraphics(
            entityID: id,
            color: F4(Color.green),
            uprightToWorld: Float4x4.translate(position) * Float4x4.scale(x: 0.5, y: 0.5, z: 1.0)
        )
        let collision = ECSCollision(entityID: id, radius: radius, position: position)
        let toggleButton = ECSToggleButton(entityID: id)
        let entity = ECSEntity(id: id, toggleButton: toggleButton, graphics: graphics, collision: collision)

        entities.append(entity)
        collisions.append(collision)
        scene.addChild(data: graphics)

        return entity
    }

    public func collides(with rect: Rect) -> [ECSCollision] {
        collisions.filter { rect.intersection(with: $0.rect) != nil }
    }

    public func find(_ entityId: String) -> ECSEntity? {
        // eventually get a map or something on entityId
        entities.first{ $0.id == entityId }
    }

    mutating public func update(_ entity: ECSEntity) {
        //TODO: this might need to be cleaned up a little
        entities.remove(at: entities.firstIndex { $0.id == entity.id }!)
        entities.append(entity)

        collisions = collisions.filter { $0.entityID != entity.id }
        if let collision = entity.collision {
            collisions.append(collision)
        }

        var graphics = scene.filter { $0.entityID != entity.id }
        if let graphic = entity.graphics {
            graphics.append(graphic)
        }
        scene = ECSSceneGraph()
        graphics.forEach { scene.addChild(data: $0) }
    }
}
