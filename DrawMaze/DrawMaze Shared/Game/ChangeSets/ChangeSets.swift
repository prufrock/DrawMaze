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
