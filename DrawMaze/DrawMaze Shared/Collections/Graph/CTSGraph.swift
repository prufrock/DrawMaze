//
// Created by David Kanenwisher on 3/22/23.
//

import Foundation

protocol CTSGraph: CustomStringConvertible, ScopeFunction {
    associatedtype Element

    var allVertices: [CTSVertex<Element>] { get }

    var description: String { get }

    func createVertex(data: Element) -> CTSVertex<Element>

    func addDirectedEdge(from source: CTSVertex<Element>, to destination: CTSVertex<Element>, weight: Double?)

    func addUndirectedEdge(between source: CTSVertex<Element>, and destination: CTSVertex<Element>, weight: Double?)

    func weight(from source: CTSVertex<Element>, to destination: CTSVertex<Element>) -> Double?

    func edges(_ source: CTSVertex<Element>) -> [CTSEdge<Element>]

//    func depthFirstSearch(from source: CTSVertex<Element>) -> [CTSVertex<Element>]

//    func breadthFirstSearch(from source: CTSVertex<Element>) -> [CTSVertex<Element>]
}

extension CTSGraph {
    func addUndirectedEdge(between source: CTSVertex<Element>, and destination: CTSVertex<Element>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }

    func add(edgeType: EdgeType, from source: CTSVertex<Element>, to destination: CTSVertex<Element>, weight: Double?) {
        switch edgeType {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }

    func breadthFirstTraversal(source: CTSVertex<Element>, visitor: Visitor<Element>) {
        // tracks the vertices to visit next
        let queue = CTSQueueArray<CTSVertex<Element>>()
        // ensures vertices are only visited once
        var enqueued: Set<CTSVertex<Element>> = []

        // get the BFS part started by enqueueing the starting vertex
        queue.enqueue(source)
        // add it to the set of enqueued vertices, so it isn't visited again
        enqueued.insert(source)

        while(true) {
            // as long as there are items to dequeue keep going
            guard let vertex = queue.dequeue() else {
                break
            }

            // do something with the vertex
            visitor(vertex)
            // queue up all the neighbors that haven't been queued before
            let neighborsEdges = edges(vertex)
            neighborsEdges.forEach { edge in
                if !enqueued.contains(edge.destination) {
                    queue.enqueue(edge.destination)
                    enqueued.insert(edge.destination)
                }
            }
        }
    }
}

enum EdgeType {
    case directed
    case undirected
}

typealias Visitor<T> = (CTSVertex<T>) -> Void