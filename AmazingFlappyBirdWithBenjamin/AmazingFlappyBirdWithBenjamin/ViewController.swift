//
//  ViewController.swift
//  AmazingFlappyBirdWithBenjamin
//
//  Created by Jonathan Pappas on 5/19/21.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            
            let scene = GameScene(size: CGSize(width: 750, height: 1334))
            scene.scaleMode = .aspectFit
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene)
            
        }
    }
}

