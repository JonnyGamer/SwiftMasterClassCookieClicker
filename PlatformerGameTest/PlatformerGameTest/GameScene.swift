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
        //sprites.insert(this)
        if let s = this as? MovableSprite {
            movableSprites.insert(s)
        } else if let s = this as? BasicSprite & SKActionable {
            actionableSprites.insert(s)
            addChild(s.actionSprite)
        } else {
            quadtree.insert(this)
        }
        
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
    var doThisWhenJumpButtonIsReleased: [() -> ()] = []
    var doThisWhenMovedOffScreen: [() -> ()] = []
    
    var players: [Inky] = []
    var woah: SKNode!
    
    var actionableSprites: Set<BasicSprite> = []
    var movableSprites: Set<BasicSprite> = []
    var sprites: Set<BasicSprite> = []
    var quadtree: QuadTree = QuadTree.init(.init(x: -512000, y: -512000, width: 1024000, height: 1024000))
    
    override func begin() {
        let player = Inky(box: (4, 4))
        player.add(self)
        players.append(player)
        player.startPosition((-64-100,300))
        woah = player.skNode
        add(player)
        
        let enemy = Chaser(box: (16, 16))
        enemy.add(self)
        enemy.startPosition((0,200))
        add(enemy)
        print(enemy.bumpedFromBottom)
        
        // Around 25 moving things per level is SAFE :)
//        for i in 1...30 {
//            let enemy21 = Chaser(box: (16, 16))
//            enemy21.add(self)
//            enemy21.startPosition((64+16+16,100 + (i*100)))
//            add(enemy21)
//        }
        
        let enemy2 = Chaser(box: (16, 16))
        enemy2.add(self)
        enemy2.startPosition((64+16+16,100))
        add(enemy2)

        let enemy3 = Chaser(box: (16, 16))
        enemy3.add(self)
        enemy3.startPosition((64+16+16+16+16,100))
        add(enemy3)
        
//        let g = GROUND(box: (1000, 16))
//        g.startPosition((0, -8))
//        g.add(self)
//        g.skNode.alpha = 0.5
//        add(g)
        
        let g0 = Moving_GROUND(box: (1000, 16))
        g0.startPosition((-1100, 100))
        g0.add(self)
        g0.skNode.alpha = 0.5
        add(g0)
        //g0.skNode.run(.moveBy(x: 100, y: 0, duration: 10))
        
        let g4 = GROUND(box: (300, 16))
        g4.startPosition((-400, -8+16+16))
        g4.add(self)
        g4.skNode.alpha = 0.5
        add(g4)
        
        let g5 = GROUND(box: (16, 300))
        g5.startPosition((400, -8))
        g5.add(self)
        g5.skNode.alpha = 0.5
        add(g5)
        
        for i in (0...10000) {
            let g2 = GROUND(box: (16, 16))
            g2.startPosition((-1000 + (i*16),-30))
            g2.add(self)
            g2.skNode.alpha = 0.5
            add(g2)
        }
        
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
        print(quadtree)
        //print(quadtree.total)
        //print(quadtree.allObjects.count, movableSprites.count)
        print("HMM")
        
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
        if event.keyCode == 123, !pressingLeft { pressingLeft = true }
        if event.keyCode == 124, !pressingRight { pressingRight = true }
        if event.keyCode == 49, !pressingUp {
            pressingUp = true
            doThisWhenJumpButtonIsPressed.run()
        }
    }
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 123 { pressingLeft = false }
        if event.keyCode == 124 { pressingRight = false }
        if event.keyCode == 49 {
            pressingUp = false
            doThisWhenJumpButtonIsReleased.run()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if pressingRight { doThisWhenRightButtonIsPressed.run() }
        if pressingLeft { doThisWhenLeftButtonIsPressed.run() }
        if !pressingLeft, !pressingRight { doThisWhenStanding.run() }
        
        // Run Camera
        magicCamera.run(.moveTo(x: woah.position.x, duration: 0.1))
        magicCamera.run(.moveTo(y: max(50, woah.position.y), duration: 0.1))
    }
    
    
    override func didFinishUpdate() {
        doThisWhenMovedOffScreen.run()
        
        // Run SKActions on Actionable Sprites (Must be inside this didFinishUpdate func)
        for i in actionableSprites {
            if let j = i as? SKActionable {
                i.setPosition((Int(j.actionSprite.frame.minX), Int(j.actionSprite.frame.minY)))
            }
        }
        

        // Run any `.always` actions
        for i in movableSprites.union(actionableSprites) {
            i.annoyance.run()
            
            // Carry things. (Soon: Make this generic enum code as well.)
            // Move with Ground X
            if let j = i as? MovableSprite {
                for k in j.onGround {
                    //i.addVelocity(k.velocity)
                    //i.newPosition(k.position)
                    //if k as? SKActionable
                    
//                    if k as? SKActionable != nil {
//                        i.addVelocity(k.velocity)
//                        print("-", i.velocity)
//                    }
//                    
//                    if k as? MovableSprite != nil {
//                        i.addVelocity(k.velocity)
//                        print("-", i.velocity)
//                    }
                    
                    if k.velocity.dx != 0 {
                        let wow = i.previousPosition.x
                        i.position.x += k.velocity.dx
                        i.previousPosition.x = wow
                    }
                    
                    //if k.velocity.dy != 0 {
                      //  i.position.y += k.velocity.dy
                    //}
                    
                }
            }
        }
        

        
        
        // Create a Quadtree for Moving Objects
        let movableSpritesTree = QuadTree.init(quadtree.size)
        for i in movableSprites {
            // Insert all Moving Sprites
            movableSpritesTree.insert(i)
        }
        for i in actionableSprites {
            // Insert all Action Sprites
            movableSpritesTree.insert(i)
        }
        
        // Check all Moving Sprites for collisions.
        for i in movableSprites {
            checkForCollision(i, movableSpritesTree)
        }
        
        // Stay on Higher Ground
        for i in movableSprites {
            
            if let i = i as? MovableSprite {
                
                // If not on groud, fall
                if i.onGround.isEmpty {
                    i.doThisWhenNotOnGround.run()
                }
                
                var groundsRemoved: [BasicSprite] = []
                let iOnGround = i.onGround
                
                i.onGround = i.onGround.filter { j in
                    
                    // Only stick on the highest ground.
                    if iOnGround.contains(where: { $0.maxY > j.maxY }) {
                        return !true
                    }
                    
                    // Stick to the highest ground if not already on it.
                    if i.position.y != j.maxY {
                        i.position.y = j.maxY
                    }
                    
                    // Check if still on Ground...
                    if j.midX < i.midX {
                        if !(i.minX >= j.maxX) == false { groundsRemoved.append(j) }
                        return !(i.minX >= j.maxX)
                    }
                    if i.midX < j.midX {
                        if !(i.maxX <= j.minX) == false { groundsRemoved.append(j) }
                        return !(i.maxX <= j.minX)
                    }
                    
                    return !false
                }
                
                // Check if standing on Ledge
                if !i.onGround.isEmpty {
                    let wow1 = iOnGround.sorted(by: { $0.maxX > $1.maxX })
                    let wow2 = iOnGround.sorted(by: { $0.minX < $1.minX })
                    
                    if i.maxX > wow1[0].maxX {
                        i.standingOnLedge(n: wow1[0])
                    } else if i.minX < wow2[0].minX {
                        i.standingOnLedge(n: wow2[0])
                    } else {
                        i.standingOnLedge(n: nil)
                    }
                } else {
                    i.standingOnLedge(n: nil)
                }
            }
        }
        
    }
    
}
