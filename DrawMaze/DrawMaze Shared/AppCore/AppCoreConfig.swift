//
// Created by David Kanenwisher on 1/3/23.
//

import Foundation

public struct AppCoreConfig {

    public let services: Services

    public struct Services {
        public let renderService: AppCoreConfig.Services.RenderService

        public struct RenderService {
            public let clearColor: (Double, Double, Double, Double)
        }
    }
}