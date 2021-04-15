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
        let player = Inky(box: (16, 16))
        player.add(self)
        players.append(player)
        player.startPosition((-64-100,300))
        woah = player.skNode
        add(player)
        
        let g0 = GROUND.init(box: (1000, 1))
        g0.add(self)
        g0.startPosition((-g0.frame.x/2,10))
        add(g0)
        
        for i in 1...100 {
            let g1 = GROUND.init(box: (10, 10))
            g1.add(self)
            g1.startPosition(((-g1.frame.x/2)+(i*32),10))
            add(g1)
        }
        
        for i in 1...100 {
            let g1 = GROUND.init(box: (10, 10))
            g1.add(self)
            g1.startPosition(((-g1.frame.x/2),10+(i*10)))
            add(g1)
        }
        
        
        otherThings()
    }
    
    func otherThings() {
        addChild(SKSpriteNode.init(color: .gray, size: CGSize.init(width: 10, height: 10)))
        
        camera = magicCamera
        magicCamera.position.y += scene!.frame.height/2
        magicCamera.position.x = woah.position.x
        addChild(magicCamera)
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
