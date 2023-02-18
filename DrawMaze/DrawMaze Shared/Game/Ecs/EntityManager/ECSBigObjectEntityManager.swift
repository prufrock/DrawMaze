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
        let graphics = ECSGraphics(entityID: id, uprightToWorld: Float4x4.translate(position))
        let collision = ECSCollision(entityID: id, radius: 0.5, position: position)
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
}
