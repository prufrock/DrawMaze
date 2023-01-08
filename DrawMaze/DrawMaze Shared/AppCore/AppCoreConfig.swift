//
// Created by David Kanenwisher on 1/3/23.
//

import Foundation

public struct AppCoreConfig {

    public let services: Services

    public struct Services {
        public let renderService: AppCoreConfig.Services.RenderService
        public let fileService: AppCoreConfig.Services.FileService

        public struct RenderService {
            public let clearColor: (Double, Double, Double, Double)
        }

        public struct FileService {
            public let levelsFile: FileDescriptor

            public struct FileDescriptor {
                public let name: String
                public let ext: String
            }
        }
    }
}