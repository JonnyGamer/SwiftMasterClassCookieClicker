//
//  PlayScene.swift
//  FlamboyantBirds
//
//  Created by Jonathan Pappas on 3/3/21.
//

import Foundation
import SpriteKit

class PlayScene: SKScene, SKPhysicsContactDelegate {
    var bird = Bird.Make()
    var gameStarted = false
    var isAlive = true
    
    override func update(_ currentTime: TimeInterval) {
        if isAlive {
            let one = bird.physicsBody!.velocity.dy
            let two = CGFloat(one < 0.4 ? 0.003 : 0.001)
            let birdRotation = one * two
            bird.run(SKAction.rotate(toAngle: min(max(-1.57, birdRotation), 0.6), duration: 0.08))
        }
        
//        if bird.frame.maxX < frame.minX {
//            fatalError()
//        }
        
    }
    
    override func mouseDown(with event: NSEvent) {
        if !gameStarted {
            press.removeFromParent()
            getReady.removeFromParent()
            beginGame()
            gameStarted = true
            bird.flap()
            
            run(createPipes())
            
        } else if isAlive {
            bird.flap()
        }
        
    }
    
    
    override func didMove(to view: SKView) {
        reset()
    }
    
    func reset() {
        physicsWorld.contactDelegate = self
        addChild(bird)
        createBackgrounds()
        createInstrctions()
    }
    
    
    var backgroundObjects: [SKSpriteNode] = []
    var groundObjects: [SKSpriteNode] = []
    
    func createBackgrounds() {
        
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.zPosition = -.infinity
            bg.position.x = CGFloat(i) * bg.size.width
            addChild(bg)
            backgroundObjects.append(bg)
        }
        
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "Ground")
            bg.zPosition = -2
            bg.position.x = CGFloat(i) * bg.size.width
            bg.position.y = self.frame.height / -2
            addChild(bg)
            groundObjects.append(bg)
        }
        
    }
    
    func beginGame() {
        
        for bg in backgroundObjects {
            let moveX = SKAction.moveBy(x: bg.size.width * -2, y: 0, duration: 20)
            let reset = SKAction.moveBy(x: bg.size.width * 2, y: 0, duration: 0)
            let theAction = SKAction.repeatForever(.sequence([moveX, reset]))
            bg.run(theAction, withKey: "Move")
        }
        
        for bg in groundObjects {
            let moveX = SKAction.moveBy(x: bg.size.width * -2, y: 0, duration: 5)
            let reset = SKAction.moveBy(x: bg.size.width * 2, y: 0, duration: 0)
            let theAction = SKAction.repeatForever(.sequence([moveX, reset]))
            bg.run(theAction, withKey: "Move")
            
            bg.physicsBody = SKPhysicsBody(rectangleOf: bg.size)
            bg.physicsBody?.affectedByGravity = false
            bg.physicsBody?.isDynamic = false
            bg.physicsBody?.restitution = 0
            bg.physicsBody?.categoryBitMask = ColliderType.Ground
        }
        
    }
    
    
    var press = SKSpriteNode(imageNamed: "Press")
    var getReady = SKSpriteNode(imageNamed: "get-ready")
    
    func createInstrctions() {
        press.anchorPoint.y = 1
        press.position = CGPoint(x: bird.position.x, y: bird.frame.minY - 20)
        press.setScale(1.8)
        press.texture?.filteringMode = .nearest
        addChild(press)
        
        getReady.anchorPoint.y = 0
        getReady.position = CGPoint(x: bird.position.x, y: bird.frame.maxY + 20)
        getReady.setScale(1.8)
        getReady.texture?.filteringMode = .nearest
        addChild(getReady)
    }
    
    
    
    func createPipes() -> SKAction {
        let delay = SKAction.wait(forDuration: 1)
        let spawnPipes = SKAction.run {
            let parentNode = self.createParentPipe()
            self.createDoublePipes(parentNode)
        }
        return .repeatForever(.sequence([delay, spawnPipes]))
    }
    
    func createParentPipe() -> SKNode {
        let pipeYPosition = CGFloat.random(in: -300...300)
        let parentNode = SKNode()
        parentNode.position.y = pipeYPosition
        addChild(parentNode)
        
        parentNode.position.x = (size.width/2) + 100
        
        let move = SKAction.moveTo(x: -(size.width/2) - 100, duration: 2.5)
        let sequence = SKAction.sequence([move, .removeFromParent()])
        parentNode.run(sequence)
        
        return parentNode
    }
    
    func createDoublePipes(_ parentNode: SKNode) {
        
        let pipeDistance: CGFloat = -100
        let pipe1 = SKSpriteNode(imageNamed: "Pipe 1")
        let pipe2 = SKSpriteNode(imageNamed: "Pipe 1")
        
        pipe1.position.y = -630 + pipeDistance
        pipe1.setScale(0.8)
        pipe1.zPosition = -10
        pipe1.name = "Pipe"
        parentNode.addChild(pipe1)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipe1.size)
        pipe1.physicsBody?.affectedByGravity = false
        pipe1.physicsBody?.isDynamic = false
        
        pipe2.position.y = 630 - pipeDistance
        pipe2.setScale(-0.8)
        pipe2.xScale *= -1
        pipe2.zPosition = -10
        pipe2.name = "Pipe"
        parentNode.addChild(pipe2)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe1.size)
        pipe2.physicsBody?.affectedByGravity = false
        pipe2.physicsBody?.isDynamic = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("CONATCS?")
        let contacts: Set = [contact.bodyA.node!, contact.bodyB.node!]
        
        if contacts.contains(bird) {
            
            if !contacts.union(groundObjects).isEmpty {
                print("You hit the ground")
            }
            
            
        }
        
        
    }
    
    
    
    
    
}


struct ColliderType {
    static let Bird: UInt32 =  1
    static let Ground:UInt32 = 2
    static let Pipes: UInt32 = 3
    static let Score: UInt32 = 4
}
