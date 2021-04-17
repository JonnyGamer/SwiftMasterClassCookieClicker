//
//  ViewController.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
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
            let scene = Scene(size: CGSize.init(width: (16*16), height: 14*16))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            // Present the scene
            view.presentScene(scene)
            //view.isAsynchronous = true
            
            
            view.ignoresSiblingOrder = true
            view.preferredFramesPerSecond = 60
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}

