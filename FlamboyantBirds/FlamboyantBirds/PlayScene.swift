//
//  PlayScene.swift
//  FlamboyantBirds
//
//  Created by Jonathan Pappas on 3/3/21.
//

import Foundation
import SpriteKit

class PlayScene: SKScene {
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
    }
    
    override func mouseDown(with event: NSEvent) {
        if !gameStarted {
            press.removeFromParent()
            getReady.removeFromParent()
            beginGame()
            gameStarted = true
            bird.flap()
        } else if isAlive {
            bird.flap()
        }
        
    }
    
    
    override func didMove(to view: SKView) {
        reset()
    }
    
    func reset() {
        addChild(bird)
        createBackgrounds()
        createInstrctions()
    }
    
    
    var backgroundObjects: [SKSpriteNode] = []
    var groundObjects: [SKSpriteNode] = []
    
    func createBackgrounds() {
        
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG Day")
            bg.zPosition = -2
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
    
    
}
