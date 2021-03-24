//
//  ViewController.swift
//  Pong
//
//  Created by Jonathan Pappas on 3/24/21.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene.init(size: CGSize.init(width: 1000, height: 1000))
            scene.scaleMode = .aspectFit
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            view.presentScene(scene)
            
            view.preferredFramesPerSecond = 120
            view.ignoresSiblingOrder = true
            view.showsPhysics = false
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
}

