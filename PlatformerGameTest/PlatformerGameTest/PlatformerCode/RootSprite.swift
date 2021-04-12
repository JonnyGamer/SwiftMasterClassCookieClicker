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
    
    var skNode: SKNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: 16, height: 16))
    
    var position: (x: Int, y: Int) = (0,0) {
        didSet{ skNode.position = CGPoint(x: CGFloat(position.x) + skNode.frame.width/2, y: CGFloat(position.y) + skNode.frame.height/2) }
    }
    
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
        if direction == .left {
            position.x -= 2
        }
        if direction == .right {
            position.x += 2
        }
    }
    
    var onGround = false
    func stopMoving(_ direction: Direction) {
        if direction == .down {
            onGround = true
        }
    }
    
    var bumpedFromTop: [(Sprites) -> ()] = []
    var bumpedFromBottom: [(Sprites) -> ()] = []
    var bumpedFromLeft: [(Sprites) -> ()] = []
    var bumpedFromRight: [(Sprites) -> ()] = []
    
}
