//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

/**
 - Going to see if I can get by with just the config from AppCore for now.
 */
struct Game {
    private(set) var world: World
    private let levels: [TileMap]
    private let config: AppCoreConfig.Game

    init(config: AppCoreConfig.Game, levels: [TileMap]) {
        self.config = config
        self.levels = levels
        // Game manages the world
        // Seems like we should start at level 0
        world = World(config: config.world, map: levels[config.firstLevelIndex])
    }

    /**
     Update the game.
     - Parameters:
       - timeStep: The amount of time to move forward.
     */
    mutating func update(timeStep: Float, input: Input) {
        world.update(timeStep: timeStep, input: input)
    }
}
