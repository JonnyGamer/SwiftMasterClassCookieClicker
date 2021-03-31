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
    var pong: SKNode!
    var pong2: SKNode!
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
        
        player1 = createPaddle()
        player1.position = .init(x: -450, y: 0)
        
        player2 = createPaddle()
        player2.position = .init(x: 450, y: 0)
        
        pong = createPong()
        pong2 = createPong()
        
        let scoreNode = SKLabelNode.init(text: "\(p1) - \(p2)")
        addChild(scoreNode)
        scoreNode.position.y = 450
    }
    
    
    
    func createPaddle() -> SKShapeNode {
        let paddle = createCustomShape(height: 200)
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
        
        if player1.frame.minY < -500 {
            player1.position.y = -500 + player1.frame.height/2
        } else if player1.frame.maxY > 500 {
            player1.position.y = 500 - player1.frame.height/2
        }
        
        if pong.position.x > pong2.position.x {
            //player2.position.y = pong.position.y
            player2.run(.moveTo(y: pong.position.y, duration: 0.15))
        } else {
            //player2.position.y = pong2.position.y
            player2.run(.moveTo(y: pong2.position.y, duration: 0.15))
        }
        
        if player2.frame.minY < -500 {
            player2.position.y = -500 + player2.frame.height/2
        } else if player2.frame.maxY > 500 {
            player2.position.y = 500 - player2.frame.height/2
        }
        
        if pong.frame.maxX < -550 || pong2.frame.maxX < -550 {
            p2 += 1
            reset()
        } else if pong.frame.minX > 500 || pong2.frame.minX > 500 {
            p1 += 1
            reset()
        }
    }
    
    var p1 = 0, p2 = 0
    func startGame() {
        if gameBegin { return }
        gameBegin = true
        
        let xMovement = Bool.random() ? -700 : 700
        let yMovement = Int.random(in: -1000...1000)
        pong.physicsBody?.velocity = .init(dx: xMovement, dy: yMovement)
        pong2.physicsBody?.velocity = .init(dx: -xMovement, dy: yMovement)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
    }
    
    
}
