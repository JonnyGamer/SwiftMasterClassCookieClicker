//
//  GameScene.swift
//  Pong
//
//  Created by Jonathan Pappas on 3/24/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var twoPlayers = true
    var player1: SKNode!
    var player2: SKNode!
    var pong: SKNode!
    
    var p1 = 0
    var p2 = 0
    var gameBegin = false
    
    override func didMove(to view: SKView) {
        reset()
    }
    
    func reset() {
        backgroundColor = .black
        gameBegin = false
        removeAllChildren()
        player1 = createPaddle()
        player1.position = .init(x: -450, y: 0)
        
        player2 = createPaddle()
        player2.position = .init(x: 450, y: 0)
        
        pong = createPong()
        
        physicsBody = .init(edgeLoopFrom: CGRect(origin: .init(x: -10000, y: -size.height/2), size: CGSize(width: 20000, height: size.height)))
        physicsBody?.isDynamic = false
        physicsBody?.restitution = 1
        physicsBody?.friction = 0
        physicsBody?.affectedByGravity = false
        physicsWorld.contactDelegate = self
        physicsBody?.contactTestBitMask = 1
        //physicsBody?.usesPreciseCollisionDetection = true
        
        let scoreNode = SKLabelNode.init(text: "\(p1) - \(p2)")
        addChild(scoreNode)
        scoreNode.position.y = 450
        
    }
    
    func createPaddle() -> SKShapeNode {
        let paddleShape = createCustomShape(height: 200)
        paddleShape.physicsBody?.isDynamic = false
        return paddleShape
    }
    
    func createPong() -> SKShapeNode {
        let pongShape = createCustomShape(height: 25)
        pongShape.physicsBody?.linearDamping = 0
        pongShape.physicsBody?.allowsRotation = false
        pongShape.physicsBody?.restitution = 1.01
        return pongShape
    }
    
    func createCustomShape(height: Int) -> SKShapeNode {
        let shape = SKShapeNode(rectOf: CGSize(width: 25, height: height), cornerRadius: 10)
        shape.fillColor = .white
        shape.strokeColor = .clear
        shape.physicsBody = SKPhysicsBody(polygonFrom: shape.path!)
        shape.physicsBody?.affectedByGravity = false
        shape.physicsBody?.friction = 0
        shape.physicsBody?.contactTestBitMask = 1
        //shape.physicsBody?.usesPreciseCollisionDetection = true
        addChild(shape)
        return shape
    }
    
    var pressing = false
    var pressing2 = false
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        
        case 49: startGame() // Press the Space Bar to begin
            
        // Player 1
        case 13: movePaddle(player1, direction: 1000) // W
        case 1: movePaddle(player1, direction: -1000) // S
            
        // Single Player may use arrow keys
        case 126: movePaddle(player1, direction: 1000, test: !twoPlayers)  // Up Arrow
        case 125: movePaddle(player1, direction: -1000, test: !twoPlayers) // Down Arrow

        // The Second Player
        case 31: movePaddle(player2, direction: 1000, test: twoPlayers)  // O
        case 37: movePaddle(player2, direction: -1000, test: twoPlayers) // L
            
        default: break
        }
    }
    
    func movePaddle(_ node: SKNode, direction: CGFloat, test: Bool = true) {
        if !test { return }
        if node === player1 {
            if pressing { return }
            pressing = true
        } else if node === player2 {
            if pressing2 { return }
            pressing2 = true
        }
        node.run(.moveBy(x: 0, y: direction, duration: 1))
    }
    
    override func keyUp(with event: NSEvent) {
        if !twoPlayers, (event.keyCode == 126 || event.keyCode == 125) {
            player1.removeAllActions()
            pressing = false
        }
        
        if (event.keyCode == 13 || event.keyCode == 1) {
            player1.removeAllActions()
            pressing = false
        }
        
        if twoPlayers, (event.keyCode == 31 || event.keyCode == 37) {
            player2.removeAllActions()
            pressing2 = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if player1.frame.minY < -500 {
            player1.position.y = -500 + player1.frame.size.height/2
        } else if player1.frame.maxY > 500 {
            player1.position.y = 500 - player1.frame.size.height/2
        }
        
        if !twoPlayers {
            player2.position.y = pong.position.y
        }
        
        if player2.frame.minY < -500 {
            player2.position.y = -500 + player2.frame.size.height/2
        } else if player2.frame.maxY > 500 {
            player2.position.y = 500 - player2.frame.size.height/2
        }
        
        if pong.frame.maxX < -550 {
            p2 += 1
            reset()
        } else if pong.frame.minX > 550 {
            p1 += 1
            reset()
        }
    }
    
    func startGame() {
        if gameBegin { return }
        gameBegin = true
        pong.physicsBody?.velocity = .init(dx: Bool.random() ? -700 : 700, dy: CGFloat.random(in: -100...100))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let _ = [contact.bodyA.node!, contact.bodyB.node!].first(where: { $0 === pong }) else { return }
        
        if let _ = [contact.bodyA.node, contact.bodyB.node].first(where: { $0 === player1 }) as? SKNode {
            pong.physicsBody?.velocity.dy = CGFloat.random(in: -1000...1000)
        } else if let _ = [contact.bodyA.node, contact.bodyB.node].first(where: { $0 === player1 || $0 === player2 }) {
            pong.physicsBody?.velocity.dy = CGFloat.random(in: -1000...1000)
        }
        
    }
    
}
