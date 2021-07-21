//
//  GameScene.swift
//  PongWithClass
//
//  Created by Jonathan Pappas on 3/31/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player1: SKNode!
    var player2: SKNode!
    var players: [SKNode] = []
    
    //var pong: SKNode!
    //var pong2: SKNode!
    var pongs: [SKNode] = []
    var pongBalls = 1
    
    var gameBegin = false
    
    override func didMove(to view: SKView) {
        reset()
    }
    
    func reset() {
        backgroundColor = .black
        removeAllChildren()
        gameBegin = false
        
        physicsBody = .init(edgeLoopFrom: CGRect(
                                origin: .init(x: -10000, y: -size.height/2),
                                size: CGSize(width: 20000, height: size.height)
        ))
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 1
        physicsBody?.friction = 0
        physicsBody?.affectedByGravity = false
        physicsWorld.contactDelegate = self
        physicsBody?.contactTestBitMask = 1
        
        player1 = createPaddle(.regular)
        player1.position = .init(x: -450, y: 0)
        
        player2 = createPaddle(.auto)
        player2.position = .init(x: 450, y: 0)
        
        players = [player1, player2]
        
        pongs = []
        for _ in 1...pongBalls {
            pongs.append(createPong(.easy))
        }
        
        let scoreNode = SKLabelNode.init(text: "\(p1) - \(p2)")
        addChild(scoreNode)
        scoreNode.position.y = 450
    }
    
    enum PaddleDifficulty: Int {
        case wall = 999
        case regular = 200
        case hard = 100
        case master = 50
        case auto = 99//199
    }
    
    func createPaddle(_ difficulty: PaddleDifficulty) -> SKShapeNode {
        let paddle = createCustomShape(height: difficulty.rawValue)
        paddle.physicsBody?.isDynamic = false
        return paddle
    }
    
    enum PongDifficulty: Int {
        case easy = 50
        case regular = 25
        case hard = 10
        case master = 5
    }
    
    func createPong(_ difficulty: PongDifficulty) -> SKShapeNode {
        let pong = createCustomShape(width: difficulty.rawValue, height: difficulty.rawValue)
        pong.physicsBody?.linearDamping = 0
        pong.physicsBody?.allowsRotation = false
        pong.physicsBody?.restitution = 1.01
        return pong
    }
    
    
    func createCustomShape(width: Int = 50, height: Int) -> SKShapeNode {
        let shape = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 20) // Corner Radius Causes Leaks
        shape.fillColor = .white
        shape.strokeColor = .clear
        shape.physicsBody = SKPhysicsBody(polygonFrom: shape.path!)
        
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.friction = 0
        shape.physicsBody?.contactTestBitMask = 1
        
        addChild(shape)
        return shape
    }
    
    
    
    var pressing = false
    
    override func keyDown(with event: NSEvent) {
        
        let keyCode = event.keyCode
        
        if keyCode == 49 {
            startGame()
        }
        
        if keyCode == 13 || keyCode == 126 {
            if player1.difficulty(.wall) { return }
            movePaddle(player1, direction: 1000)
        }
        
        if keyCode == 1 || keyCode == 125 {
            if player1.difficulty(.wall) { return }
            movePaddle(player1, direction: -1000)
        }
            
    }
    
    func movePaddle(_ node: SKNode, direction: CGFloat) {
        
        if node === player1 {
            if pressing { return }
            pressing = true
        }
        
        node.run(.moveBy(x: 0, y: direction, duration: 1))
    }
    
    
    override func keyUp(with event: NSEvent) {
        let keyCode = event.keyCode
        
        if keyCode == 126 || keyCode == 125 || keyCode == 1 || keyCode == 13 {
            player1.removeAllActions()
            pressing = false
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !gameBegin { return }
        
        var foundMax = player2!
        var foundMin = player1!
        
        var end = false
        for pong in pongs {
            
            if pong.physicsBody!.velocity.dx > 0 {
                if foundMax === player2 {
                    foundMax = pong
                } else {
//                    if pong.physicsBody!.velocity.dx > foundMin.physicsBody!.velocity.dx{
//                        foundMax = pong
//                    }
                    if pong.position.x > foundMax.position.x {
                        foundMax = pong
                    }
                }
            }
            
            if pong.physicsBody!.velocity.dx < 0 {
                if foundMin === player1 {
                    foundMin = pong
                } else {
//                    if pong.physicsBody!.velocity.dx < foundMin.physicsBody!.velocity.dx{
//                        foundMin = pong
//                    }
                    if pong.position.x < foundMin.position.x {
                        foundMin = pong
                    }
                }
            }
            
            if abs(pong.physicsBody!.velocity.dx) < 700 {
                pong.physicsBody?.velocity.dx *= 1.02
            }
            
            if abs(pong.physicsBody!.velocity.dy) > 700 {
                pong.physicsBody?.velocity.dy /= 1.02
            }
            
            if !end {
                
                // TRYING TO BGFIX
//                if pong.frame.minX > 600 {
//                    if player2.difficulty(.wall) {
//                        pong.position.x = player2.position.x - pong.frame.width
//                        //pong.position.x -= (pong.position.x - player2.position.x) + 50// 400
//                        pong.physicsBody?.velocity.dx *= -1
//                        //pong.position.x = 0
//                        print("AUGH")
//                    }
//
////                    print(pong.position.y)
////                    pong.removeFromParent()
////                    pongs = pongs.filter { $0 !== pong }
//                }
                
                if pong.frame.maxX < -600 {
                    // what if player 1 is wall
                    p2 += 1
                    end = true
                    reset()
                } else if pong.frame.minX > 600 {
                    // what if player 2 is wall
                    p1 += 1
                    end = true
                    reset()
                }
                
            }
        }
        if end { return }
        
        
        
        
        
//        if player2.difficulty(.auto) {
//            //player2.position.y = foundMax.position.y
//            player2.run(.moveTo(y: foundMax.position.y, duration: 0.1))
//            if foundMax !== player2, player2.frame.minX < (foundMax.frame.maxX+10) {
//                //player2.removeAction(forKey: "Hello")
//
//                player2.run(.sequence([.moveBy(x: 200, y: 0, duration: 0.1), .moveTo(x: 450, duration: 0.05)]))
//            }
//        }
//
//        if player1.difficulty(.auto) {
//            //player2.position.y = foundMax.position.y
//            player1.run(.moveTo(y: foundMin.position.y, duration: 0.1))
//            if foundMin !== player1, player1.frame.maxX > (foundMax.frame.minX-10) {
//                //player1.removeAction(forKey: "Hello")
//
//                player1.run(.sequence([.moveBy(x: -200, y: 0, duration: 0.1), .moveTo(x: -450, duration: 0.05)]))
//            }
//        }
        // BUGFIX THE AUTO so that it wont go past the wall
        if player2.difficulty(.auto) {
            //player1.position.y = foundMax.position.y
            player2.run(.moveTo(y: foundMax.position.y, duration: 0.1))
        }
        if player1.difficulty(.auto) {
            //player1.position.y = foundMax.position.y
            player1.run(.moveTo(y: foundMin.position.y, duration: 0.1))
        }
        
        for player in players {
            if player.difficulty(.wall) {
                // Do nothing
            } else if player.frame.minY < -500 {
                player.position.y = -500 + player.frame.height/2
            } else if player.frame.maxY > 500 {
                player.position.y = 500 - player.frame.height/2
            }
        }
        
        
        
    }
    
    var p1 = 0, p2 = 0
    func startGame() {
        if gameBegin { return }
        gameBegin = true
        
        let wait = SKAction.wait(forDuration: 0.5)
        run(.sequence([wait, .run({
            
            var xMovement = Bool.random() ? -100 : 100
            let yMovement = 0//Int.random(in: -1000...1000)
            
            for i in self.pongs {
                xMovement *= -1
                i.physicsBody?.velocity = .init(dx: xMovement, dy: yMovement)
            }
            

            
        })]))
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    
}


extension SKNode {
    func difficulty(_ d: GameScene.PaddleDifficulty) -> Bool {
        return Int(frame.height) == d.rawValue
    }
}



