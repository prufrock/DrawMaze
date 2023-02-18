//
// Created by David Kanenwisher on 2/17/23.
//

import Foundation

struct ECSToggleButton: ECSComponent {
    var entityID: String
    var buttonState: State = .NotToggled

    mutating func update(input: GameInput, entity: ECSEntity, world: World) {
        if (input.selectedButton?.id == entityID) {
            buttonState = .Toggled
        }
    }

    public enum State {
        case NotToggled, Toggled
    }
}
