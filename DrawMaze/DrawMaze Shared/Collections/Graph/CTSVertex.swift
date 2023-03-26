//
// Created by David Kanenwisher on 3/22/23.
//

import Foundation

class CTSVertex<T>: Hashable {
    var data: T
    var index: Int

    init(index: Int, data: T) {
        self.data = data
        self.index = index
    }

    static func ==(lhs: CTSVertex<T>, rhs: CTSVertex<T>) -> Bool {
        lhs.index == rhs.index
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
}