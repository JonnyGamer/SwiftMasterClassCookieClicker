//
//  ViewController.swift
//  BabaIsYouDay2
//
//  Created by Jonathan Pappas on 4/28/21.
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
            
            let scene = GameScene(size: CGSize(width: 1000, height: 1000))
            scene.scaleMode = .aspectFit
            // STEP 0
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

