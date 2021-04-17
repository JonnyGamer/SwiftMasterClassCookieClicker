//
//  RootSprite.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit

protocol Spriteable {
    //var specificActions: [When] { get }
    func whenActions() -> [Whens]
}

protocol SKActionable {
    var skNode: SKNode! { get set }
    var myActions: [SKAction] { get }
    var actionSprite: SKNode { get set }
}
extension SKActionable {
    @discardableResult
    func spawnObject<T: BasicSprite>(_ this: T.Type, frame: (Int, Int), location: (Int, Int), reverseMovement: Bool = false, image: String? = nil) -> T {
        let wow = this.init(box: frame, image: image)
        wow.startPosition(location)
        (wow as? MovableSprite)?.reverseMovement = reverseMovement
        wow.add(Cash.scene!)
        wow.creator = self as? BasicSprite
        Cash.scene.add(wow)
        return wow
    }
}

struct Cash {
    static var textures: [String:SKTexture] = [:]
    static func getTexture(_ i: String) -> SKTexture {
        if let t = Cash.textures[i] {
            return t
        } else {
            let t = SKTexture.init(imageNamed: i)
            t.filteringMode = .nearest
            return t
        }
    }
    static var scene: Scene!
}


class BasicSprite: Hashable {
    static func == (lhs: BasicSprite, rhs: BasicSprite) -> Bool {
        lhs === rhs
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(self)")
    }
    
    
    // Every Frame do this
    var everyFrame: [() -> ()] = []
    
    // Attached to buttons (Actually, only Non-Static objects can be connected to these)
    var doThisWhenJumpButtonIsPressed: [() -> ()] = []
    var doThisWhenLeftButtonIsPressed: [() -> ()] = []
    var doThisWhenRightButtonIsPressed: [() -> ()] = []
    var doThisWhenJumpButtonIsReleased: [() -> ()] = []
    var doThisWhenRightOrLeftIsPressed: [() -> ()] = []
    var doThisWhenNOTRightOrLeftIsPressed: [() -> ()] = []
    
    // Killing Things
    var doThisWhenKilledObject: [(BasicSprite) -> ()] = []
    var doThisWhenKilledBy: [(BasicSprite) -> ()] = []
    var killedObjects = 0
    var invincible = false
    
    // Was bumped by
    var wasBumpedFromUp: [(MovableSprite) -> ()] = []
    var wasBumpedFromDown: [((MovableSprite)) -> ()] = []
    var wasBumpedFromLeft: [(MovableSprite) -> ()] = []
    var wasBumpedFromRight: [(MovableSprite) -> ()] = []
    
    func contactTest(_ dir: Direction, bumpedBy: MovableSprite) {
        if !(contactOn.contains(dir.reversed) && bumpedBy.contactOn.contains(dir)) { return }
        
        //print(self, dir, bumpedBy)
        if dir == .up {
            bumpedBy.runWhenBumpUp.run(self)
            wasBumpedFromUp.run(bumpedBy)
        } else if dir == .down {
            bumpedBy.runWhenBumpDown.run(self)
            wasBumpedFromDown.run(bumpedBy)
        } else if dir == .left {
            bumpedBy.runWhenBumpLeft.run(self)
            wasBumpedFromLeft.run(bumpedBy)
        } else if dir == .right {
            bumpedBy.runWhenBumpRight.run(self)
            wasBumpedFromRight.run(bumpedBy)
        }
    }
    
    
    var creator: BasicSprite?
    
    var frame = (x: 16, y: 16)
    
