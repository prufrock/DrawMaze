//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

struct World {
    private(set) var map: TileMap

    var actors: [Actor] {
        get {
            var list: [Actor] = []

            if let clicked = clickLocation {
                list.append(clicked)
            }
            list.append(contentsOf: buttons)
            list.append(contentsOf: walls)

            return list
        }
    }

    var walls: [Wall]

    var camera: Camera?
    var overHeadCamera: Camera?
    var floatingCamera: Camera?
    var hudCamera = HudCamera(model: .square)

    var clickLocation: TouchLocation?
    
    var buttons: [Button] = []

    init(map:  TileMap) {
        self.map = map
        walls = []
        buttons = [
            Button(position: F2(0.0, 0.0), model: .square, color: F3(0, 0.2, 0)),
            Button(position: F2(1.0, 1.0), model: .square, color: F3(0, 0.2, 0)),
            Button(position: F2(1.0, 0.0), model: .square, color: F3(0, 0.2, 0)),
            Button(position: F2(0.0, 1.0), model: .square, color: F3(0, 0.2, 0))
        ]
        reset()
    }

    /**
     Set the world back to how it all began...
     */
    private mutating func reset() {
        overHeadCamera = CameraOverhead(position: Float2(0.0, 0.0), model: .square) // world
        floatingCamera = CameraFloating(position: Float2(0.0, 0.0), model: .square) // world
        camera = hudCamera

        for y in 0..<map.height {
            for x in 0..<map.width {
                let position = Float2(x: Float(x) + 0.5, y: Float(y) + 0.5) // world, in the center of the tile
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

        var worldPosition: F2? = nil
        if (input.isTouched) {
            let ndcPosition = input.touchCoordinates.toNdcSpace(screenWidth: input.viewWidth, screenHeight: input.viewHeight, flipY: true)
            worldPosition = ndcPosition.toWorldSpace(camera: camera!, aspect: input.aspect)
            clickLocation = TouchLocation(model: .square).run { location in
                var newLocation = location
                newLocation.position = worldPosition!
                return newLocation
            }

            // This is *real* ugly but it ensures that an overlapping click only picks a single button by selecting
            // the first one with the largest intersection with the click location.
            if let location = clickLocation {
                var largestIntersection: Float2?
                var largestIntersectedButtonIndex: Int?
                for i in (0 ..< buttons.count) {
                    if let intersection = location.intersection(with: buttons[i]),
                       intersection.length > largestIntersection?.length ?? 0 {
                        var button = buttons[i]
                        button.color = Float3(0.0, 0.5, 1.0)
                        buttons[i] = button
                        largestIntersection = intersection
                        largestIntersectedButtonIndex = i
                    } else {
                        var button = buttons[i]
                        button.color = Float3(0.0, 0.5, 1.0)
                        buttons[i] = button
                    }
                }
                if let chosenIndex = largestIntersectedButtonIndex {
                    var button = buttons[chosenIndex]
                    button.color = Float3(1.0, 0.5, 1.0)
                    buttons[chosenIndex] = button
                }
            }
        }
    }
}
