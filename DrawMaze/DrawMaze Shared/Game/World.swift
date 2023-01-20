//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

/**
 - Going to see if I can get by with just the config from AppCore for now.
 */
struct World {
    private let config: AppCoreConfig.Game.World

    private(set) var map: TileMap

    var actors: [Actor] {
        get {
            var list: [Actor] = []

            if let clicked = touchLocation {
                list.append(clicked)
            }
            list.append(contentsOf: buttons)
            list.append(contentsOf: walls)

            return list
        }
    }

    private var walls: [Wall]

    public var camera: Camera?
    private var overHeadCamera: Camera?
    private var floatingCamera: Camera?
    private var hudCamera = HudCamera(model: .square)

    private var touchLocation: TouchLocation?

    private var selectedButtonId: Int = -1
    
    private var buttons: [Button] = []

    // The UI used to create a maze. I expect this eventually needs to get more complicated but going with it for now.
    private var drawMazeUI: [Button] = []

    init(config: AppCoreConfig.Game.World, map:  TileMap) {
        self.config = config
        self.map = map
        walls = []
        drawMazeUI = [
        ]
        // 10 across
        // 20 down
        for i in 0...200 {
            let x = i % 10
            let y = i / 10
            drawMazeUI.append(Button(centeredIn: F2(x.f, y.f), model: .square, color: F3(0, 0.2, 0)))

        }
        buttons = drawMazeUI
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
        if (input.isTouched) {
            let position = input.touchCoordinates
                    .toNdcSpace(screenWidth: input.viewWidth, screenHeight: input.viewHeight, flipY: true)
                    .toWorldSpace(camera: camera!, aspect: input.aspect)
            let location = TouchLocation(position: position, model: .square)
            touchLocation = location

            selectedButtonId = pickButtonId(at: location)
        }

        // Update buttons
        for i in (0 ..< buttons.count) {
            if i == selectedButtonId {
                var button = buttons[i]
                button.color = Float3(0.0, 0.6, 0.0)
                buttons[i] = button
            } else {
                var button = buttons[i]
                button.color = Float3(0.5, 0.5, 1.0)
                buttons[i] = button
            }
        }
    }

    private mutating func pickButtonId(at location: TouchLocation) -> Int {
        var largestIntersectedButtonIndex: Int = -1
        var largestIntersection: Float2?
        for i in (0 ..< buttons.count) {
            if let intersection = location.intersection(with: buttons[i]),
               intersection.length > largestIntersection?.length ?? 0 {
                largestIntersection = intersection
                largestIntersectedButtonIndex = i
            }
        }

        return largestIntersectedButtonIndex
    }
}
