//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

struct Input {
    var movement: Float2
    var cameraMovement: Float3
    var camera: AvailableCameras
    var isClicked: Bool
    var touchCoordinates: Float2
    var aspect: Float
    var viewWidth: Float
    var viewHeight: Float
}