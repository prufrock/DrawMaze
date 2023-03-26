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

    func breadthFirstTraversalRecursive(source: CTSVertex<Element>, visitor: Visitor<Element>) {
        let vertexQueue = CTSStackQueue<CTSVertex<Element>>()
        var enqueued: Set<CTSVertex<Element>> = []

        vertexQueue.enqueue(source)
        enqueued.insert(source)

        breadthFirstTraversalRecursive(vertexQueue: vertexQueue, enqueued: &enqueued, visitor: visitor)
    }

    private func breadthFirstTraversalRecursive(
        vertexQueue: CTSStackQueue<CTSVertex<Element>>,
        enqueued: inout Set<CTSVertex<Element>>,
        visitor: Visitor<Element>) {

        // avoid passing the current vertex as an argument and clear it from the queue before processing neighbors
        guard let vertex = vertexQueue.dequeue() else {
            return
        }

        // process the vertex
        visitor(vertex)

        // add all this node's unvisited neighbors
        edges(vertex).forEach { edge in
            if !enqueued.contains(edge.destination) {
                vertexQueue.enqueue(edge.destination)
                // Don't forget to add it to `enqueued` so it isn't visited again
                enqueued.insert(edge.destination)
            }
        }

        // go back around again
        breadthFirstTraversalRecursive(vertexQueue: vertexQueue, enqueued: &enqueued, visitor: visitor)
    }

    func breadthFirstSort(source: CTSVertex<Element>) -> [CTSVertex<Element>] {
        var sorted: [CTSVertex<Element>] = []
        breadthFirstTraversal(source: source) { vertex in
            sorted.append(vertex)
        }

        return sorted
    }
}

enum EdgeType {
    case directed
    case undirected
}

typealias Visitor<T> = (CTSVertex<T>) -> Void