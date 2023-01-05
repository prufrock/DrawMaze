//
// Created by David Kanenwisher on 1/4/23.
//

import Foundation
import simd

public typealias Float4x4 = simd_float4x4

public extension Float4x4 {
    static func identity() -> Self {
        matrix_identity_float4x4
    }

    static func translate(x: Float, y: Float, z: Float) -> Self {
        Self(
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [x, y, z, 1]
        )
    }

    static func translate(_ f2: F2) -> Self {
        Self(
            [1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
            [f2.x, f2.y, 0, 1]
        )
    }

    static func scale(x: Float, y: Float, z: Float) -> Self {
        Self(
            [x, 0, 0, 0],
            [0, y, 0, 0],
            [0, 0, z, 0],
            [0, 0, 0, 1]
        )
    }

    static func scaleX(_ x: Float) -> Self {
        scale(x: x, y: 1, z: 1)
    }

    static func scaleY(_ y: Float) -> Self {
        scale(x: 1, y: y, z: 1)
    }

    static func scaleZ(_ z: Float) -> Self {
        scale(x: 1, y: 1, z: z)
    }

    static func rotateX(_ angle: Float) -> Self {
        Self(
            [1,           0,          0, 0],
            [0,  cos(angle), sin(angle), 0],
            [0, -sin(angle), cos(angle), 0],
            [0,           0,          0, 1]
        )
    }

    static func rotateY(_ angle: Float) -> Self {
        Self(
            [cos(angle), 0, -sin(angle), 0],
            [         0, 1,           0, 0],
            [sin(angle), 0,  cos(angle), 0],
            [         0, 0,           0, 1]
        )
    }

    static func rotateZ(_ angle: Float) -> Self {
        Self(
            [ cos(angle), sin(angle), 0, 0],
            [-sin(angle), cos(angle), 0, 0],
            [          0,          0, 1, 0],
            [          0,          0, 0, 1]
        )
    }

    static func perspectiveProjection(fov: Float, aspect: Float, nearPlane: Float, farPlane: Float) -> Self {
        let zoom = 1 / tan(fov / 2) // objects get smaller as fov increases

        // Figure out the individual values
        let y = zoom
        let x = y / aspect
        let z = farPlane / (farPlane - nearPlane)
        let w = -nearPlane * z

        // Initialize the columns
        let X = Float4(x, 0, 0, 0)
        let Y = Float4(0, y, 0, 0)
        let Z = Float4(0, 0, z, 1)
        let W = Float4(0, 0, w, 0)

        // Create the projection from the columns
        return Self(X, Y, Z, W)
    }

    func upperLeft() -> Float3x3 {
        Float3x3(columns: (columns.0.xyz, columns.1.xyz, columns.2.xyz))
    }
}