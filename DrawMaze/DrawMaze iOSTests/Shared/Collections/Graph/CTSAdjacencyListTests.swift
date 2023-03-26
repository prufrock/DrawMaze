//
//  CTSStackArrayTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/11/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSAdjacencyListTests: XCTestCase {

    func testWeight() {
        Airports().apply { a in
            XCTAssertNil(a.graph.weight(from: a.washingtonDC, to: a.hongKong))
            XCTAssertEqual(1166, a.graph.weight(from: a.detroit, to: a.austin))
            XCTAssertEqual(6764, a.graph.weight(from: a.washingtonDC, to: a.tokyo))
        }
    }

    func testBreadthFirstTraversal() {
        Airports().apply { a in
            var total = 0
            var order: [String] = []
            a.graph.breadthFirstTraversal(source: a.fargo, visitor: { vertex in
                order.append(vertex.data)
                total += 1
            })
            XCTAssertEqual(2, total)
            XCTAssertEqual(["Fargo", "Bismark"], order)
        }

        Airports().apply { a in
            var total = 0
            var order: [String] = []
            a.graph.breadthFirstTraversal(source: a.washingtonDC, visitor: { vertex in
                order.append(vertex.data)
                total += 1
            })
            XCTAssertEqual(8, total)
            XCTAssertEqual(["Washington DC", "Tokyo", "Austin", "San Francisco", "Seattle", "Singapore", "Hong Kong", "Detroit"], order)
        }
    }

    func testbreadthFirstTraversalRecursive() {
        Airports().apply { a in
            var total = 0
            var order: [String] = []
            a.graph.breadthFirstTraversalRecursive(source: a.fargo, visitor: { vertex in
                order.append(vertex.data)
                total += 1
            })
            XCTAssertEqual(2, total)
            XCTAssertEqual(["Fargo", "Bismark"], order)
        }

        Airports().apply { a in
            var total = 0
            var order: [String] = []
            a.graph.breadthFirstTraversalRecursive(source: a.washingtonDC, visitor: { vertex in
                order.append(vertex.data)
                total += 1
            })
            XCTAssertEqual(8, total)
            XCTAssertEqual(["Washington DC", "Tokyo", "Austin", "San Francisco", "Seattle", "Singapore", "Hong Kong", "Detroit"], order)
        }
    }

    func testBreadthFirstSort() {
        Airports().apply { a in
            let sorted = a.graph.breadthFirstSort(source: a.fargo)
            XCTAssertEqual(2, sorted.count)
            XCTAssertEqual(["Fargo", "Bismark"], sorted.map {
                $0.data
            })
        }

        Airports().apply { a in
            let sorted = a.graph.breadthFirstSort(source: a.washingtonDC)
            XCTAssertEqual(8, sorted.count)
            XCTAssertEqual(["Washington DC", "Tokyo", "Austin", "San Francisco", "Seattle", "Singapore", "Hong Kong", "Detroit"], sorted.map {
                $0.data
            })
        }
    }

    func testIsDisconnected() {
        let graph = CTSAdjacencyList<String>()

        let fargo = graph.createVertex(data: "Fargo")
        let bismark = graph.createVertex(data: "Bismark")

        XCTAssertTrue(graph.isDisconnected(source: fargo))

        graph.add(edgeType: EdgeType.undirected, from: fargo, to: bismark, weight: 190)

        XCTAssertFalse(graph.isDisconnected(source: fargo))
    }
}

class Airports: ScopeFunction {
    var graph: CTSAdjacencyList<String>

    var fargo: CTSVertex<String>
    var bismark: CTSVertex<String>
    var singapore: CTSVertex<String>
    var tokyo: CTSVertex<String>
    var hongKong: CTSVertex<String>
    var detroit: CTSVertex<String>
    var sanFrancisco: CTSVertex<String>
    var washingtonDC: CTSVertex<String>
    var austin: CTSVertex<String>
    var seattle: CTSVertex<String>

    init() {
        graph = CTSAdjacencyList<String>()

        fargo = graph.createVertex(data: "Fargo")
        bismark = graph.createVertex(data: "Bismark")
        singapore = graph.createVertex(data: "Singapore")
        tokyo = graph.createVertex(data: "Tokyo")
        hongKong = graph.createVertex(data: "Hong Kong")
        detroit = graph.createVertex(data: "Detroit")
        sanFrancisco = graph.createVertex(data: "San Francisco")
        washingtonDC = graph.createVertex(data: "Washington DC")
        austin = graph.createVertex(data: "Austin")
        seattle = graph.createVertex(data: "Seattle")

        graph.add(edgeType: EdgeType.undirected, from: fargo, to: bismark, weight: 190)
        graph.add(edgeType: EdgeType.undirected, from: singapore, to: tokyo, weight: 3302)
        graph.add(edgeType: EdgeType.undirected, from: hongKong, to: tokyo, weight: 1806)
        graph.add(edgeType: EdgeType.undirected, from: tokyo, to: detroit, weight: 6427)
        graph.add(edgeType: EdgeType.undirected, from: tokyo, to: washingtonDC, weight: 6764)
        graph.add(edgeType: EdgeType.undirected, from: hongKong, to: sanFrancisco, weight: 6893)
        graph.add(edgeType: EdgeType.undirected, from: detroit, to: austin, weight: 1166)
        graph.add(edgeType: EdgeType.undirected, from: austin, to: washingtonDC, weight: 1035)
        graph.add(edgeType: EdgeType.undirected, from: sanFrancisco, to: washingtonDC, weight: 2435)
        graph.add(edgeType: EdgeType.undirected, from: washingtonDC, to: seattle, weight: 2321)
        graph.add(edgeType: EdgeType.undirected, from: sanFrancisco, to: seattle, weight: 678)
        graph.add(edgeType: EdgeType.undirected, from: austin, to: sanFrancisco, weight: 1166)
    }
}
