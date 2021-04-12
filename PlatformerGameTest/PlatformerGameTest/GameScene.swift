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
    var magicCamera: SKCameraNode = .init()
    
    var doThisWhenJumpButtonIsPressed: [() -> ()] = []
    var doThisWhenLeftButtonIsPressed: [() -> ()] = []
    var doThisWhenRightButtonIsPressed: [() -> ()] = []
    
    var players: [Sprites] = []
    var woah: SKNode!
    
    override func begin() {
        let player = Inky()
        player.add(self)
        players.append(player)
        player.position.x = 16
        woah = player.skNode
        add(player)
        
        let enemy = Chaser()
        enemy.add(self)
        add(enemy)
        
        camera = magicCamera
        magicCamera.position.y += scene!.frame.height/2
        addChild(magicCamera)
        //addChild(magicCamera)
    }
    
    func buttonPressed(_ button: Button) {
        switch button {
        case .jump: doThisWhenJumpButtonIsPressed.run()// .forEach { $0() }//  charactersThatJumpWhenJumpButtonIsPressed.forEach { $0.jump() }
        case .left: doThisWhenLeftButtonIsPressed.run()
        case .right: doThisWhenRightButtonIsPressed.run()
        }
    }
    
    var pressingUp: Bool = false
    var pressingLeft: Bool = false
    var pressingRight: Bool = false
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 123 {
            pressingLeft = true
        }
        if event.keyCode == 124 {
            pressingRight = true
        }
        if event.keyCode == 126 {
            pressingUp = true
        }
    }
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 123 {
            pressingLeft = false
        }
        if event.keyCode == 124 {
            pressingRight = false
        }
//        if event.keyCode == 126 {
//            pressingUp = false
//        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if pressingUp {
            doThisWhenJumpButtonIsPressed.run()
            pressingUp = false
        }
        if pressingRight { doThisWhenRightButtonIsPressed.run() }
        if pressingLeft { doThisWhenLeftButtonIsPressed.run() }
        
        magicCamera.run(.moveTo(x: woah.position.x, duration: 0.1))
    }
    
    var annoyance: [() -> ()] = []
    override func didFinishUpdate() {
        annoyance.run()
    }
    
}

//let sceno = Scene()
//sceno.begin()
