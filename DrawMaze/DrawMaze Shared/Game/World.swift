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
    public var hudCamera = HudCamera(model: .square)

    private var touchLocation: TouchLocation?

    private var selectedButtonId: Int = -1
    
    private var buttons: [Button] = []

    // The UI used to create a maze. I expect this eventually needs to get more complicated but going with it for now.
    private var drawMazeUI: [Button] = []
    // The buttons to show when playing
    private var playMazeUI: [Button] = []
    // The button to switch between draw and play
    private var playButton: Button

    init(config: AppCoreConfig.Game.World, map: TileMap) {
        self.config = config
        self.map = map
        walls = []
        playButton = TapButton(id: "play", centeredIn: F2(7.f, 17.f), model: .square, color: F3(0, 0.2, 0))
        drawMazeUI = [
            playButton
        ]
        playMazeUI = [
            playButton
        ]
        // whole iphone 14 screen is 10 across and 20 down
        let gridWidth = 9
        let gridHeight = 9
        let horizontalStart = 7
        let totalButtons = 81
        for i in 0..<totalButtons { // one less than total cuz grid starts at 0,0
            let x = i % gridWidth
            let y = horizontalStart + (i / gridHeight)
            drawMazeUI.append(ToggleButton(id: String(i), centeredIn: F2(x.f, y.f), model: .square, color: F3(0, 0.2, 0)))
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
        camera = overHeadCamera

        // draw the world
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
        var gameInput = GameInput(externalInput: input, selectedButtonId: nil)

        if (input.isTouched) {
            let position = input.touchCoordinates
                    .screenToNdc(screenWidth: input.viewWidth, screenHeight: input.viewHeight, flipY: true)
                    .ndcToWorld(camera: hudCamera, aspect: input.aspect)
            let location = TouchLocation(position: position, model: .square)
            touchLocation = location

            let button = pickButton(at: location)
            if let selected = button {
                gameInput.selectedButtonId = selected.id
            }
        }

        // Update buttons
        for i in (0 ..< buttons.count) {
            var button = buttons[i]
            button.update(input: gameInput)
            buttons[i] = button
        }

        // silly quick work around
        if let playButton = buttons.first(where: { $0.id == "play"}), let b = playButton as? TapButton {
            if (b.togglePlay) {
                camera = floatingCamera
                // hey it works for now...
                if buttons.count == drawMazeUI.count {
                    drawMazeUI = buttons
                    playMazeUI[0] = playButton
                    buttons = playMazeUI
                }
            } else {
                camera = overHeadCamera
                if buttons.count == playMazeUI.count {
                    playMazeUI = buttons
                    drawMazeUI[0] = playButton
                    buttons = drawMazeUI
                }
            }
        }
    }

    private func pickButton(at location: TouchLocation) -> Button? {
        var largestIntersectedButtonButton: Button? = nil
        var largestIntersection: Float2?
        buttons.forEach { button in
            if let intersection = location.intersection(with: button),
               intersection.length > largestIntersection?.length ?? 0 {
                largestIntersection = intersection
                largestIntersectedButtonButton = button
            }
        }

        return largestIntersectedButtonButton
    }
}
