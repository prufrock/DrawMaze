//
//  FloatExts.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/3/23.
//

import Foundation

extension Float {
    func toRadians() -> Float {
        self * (.pi / 180)
    }
}

extension Double {
    var f: Float {
        Float(self)
    }
}

extension Int {
    var f: Float {
        Float(self)
    }
}
