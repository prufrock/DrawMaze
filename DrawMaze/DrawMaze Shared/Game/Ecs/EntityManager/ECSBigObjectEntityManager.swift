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

    // One day it'll be a graph
    var sceneGraph: [ECSGraphics] = []

    mutating func createDecoration(id: String, position: Float2) -> ECSEntity {
        let graphics = ECSGraphics(entityID: id, uprightToWorld: Float4x4.translate(position))
        let entity = ECSEntity(id: id, graphics: graphics)

        entities.append(entity)
        sceneGraph.append(graphics)

        return entity
    }
}
