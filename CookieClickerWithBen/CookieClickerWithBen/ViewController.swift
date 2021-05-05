//
//  ViewController.swift
//  CookieClickerWithBen
//
//  Created by Jonathan Pappas on 5/5/21.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
           
            let scene = GameScene.init(size: CGSize.init(width: 1000, height: 1000))
            scene.scaleMode = .aspectFit
            
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            
            view.presentScene(scene)
            
        }
    }
}

