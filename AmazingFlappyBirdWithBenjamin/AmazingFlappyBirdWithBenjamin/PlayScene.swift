//
//  PlayScene.swift
//  AmazingFlappyBirdWithBenjamin
//
//  Created by Jonathan Pappas on 5/19/21.
//

import Foundation
import SpriteKit

class PlayScene : SKScene, SKPhysicsContactDelegate {
    
    let bg = SKSpriteNode(imageNamed: "BG Day")
    let bird = SKSpriteNode(imageNamed: "Bird1")
    var movingObjects: Set<SKNode> = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        addChild(bg)
        
        addChild(bird)
        bird.position.y = 250
        
        let textureNames = ["Bird1", "Bird2", "Bird3"].map { SKTexture(imageNamed: $0) }
        let animation = SKAction.animate(with: textureNames, timePerFrame: 0.1)
        bird.run(.repeatForever(animation))
        
        let ground = SKSpriteNode(imageNamed: "Ground")
        addChild(ground)
        ground.position.y = (-frame.height/2) + (ground.frame.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.contactTestBitMask = .max
        
        let moveGround = SKAction.moveBy(x: -ground.frame.width, y: 0, duration: 2.0)
        let moveBack = SKAction.moveBy(x: ground.frame.width, y: 0, duration: 0.0)
        let superGround = SKAction.repeatForever(.sequence([moveGround, moveBack]))
        ground.run(superGround)
        bg.run(superGround)
        bg.speed = 0.2
        
        let moreGround = ground.copy() as! SKSpriteNode
        addChild(moreGround)
        moreGround.position.x = ground.frame.width
        
        let moreBG = bg.copy() as! SKSpriteNode
        addChild(moreBG)
        moreBG.position.x = bg.frame.width
        moreBG.zPosition = -1
        
        movingObjects = [ground, moreGround, bg, moreBG]
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if bird.physicsBody == nil {
            bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.height/2)
            bird.physicsBody?.contactTestBitMask = .max
        }
        
        bird.physicsBody?.velocity.dy = 600
        birdAlive = true
    }
    
    var birdAlive = false
    
    override func update(_ currentTime: TimeInterval) {
        if !birdAlive { return }
        
        let one = bird.physicsBody!.velocity.dy
        let two = CGFloat(one < 0.4 ? 0.003 : 0.001)
        let birdRotation = one * two
        
        let toAngle = min(max(-1.57, birdRotation), 0.6)
        let rotateAction: SKAction = .rotate(toAngle: toAngle, duration: 0.08)
        bird.run(rotateAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Collision has Occured!")
        
        bird.physicsBody = nil
        birdAlive = false
        
        for object in movingObjects {
            object.removeAllActions()
        }
        
    }
    
    
}



// [*] Stop all actions when bird hits something

// Add pipes
// Add score counter
// Save highscores

// Game Over Screen
// don't keep jumping when bird hits the ground
// bird flaps a little faster when nose diving
