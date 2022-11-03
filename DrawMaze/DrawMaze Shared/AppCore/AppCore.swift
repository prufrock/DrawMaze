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

    /**
      Looking for a way to cancel a DispatchWorkItem in flight. Pretty much just for Loading
     right now.
     - Parameter workItem: Needs to be nullable so it can be reset when not in use.
     */
    func setWorkItem(workItem: DispatchWorkItem?)
}