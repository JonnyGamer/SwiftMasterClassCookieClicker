//
//  RootSprite.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit

protocol Spriteable {
    var specificActions: [When] { get }
}

class BasicSprite {
    var isPlayer: Bool { return false }
    //var position: (x: Int, y: Int) = (0,0)
    
    var frame = (x: 16, y: 16)
    var skNode: SKNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: 16, height: 16))
    
    func startPosition(_ n: (x: Int, y: Int)) {
        position = n
        position = n
    }
    var position: (x: Int, y: Int) = (0,0) {
        willSet { previousPosition = position }
        didSet{ skNode.position = CGPoint(x: CGFloat(position.x) + skNode.frame.width/2, y: CGFloat(position.y) + skNode.frame.height/2) }
    }
    var previousPosition: (x: Int, y: Int) = (0,0)
    var velocity: (dx: Int, dy: Int) { return (dx: previousPosition.x - position.x, dy: previousPosition.y - position.y) }
    
    func run(_ this: SKAction) {
        skNode.run(this)
    }
    
    var bounceHeight: Int { 8 }
    
    func jump() { jump(nil) }
    func jump(_ height: Int?) {
        if onGround {
            fallingVelocity = height ?? bounceHeight
            fall()
        }
    }
    
    var fallingVelocity = 0
    func fall() {
        onGround = false
        position.y += fallingVelocity
        fallingVelocity -= 2
    }
    
    func move(_ direction: Direction) {
        standing = false
        if direction == .left {
            position.x -= 2
        }
        if direction == .right {
            position.x += 2
        }
    }
    var standing = true
    func stand() {
        standing = true
        previousPosition = position
    }
    
    var onGround = false
    func stopMoving(_ direction: Direction) {
        if direction == .down {
            onGround = true
        }
        if direction == .left {
            position.x += Int(velocity.dx)
        }
        if direction == .right {
            position.x -= Int(velocity.dx)
        }
    }
    
    
    var movingUp: Bool { return !onGround && fallingVelocity >= 0 }
    var falling: Bool { return !onGround && fallingVelocity < 0 }
    
    var bumpedFromTop: [(Sprites) -> ()] = []
    var bumpedFromBottom: [(Sprites) -> ()] = []
    var bumpedFromLeft: [(Sprites) -> ()] = []
    var bumpedFromRight: [(Sprites) -> ()] = []
    
}
