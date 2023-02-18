//
// Created by David Kanenwisher on 2/14/23.
//

struct ECSEntity {
    var id: String

    // components

    // behaviors
    var toggleButton: ECSToggleButton?

    // graphics
    var graphics: ECSGraphics?

    // physics
    var collision: ECSCollision?

    mutating func update(input: GameInput, world: World) {
        if var button = toggleButton {
            button.update(input: input, entity: self, world: world)
            toggleButton = button
        }
    }
}
