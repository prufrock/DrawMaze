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
}
