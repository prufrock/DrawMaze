//
// Created by David Kanenwisher on 2/17/23.
//

import Foundation

struct ECSToggleButton: ECSComponent {
    var entityID: String
    var buttonState: State = .NotToggled
    let toggledColor: Float4 = Float4(0.0, 0.6, 0.0, 1.0)
    let notToggledColor: Float4 = Float4(0.0, 0.2, 0.0, 1.0)

    mutating func update(input: GameInput, entity: inout ECSEntity, world: World) {
        if (input.selectedButton?.id == entityID) {
            switch buttonState {
            case .Toggled:
                buttonState =  .NotToggled
                entity.graphics?.color = notToggledColor
            case .NotToggled:
                buttonState = .Toggled
                entity.graphics?.color = toggledColor
            }
        }
    }

    public enum State {
        case NotToggled, Toggled
    }
}
