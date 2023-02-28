//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation
import simd

/**
 - Going to see if I can get by with just the config from AppCore for now.
 */
struct World {
    private let config: AppCoreConfig.Game.World

    private var entityManager: ECSEntityManager

    private(set) var map: TileMap

    var scene: ECSSceneGraph {
        get {
            entityManager.scene
        }
    }

    private var playing = false

    public var camera: ECSEntity?
    public var hudCamera: ECSEntity?
    public var overHeadCamera: ECSEntity?
    public var floatingCamera: ECSEntity?

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
        let totalButtons = gridWidth * gridHeight
        let radius = 0.5.f
        for i in 0..<totalButtons { // one less than total cuz grid starts at 0,0
            let x = i % gridWidth
            let y = horizontalStart + (i / gridHeight)
            entityManager.createToggleButton(id: "btn-map" + String(i), position: Float2(x.f + radius,  y.f + radius))
        }
        reset()
    }

    /**
     Set the world back to how it all began...
     */
    private mutating func reset() {

        floatingCamera = entityManager.createCamera(
            id: "floating-camera",
            initialAspectRatio: 1.0,
            position3d: F3(0.0, 0.0, 1.5),
            baseWorldToView: { component in
                Float4x4.perspectiveProjection(fov: component.fov, aspect: component.aspect, nearPlane: component.nearPlane, farPlane: component.farPlane)
                    * Float4x4.scale(x: 1.0, y: -1.0, z: 1.0) // flip on the y-axis so the origin is the upper-left
                	* Float4x4.rotateX(.pi/2)
                    * Float4x4.translate(x: component.position3d.x, y: component.position3d.y, z: component.position3d.z).inverse //invert because we look out of the camera
            })


        overHeadCamera = entityManager.createCamera(
            id: "overhead-camera",
            initialAspectRatio: 1.0,
            position3d: F3(0.0, 0.0, -10.5),
            baseWorldToView: { component in
                Float4x4.perspectiveProjection(fov: component.fov, aspect: component.aspect, nearPlane: component.nearPlane, farPlane: component.farPlane)
                    * Float4x4.scale(x: 1.0, y: -1.0, z: 1.0) // flip on the y-axis so the origin is the upper-left
                    * Float4x4.translate(x: component.position3d.x, y: component.position3d.y, z: component.position3d.z).inverse //invert because we look out of the camera
            })

        camera = floatingCamera

        hudCamera = entityManager.createCamera(
            id: "hud-camera",
            initialAspectRatio: 1.0,
            position3d: F3(0.0, 0.0, 0.0),
            baseWorldToView: { component in
                Float4x4.translate(x: -1, y: 1, z: 0.0) * // 0,0 in world space should be -1, 1 or the upper left corner in NDC.
                    Float4x4.scale(x: 0.1, y: 0.1, z: 1.0) *
                    Float4x4.scale(x: 1 / component.aspect, y: -1.0, z: 1.0)
            })

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
                        position: position,
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
                    .ndcToWorld(camera: hudCamera!.camera!)
            let eLocation = entityManager.createProp(id: "touchLocation", position: position, radius: 0.12, camera: .hud)

            if let collision = eLocation.collision {
                if let selected = entityManager.pickCollision(at: collision) {
                    print("collided entity \(selected.id)")
                    gameInput.selectedButton = selected
                }
            }
        }

        // Update all of the entities
        entityManager.entities.forEach { entity in
            var newEntity = entity
            entityManager.update(newEntity.update(input: gameInput, world: &self))
        }

        if let camera = hudCamera {
            hudCamera = entityManager.find(camera.id)
        }

        if let camera = overHeadCamera {
            overHeadCamera = entityManager.find(camera.id)
        }

        if let camera = floatingCamera {
            floatingCamera = entityManager.find(camera.id)
        }

        // silly quick work around
        if (playing) {
            camera = floatingCamera
            entityManager.hideMapButtons(true)
        } else {
            camera = overHeadCamera
            entityManager.hideMapButtons(false)
        }
    }
}
