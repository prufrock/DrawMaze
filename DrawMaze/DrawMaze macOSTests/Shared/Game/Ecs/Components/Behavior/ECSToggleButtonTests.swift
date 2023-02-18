//
// Created by David Kanenwisher on 2/18/23.
//

import Foundation

import XCTest
@testable import DrawMaze_iOS

final class ECSToggleButtonTests: XCTestCase {

    func testWhenNotSelected() throws {
        var button = ECSToggleButton(entityID: "b1")
        button.update(input: HLP.gameInput, entity: ECSEntity(id: "b1", toggleButton: button), world: HLP.world)

        XCTAssertEqual(ECSToggleButton.State.NotToggled, button.buttonState, "Should not have been toggled")
    }

    func testWhenSelected() throws {
        var button = ECSToggleButton(entityID: "b1")
        var gameInput = HLP.gameInput
        let entity = ECSEntity(id: "b1", toggleButton: button)
        gameInput.selectedButton = entity
        button.update(input: gameInput, entity: entity, world: HLP.world)

        XCTAssertEqual(ECSToggleButton.State.Toggled, button.buttonState, "Did the logic change?")
    }
}
