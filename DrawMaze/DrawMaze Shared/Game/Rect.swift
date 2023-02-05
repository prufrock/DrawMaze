//
// Created by David Kanenwisher on 1/5/23.
//

import Foundation

// TODO: consider moving Rect out of Game
public struct Rect {
    var min, max: Float2

    public func intersection(with rect: Rect) -> Float2? {
        let left = Float2(x: max.x - rect.min.x, y: 0) // world
        if left.x <= 0 {
            return nil
        }
        let right = Float2(x: min.x - rect.max.x, y: 0) // world
        if right.x >= 0 {
            return nil
        }
        let up = Float2(x: 0, y: max.y - rect.min.y) // world
        if up.y <= 0 {
            return nil
        }
        let down = Float2(x: 0, y: min.y - rect.max.y) // world
        if down.y >= 0 {
            return nil
        }

        // sort by length with the smallest first and grab that one
        return [left, right, up, down].sorted(by: { $0.length < $1.length }).first
    }

    public func contains(_ p: Float2) -> Bool {
        !(min.x > p.x || max.x < p.x || min.y > p.y || max.y < p.y)
    }

    /**
     Upper left origin
     */
    public func divide(_ direction: Divide) -> (Rect, Rect) {
        let size: Float
        switch direction {
        case .horizontal:
            size = (max.y - min.y) / 2
            return (
                Rect(min: min, max: Float2(max.x, max.y - size)),
                Rect(min: Float2(min.x, min.y + size), max: max)
            )
        case .vertical:
            size = (max.x - min.x) / 2
            return (
                Rect(min: min, max: Float2(max.x - size, max.y)),
                Rect(min: Float2(min.x + size, min.y), max: max)
            )
        }
    }

    public enum Divide {
        case horizontal, vertical
    }
}
