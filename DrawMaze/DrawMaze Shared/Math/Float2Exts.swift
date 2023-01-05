//
//  FloatExts.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/3/23.
//

import Foundation
import simd

public typealias Float2 = SIMD2<Float>
public typealias F2 = Float2

public extension Float2 {
    var length: Float {
        (x * x + y * y).squareRoot()
    }

    var orthogonal: Self {
        Float2(x: -y, y: x)
    }

    init(_ x: Int, _ y: Int) {
        self.init(Float(x), Float(y))
    }

    func toFloat3() -> Float3 {
        Float3(self)
    }

    func rotated(by rotation: Float2x2) -> Self {
        rotation * self
    }

    func toTranslation() -> Float4x4 {
        Float4x4.translate(x: x, y: y, z: 0.0)
    }
}
