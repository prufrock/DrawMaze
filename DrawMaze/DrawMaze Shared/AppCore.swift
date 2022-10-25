//
//  AppCore.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 10/24/22.
//

import Foundation

struct AppCore {
    let state: AppCoreState

    var name: String {
        get {
            state.name
        }
    }
}

protocol AppCoreState {
    var name: String { get }
}

extension AppCore {
    struct NeverLoaded: AppCoreState {
        let name = "NeverLoaded"
    }
}
