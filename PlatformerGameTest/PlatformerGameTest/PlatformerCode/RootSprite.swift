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
    
    var skNode: SKNode = SKSpriteNode.init(color: .white, size: CGSize.init(width: 10, height: 10))
    
    var position: (x: Int, y: Int) = (0,0) {
        didSet{ skNode.position = CGPoint(x: CGFloat(position.x) + skNode.frame.width/2, y: CGFloat(position.y) + skNode.frame.height/2) }
    }
    
    func run(_ this: SKAction) {
        skNode.run(this)
    }
    
    var bounceHeight = 0
    
    func jump() { jump(nil) }
    func jump(_ height: Int?) {}
    
    func move(_ direction: Direction) {
        if direction == .left {
            position.x -= 4
        }
        if direction == .right {
            position.x += 4
        }
    }
    
    func stopMoving(_ direction: Direction) {}
    
    var bumpedFromTop: [(Sprites) -> ()] = []
    var bumpedFromBottom: [(Sprites) -> ()] = []
    var bumpedFromLeft: [(Sprites) -> ()] = []
    var bumpedFromRight: [(Sprites) -> ()] = []
    
}
