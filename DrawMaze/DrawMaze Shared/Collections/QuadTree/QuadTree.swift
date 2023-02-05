//
// Created by David Kanenwisher on 2/4/23.
//

import Foundation

protocol CTSQuadTree {
    func insert(_ p: Float2) -> Bool
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

    private var level: Int

    public init(boundary: Rect, level: Int = 0) {
        self.boundary = boundary
        self.level = level
    }

    public func insert(_ p: Float2) -> Bool {
        // it it's outside the quadtree reject it
        if !boundary.contains(p) {
            return false
        }

        if hasVacancies() && !divided() {
            points.append(p)
            return true
        }

        if !divided() {
            _ = subDivide()
        }

        //TODO: use a list of 4 elements?
        if northWest!.insert(p) {
            return true
        } else if northEast!.insert(p) {
            return true
        } else if southWest!.insert(p) {
            return true
        } else if southEast!.insert(p) {
            return true
        }

        return false
    }

    public func queryRange(_ range: Rect) -> [Float2] {
    []
    }

    private func hasVacancies() -> Bool {
       points.count < capacity
    }

    private func divided() -> Bool {
        northWest != nil
    }

    private func subDivide() -> Bool {
        let (ab, cd) = boundary.divide(.horizontal)
        let (a, b) = ab.divide(.vertical)
        let (c, d) = cd.divide(.vertical)

        northWest = CTSQuadTreeList(boundary: a, level: level + 1)
        northEast = CTSQuadTreeList(boundary: b, level: level + 1)
        southWest = CTSQuadTreeList(boundary: c, level: level + 1)
        southEast = CTSQuadTreeList(boundary: d, level: level + 1)

        //TODO: Consider checking when they get too small
        return true
    }
}
