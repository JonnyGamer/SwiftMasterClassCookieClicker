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
    var pongs: [SKNode] = []
    var pongBalls = 2
    
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
        
        player1 = createPaddle(200)
        player1.position = .init(x: -450, y: 0)
        
        player2 = createPaddle(200)
        player2.position = .init(x: 450, y: 0)
        
        for i in 0..<pongBalls {
            pongs.append(createPong())
        }
        
        let scoreNode = SKLabelNode.init(text: "\(p1) - \(p2)")
        addChild(scoreNode)
        scoreNode.position.y = 450
    }
    
    
    
    func createPaddle(_ height: Int) -> SKShapeNode {
        let paddle = createCustomShape(height: height) //2 00
        paddle.physicsBody?.isDynamic = false
        return paddle
    }
    
    func createPong() -> SKShapeNode {
        let pong = createCustomShape(height: 25)
        pong.physicsBody?.linearDamping = 0
        pong.physicsBody?.allowsRotation = false
        pong.physicsBody?.restitution = 1.01
        return pong
    }
    
    
    func createCustomShape(height: Int) -> SKShapeNode {
        let shape = SKShapeNode(rectOf: CGSize(width: 25, height: height), cornerRadius: 10)
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
            movePaddle(player1, direction: 1000)
        }
        
        if keyCode == 1 || keyCode == 125 {
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
        
        if player1.frame.minY < -500 {
            player1.position.y = -500 + player1.frame.height/2
        } else if player1.frame.maxY > 500 {
            player1.position.y = 500 - player1.frame.height/2
        }
        
        var foundMax = player2!
        var end = false
        pongs.forEach {
            
            if foundMax === player2 {
                foundMax = $0
            } else {
                if $0.position.x > foundMax.position.x {
                    foundMax = $0
                }
            }
            
            
            if !end {
                if $0.frame.maxX < -550 {
                    end = true
                    p2 += 1
                    reset()
                } else if $0.frame.minX > 500 {
                    end = true
                    p1 += 1
                    reset()
                }
            }
            
        }
        if end { return }
        
        
        let dy = Double(abs(player2.position.y - foundMax.position.y))
        
        player2.run(.moveTo(y: foundMax.position.y, duration: 0.15)) // dy / 1000 - reg mode
        
        
        
        if player2.frame.minY < -500 {
            player2.position.y = -500 + player2.frame.height/2
        } else if player2.frame.maxY > 500 {
            player2.position.y = 500 - player2.frame.height/2
        }
    }
    
    var p1 = 0, p2 = 0
    func startGame() {
        if gameBegin { return }
        gameBegin = true
        
        let wait = SKAction.wait(forDuration: 0.5)
        run(.sequence([wait, .run({
            
            var xMovement = Bool.random() ? -700 : 700
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
                pong.physicsBody?.velocity.dy = 0
            } else {
                pong.physicsBody?.velocity.dy = CGFloat.random(in: -1000...1000)
            }
        } else if let _ = [contact.bodyA.node, contact.bodyB.node].first(where: { $0 === player1 || $0 === player2 }) {
            if !player2.hasActions() {
                pong.physicsBody?.velocity.dy = 0
            } else {
                pong.physicsBody?.velocity.dy = CGFloat.random(in: -1000...1000)
            }
        }
    }
    
    
}
