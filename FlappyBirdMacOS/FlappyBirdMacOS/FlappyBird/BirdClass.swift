//
//  BirdClass.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation
import SpriteKit

struct ColliderType {
    static let Bird: UInt32 = 1
    static let Ground: UInt32 = 2
    static let Pipes: UInt32 = 3
    static let Score: UInt32 = 4
}

class Bird: SKSpriteNode {
    
    var birdAnimation = [SKTexture]()
    var birdAnimationAction = SKAction()
    var diedTexture = SKTexture()
    var complete = true
    
    func initialize() {
        
        var name = String()
        for i in 1..<5 {
            if i != 4 {
                name = "\(GameManager.getBird()) \(i)"
            } else {
                name = "\(GameManager.getBird()) 1"
            }
            birdAnimation.append(SKTexture(imageNamed: name))
        }
        
        birdAnimationAction = SKAction.animate(with: birdAnimation, timePerFrame: 0.08, resize: true, restore: true)
        
        if GameManager.invisi {
            let invisiAnim = SKAction.fadeOut(withDuration: 0.25)
            let invisiAnim1 = SKAction.fadeOut(withDuration: 1)
            let invisiAnim2 = SKAction.fadeIn(withDuration: 0.25)
            let invisiSequence = SKAction.sequence([invisiAnim, invisiAnim1, invisiAnim2])
            self.run(SKAction.repeatForever(invisiSequence), withKey: "InvisiSequence")
        }
        
        diedTexture = SKTexture(imageNamed: "\(GameManager.getBird()) 1")
        
        self.name = "Bird"
        self.zPosition = 3
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        if GameManager.birdIndex > (2*(GameManager.birds.count/3)) - 1 {
            self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: self.size.width, height: self.size.height))
            // self.physicsBody = SKPhysicsBody(texture: self.texture!, alphaThreshold: 99, size: CGSize(width: self.size.width, height: self.size.height))
            // self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: self.size.height))
            // self.physicsBody = SKPhysicsBody(texture: SKTexture(cgImage: "Mega 1" as! CGImage), size: CGSize(width: self.size.width, height: self.size.height))
        } else {
            self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.height / 2)
        }
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = ColliderType.Bird
        self.physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Pipes
        self.physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Pipes | ColliderType.Score
    }
    
    func flap() {
        physicsBody?.affectedByGravity = true
        physicsBody?.restitution = 0
        
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 125))
        if GameManager.birdIndex > (2*(GameManager.birds.count/3)) - 1 {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
        }
        if complete {
            complete = false
            self.run(birdAnimationAction, completion: {
                self.complete = true
            })
        }
    }
    
    func superFlap() {
        self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
        if GameManager.birdIndex > (2*(GameManager.birds.count/3)) - 1 {
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 500))
        }
        if complete {
            complete = false
            self.run(birdAnimationAction, completion: {
                self.complete = true
            })
        }
    }
}





