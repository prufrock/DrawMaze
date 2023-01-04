//
//  FloatExts.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/3/23.
//

import Foundation
import simd

typealias Float2 = SIMD2<Float>
typealias F2 = Float2

extension Float2 {
    var length: Float {
        (x * x + y * y).squareRoot()
    }
}
