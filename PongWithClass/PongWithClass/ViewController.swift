//
//  ViewController.swift
//  PongWithClass
//
//  Created by Jonathan Pappas on 3/31/21.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            
            let scene = GameScene(size: CGSize(width: 1000, height: 1000))
            scene.anchorPoint = .init(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
            
        }
        
    }
}

