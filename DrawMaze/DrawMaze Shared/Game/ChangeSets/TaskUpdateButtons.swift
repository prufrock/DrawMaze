//
// Created by David Kanenwisher on 1/30/23.
//

import Foundation

struct TaskUpdateButtons {
}

extension Array: Changeable where Element == Changeable {
    var id: String {
        get {
            ""
        }
    }
    mutating func update(_ world: World, input: GameInput) -> [ChangeAction] {
        var changes: [ChangeAction] = []

        forEach { itemSnap in
            var itemWrite = itemSnap
            changes.append(contentsOf: itemWrite.update(world, input: input))
        }

        return changes
    }

    mutating func accept(_ changes: [ChangeAction]) {
        changes.forEach { action in
            switch action {
            case .create(change: let change):
                if change is Element {
                    append(change as! Element)
                }
            case .update(change: let change):
                if change is Element {
                    if let i = firstIndex(where: { $0.id == (change as! Element).id }) {
                        remove(at: i)
                        insert((change as! Element), at: i)
                    }
                }
            case .delete(change: let change):
                if change is Element {
                    if let i = firstIndex(where: { $0.id == (change as! Element).id }) {
                        remove(at: i)
                    }
                }
            }
        }
    }
}
