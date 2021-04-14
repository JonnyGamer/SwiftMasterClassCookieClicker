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

class BasicSprite: Hashable {
    static func == (lhs: BasicSprite, rhs: BasicSprite) -> Bool {
        lhs === rhs
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(self)")
    }
    var annoyance: [() -> ()] = []
    
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
    func stopX() {
        previousPosition.x = position.x
    }
    func stopY() {
        previousPosition.y = position.y
    }
    
    var canDieFrom: [Direction] = []
    var dead = false
    func die(_ direction: Direction?) {
        // Double check this line of code
        if direction != nil, !canDieFrom.contains(direction!) { return }
        
        dead = true
        (skNode.scene as? Scene)?.sprites.remove(self)
        skNode.run(.sequence([.fadeAlpha(to: 0.1, duration: 0.1)]))// .removeFromParent()
    }
    
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
            onGround = onGround.filter { !($0.velocity.dy < bounceHeight) }
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
    
    var frameCount = 0
    var everyFrame = 1
    var xSpeed = 2
    func move(_ direction: Direction) {
        standing = false
        if frameCount % everyFrame == 0 {
            if direction == .left {
                position.x -= xSpeed
            }
            if direction == .right {
                position.x += xSpeed
            }
        }
        frameCount += 1
    }
    
    var standing = true
    func stand() {
        if !onGround.isEmpty {
            standing = true
            previousPosition = position
        }
    }
    
    func pushDirection(_ hit: BasicSprite,_ direction: Direction) {
        if direction == .right {
            hit.position.x = maxX
            hit.position.x -= velocity.dx
            hit.position.x += velocity.dx
            print()
        }
        
        if direction == .left {
            hit.position.x = minX - hit.frame.x
            hit.position.x -= velocity.dx
            hit.position.x += velocity.dx
        }
        
//        if direction == .right || direction == .left {
//            hit.position.x += velocity.dx
//        }
    }
    
    var standingOnLedgeAction: [() -> ()] = []
    var ledgeOn: BasicSprite?
    func standingOnLedge(n: BasicSprite?) {
        if n == nil { ledgeOn = nil; return }
        if ledgeOn !== n {
            standingOnLedgeAction.run()
            ledgeOn = n
        }
        //print("OK")
        //jump()
    }
    
    
    
    var leftGround: Set<BasicSprite> = []// = false
    var rightGround: Set<BasicSprite> = []// = false
    
    var onGround: Set<BasicSprite> = []// = false
    func stopMoving(_ hit: BasicSprite, _ direction: Direction) {
        if direction == .down {
            landedOn(hit)
            runWhenBumpDown.run()
        }
        
        // Still working on UP??
        if direction == .up {
            if "\(self)".contains("C") {
                print("YEH")
            }
            position.y = hit.minY - frame.y
            fallingVelocity = 0
            stopY()
            print(velocity)
            runWhenBumpUp.run()
        }
        
        if direction == .left {
            position.x = hit.maxX
            stopX()
            runWhenBumpLeft.run()
        }
        
        if direction == .right {
            position.x = hit.minX - frame.x
            stopX()
            runWhenBumpRight.run()
        }
    }
    
    var runWhenBumpDown: [()->()] = []
    var runWhenBumpLeft: [()->()] = []
    var runWhenBumpRight: [()->()] = []
    var runWhenBumpUp: [()->()] = []
    
    func landedOn(_ this: BasicSprite) {
        fallingVelocity = 0
        onGround.insert(this)
        position.y = this.maxY
        stopY()
    }
    
    var movingUp: Bool { return onGround.isEmpty && fallingVelocity >= 0 }
    var falling: Bool { return onGround.isEmpty && fallingVelocity < 0 }
    

    
}
