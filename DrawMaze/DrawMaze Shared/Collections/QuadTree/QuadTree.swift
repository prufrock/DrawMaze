//
// Created by David Kanenwisher on 2/4/23.
//

import Foundation

protocol CTSQuadTree {
    func insert(_ p: Float2) -> Bool
    func subdivide()
    func queryRange(_ range: Rect) -> [Float2]
}

public class CTSQuadTreeList: CTSQuadTree {

    // node capacity
    private var capacity = 4

    // points in this quad tree node
    private var points: [Float2] = []

    // children - partitioning 2D euclidean space
    private var northWest: CTSQuadTree? = nil
    private var northEast: CTSQuadTree? = nil
    private var southWest: CTSQuadTree? = nil
    private var southEast: CTSQuadTree? = nil

    private var boundary: Rect

    public init(boundary: Rect) {
        self.boundary = boundary
    }

    public func insert(_ p: Float2) -> Bool {
        // it it's outside the quadtree reject it
        if !boundary.contains(p) {
            return false
        }

        if hasVacancies() && notDivided() {
            points.append(p)
            return true
        }

        return false
    }

    public func subdivide() {
    }

    public func queryRange(_ range: Rect) -> [Float2] {
    []
    }

    private func hasVacancies() -> Bool {
       points.count < capacity
    }

    func notDivided() -> Bool{
        northWest == nil
    }
}
