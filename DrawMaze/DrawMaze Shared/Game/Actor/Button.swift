//
// Created by David Kanenwisher on 1/11/23.
//

import simd

protocol Button: Actor {
    var id: String { get }

    mutating func update(input: GameInput)
}

struct ToggleButton: Button {

    var id: String
    var radius: Float = 0.5
    var position: F2 = F2(0.0, 0.0)
    var model: BasicModels

    var color: Float3 = Float3(0.0, 0.5, 1.0)
    private var notToggledColor: Float3 = Float3(0.0, 0.5, 1.0)
    private var toggledColor: Float3 = Float3(0.0, 0.6, 0.0)

    private var toggleState: ToggleButton.State

    var modelToUpright:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.translate(x: position.x, y: position.y, z: 0.0) *
                Float4x4.scale(x: radius, y: radius, z: radius)
        }
    }

    init(
        id: String,
        centeredIn: F2,
        model: BasicModels = .square,
        color: Float3,
        toggleState: ToggleButton.State = .NotToggled
    ) {
        self.id = id
        self.position = centeredIn + F2(0.5, 0.5)
        self.model = model
        self.color = color
        self.notToggledColor = color
        self.toggleState = toggleState
    }

    mutating func update(input: GameInput) {
        switch toggleState {
        case .NotToggled:
            if (selected(input)) {
                toggleState = .Toggled
                self.color = toggledColor
            }
        case .Toggled:
            if (selected(input)) {
                toggleState = .NotToggled
                self.color = notToggledColor
            }
        }
    }

    private func selected(_ input: GameInput) -> Bool {
        id == input.selectedButtonId
    }

    public enum State {
        case NotToggled, Toggled
    }
}

struct TapButton: Button {

    var id: String
    var radius: Float = 0.5
    var position: F2 = F2(0.0, 0.0)
    var model: BasicModels

    var color: Float3 = Float3(0.0, 0.5, 1.0)
    private var notToggledColor: Float3 = Float3(0.0, 0.5, 1.0)
    private var toggledColor: Float3 = Float3(0.0, 0.6, 0.0)

    private var toggleState: ToggleButton.State

    private let debounceDuration: Float = 0.25
    private var debounceTime: Float = 0.0

    var modelToUpright:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.translate(x: position.x, y: position.y, z: 0.0) *
                Float4x4.scale(x: radius, y: radius, z: radius)
        }
    }
    public var togglePlay: Bool = false

    init(
        id: String,
        centeredIn: F2,
        model: BasicModels = .square,
        color: Float3,
        toggleState: ToggleButton.State = .NotToggled
    ) {
        self.id = id
        self.position = centeredIn + F2(0.5, 0.5)
        self.model = model
        self.color = color
        self.notToggledColor = color
        self.toggleState = toggleState
    }

    mutating func update(input: GameInput) {
        switch toggleState {
        case .NotToggled:
            if (selected(input)) {
                toggleState = .Toggled
                self.color = toggledColor
                self.togglePlay = !self.togglePlay
            }
        case .Toggled:
            debounceTime += input.externalInput.timeStep

            if (debounceTime > debounceDuration) {
                toggleState = .NotToggled
                self.color = notToggledColor
                debounceTime = 0.0
            }
        }
    }

    private func selected(_ input: GameInput) -> Bool {
        id == input.selectedButtonId
    }

    public enum State {
        case NotToggled, Toggled
    }
}