    //var helperNode: SKNode
    required init(box: (Int, Int), image: String? = nil) {
        //helperNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: box.0, height: box.1))
        frame = box
        
        if let foo = self as? MovableSprite {
            
            if let i = image {
                foo.skNode = SKSpriteNode.init(texture: Cash.getTexture(i), size: CGSize.init(width: box.0, height: box.1))
            } else {
                foo.skNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: box.0, height: box.1))
            }
        } else if let foo = self as? ActionSprite {
            if let i = image {
                foo.skNode = SKSpriteNode.init(texture: Cash.getTexture(i), size: CGSize.init(width: box.0, height: box.1))
            } else {
                foo.skNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: box.0, height: box.1))
            }
        }
        
    }
    

    
    func startPosition(_ n: (x: Int, y: Int)) {
        position = n
        position = n
    }
    func setPosition(_ n: (x: Int, y: Int)) {
        let savePos = position
        position = n
        previousPosition = savePos
    }
    func addVelocity(_ n: (Int, Int)) {
        let savePos = previousPosition
        position = (position.x + n.0, position.y + n.1)
        //position.x += n.0
        //position.y += n.1
        previousPosition = savePos
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
        didSet{
            
            if let skNode = (self as? MovableSprite)?.skNode {
                skNode.position = CGPoint(x: CGFloat(position.x) + skNode.frame.width/2, y: CGFloat(position.y) + skNode.frame.height/2)
            } else if let skNode = (self as? ActionSprite)?.skNode {
                skNode.position = CGPoint(x: CGFloat(position.x) + skNode.frame.width/2, y: CGFloat(position.y) + skNode.frame.height/2)
            }
            
        }
    }
    var previousPosition: (x: Int, y: Int) = (0,0)
    var velocity: (dx: Int, dy: Int) { return (dx: position.x - previousPosition.x, dy: position.y - previousPosition.y) }
    func stopX() {
        previousPosition.x = position.x
    }
    func stopY() {
        previousPosition.y = position.y
    }
    
    
    

    var contactOn: [Direction] = .all()
    var wallOn: [Direction] = []
    
    
    func willStopMoving(_ hit: BasicSprite, _ direction: Direction) {
        
        //if !collisionOn.contains(direction) || !hit.collisionOn.contains(direction.reversed) { return }
        
        (self as? MovableSprite)?.stopMoving(hit, direction)
        
//        if direction == .up, !runWhenBumpUp.isEmpty {
//            runWhenBumpUp.run(self)
//            if hit.collisionOn.contains(.down), !hit.runWhenBumpDown.isEmpty {
//                hit.runWhenBumpDown.run(self) // Hit a ? Block??? (Guess: Double check)
//            }
//        } else if direction == .down, !runWhenBumpDown.isEmpty {
//            runWhenBumpDown.run(self)
//            if hit.collisionOn.contains(.up), !hit.runWhenBumpUp.isEmpty {
//                hit.runWhenBumpUp.run(self) // STOMP ON GOOMBA :)
//            }
//        } else if direction == .right, !runWhenBumpRight.isEmpty {
//            runWhenBumpRight.run(self)
//            if hit.collisionOn.contains(.left), !hit.runWhenBumpLeft.isEmpty {
//                hit.runWhenBumpLeft.run(self)
//            }
//        } else if direction == .left, !runWhenBumpLeft.isEmpty {
//            runWhenBumpLeft.run(self)
//            if hit.collisionOn.contains(.right), !hit.runWhenBumpRight.isEmpty {
//                hit.runWhenBumpRight.run(self)
//            }
//        }
    }
    
    var canDieFrom: [Direction] = []
    var dead = false
    var deathID = Int.min
    
    @discardableResult
    func die(_ direction: Direction? = nil,_ id: [Int] = [], killedBy: BasicSprite) -> Bool {
        if invincible { return false }
        if !id.isEmpty {
            if !id.contains(deathID) {
                return false
            }
        } else {
            
            // Double check this line of code
            if direction != nil, !canDieFrom.contains(direction!) {
                print("NOPE")
                return false
            }
            
        }
        
        if !dead, killedBy !== self {
            doThisWhenKilledBy.run(killedBy)
            if invincible { return false }
            killedBy.doThisWhenKilledObject.run(self)
            if invincible { return false }
        }
        dead = true
        
        if let a = self as? ActionSprite, let s = a.skNode.scene as? Scene {
            s.sprites.remove(self)
            s.movableSprites.remove(self)
            s.actionableSprites.remove(self)
            a.skNode.removeFromParent();
            //a.skNode.run(.sequence([.fadeAlpha(to: 0.1, duration: 0.1)]))// .removeFromParent()
        } else if let a = self as? MovableSprite, let s = a.skNode.scene as? Scene {
            s.sprites.remove(self)
            s.movableSprites.remove(self)
            s.actionableSprites.remove(self)
            a.skNode.removeFromParent()
            //a.skNode.run(.sequence([.fadeAlpha(to: 0.1, duration: 0.1)]))// .removeFromParent()
        }
        (self as? SKActionable)?.actionSprite.removeFromParent()
        
        creator = nil
        return true
    }
    
    
    
}

class ActionSprite: BasicSprite {
    var skNode: SKNode!
    var onScreen = false
}

class MovableSprite: BasicSprite {
    
    var skNode: SKNode!

