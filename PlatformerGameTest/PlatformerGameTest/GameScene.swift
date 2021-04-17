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
            addChild(s.skNode)
            if let q = this as? BasicSprite & SKActionable {
                addChild(q.actionSprite)
                q.actionSprite.position = CGPoint(x: s.position.x, y: s.position.y)
            }
            
        } else if let s = this as? BasicSprite & SKActionable {
            actionableSprites.insert(s)
            addChild(s.skNode)
            addChild(s.actionSprite)
            s.actionSprite.position = CGPoint(x: s.position.x, y: s.position.y)
        } else {
            quadtree.insert(this)
        }
        
        //addChild(this.helperNode)
        //(this.helperNode as? SKSpriteNode)?.anchorPoint = .zero
        //this.helperNode.alpha = 0.5
        //this.helperNode.position = .init(x: this.position.x, y: this.position.y)
        //print(this.helperNode.frame.size, this.helperNode.position)
    }
}

class MagicScene: SKScene {
    override func didMove(to view: SKView) { begin() }
    func begin() {}
}

class Scene: MagicScene {
    var magicCamera: SKCameraNode = .init()
    

    
    var players: [BasicSprite] = []
    var woah: SKNode!
    
    var actionableSprites: Set<BasicSprite> = []
    var movableSprites: Set<BasicSprite> = []
    var sprites: Set<BasicSprite> = []
    var quadtree: QuadTree = QuadTree.init(.init(x: -5120, y: -5120, width: 10240, height: 10240))
    
    var u = 16 // The unit!
    @discardableResult
    func build<T: BasicSprite>(_ this: T.Type, pos: (Int, Int), size: (Int, Int) = (1,1), player: Bool = false, image: String? = nil) -> T {
        let box = this.init(box: (size.0*u,size.1*u), image: image)
        box.startPosition((pos.0*u,pos.1*u))
        box.add(self)
        if player { players.append(box); woah = (box as! MovableSprite).skNode } // add player
        add(box)
        return box
    }
    var massiveHeight = 0
    
    override func begin() {
        quadtree = QuadTree.init(.init(x: -5120, y: -5120, width: 10240, height: 10240))
        sprites.removeAll(); movableSprites.removeAll(); actionableSprites.removeAll(); players.removeAll()
        
        if let loadScene = SKScene.init(fileNamed: "1-1") {
            backgroundColor = loadScene.backgroundColor
            for i in loadScene.children {
                guard let tileNode = i as? SKTileMapNode else { fatalError() }
                guard let tileName = i.name else { fatalError() }
                assert(tileNode.tileSize.width == tileNode.tileSize.height)
                u = Int(tileNode.tileSize.width)

                let numberOfColumns = tileNode.numberOfColumns
                let numberOfRows = tileNode.numberOfRows
                massiveHeight = numberOfRows

                var tileToUse: BasicSprite.Type? = nil
                switch tileName {
                case "bg": tileNode.removeFromParent(); addChild(tileNode); continue
                case "GROUND": tileToUse = GROUND.self; tileNode.removeFromParent(); addChild(tileNode)
                case "QuestionBlock": tileToUse = QuestionBox.self
                case "BrickBlock": tileToUse = BrickBox.self
                case "Anim": tileToUse = nil
                    
                case "None": continue
                default: fatalError()
                }
                //tileNode.name

                for x in 0..<numberOfColumns {
                    for y in 0..<numberOfRows {

                        if let tile = tileNode.tileGroup(atColumn: x, row: y) {
                            if let tileName = tile.name {
                                
                                if let tileToUse = tileToUse {
                                    let g0 = build(tileToUse, pos: (x,y), image: tileName)
                                } else {
                                    var newTileToUse: BasicSprite.Type!// = Goomba.self
                                    switch tileName {
                                    case "Goomba": newTileToUse = Goomba.self
                                    default: fatalError()
                                    }
                                    let g0 = build(newTileToUse, pos: (x,y), image: tileName)
                                }
                                
                                //print("- Just Added", tileName)
                            }

                        }
                    }
                }

            }
        }
        
        
        let player = build(Inky.self, pos: (3,2), player: true)
        
        let g0 = build(GROUND.self, pos: (-1,0), size: (1,massiveHeight*2))
        
        //let g0 = build(GROUND.self, pos: (0,-3), size: (69,2), image: "Ground")
        //let g1 = build(GROUND.self, pos: (g0.maxX/u+2,0), size: (15,2))
        //let g2 = build(GROUND.self, pos: (g1.maxX/u+3,0), size: (43,2))
        //let g3 = build(GROUND.self, pos: (g2.maxX/u+2,0), size: (43,2))
//        let pipe1 = build(GROUND.self, pos: (28,2), size: (2,2))
//        let pipe2 = build(GROUND.self, pos: (38,2), size: (2,3))
//        let pipe3 = build(GROUND.self, pos: (46,2), size: (2,4))
//        let pipe4 = build(GROUND.self, pos: (57,2), size: (2,4))
        
        
        //let q = build(QuestionBox.self, pos: (1, 9), image: "QuestionBlock")
        
        
        
        otherThings()
    }
    
