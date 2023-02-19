//
// Created by David Kanenwisher on 2/17/23.
//

import Foundation

struct ECSToggleButton: ECSComponent {
    var entityID: String
    var buttonState: State = .NotToggled

    mutating func update(input: GameInput, entity: inout ECSEntity, world: World) {
        if (input.selectedButton?.id == entityID) {
            switch buttonState {
            case .Toggled:
                buttonState =  .NotToggled
                entity.graphics?.color = Float4(Color.green)
            case .NotToggled:
                buttonState = .Toggled
                entity.graphics?.color = Float4(Color.blue)
            }
        }
    }

    public enum State {
        case NotToggled, Toggled
    }
}
