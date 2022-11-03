//
//  AppCore.swift
//  DrawMaze
//
//  Created by David Kanenwisher on 10/24/22.
//

import Foundation

protocol AppCore {
    func launch()

    func terminate()

    func activate()

    func initialize()
}


protocol AppCoreState {
    var name: String { get }
    var controller: AppCoreController { get }

    func launch() -> AppCoreState

    func terminate() -> AppCoreState

    func activate() -> AppCoreState

    func transition() -> AppCoreState?

    func initialize() -> AppCoreState
}


