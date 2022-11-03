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

    func enterBackground()
}