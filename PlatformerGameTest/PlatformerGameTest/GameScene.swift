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
        print("---", players[0].velocity)
    }
    
    var annoyance: [() -> ()] = []
    override func didFinishUpdate() {
        annoyance.run()
        
        print("---", players[0].velocity)
        for i in sprites {
            
            for j in sprites {
                if i === j { continue }
                
                
                // Falling Down
                foo: if let j = j as? MovableSprite {
                    if !(i.minX...i.maxX).overlaps(j.minX...j.maxX) { break foo }
                    if i.velocity.dy == 0, j.velocity.dy == 0 { break foo }
                    if j.onGround.contains(where: { $0 === i }) { break foo }
                    if (i as? MovableSprite)?.onGround.contains(where: { $0 === j }) == true { break foo }
                    
                    if j.velocity.dy < 0 {
                        
                        if ((j.minY + (j.velocity.dy+1))...(j.maxY)).contains(i.maxY) {
                            if !j.onGround.contains(where: { $0 === i }) {
                                if j === players[0], i.frame.x == 16 {
                                    print("Foo")
                                }
                                j.landedOn(i)
                                print("-", j)
                            }
                        } else {
                            print("HMMM...")
                        }
                    } else if j.velocity.dy > 0 {
                        
                        if let i = i as? MovableSprite {
                            
                            if (j.minY...(j.maxY + j.velocity.dy)).contains(i.maxY) {
                                if i.velocity.dy < j.velocity.dy {
                                    if !i.onGround.contains(where: { $0 === j }) {
                                        i.landedOn(j)
                                        print("-", i)
                                    }
                                }
                            }
                            
                        }
                    }
                    
                }
                    
                    //if i.minX
                    if i.midX > j.midX {
                        if j.midY > i.midY {
                            if j.minY >= i.maxY { continue }
                        } else {
                            if j.maxY <= i.minY { continue }
                        }
                        
                        // Only Runs When Side by Side
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
                    
                    //print("HITO")
               // }
            }
        }
        print("---", players[0].velocity)
        
        for i in sprites {
            if let i = i as? MovableSprite {
                i.onGround.removeAll(where: { j in
                    print("abc", j.velocity.dx)
                    //if j.velocity.dx != 0 {
                        print("WOAH!")
                        i.position.x += j.velocity.dx
                    //}
                    print("----", players[0].velocity)
                    if i.position.y != j.maxY {
                        i.position.y = j.maxY
                    }
                    print("----", players[0].velocity)
                    
                    if j.midX < i.midX {
                        return i.minX >= j.maxX
                    }
                    if i.midX < j.midX {
                        return i.maxX <= j.minX
                    }
                    
                    return false
                })
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
