//
//  BirdClass.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation
import SpriteKit

struct ColliderType {
    static let Bird: UInt32 =  0b001
    static let Ground:UInt32 = 0b010
    static let Pipes: UInt32 = 0b011
    static let Score: UInt32 = 0b100
}

class Bird: SKSpriteNode {
    
    var birdAnimationAction: ((Double) -> SKAction)!// = SKAction()
    
    func die() {
        physicsBody = nil
        removeAllActions()
        runAnimationOnce()
    }
    
    static func Make() -> Bird {
        let b = Bird(imageNamed: "\(GameManager.getBird()) 1")
        b.initialize()
        return b
    }
    
    func initialize(withoutPhysics: Bool = false) {
        if withoutPhysics { setScale(1.3) }
        GameManager.birdIsTiny() ? setScale(0.6) : ()
        GameManager.birdIsMega() ? setScale(0.8) : ()
        
        makeAnimation()
        runAnimationForever()
        self.name = "Bird"
        birdPhysics()
    }
    
    func makeAnimation() {
        let birdAnimation: [SKTexture] = (1...3).map {
            SKTexture(imageNamed: GameManager.getBird() + " \($0)")
        }
        birdAnimationAction = {
            return SKAction.animate(with: birdAnimation, timePerFrame: $0, resize: true, restore: true)
        }
        
        let invisiActionKey = "InvisiSequence"
        if GameManager.invisi {
            let invisiSequence = SKAction.sequence([.birdFadeOut, .waitForOneSecond, .birdFadeIn])
            run(.repeatForever(invisiSequence), withKey: invisiActionKey)
            return
        }
        removeAction(forKey: invisiActionKey)
        alpha = 1
    }
    func runAnimationForever() {
        run(.repeatForever(birdAnimationAction(0.08)))
    }
    func runAnimationOnce() {
        removeAction(forKey: "Flap")
        run(birdAnimationAction(0.2), withKey: "Flap")
    }
    
    func birdPhysics() {
        
        if GameManager.birdIsMega() {
            physicsBody = SKPhysicsBody(texture: texture!, size: size)
        } else {
            physicsBody = SKPhysicsBody(circleOfRadius: size.height / 2)
        }
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = ColliderType.Bird
        physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Pipes
        physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Pipes | ColliderType.Score
    }
    func smackedPipe() {
//        physicsBody?.collisionBitMask = ColliderType.Ground
//        physicsBody?.contactTestBitMask = ColliderType.Ground
//        physicsBody?.velocity = .zero
//        physicsBody?.applyImpulse(.init(dx: 0, dy: 100))
    }
    
    func flap() {
        physicsBody?.affectedByGravity = true
        physicsBody?.restitution = 0
        let newVel = max(0, physicsBody?.velocity.dy ?? 0)
        if GameManager.birdIsMega() {
            physicsBody?.velocity.dy = 732 + (newVel/2)
        } else {
            physicsBody?.velocity.dy = 588 + (newVel/2)
        }
    }
    
}





