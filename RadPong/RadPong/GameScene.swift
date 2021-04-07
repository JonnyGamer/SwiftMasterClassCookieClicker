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
    
    var pongs: [SKNode] = []
    var pongBalls = 50
    
    var gameBegin = false
    
    override func didMove(to view: SKView) {
        reset()
    }
    
    func reset() {
        backgroundColor = .black
        removeAllChildren()
        
        gameBegin = false
        pongs = []
        
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
        
        player1 = createPaddle(.done)
        player1.position = .init(x: -450, y: 0)
        
        player2 = createPaddle(.done)
        player2.position = .init(x: 450, y: 0)
        players = [player1, player2]
        
        for i in 0..<pongBalls {
            pongs.append(createPong(.master))
        }
        
        let scoreNode = SKLabelNode.init(text: "\(p1) - \(p2)")
        addChild(scoreNode)
        scoreNode.position.y = 450
    }
    
    
    enum PaddleDifficulty: Int {
        case done = 2000
        case easy = 250
        case regular = 200
        case hard = 100
        case master = 50
        case auto = 249
    }
    func createPaddle(_ difficulty: PaddleDifficulty) -> SKShapeNode {
        return createPaddle(difficulty.rawValue)
    }
    func createPaddle(_ height: Int) -> SKShapeNode {
        let paddle = createCustomShape(height: height) //2 00
        paddle.physicsBody?.isDynamic = false
        return paddle
    }
    
    enum BallDifficulty: Int {
        case easy = 50
        case regular = 25
        case hard = 10
        case master = 5
    }
    func createPong(_ difficulty: BallDifficulty = .regular) -> SKShapeNode {
        let pong = createCustomShape(width: difficulty.rawValue, height: difficulty.rawValue) // 25
        pong.physicsBody?.linearDamping = 0
        pong.physicsBody?.allowsRotation = false
        pong.physicsBody?.restitution = 1.01
        //pong.physicsBody?.usesPreciseCollisionDetection = true
        return pong
    }
    
    
    func createCustomShape(width: Int = 25, height: Int) -> SKShapeNode {
        let shape = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 10)
        shape.fillColor = .white
        shape.strokeColor = .clear
        shape.physicsBody = SKPhysicsBody(polygonFrom: shape.path!)
        shape.physicsBody?.usesPreciseCollisionDetection = true
        
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
            if player1.difficulty(.done) { return }
            movePaddle(player1, direction: 1000)
        }
        
        if keyCode == 1 || keyCode == 125 {
            if player1.difficulty(.done) { return }
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
        pongs.forEach {
            
            if foundMax === player2 {
                foundMax = $0
            } else {
                if $0.position.x > foundMax.position.x {
                    foundMax = $0
                }
            }
            
            if foundMin === player1 {
                foundMin = $0
            } else {
                if $0.position.x < foundMin.position.x {
                    foundMin = $0
                }
            }
            
            if abs($0.physicsBody!.velocity.dx) < 700 {
                $0.physicsBody?.velocity.dx *= 1.02
            }
            if abs($0.physicsBody!.velocity.dy) < 700 {
                $0.physicsBody?.velocity.dy *= 1.02
            }
            
            
            if !end {
                if $0.frame.maxX < -550 {
                    if player1.difficulty(.done) {
                        $0.run(.moveTo(x: player1.frame.maxX+50, duration: 0.1))
                       return
                    }
                    end = true
                    p2 += 1
                    reset()
                } else if $0.frame.minX > 500 {
                    if player2.difficulty(.done) {
                        $0.run(.moveTo(x: player2.frame.maxX-50, duration: 0.1))
                       return
                    }
                    end = true
                    p1 += 1
                    reset()
                }
            }
            
        }
        if end { return }
        
        
        let dy = Double(abs(player2.position.y - foundMax.position.y))
        let dy2 = Double(abs(player1.position.y - foundMin.position.y))
        
        if player2.difficulty(.auto) {
            player2.run(.moveTo(y: foundMax.position.y, duration: 0.1)) // dy / 1000 - reg mode
        }
        if player1.difficulty(.auto) {
            player1.run(.moveTo(y: foundMin.position.y, duration: 0.1)) // dy / 1000 - reg mode
        }
        
        for player in players {
            if player.difficulty(.done) {
                // Too Big
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
            let yMovement = Int.random(in: -1000...1000)
            
            for i in self.pongs {
                xMovement *= -1
                i.physicsBody?.velocity = .init(dx: xMovement, dy: 0)
            }
            
        })]))
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let pong = [contact.bodyA.node!, contact.bodyB.node!].first(where: { pongs.contains($0) }) else { return }
        
        if let _ = [contact.bodyA.node, contact.bodyB.node].first(where: { $0 === player1 }) as? SKNode {
            if !player1.hasActions() {
                if player1.difficulty(.done) {
                    pong.xScale *= 1.1//pong.setScale(1)
                    pong.yScale *= 1.1//pong.setScale(1)
                    pong.physicsBody?.velocity.dx = 700
                    if pong.xScale > 20 {
                        pong.setScale(20)
                    }
                    //pong.run(.move(to: .zero, duration: 1))
                }
                pong.physicsBody?.velocity.dx = 700
                pong.physicsBody?.velocity.dy = 0
            } else {
                pong.physicsBody?.velocity.dx = 700
                pong.physicsBody?.velocity.dy = CGFloat.random(in: -1000...1000)
            }
        } else if let _ = [contact.bodyA.node, contact.bodyB.node].first(where: { $0 === player2 }) {
            if !player2.hasActions() {
                if player2.difficulty(.done) {
                    pong.xScale *= 1.1//pong.setScale(1)
                    pong.physicsBody?.velocity.dx = -700
                    pong.yScale *= 1.1
                    if pong.xScale > 20 {
                        pong.setScale(20)
                    }
                    //pong.run(.move(to: .zero, duration: 1))
                }
                pong.physicsBody?.velocity.dy = 0
            } else {
                pong.physicsBody?.velocity.dx = -700
                pong.physicsBody?.velocity.dy = CGFloat.random(in: -1000...1000)
            }
        }
    }
    
    
}

extension SKNode {
    func difficulty(_ d: GameScene.PaddleDifficulty) -> Bool {
        return Int(frame.height) == d.rawValue
    }
}
