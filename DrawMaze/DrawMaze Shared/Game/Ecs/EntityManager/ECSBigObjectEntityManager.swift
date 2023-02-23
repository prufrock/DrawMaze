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

    //TODO: what if there were many scenes(hud, world), each with its own uniforms like camera?
    //rebuild the scene graph each time it's needed -- may only want to do when it's dirty
    var scene: ECSSceneGraph
    {
        var scene = ECSSceneGraph()
        for entity in entities {
            if let component = entity.graphics {
                scene.addChild(data: component)
            }
        }
        return scene
    }

    //TODO: convert to a quad tree
    //TODO: rebuild the collision list each time it's needed -- may only want to do when it's dirty
    private var collisions: [ECSCollision]
    {
        var collection: [ECSCollision] = []
        for entity in entities {
            if let component = entity.collision {
                collection.append(component)
            }
        }
        return collection
    }

    mutating func createDecoration(id: String, position: Float2) -> ECSEntity {
        let graphics = ECSGraphics(entityID: id, uprightToWorld: Float4x4.translate(position))
        let entity = ECSEntity(id: id, graphics: graphics)

        update(entity)

        return entity
    }

    mutating func createToggleButton(id: String, position: Float2) -> ECSEntity {
        let radius: Float = 0.5
        let toggleButton = ECSToggleButton(entityID: id, toggledAction: { _, _, _ in print("toggled")}, notToggledAction: { _, _, _ in print("not toggled")})
        let graphics = ECSGraphics(
            entityID: id,
            color: toggleButton.notToggledColor,
            uprightToWorld: Float4x4.translate(position) * Float4x4.scale(x: 0.5, y: 0.5, z: 1.0)
        )
        let collision = ECSCollision(entityID: id, radius: radius, position: position)
        let entity = ECSEntity(id: id, toggleButton: toggleButton, graphics: graphics, collision: collision)

        update(entity)

        return entity
    }

    mutating func createToggleButton(
        id: String,
        position: Float2,
        toggledAction: @escaping (GameInput, inout ECSEntity, inout World) -> Void,
        notToggledAction: @escaping (GameInput, inout ECSEntity, inout World) -> Void
    ) -> ECSEntity {
        let radius: Float = 0.5
        let toggleButton = ECSToggleButton(entityID: id, toggledAction: toggledAction, notToggledAction: notToggledAction)
        let graphics = ECSGraphics(
            entityID: id,
            color: toggleButton.notToggledColor,
            uprightToWorld: Float4x4.translate(position) * Float4x4.scale(x: 0.5, y: 0.5, z: 1.0)
        )
        let collision = ECSCollision(entityID: id, radius: radius, position: position)
        let entity = ECSEntity(id: id, toggleButton: toggleButton, graphics: graphics, collision: collision)

        update(entity)

        return entity
    }

    /**
     * Create a prop: an entity that can be collided with.
     */
    mutating func createProp(id: String, position: Float2, radius: Float, camera: ECSGraphics.Camera = .world) -> ECSEntity {
        let graphics = ECSGraphics(
            entityID: id,
            color: Float4(0.0, 0.0, 1.0, 1.0),
            uprightToWorld: Float4x4.translate(position) * Float4x4.scale(x: radius, y: radius, z: 1.0),
            camera: camera
        )
        let collision = ECSCollision(entityID: id, radius: radius, position: position)
        let entity = ECSEntity(id: id, graphics: graphics, collision: collision)

        update(entity)

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
        entities = entities.filter { $0.id != entity.id }
        entities.append(entity)
    }
}