    func otherThings() {
        addChild(SKSpriteNode.init(color: .gray, size: CGSize.init(width: 10, height: 10)))
        
        camera = magicCamera
        magicCamera.position.y = scene!.frame.height/2
        magicCamera.position.x = woah.position.x
        addChild(magicCamera)
    }
    
    
    var pressingUp: Bool = false
    var pressingLeft: Bool = false
    var pressingRight: Bool = false
    override func keyDown(with event: NSEvent) {
        if event.keyCode == 123, !pressingLeft { pressingLeft = true }
        if event.keyCode == 124, !pressingRight { pressingRight = true }
        if event.keyCode == 49 {
            pressingUp = true
        }
    }
    var releasingUp: Bool = false
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 123 { pressingLeft = false }
        if event.keyCode == 124 { pressingRight = false }
        if event.keyCode == 49 {
            releasingUp = true
            if (players[0] as? MovableSprite)?.dead == true {
                releasingUp = false
                removeAllActions()
                removeAllChildren()
                didMove(to: view!)
                return
            }
            
            //pressingUp = false
            //doThisWhenJumpButtonIsReleased.run()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Run Camera
        magicCamera.run(.moveTo(x: max(frame.width/2, woah.position.x), duration: 0.1))
        magicCamera.run(.moveTo(y: max(frame.height/2, min(woah.position.y, (massiveHeight.cg*u.cg)-(frame.height/2))), duration: 0.1))
    }
    
    
    override func didFinishUpdate() {
        
        let pressedRight = pressingRight// if pressingRight { doThisWhenRightButtonIsPressed.run() }
        let pressedLeft = pressingLeft// { doThisWhenLeftButtonIsPressed.run() }
        let pressedUp = pressingUp; pressingUp = false
        let releasedUp = releasingUp; releasingUp = false
        
        // Run SKActions on Actionable Sprites (Must be inside this didFinishUpdate func)
        for i in actionableSprites {
            if let j = i as? (ActionSprite & SKActionable), j.actionSprite.hasActions() {
                i.setPosition((Int(j.actionSprite.frame.minX), Int(j.actionSprite.frame.minY)))
            } else {
                i.setPosition(i.position)
            }
        }
        

        // Run any `.always` actions
        for i in movableSprites.union(actionableSprites) {
            i.everyFrame.run()
            
            if pressedLeft, pressedRight {
                // Hahaha. Can't move right and left at the same time ;)
            } else {
                if pressedRight { i.doThisWhenRightButtonIsPressed.run() }
                if pressedLeft { i.doThisWhenLeftButtonIsPressed.run() }
                if pressedLeft || pressedRight {
                    i.doThisWhenRightOrLeftIsPressed.run()
                } else {
                    i.doThisWhenNOTRightOrLeftIsPressed.run()
                }
            }
            
            if pressedUp {
                i.doThisWhenJumpButtonIsPressed.run()
            }
            if releasedUp { i.doThisWhenJumpButtonIsReleased.run() }
            
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
//                if i.onGround.isEmpty {
//                    i.doThisWhenNotOnGround.run(i)
//                }
                
                var groundsRemoved: [BasicSprite] = []
                let iOnGround = i.onGround
                
                i.onGround = i.onGround.filter { j in
                    
                    // If ground is dead
                    if j.dead {
                        groundsRemoved.append(j)
                        return !true
                    }
                    
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
                
//                if !groundsRemoved.isEmpty {
//                    print("NOonono")
//                }
                
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
