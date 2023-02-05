//
// Created by David Kanenwisher on 2/4/23.
//

import Foundation

protocol CTSQuadTree {
    func insert(_ p: Float2) -> Bool
    func find(_ rect: Rect) -> [Float2]
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

    public func find(_ rect: Rect) -> [Float2] {
        var found: [Float2] = []

        // Look, if the rect doesn't intersect with the boundary, what are we evening doing here?
        if boundary.intersection(with: rect) == nil {
            return found
        }

        // Check the points in this node
        if !points.isEmpty {
            points.forEach { point in
                if rect.contains(point) {
                    found.append(point)
                }
            }
        }

        // No more partitions to check then head home
        if !divided() {
            return found
        }

        // Check with the partitions
        found.append(contentsOf: northWest!.find(rect))
        found.append(contentsOf: northEast!.find(rect))
        found.append(contentsOf: southWest!.find(rect))
        found.append(contentsOf: southEast!.find(rect))

        return found
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
