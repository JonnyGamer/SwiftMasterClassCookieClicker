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
            let scene = SKScene(size: CGSize(width: 750, height: 1334))
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