    var onScreen = false
    var runWhenBumpDown: [(BasicSprite)->()] = []
    var runWhenBumpLeft: [(BasicSprite)->()] = []
    var runWhenBumpRight: [(BasicSprite)->()] = []
    var runWhenBumpUp: [(BasicSprite)->()] = []
    var doThisWhenNotOnGround: [()->()] = []
    
    
    func run(_ this: SKAction) {
        skNode.run(this)
    }
    
//    func spawnObject(_ this: BasicSprite.Type, frame: (Int, Int), location: (Int, Int), reverseMovement: Bool = false) {
//        let wow = this.init(box: frame)
//        wow.startPosition(location)
//        (wow as? MovableSprite)?.reverseMovement = reverseMovement
//        wow.add((skNode.scene as? Scene)!)
//        wow.creator = self
//        (skNode.scene as? Scene)?.add(wow)
//    }
    
    var isPlayer: Bool { return false }
    
    var lastMovedThisDirection: Direction = .right
    var maxJumps = 1
    var jumps = 0
    var totalJumps = 0
    var bounceHeight = 8
    var doThisAfterNJumps: [Int:[() -> ()]] = [:]
    
    @discardableResult
    func jump() -> Bool { jump(nil) }
    @discardableResult
    func jump(_ height: Int?) -> Bool {
        if dead { return false }
        if jumps >= maxJumps { return false }
        jumps += 1; totalJumps += 1; doThisAfterNJumps[totalJumps]?.run()
        
        if !onGround.isEmpty {
            onGround = onGround.filter { !($0.velocity.dy < bounceHeight) }
        }
        if onGround.isEmpty {
            fallingVelocity = height ?? bounceHeight
            doThisWhenNotOnGround.run()
            //fall()
            return true
        }
        return false
    }
    func stopMovingUp() {
        if movingUp, fallingVelocity > maxJumpSpeed {
            fallingVelocity = maxJumpSpeed
        }
    }
    
    var ySpeed = -1
    var yEveryFrameCount = 0
    var yEveryFrame = 1
    
    var maxJumpSpeed: Int = .max
    var minFallSpeed: Int = -16
    var fallingVelocity = 0
    func fall() {
        if jumps == 0 { jumps = 1 }
        
        position.y += min(maxJumpSpeed, max(minFallSpeed, fallingVelocity))
        if yEveryFrameCount % yEveryFrame == 0 {
            fallingVelocity += ySpeed
        }
        yEveryFrameCount += 1
    }
    
    var frameCount = 0
    var everyFrameR = 1
    var xSpeed = 2
    var reverseMovement = false
    func move(_ direction: Direction) {
        if dead { return }
        
        standing = false
        if frameCount % everyFrameR == 0 {
            if direction == .left {
                position.x -= xSpeed * (reverseMovement ? -1 : 1)
            }
            if direction == .right {
                position.x += xSpeed * (reverseMovement ? -1 : 1)
            }
            if lastMovedThisDirection != direction {
                lastMovedThisDirection = direction
                skNode.xScale *= -1
            }
        }
        frameCount += 1
    }
    
    var standing = true
    func stand() {
        if dead { return }
        
        if !onGround.isEmpty {
            standing = true
            previousPosition = position
        }
    }
    
    func pushDirection(_ hit: MovableSprite,_ direction: Direction) {
        if direction == .right {
            hit.position.x = maxX
            hit.position.x -= velocity.dx
            hit.position.x += velocity.dx
            runWhenBumpRight.run(hit)
        }
        
        if direction == .left {
            hit.position.x = minX - hit.frame.x
            hit.position.x -= velocity.dx
            hit.position.x += velocity.dx
            runWhenBumpLeft.run(hit)
        }
        
        if direction == .down {
            runWhenBumpDown.run(hit)
        }
        if direction == .up {
            runWhenBumpLeft.run(hit)
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
            //runWhenBumpDown.run()
        }
        
        // Still working on UP??
        if direction == .up {
            if position.y > hit.minY - frame.y {
                position.y = hit.minY - frame.y
                fallingVelocity = -1
                stopY()
            }
            //print(velocity)
            //runWhenBumpUp.run()
        }
        
        if direction == .left {
            position.x = hit.maxX
            stopX()
            //runWhenBumpLeft.run()
        }
        
        if direction == .right {
            position.x = hit.minX - frame.x
            stopX()
            //runWhenBumpRight.run()
        }
    }
    
    func landedOn(_ this: BasicSprite) {
        fallingVelocity = 0
        onGround.insert(this)
        if position.y != this.maxY {
            position.y = this.maxY
        }
        stopY()
    }
    
    var movingUp: Bool { return onGround.isEmpty && fallingVelocity >= 0 }
    var falling: Bool { return onGround.isEmpty && fallingVelocity < 0 }
    

    
}
