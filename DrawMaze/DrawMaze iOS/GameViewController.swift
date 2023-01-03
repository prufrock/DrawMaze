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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        metalView.backgroundColor = .blue
        metalView.delegate = self // implements MTKViewDelegate in GameViewController+MTKViewDelegate.swift
    }
}

extension GameViewController: MTKViewDelegate {
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {

    }

    public func draw(in view: MTKView) {
        // If the core isn't there it's best to blow up.
        appDelegate.core!.sync(RenderCommand(metalView: metalView))
    }
}

