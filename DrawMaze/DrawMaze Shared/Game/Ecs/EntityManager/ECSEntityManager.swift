//
// Created by David Kanenwisher on 2/14/23.
//

import Foundation

protocol ECSEntityManager {
    var entities: [ECSEntity] { get }

    // one day it will be a graph
    var scene: ECSSceneGraph { get }

    @discardableResult
    mutating func createDecoration(id: String, position: Float2) -> ECSEntity

    @discardableResult
    mutating func createToggleButton(id: String, position: Float2) -> ECSEntity

    @discardableResult
    mutating func createToggleButton(id: String, position: Float2, toggledAction: @escaping (GameInput, inout ECSEntity, inout World) -> Void, notToggledAction: @escaping (GameInput, inout ECSEntity, inout World) -> Void) -> ECSEntity

    @discardableResult
    mutating func createProp(id: String, position: Float2, radius: Float, camera: ECSGraphics.Camera) -> ECSEntity

    @discardableResult
    func collides(with rect: Rect) -> [ECSCollision]

    func find(_ entityId: String) -> ECSEntity?

    mutating func update(_: ECSEntity)
}
