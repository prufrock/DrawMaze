//
//  CTSStackArrayTests.swift
//  DrawMaze iOSTests
//
//  Created by David Kanenwisher on 3/11/23.
//

import XCTest
@testable import DrawMaze_iOS

final class CTSAdjacencyListTests: XCTestCase {

    func testAirports() {
        let graph = CTSAdjacencyList<String>()

        let fargo = graph.createVertex(data: "Fargo")
        let bismark = graph.createVertex(data: "Bismark")
        let singapore = graph.createVertex(data: "Singapore")
        let tokyo = graph.createVertex(data: "Tokyo")
        let hongKong = graph.createVertex(data: "Hong Kong")
        let detroit = graph.createVertex(data: "Detroit")
        let sanFrancisco = graph.createVertex(data: "San Francisco")
        let washingtonDC = graph.createVertex(data: "Washington DC")
        let austin = graph.createVertex(data: "Austin")
        let seattle = graph.createVertex(data: "Seattle")

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

        XCTAssertNil(graph.weight(from: washingtonDC, to: hongKong))
        XCTAssertEqual(1166, graph.weight(from: detroit, to: austin))
        XCTAssertEqual(6764, graph.weight(from: washingtonDC, to: tokyo))

        var total = 0
        var order: [String] = []
        graph.breadthFirstTraversal(source: fargo, visitor: { vertex in
            order.append(vertex.data)
            total += 1
        })
        XCTAssertEqual(2, total)
        XCTAssertEqual(["Fargo", "Bismark"], order)

        total = 0
        order = []
        graph.breadthFirstTraversalRecursive(source: fargo, visitor: { vertex in
            order.append(vertex.data)
            total += 1
        })
        XCTAssertEqual(2, total)
        XCTAssertEqual(["Fargo", "Bismark"], order)

        var sorted = graph.breadthFirstSort(source: fargo)
        XCTAssertEqual(2, sorted.count)
        XCTAssertEqual(["Fargo", "Bismark"], sorted.map {$0.data})

        total = 0
        order = []
        graph.breadthFirstTraversal(source: washingtonDC, visitor: { vertex in
            order.append(vertex.data)
            total += 1
        })
        XCTAssertEqual(8, total)
        XCTAssertEqual(["Washington DC", "Tokyo", "Austin", "San Francisco", "Seattle", "Singapore", "Hong Kong", "Detroit"], order)

        total = 0
        order = []
        graph.breadthFirstTraversalRecursive(source: washingtonDC, visitor: { vertex in
            order.append(vertex.data)
            total += 1
        })
        XCTAssertEqual(8, total)
        XCTAssertEqual(["Washington DC", "Tokyo", "Austin", "San Francisco", "Seattle", "Singapore", "Hong Kong", "Detroit"], order)

        sorted = graph.breadthFirstSort(source: washingtonDC)
        XCTAssertEqual(8, sorted.count)
        XCTAssertEqual(["Washington DC", "Tokyo", "Austin", "San Francisco", "Seattle", "Singapore", "Hong Kong", "Detroit"], sorted.map {$0.data})
    }
}
