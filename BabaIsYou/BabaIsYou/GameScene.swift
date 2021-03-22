//
//  GameScene.swift
//  BabaIsYou
//
//  Created by Jonathan Pappas on 3/22/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let game = Game()
    var superNode = SKNode()
    
    override func didMove(to view: SKView) {
        addChild(superNode)
        
        print("Hello World WASSUP")
        game.start()
        resetChildren()
        
        superNode.position = .init(x: size.width/2, y: size.height/2)
        superNode.position.x -= CGFloat(game.gridSize.x * 50) - 50
        superNode.position.y -= CGFloat(game.gridSize.y * 50) - 50
        
        //print(game.gridSize.x)
        let bgNode = SKSpriteNode.init(color: .black, size: .init(width: 10+game.gridSize.x * 100, height: 10+game.gridSize.y * 100))
        bgNode.position = .init(x: size.width/2, y: size.height/2)
        bgNode.zPosition = -1
        addChild(bgNode)
        
        //while game.alive {
        //    let foo = readLine() ?? " "
        //    let ind = ["w", "s", "a", "d", " "].firstIndex(of: foo) ?? 5
        //
        //    game.move(Game.Cardinal.init(rawValue: ind) ?? .none)
        //    print(game)
        //}
        //
        //print("Good-bye World")
    }

    func resetChildren() {
        superNode.removeAllChildren()
        for i in game.totalObjects {
            superNode.addChild(i.sprite)
        }
    }
    
    var smackKey: Int? = nil
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        if smackKey != nil { return }
        smackKey = Int(event.keyCode)
        
        switch event.keyCode {
        case 126, 13: game.move(.up)
        case 123, 0: game.move(.left)
        case 125, 1: game.move(.down)
        case 124, 2: game.move(.right)
        default: break// game.move(.none)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        if let smack = smackKey, event.keyCode == smack {
            smackKey = nil
        }
    }
    
}
