//
// Created by David Kanenwisher on 1/3/23.
//

import Foundation
import MetalKit

/**
 Knows how to render to the view.

 - Just the bare minimum to get the clear color set on the screen.
 */
class RNDRRenderer {
    private let view: MTKView
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let config: AppCoreConfig.Services.RenderService

    public init(_ view: MTKView, config: AppCoreConfig.Services.RenderService) {
        self.view = view
        self.config = config

        guard let newDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("""
                       I looked in the computer and didn't find a device...sorry =/
                       """)
        }
        view.device = newDevice
        view.clearColor = MTLClearColor(red: config.clearColor.0, green: config.clearColor.1, blue: config.clearColor.2, alpha: config.clearColor.3)

        device = newDevice

        guard let newCommandQueue = device.makeCommandQueue() else {
            fatalError("""
                       What?! No command queue. Come on, what's the deal!
                       """)
        }

        commandQueue = newCommandQueue
    }

    public func render() {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {
            fatalError("""
                       Ugh, no command buffer. They must be fresh out!
                       """)
        }

        guard let descriptor = view.currentRenderPassDescriptor, let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            fatalError("""
                       Dang it, couldn't create a command encoder.
                       """)
        }

        encoder.endEncoding()

        guard let drawable = view.currentDrawable else {
            fatalError("""
                       Wakoom! Attempted to get the view's drawable and everything fell apart! Boo!
                       """)
        }

        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
