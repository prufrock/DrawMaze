//
// Created by David Kanenwisher on 1/3/23.
//

import Foundation

/**
 The AppCore manages the state of the application.

 - Skipping the state machine for now.
 */
class AppCore {
    private var context: AppCoreContext

    init(_ config: AppCoreConfig) {
        context = AppCoreContext(config: config)
    }
}
