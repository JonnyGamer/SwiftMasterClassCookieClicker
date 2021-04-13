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
    var bumpedFromTop: [(MovableSprite) -> ()] { get set }
    var bumpedFromBottom: [(MovableSprite) -> ()] { get set }
    var bumpedFromLeft: [(MovableSprite) -> ()] { get set }
    var bumpedFromRight: [(MovableSprite) -> ()] { get set }
}

class BasicSprite {
    
    var frame = (x: 16, y: 16)
    var skNode: SKNode// = SKSpriteNode.init(color: .white, size: CGSize.init(width: 16, height: 16))
    init(box: (Int, Int)) {
        skNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: box.0, height: box.1))
        frame = box
    }
    
    func startPosition(_ n: (x: Int, y: Int)) {
        position = n
        position = n
    }
    var position: (x: Int, y: Int) = (0,0) {
        willSet {
            if newValue.y != position.y, newValue.x != position.x {
                previousPosition = position
            } else if newValue.y != position.y {
                previousPosition.y = position.y
            } else if newValue.x != position.x {
                previousPosition.x = position.x
            } else {
                previousPosition = position
            }
        }
        didSet{ skNode.position = CGPoint(x: CGFloat(position.x) + skNode.frame.width/2, y: CGFloat(position.y) + skNode.frame.height/2) }
    }
    var previousPosition: (x: Int, y: Int) = (0,0)
    var velocity: (dx: Int, dy: Int) { return (dx: position.x - previousPosition.x, dy: position.y - previousPosition.y) }
    
    func run(_ this: SKAction) {
        skNode.run(this)
    }
    
    var bumpedFromTop: [(MovableSprite) -> ()] = []
    var bumpedFromBottom: [(MovableSprite) -> ()] = []
    var bumpedFromLeft: [(MovableSprite) -> ()] = []
    var bumpedFromRight: [(MovableSprite) -> ()] = []
    
}


class MovableSprite: BasicSprite {
    var isPlayer: Bool { return false }
    
    
    
    var bounceHeight: Int { 8 }
    
    func jump() { jump(nil) }
    func jump(_ height: Int?) {
        if !onGround.isEmpty {
            onGround.removeAll(where: { $0.velocity.dy < bounceHeight })
            if onGround.isEmpty {
                fallingVelocity = height ?? bounceHeight
                fall()
            }
        }
    }
    
    var fallingVelocity = 0
    func fall() {
        position.y += fallingVelocity
        fallingVelocity -= 1
        if fallingVelocity <= -16 {
            fallingVelocity = -16
        }
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
        if !onGround.isEmpty {
            standing = true
            previousPosition = position
        }
    }
    
    func pushDirection(_ hit: BasicSprite,_ direction: Direction) {
        if direction == .right || direction == .left {
            hit.position.x += velocity.dx
        }
    }
    
    var onGround: [BasicSprite] = []// = false
    func stopMoving(_ hit: BasicSprite, _ direction: Direction) {
        if direction == .down {
            landedOn(hit)
        }
        
        // Still working on UP??
        if direction == .up {
            if velocity.dy > 0 {
                //hit.position.y += velocity.dy
            }
        }
        
        if direction == .left {
            position.x += Int(velocity.dx)
        }
        if direction == .right {
            position.x -= Int(velocity.dx)
        }
    }
    
    func landedOn(_ this: BasicSprite) {
        fallingVelocity = 0
        onGround.append(this)
        position.y = this.maxY
    }
    
    var movingUp: Bool { return onGround.isEmpty && fallingVelocity >= 0 }
    var falling: Bool { return onGround.isEmpty && fallingVelocity < 0 }
    

    
}
