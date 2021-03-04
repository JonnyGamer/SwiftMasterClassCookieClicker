//
//  ViewController.swift
//  FlamboyantBirds
//
//  Created by Jonathan Pappas on 3/3/21.
//


import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
           
            let scene = MainMenu(size: CGSize(width: 750, height: 1334))
            scene.scaleMode = .aspectFit
            scene.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
            view.presentScene(scene)
            
            
            
            view.ignoresSiblingOrder = false
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

