//
// Created by David Kanenwisher on 3/11/23.
//

import Foundation

protocol CTSStack: CustomStringConvertible, ScopeFunction {
    associatedtype T
    var count: Int { get }
    func push(_ item: T)
    func pop() -> T
    func isEmpty() -> Bool
    func toArray() -> [T]
}

class CTSStackArray<T>: CTSStack {
    // holds the data
    // going to treat the end of the list as the top of the stack
    // this make pushing and popping O(1)
    private var storage: [T] = []

    var description: String {
        storage.reversed().map { "\($0)" }.joined(separator: ", ")
    }

    var count: Int {
        storage.count
    }

    func push(_ item: T) {
        storage.append(item)
    }

    func pop() -> T {
        storage.removeLast()
    }

    func isEmpty() -> Bool {
        storage.isEmpty
    }

    func toArray() -> [T] {
        storage.reversed()
    }
}
