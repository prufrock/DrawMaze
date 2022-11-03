//
// Created by David Kanenwisher on 11/2/22.
//

import Foundation

protocol AppCoreState {
    var name: String { get }
    var controller: AppCoreController { get }

    func launch() -> AppCoreState

    func terminate() -> AppCoreState

    func activate() -> AppCoreState

    func transition() -> AppCoreState?

    func initialize() -> AppCoreState

    func enterBackground() -> AppCoreState
}
