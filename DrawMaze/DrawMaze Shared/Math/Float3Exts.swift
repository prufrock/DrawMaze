//
//  FloatExts.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/3/23.
//

import Foundation
import simd

public typealias Float3 = SIMD3<Float>
public typealias F3 = Float3

public extension Float3 {
    var length: Float {
        (x * x + y * y + z * z).squareRoot()
    }

    init(_ value: Float2) {
        self.init(value.x, value.y, 0.0)
    }

    func toFloat2() -> Float2 {
        Float2(x: x, y: y)
    }
}
