//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation
import simd

enum AvailableCameras {
    case overhead, floatingCamera, hudCamera
}

protocol Camera: Actor {
    var position3d: F3 {get set}

    func worldToView(fov: Float, aspect: Float, nearPlane: Float, farPlane: Float) -> Float4x4
}

struct CameraOverhead: Camera {
    var radius: Float = 0.0
    var position: F2 = F2(0.0, 0.0)
    var position3d: F3 = F3(0.0, 0.0, -10.5)
    var model: BasicModels

    var color: Float3 = Float3(0.0, 1.0, 0.0)

    var modelToUpright:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.identity()
        }
    }

    func worldToView(fov: Float, aspect: Float, nearPlane: Float, farPlane: Float) -> Float4x4 {
        Float4x4.perspectiveProjection(fov: fov, aspect: aspect, nearPlane: nearPlane, farPlane: farPlane)
            * Float4x4.scale(x: 1.0, y: -1.0, z: 1.0) // flip on the y-axis so the origin is the upper-left
            * Float4x4.translate(x: position3d.x, y: position3d.y, z: position3d.z).inverse //invert because we look out of the camera
    }
}

struct CameraFloating: Camera {
    var radius: Float = 0.0
    var position = F2(0.0, 0.0)
    var position3d = F3(0.0, 0.0, 1.5)
    var model: BasicModels

    var color: Float3 = Float3(0.0, 1.0, 0.0)

    var modelToUpright:Float4x4 {
        get {
            Float4x4.scale(x: 0.01, y: 0.01, z: 0.0)
        }
    }

    var uprightToWorld:Float4x4 {
        get {
            Float4x4.translate(x: position.x, y: position.y, z: 0.0)
        }
    }

    func worldToView(fov: Float, aspect: Float, nearPlane: Float, farPlane: Float) -> Float4x4 {
        Float4x4.perspectiveProjection(fov: fov, aspect: aspect, nearPlane: nearPlane, farPlane: farPlane)
            * Float4x4.scale(x: 1.0, y: -1.0, z: 1.0) // flip on the y-axis so the origin is the upper-left
            * Float4x4.rotateX(.pi/2)
            * Float4x4.translate(x: position3d.x, y: position3d.y, z: position3d.z).inverse //invert because we look out of the camera
    }
}
