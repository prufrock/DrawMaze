//
// Created by David Kanenwisher on 1/3/23.
//

import Foundation
import MetalKit

public class RenderService {
    private let config: AppCoreConfig.Services.RenderService

    init(_ config: AppCoreConfig.Services.RenderService) {
        self.config = config
    }

    public func sync(_ command: RenderCommand) {
        // Not sure about creating this on every render request. Where does renderer cache stuff at then?
        let renderer = RNDRRenderer(command.metalView, config: config)
        renderer.render()
    }
}

public struct RenderCommand: ServiceCommand {
    let metalView: MTKView
}
