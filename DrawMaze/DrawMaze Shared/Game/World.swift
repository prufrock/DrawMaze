//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

struct World {
    private(set) var map: TileMap

    var actors: [Actor] {
        get {
            var list: [Actor] = []

            list.append(contentsOf: walls)

            return list
        }
    }

    var walls: [Wall]

    var camera: Camera?
    var overHeadCamera: Camera?
    var floatingCamera: Camera?

    init(map:  TileMap) {
        self.map = map
        walls = []
        reset()
    }

    /**
     Set the world back to how it all began...
     */
    private mutating func reset() {
        overHeadCamera = CameraOverhead(position: Float2(0.0, 0.0), model: .square)
        floatingCamera = CameraFloating(position: Float2(0.0, 0.0), model: .square)
        camera = overHeadCamera

        for y in 0..<map.height {
            for x in 0..<map.width {
                let position = Float2(x: Float(x) + 0.5, y: Float(y) + 0.5) // in the center of the tile
                let tile = map[x, y]
                switch tile {
                case .floor:
                    // not going to render floors for now
                    break
                case .wall:
                    walls.append(Wall(position: position, model: .square))
                }
            }
        }
    }


    /**
     Update the game.
     - Parameters:
       - timeStep: The amount of time to move it forward.
       - input: The actionable changes in the game from the ViewController.
     */
    mutating func update(timeStep: Float, input: Input) {

    }
}
