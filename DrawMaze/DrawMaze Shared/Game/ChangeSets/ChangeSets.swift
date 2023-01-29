//
//  ChangeSets.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/28/23.
//

import Foundation

/**
 Not everything should be a Change but what does a Change need to do?
 */
protocol Change {
    
}

/**
 An object that changes and can be changed.
 */
protocol Changeable {
    /**
     Calculates the changes to be made and changes itself in response.
     */
    mutating func update(_ world: World, input: GameInput) -> [ChangeAction]

    /**
     Accepts the changes others have made to it.
     */
    mutating func accept(_ changes: [ChangeAction])
}

enum ChangeAction {
    // knowing what type of change it is should make applying the change a little faster
    case create(change: Change)
    case update(change: Change)
    case delete(change: Change)

    func get() -> Change {
        switch self {
        case .create(let change):
            return change
        case .update(let change):
            return change
        case .delete(let change):
            return change
        }
    }
}
