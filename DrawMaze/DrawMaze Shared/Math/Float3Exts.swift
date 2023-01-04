//
//  FloatExts.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/3/23.
//

import Foundation
import simd

typealias Float3 = SIMD3<Float>
typealias F3 = Float3

extension Float3 {
    var length: Float {
        (x * x + y * y + z * z).squareRoot()
    }
}
