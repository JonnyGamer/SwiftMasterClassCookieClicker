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
extension Scene {
    func add(_ this: BasicSprite) {
        sprites.append(this)
        addChild(this.skNode)
    }
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
    var doThisWhenStanding: [() -> ()] = []
    
    var players: [Inky] = []
    var woah: SKNode!
    
    var movableSprites: [MovableSprite] = []
    var sprites: [BasicSprite] = []
    
    override func begin() {
        let player = Inky(box: (4, 4))
        player.add(self)
        players.append(player)
        player.startPosition((-64,50))
        woah = player.skNode
        add(player)
        
        let enemy = Chaser(box: (16, 16))
        enemy.add(self)
        enemy.startPosition((0,200))
        add(enemy)
        print(enemy.bumpedFromBottom)
//        let enemy2 = Chaser(box: (16, 16))
//        enemy2.add(self)
//        enemy2.startPosition((0,300))
//        add(enemy2)
        
        
        let enemy2 = Chaser(box: (16, 16))
        enemy2.add(self)
        enemy2.startPosition((64+16+16,0))
        add(enemy2)

        let enemy3 = Chaser(box: (16, 16))
        enemy3.add(self)
        enemy3.startPosition((64+16+16+16+16,0))
        add(enemy3)
        
        let g = GROUND(box: (1000, 16))
        g.startPosition((-500, -8))
        g.add(self)
        g.skNode.alpha = 0.5
        add(g)
        
        let g4 = GROUND(box: (300, 16))
        g4.startPosition((-400, -8+16+16))
        g4.add(self)
        g4.skNode.alpha = 0.5
        add(g4)
        

        let g2 = GROUND(box: (16, 1000))
        g2.startPosition((200, -8))
        g2.add(self)
        g2.skNode.alpha = 0.5
        add(g2)
        
        let g3 = GROUND(box: (16, 1000))
        g3.startPosition((-200, -8))
        g3.add(self)
        g3.skNode.alpha = 0.5
        add(g3)

        
        addChild(SKSpriteNode.init(color: .gray, size: CGSize.init(width: 10, height: 10)))
        
        camera = magicCamera
        magicCamera.position.y += scene!.frame.height/2
        magicCamera.position.x = woah.position.x
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
        if event.keyCode == 123, !pressingLeft {
            pressingLeft = true
        }
        if event.keyCode == 124, !pressingRight {
            pressingRight = true
        }
        if event.keyCode == 126, !pressingUp {
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
        if !pressingLeft, !pressingRight { doThisWhenStanding.run() }
        
        magicCamera.run(.moveTo(x: woah.position.x, duration: 0.1))
        magicCamera.run(.moveTo(y: max(50, woah.position.y), duration: 0.1))
    }
    
    
    


    

    
    var annoyance: [() -> ()] = []
    override func didFinishUpdate() {
        annoyance.run()
        print("-")
        print("ok")
        for i in sprites.shuffled() {
            checkForCollision(i)
        }
        
        // Stay on Higher Ground
        for i in sprites {
            if let i = i as? MovableSprite {
                
                let iOnGround = i.onGround
                
                print(i, iOnGround.count)
                i.onGround = i.onGround.filter { j in
                    
                    // Only stick on the highest ground.
                    if iOnGround.contains(where: { $0.maxY > j.maxY }) {
                        return !true
                    }
                    
                    // TEST LATER: Move with Ground X
                    //if j.velocity.dx != 0 {
                        // i.position.x += j.velocity.dx
                    //}
                    
                    // Stick to the highest ground if not already on it.
                    if i.position.y != j.maxY {
                        i.position.y = j.maxY
                    }
                    
                    // Check if still on Ground...
                    if j.midX < i.midX {
                        return !(i.minX >= j.maxX)
                    }
                    if i.midX < j.midX {
                        return !(i.maxX <= j.minX)
                    }
                    
                    return !false
                }
                
                // If not on groud, fall
                if i.onGround.isEmpty {
                    i.fall()
                }
            }
        }
        
        if players[0].minY < 0 {
            print("NONONO")
        }
        
    }
    
}

//let sceno = Scene()
//sceno.begin()
