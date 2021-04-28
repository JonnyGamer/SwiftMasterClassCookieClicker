//
//  GameScene.swift
//  BabaIsYouDay2
//
//  Created by Jonathan Pappas on 4/28/21.
//

import SpriteKit
import GameplayKit

import SpriteKit
import GameplayKit

// Step 2.5 ish
var tenth: CGFloat = 10
var halfSpriteGrid: CGFloat = 50
var imageGrid: Int = 0
var spriteGrid: Int = 100 {
    didSet {
        halfSpriteGrid = CGFloat(spriteGrid) / 2
        tenth = CGFloat(spriteGrid) / 10
    }
}


class GameScene: SKScene {
    
    //var baba: Objects!
    let game = Game()
    // Step 8 - super node
    var superNode = SKNode()
    
    override func didMove(to view: SKView) {
        
        game.start()
        // Step 10.1 remove this 3 lines
        //for i in game.totalObjects {
        //    addChild(i.sprite)
        //}
        
        /* Step 9 add supernode*/ addChild(superNode)
        resetChildren()
        superNode.position.x = CGFloat(game.gridSize.x) * -halfSpriteGrid + halfSpriteGrid
        superNode.position.y = CGFloat(game.gridSize.y) * -halfSpriteGrid + halfSpriteGrid
        
        let bgNodeWidth = CGFloat(game.gridSize.x * Int(spriteGrid)) + tenth
        let bgNodeHeight = CGFloat(game.gridSize.y * Int(spriteGrid)) + tenth
        let bgNode = SKSpriteNode.init(color: .gray, size: .init(width: bgNodeWidth, height: bgNodeHeight))
        bgNode.zPosition = -1
        addChild(bgNode)
    }
    
    /* Step 10.3 add supernode*/
    func resetChildren() {
        superNode.removeAllChildren()
        for i in game.totalObjects {
            i.sprite.position = .init(x: i.position.x * spriteGrid, y: i.position.y * spriteGrid)
            superNode.addChild(i.sprite)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if .random(), .random(), .random() {
            game.move([.up, .down, .left, .right].randomElement()!)
        }
        
    }
    
    
}
