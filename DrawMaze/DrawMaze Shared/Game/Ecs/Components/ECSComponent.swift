//
// Created by David Kanenwisher on 2/14/23.
//

import Foundation

protocol ECSComponent {
    var entityID: String { get }

    mutating func update(input: GameInput, entity: inout ECSEntity, world: inout World)

    mutating func receive(message: ECSMessage)
}

extension ECSComponent {
    mutating func receive(message: ECSMessage) {
    }
}

enum ECSMessage {
    case UpdateAspectRatio(Float)
    case UpdateSpeed(Float)
    case UpdateRotation(Float2x2, Float4x4)
}