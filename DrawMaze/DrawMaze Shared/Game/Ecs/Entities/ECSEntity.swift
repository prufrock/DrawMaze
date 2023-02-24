//
// Created by David Kanenwisher on 2/14/23.
//

struct ECSEntity {
    var id: String

    // components

    // behaviors
    var toggleButton: ECSToggleButton?

    // graphics
    var camera: ECSCamera?
    var graphics: ECSGraphics?

    // physics
    var collision: ECSCollision?

    mutating func update(input: GameInput, world: inout World) {
        if var button = toggleButton {
            button.update(input: input, entity: &self, world: &world)
            toggleButton = button
        }

        if var camera = camera {
            camera.update(input: input, entity: &self, world: &world)
            self.camera = camera
        }
    }
}
