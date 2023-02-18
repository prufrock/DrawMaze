//
// Created by David Kanenwisher on 2/1/23.
//

import Foundation

@testable import DrawMaze_iOS

/**
 Stuff to help out with tests.
 */
struct HLP {
    // Curious to see how low accuracy has to go across all the tests
    static let accuracy: Float = 0.0000005

    static let appCoreConfig = AppCoreConfig(
        game: AppCoreConfig.Game(
            world: AppCoreConfig.Game.World()
        ),
        platform: AppCoreConfig.Platform(
            maximumTimeStep: 1 / 20, // don't step bigger than this (minimum of 20 fps)
            worldTimeStep: 1 / 120 // 120 steps a second
        ),
        services: AppCoreConfig.Services(
            renderService: AppCoreConfig.Services.RenderService(
                type: .ersatz,
                clearColor: (0.3, 0.0, 0.3, 1.0)
            ),
            fileService: AppCoreConfig.Services.FileService(
                levelsFile: AppCoreConfig.Services.FileService.FileDescriptor(name: "levels", ext: "json")
            )
        )
    )

    static let world = World(config: HLP.appCoreConfig.game.world, map: TileMap(MapData(tiles: [Tile.floor, Tile.floor, Tile.floor, Tile.floor], width: 2), index: 0))

    static let input = Input(timeStep: 0.0, isTouched: false, touchCoordinates: F2(0.0), viewWidth: 100, viewHeight: 100, aspect: 1.0)
    static let gameInput = GameInput(externalInput: input)
}
