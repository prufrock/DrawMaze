//
//  DrawMaze_macOSTests.swift
//  DrawMaze macOSTests
//
//  Created by David Kanenwisher on 10/24/22.
//

import XCTest
@testable import DrawMaze_iOS

final class ButtonTests: XCTestCase {

    func testChanges() throws {
        var button = ToggleButton(id: "toggle", centeredIn: F2(5.0, 5.0), color: F3(0.5, 0.5, 0.0))
        let world = World(config: AppCoreConfig.Game.World(), map: TileMap(MapData(tiles: [], width: 1), index: 0))
        let platformInput = Input(timeStep: 0.0, isTouched: false, touchCoordinates: F2(), viewWidth: 0.0, viewHeight: 0.0, aspect: 0.0)
        let changes = button.update(world, input: GameInput(platform: platformInput, selectedButtonId: nil))

        // It's ugly but it works!
        changes.forEach { change in
            switch change {
            case .update(let someChange):
                switch someChange {
                case let someButton as Button:
                XCTAssertEqual(F3(0.5, 0.5, 0.0), someButton.color)
                default:
                XCTFail("It should've been a button 😢")
                }
            case let someButton as Button:
                XCTAssertEqual(F3(0.5, 0.5, 0.0), someButton.color)
            default:
                XCTFail("It should've been a button 😢")
            }
        }
    }
}
