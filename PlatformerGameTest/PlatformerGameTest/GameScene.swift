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
        
        
//        let enemy2 = Chaser((box: (16, 16))
//        enemy2.add(self)
//        enemy2.startPosition((64+16+16,0))
//        add(enemy2)
//
//        let enemy3 = Chaser((box: (16, 16))
//        enemy3.add(self)
//        enemy3.startPosition((64+16+16+16+16,0))
//        add(enemy3)
        
        let g = GROUND(box: (1000, 16))
        g.startPosition((-500, -8))
        g.add(self)
        g.skNode.alpha = 0.5
        add(g)

        let g2 = GROUND(box: (16, 1000))
        g2.startPosition((200, -8))
        g2.add(self)
        g2.skNode.alpha = 0.5
        add(g2)

        
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
        
        for i in sprites.shuffled() {
            
            for j in sprites.shuffled() {
                if i === j { continue }
                
                
                // Falling Down
                foo: if let j = j as? MovableSprite {
                    if !(i.minX..<i.maxX).overlaps(j.minX..<j.maxX) { break foo }
                    if i.velocity.dy == 0, j.velocity.dy == 0 { break foo }
                    
                    if j.onGround.contains(where: { $0 === i }) { break foo }
                    if (i as? MovableSprite)?.onGround.contains(where: { $0 === j }) == true { break foo }
                    
                    if j.velocity.dy < 0 {
                        if ((j.minY + (j.velocity.dy-1))...(j.maxY)).contains(i.maxY) {
                            if !j.onGround.contains(where: { $0 === i }) {
                                i.bumpedFromBottom.forEach { $0(j) }
                                print("-", j)
                            }
                        }
                    } else if j.velocity.dy > 0 {
                        
                        if let i = i as? MovableSprite {
                            
                            if (j.minY...(j.maxY + j.velocity.dy)).contains(i.maxY) {
                                if i.velocity.dy < j.velocity.dy {
                                    if !i.onGround.contains(where: { $0 === j }) {
                                        
                                        // This line is needed, Otherwise bad bugs when pushing -> then jumping
                                        if j.maxX - j.velocity.dx <= i.minX { break foo }
                                        if j.minX - j.velocity.dx >= i.minX { break foo }
                                        
                                        j.bumpedFromBottom.forEach { $0(i) }
                                        print("-", i)
                                    }
                                }
                            }
                        }
                    }
                    
                }
                    
                if i.midX > j.midX {
                    if j.midY > i.midY {
                        if j.minY >= i.maxY { continue }
                    } else {
                        if j.maxY <= i.minY { continue }
                    }
                    
                    // Only Runs When Side by Side
                    if i.maxX > j.minX, i.minX < j.maxX {
                        if i.velocity.dx == -j.velocity.dx {
                            i.position.x = i.previousPosition.x
                            j.position.x = j.previousPosition.x
                        } else if -i.velocity.dx < j.velocity.dx {
                            
                            //i.position.x += j.velocity.dx
                            if let j = j as? MovableSprite {
                                i.bumpedFromRight.forEach { $0(j) }
                            }
                            
                            //i.position.x = j.maxX
                        } else {
                            //j.position.x += i.velocity.dx
                            if let i = i as? MovableSprite {
                                j.bumpedFromLeft.forEach { $0(i) }
                            }
                            
                            //j.position.x = i.minX - j.frame.x
                        }
                    }
                }
                    

            }
        }
        
        for i in sprites {
            if let i = i as? MovableSprite {
                
                let iOnGround = i.onGround
                
                print(i, iOnGround.count)
                i.onGround = i.onGround.filter { j in
                    
                    // Only stick on the highest ground.
                    if iOnGround.contains(where: { $0.maxY > j.maxY }) {
                        return !true
                    }
                    
                    // Move with Ground X
                    //if j.velocity.dx != 0 {
                        i.position.x += j.velocity.dx
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
