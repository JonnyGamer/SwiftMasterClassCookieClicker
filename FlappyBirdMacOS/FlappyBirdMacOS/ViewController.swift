//
//  ViewController.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
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
            if let scene = scenesLoaded[.mainMenu] {
                scene.scaleMode = .aspectFit
                scene.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
            // view.showsPhysics = true
        }
    }
}

