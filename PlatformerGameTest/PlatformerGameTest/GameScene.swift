//
//  GameScene.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import SpriteKit
import GameplayKit
//
//class GameScene: SKScene {
//
//}
extension SKScene {
    func add(_ this: BasicSprite) { addChild(this.skNode) }
}

class MagicScene: SKScene {
    override func didMove(to view: SKView) { begin() }
    func begin() {}
}

class Scene: MagicScene {
    
    var doThisWhenJumpButtonIsPressed: [() -> ()] = []
    var doThisWhenLeftButtonIsPressed: [() -> ()] = []
    var doThisWhenRightButtonIsPressed: [() -> ()] = []
    
    var players: [Sprites] = []
    
    override func begin() {
        let player = Inky()
        player.add(self)
        players.append(player)
        player.position.x = 10
        add(player)
        
        let enemy = Chaser()
        enemy.add(self)
        add(enemy)
    }
    
    func buttonPressed(_ button: Button) {
        switch button {
        case .jump: doThisWhenJumpButtonIsPressed.run()// .forEach { $0() }//  charactersThatJumpWhenJumpButtonIsPressed.forEach { $0.jump() }
        case .left: doThisWhenLeftButtonIsPressed.run()
        case .right: doThisWhenRightButtonIsPressed.run()
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 123 {
            doThisWhenLeftButtonIsPressed.run()
        }
        if event.keyCode == 124 {
            doThisWhenRightButtonIsPressed.run()
        }
        if event.keyCode == 126 {
            doThisWhenJumpButtonIsPressed.run()
        }
    }
    
    func upate() {
        
    }
}

//let sceno = Scene()
//sceno.begin()
