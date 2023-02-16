//
// Created by David Kanenwisher on 2/14/23.
//

import Foundation

protocol ECSEntityManager {
    var entities: [ECSEntity] { get }

    // one day it will be a graph
    var sceneGraph: [ECSGraphics] { get }

    @discardableResult
    mutating func createDecoration(id: String, position: Float2) -> ECSEntity
}
