//
//  ChangeSets.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 1/28/23.
//

import Foundation

protocol Changes {
    
}

enum ChangeAction {
    case create(change: Changes)
    case update(change: Changes)
    case delete(change: Changes)
}
