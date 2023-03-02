//
// Created by David Kanenwisher on 2/14/23.
//

struct ECSEntity {
    var id: String

    // components

    // behaviors
    var toggleButton: ECSToggleButton?
    var mapButton: ECSMapButton?
    var wall: ECSWall?

    // graphics
    var camera: ECSCamera?
    var graphics: ECSGraphics?

    // physics
    var collision: ECSCollision?

    mutating func update(input: GameInput, world: inout World) -> ECSEntity {

        // MARK: Behavior
        if var button = toggleButton {
            button.update(input: input, entity: &self, world: &world)
            toggleButton = button
        }

        if var component = mapButton {
            component.update(input: input, entity: &self, world: &world)
            mapButton = component
        }

        if var component = wall {
            component.update(input: input, entity: &self, world: &world)
            wall = component
        }

        if var camera = camera {
            camera.update(input: input, entity: &self, world: &world)
            self.camera = camera
        }

        return self
    }
}
