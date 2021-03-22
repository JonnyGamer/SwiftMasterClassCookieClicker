//
//  GameScene.swift
//  BabaIsYou
//
//  Created by Jonathan Pappas on 3/22/21.
//

import SpriteKit
import GameplayKit

var tenth: Int = 10
var halfSpriteGrid: Int = 50
var imageGrid: Int = 0
var spriteGrid: Int = 100 {
    didSet {
        halfSpriteGrid = spriteGrid / 2
        tenth = spriteGrid / 10
    }
}

class GameScene: SKScene {
    let game = Game()
    var superNode = SKNode()
    
    override func didMove(to view: SKView) {
        addChild(superNode)
        
        print("Hello World WASSUP")
        game.start()
        resetChildren()
        
        superNode.position = .init(x: size.width/2, y: size.height/2)
        superNode.position.x -= CGFloat(game.gridSize.x * halfSpriteGrid - halfSpriteGrid)
        superNode.position.y -= CGFloat(game.gridSize.y * halfSpriteGrid - halfSpriteGrid)
        
        let bgNode = SKSpriteNode.init(color: .black, size: .init(width: tenth+game.gridSize.x * spriteGrid, height: tenth+game.gridSize.y * spriteGrid))
        bgNode.position = .init(x: size.width/2, y: size.height/2)
        bgNode.zPosition = -1
        addChild(bgNode)
    }

    func resetChildren() {
        superNode.removeAllChildren()
        for i in game.totalObjects {
            i.sprite.position = .init(x: i.position.x * spriteGrid, y: i.position.y * spriteGrid)
            superNode.addChild(i.sprite)
        }
    }
    
    var ultimateWin = false
    var smackKey: Int? = nil
    override func keyDown(with event: NSEvent) {
        if ultimateWin { return }
        print(event.keyCode)
        if smackKey != nil { return }
        smackKey = Int(event.keyCode)
        
        switch event.keyCode {
        case 126, 13: game.move(.up); resetChildren()
        case 123, 0: game.move(.left); resetChildren()
        case 125, 1: game.move(.down); resetChildren()
        case 124, 2: game.move(.right); resetChildren()
        case 49: game.undoMove(); resetChildren()
        default: break// game.move(.none)
        }
        
        superNode.alpha = game.alive ? 1 : 0.5
        if game.win {
            ultimateWin = true
            //view?.presentScene(SKScene())
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if let smack = smackKey, event.keyCode == smack {
            smackKey = nil
        }
    }
    
}
