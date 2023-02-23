//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

/**
 - Going to see if I can get by with just the config from AppCore for now.
 */
struct World {
    private let config: AppCoreConfig.Game.World

    private var entityManager: ECSEntityManager

    private(set) var map: TileMap

    var actors: [Actor] {
        get {
            var list: [Actor] = []

            return list
        }
    }

    var scene: ECSSceneGraph {
        get {
            entityManager.scene
        }
    }

    private var playing = false

    public var camera: Camera?
    private var overHeadCamera: Camera?
    private var floatingCamera: Camera?
    public var hudCamera = HudCamera(model: .square)

    init(config: AppCoreConfig.Game.World, map: TileMap) {
        self.config = config
        self.map = map
        self.entityManager = ECSBigObjectEntityManager()
        entityManager.createToggleButton(
            id: "btn-play",
            position: F2(7.5.f, 17.5.f),
            toggledAction: {gameInput, ecsEntity, world in world.playing.toggle() },
            notToggledAction: {gameInput, ecsEntity, world in world.playing.toggle() }
        )

        // whole iphone 14 screen is 10 across and 20 down
        let gridWidth = 9
        let gridHeight = 9
        let horizontalStart = 7
        let totalButtons = 81
        for i in 0..<totalButtons { // one less than total cuz grid starts at 0,0
            let x = i % gridWidth
            let y = horizontalStart + (i / gridHeight)
            entityManager.createToggleButton(id: "btn-map" + String(i), position: Float2(x.f + 0.5, y.f + 0.5))
        }
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
                    entityManager.createProp(
                        id: "wall" + String(x) + String(y),
                        position: Float2(x.f + 0.5, y.f + 0.5),
                        radius: 0.5,
                        camera: .world
                    )
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
            let eLocation = entityManager.createProp(id: "touchLocation", position: position, radius: 0.12, camera: .hud)

            if let collision = eLocation.collision {
                if let selected = pickCollision(at: collision) {
                    print("collided entity \(selected.id)")
                    gameInput.selectedButton = selected
                }
            }
        }

        // Update buttons
        if var selectedButton = gameInput.selectedButton {
            selectedButton.update(input: gameInput, world: &self)
            entityManager.update(selectedButton)
        }

        // silly quick work around
        if (playing) {
            camera = floatingCamera
        } else {
            camera = overHeadCamera
        }
    }

    //TODO: find a new home, maybe EntityManager?
    private func pickCollision(at location: ECSCollision) -> ECSEntity? {
        var largestIntersectedButton: ECSEntity? = nil
        var largestIntersection: Float2?
        entityManager.collides(with: location.rect).forEach { button in
            if let intersection = location.intersection(with: button.rect),
               intersection.length > largestIntersection?.length ?? 0 {
                largestIntersection = intersection
                largestIntersectedButton = entityManager.find(button.entityID)!
            }
        }

        return largestIntersectedButton
    }
}
