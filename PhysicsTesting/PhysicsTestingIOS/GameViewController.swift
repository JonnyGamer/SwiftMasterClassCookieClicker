//
//  GameViewController.swift
//  EverMazeNextGenerationIOS
//
//  Created by Jonathan Pappas on 7/22/21.
//

import UIKit
import SpriteKit
import GameplayKit

import Magic
import EverMazeKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = LaunchScreen.init(size: .init(width: 1000 * (view.frame.width / view.frame.height), height: 1000))
            w = scene.frame.width
            Magic.w = w
            EverMazeKit.w = w
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
            
            // Present the scene
            view.presentScene(scene)
            view.preferredFramesPerSecond = 120
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
            view.showsPhysics = false
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
