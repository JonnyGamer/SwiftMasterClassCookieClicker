//
//  GameScene.swift
//  BabaIsYouWithClass
//
//  Created by Jonathan Pappas on 4/21/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //var baba: Objects!
    let game = Game()
    
    override func didMove(to view: SKView) {
        
        game.start()
        for i in game.totalObjects {
            addChild(i.sprite)
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        game.move([.up, .down, .left, .right].randomElement()!)
        
    }
    
    
}
