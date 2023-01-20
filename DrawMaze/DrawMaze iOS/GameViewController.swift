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

    private let maximumTimeStep: Float = 1 / 20 // cap at a minimum of 20 FPS
    private let worldTimeStep: Float = 1 / 120 // number of steps to take each frame
    private var lastFrameTime = CACurrentMediaTime()

    // variables for using the touch screen
    private let tapGesture = UITapGestureRecognizer()
    private var lastTouchedTime: Double = 0.0
    var touchCoords: Float2 = Float2()

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appCore = appDelegate.core else {
            fatalError("What in the zebra stripes?! The AppCore should be available by now!")
        }
        // Do any additional setup after loading the view.
        // This is a little bit of a mess but I do like the general idea of going through a the AppCore.
        var levels: [TileMap] = []
        appCore.sync(LoadLevelFileCommand { maps in
            levels = maps
        })
        game = Game(config: appCore.config.game, levels: levels)
        setupMetalView()

        // attach the UITapGestureRecognizer to turn the screen into a button
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(touch))
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
        print("frame height: \(view.frame.height) width: \(view.frame.width)")
        screenDimensions = ScreenDimensions(width: view.frame.width, height: view.frame.height)
    }

    public func draw(in view: MTKView) {
        let time = CACurrentMediaTime()
        let timeStep = min(maximumTimeStep, Float(CACurrentMediaTime() - lastFrameTime))

        var input = Input(
            // pressing fire happens while rendering new frames so the press we care about is the one that happened after
            // the last frame was rendered.
            isTouched: lastTouchedTime > lastFrameTime,
            touchCoordinates: touchCoords,
            viewWidth: screenDimensions.width,
            viewHeight: screenDimensions.height,
            aspect: screenDimensions.aspect
        )

        let worldSteps = (timeStep / worldTimeStep).rounded(.up)
        for _ in 0 ..< Int(worldSteps) {
            game.update(timeStep: timeStep / worldSteps, input: input)
            // the world advances faster than draw calls are made so to ensure "isTouched" is only applied once it gets set to false. Especially helpful when going from the title screen into the game.
            input.isTouched = false
        }
        lastFrameTime = time

        // If the core isn't there it's best to blow up.
        appDelegate.core!.sync(RenderCommand(
            metalView: metalView,
            screenDimensions: screenDimensions,
            game: game
            ))
    }
}

// Methods for capturing gestures
extension GameViewController {
    @objc func touch(_ gestureRecognizer: UITapGestureRecognizer) {
        lastTouchedTime = CACurrentMediaTime()
        let location = gestureRecognizer.location(in: view)
        touchCoords = Float2(Float(location.x), Float(location.y))
        print("touchCoords:", String(format: "%.1f, %.1f", touchCoords.x, touchCoords.y))
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    // Allow for more than on gesture recognizer to do its thing at the same time.
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

