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
    
    var players: [Sprites] = []
    var woah: SKNode!
    
    var movableSprites: [MovableSprite] = []
    var sprites: [BasicSprite] = []
    
    override func begin() {
        let player = Inky(box: (16, 16))
        player.add(self)
        players.append(player)
        player.startPosition((-64,50))
        woah = player.skNode
        add(player)
        
        let enemy = Chaser(box: (16, 16))
        enemy.add(self)
        enemy.startPosition((0,200))
        add(enemy)
        
        
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
        add(g)
        
        
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
        if !pressingLeft, !pressingRight { doThisWhenStanding.run() }
        
        magicCamera.run(.moveTo(x: woah.position.x, duration: 0.1))
    }
    
    var annoyance: [() -> ()] = []
    override func didFinishUpdate() {
        annoyance.run()
        
        for i in sprites {
            if i === players[0] {
                print(i.position.y)
            }
            
            for j in sprites {
                if i === j { continue }
                
                if i.skNode.intersects(j.skNode) {
                    
                    if i.midY > j.midY {
                        
                        if i.maxY > j.minY, i.minY < j.maxY {
                            
                            if i.velocity.dy == -j.velocity.dy {
                                i.position = i.previousPosition
                                j.position = j.previousPosition
                            } else if -i.velocity.dy < j.velocity.dy {
                                print("LANDED ON")
                                
                                if let i = i as? MovableSprite {
                                    i.onGround.append(j)// = true
                                    i.position.y += j.velocity.dy
                                }
                                
                            } else {
                                if let j = j as? MovableSprite, j.onGround.isEmpty {
                                    j.position.y += i.velocity.dy
                                } else if let i = i as? MovableSprite {
                                    i.onGround.append(j)// = true
                                    i.position.y = j.maxY
                                }
                                
                                print("LANDED ON 2, \(i.velocity), \(j.velocity)")
                            }
                        }
                        
                    }
                    
                    if i.midX > j.midX {
                        if j.midY > i.midY {
                            if j.minY >= i.maxY { continue }
                        } else {
                            if j.maxY <= i.minY { continue }
                        }
                        
                        if i.maxX > j.minX, i.minX < j.maxX {
                            if i.velocity.dx == -j.velocity.dx {
                                i.position = i.previousPosition
                                j.position = j.previousPosition
                            } else if -i.velocity.dx < j.velocity.dx {
                                i.position.x += j.velocity.dx
                                //i.position.x = j.maxX
                            } else {
                                j.position.x += i.velocity.dx
                                //j.position.x = i.minX - j.frame.x
                            }
                        }
                    }
                    
                }
            }
        }
        
        for i in sprites {
            if let i = i as? MovableSprite {
                i.onGround.removeAll(where: { j in
                    if j.midX < i.midX {
                        return i.minX >= j.maxX
                    }
                    if i.midX < j.midX {
                        return i.maxX <= j.minX
                    }
                    i.position.y = j.maxY
                    i.position.x += j.velocity.dx
                    
                    return false
                })
//                if i.onGround.isEmpty, !i.falling {
//                    i.fall()
//                }
            }
        }
        
    }
    
}

//let sceno = Scene()
//sceno.begin()
