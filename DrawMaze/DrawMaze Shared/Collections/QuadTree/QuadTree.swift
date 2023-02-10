//
// Created by David Kanenwisher on 2/4/23.
//

import Foundation

protocol CTSQuadTree {
    func insert(_ p: Float2) -> Bool
    func find(_ rect: Rect) -> [Float2]
}