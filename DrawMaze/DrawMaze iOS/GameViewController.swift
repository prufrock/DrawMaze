//
//  ViewController.swift
//  DrawMaze iOS
//
//  Created by David Kanenwisher on 10/24/22.
//

import UIKit
import MetalKit

class GameViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let metalView = MTKView()
    private var game: Game!

    private var screenDimensions = ScreenDimensions(width: 0.0, height: 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // This is a little bit of a mess but I do like the general idea of going through a the AppCore.
        var levels: [TileMap] = []
        appDelegate.core!.sync(LoadLevelFileCommand { maps in
            levels = maps
        })
        game = Game(levels: levels)
        setupMetalView()
    }
}

extension GameViewController {
    func setupMetalView() {
        view.addSubview(metalView)
        metalView.translatesAutoresizingMaskIntoConstraints = false
        metalView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        metalView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        metalView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        metalView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        metalView.contentMode = .scaleAspectFit
        metalView.backgroundColor = .black
        metalView.delegate = self
    }
}

extension GameViewController: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        screenDimensions = ScreenDimensions(width: size.width, height: size.height)
    }

    public func draw(in view: MTKView) {
        // If the core isn't there it's best to blow up.
        appDelegate.core!.sync(RenderCommand(
            metalView: metalView,
            screenDimensions: screenDimensions,
            game: game
            ))
    }
}

