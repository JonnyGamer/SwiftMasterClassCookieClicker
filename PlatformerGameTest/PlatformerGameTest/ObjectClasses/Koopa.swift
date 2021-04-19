//
//  Koopa.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/17/21.
//

import Foundation
import SpriteKit

class Koopa: MovableSprite, SKActionable, WhenActions2 {
    static var starterImage: Images = .koopa1
    static var starterSize: (Int, Int) = (16,32)
    
    // Squash the Koopa?
    func squash(_ mario: Inky) {
        self.stomped = true
        mario.jump(mario.maxJumpSpeed)
        self.spawnObject(KoopaShell.self, location: self.position)
        _=self.die(nil, [], killedBy: mario)
        
//        if !self.squashed {
//            self.squashed = true
//            self.xSpeed = 0
//            mario.jump()
//            self.runAction(1, append: [
//                .run {  }
//            ])
//        }
    }
    
    func checkIfWalkIntoMario(_ this: BasicSprite) {
        if let mario = this as? Inky {
            mario.die(killedBy: self)
        }
    }
    
    func whenActions() -> [Whens] {[

        // If Koopa Hits Something, reverse it's movement
        .bumped(.left, doThis: {
            self.checkIfWalkIntoMario($0)
            self.movementDirection = .right
            
        }),
        .bumped(.right, doThis: {
            self.checkIfWalkIntoMario($0)
            self.movementDirection = .left
        }),
        
        // If Koopa falls on Mario
        .bumped(.down, doThis: { if let mario = $0 as? Inky { _ = mario.die(nil, [], killedBy: self) } }),
        // If Mario uses Koopa like a ? Box
        .wasBumpedBy(.up, doThis: { if let mario = $0 as? Inky { _ = mario.die(killedBy: self) } }),
        
        // If Mario Falls on Koopa
        .wasBumpedBy(.down, doThis: {
            if let mario = $0 as? Inky {
                mario.run(.sound(.stomp))
                self.squash(mario)
            }
        }),
        
        // If Mario walks into Koopa, he dies
        .wasBumpedBy(.left, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        .wasBumpedBy(.right, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        
        // Koopa Falls, Unless stomped
        .when(.notOnGround, doThis: {
            self.fall()
        }),
        
        // Koopa always moves left
        .when(.always, doThis: {
            self.runAction(0)
            self.move(self.movementDirection)
        }),
        
        // Koopa starts walking once on Screen
        .when(.firstTimeOnScreen, doThis: {
            self.skNode.xScale *= -1
            self.xSpeed = 1
        }),
        
        .killedBy({ _ in
            if self.stomped {
                return
            }
            self.spawnObject(DeadKoopa.self, location: self.position)
        }),
        
        // Goomba falls off the screen
        .when(.offScreen, doThis: {
            if self.maxY < 0 {
                self.stomped = true
                self.die(killedBy: self)
            }
        }),
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
    ]}
    
    var stomped = false
    var movementDirection: Direction = .left
    var bounciness: Int = 5
    var myActions: [SKAction] {[
        .sequence([
            .setImage(.koopa1, 0.15),
            .setImage(.koopa2, 0.15),
        ]),
        .sequence([
            .killAction(self, 0),
            .setImage(.goombaFlat, 0.3),
        ])
    ]}

    var actionSprite: SKNode = SKSpriteNode()
}

class DeadKoopa: MovableSprite, WhenActions2, SKActionable {
    static var starterImage: Images = .shell
    static var starterSize: (Int, Int) = (16,16)
    
    func whenActions() -> [Whens] {[
        // Die when off screen
        .when(.always, doThis: {
            if self.started { return }; self.started = true 
            self.skNode.zPosition = .infinity
            self.skNode.yScale = -1
            self.runAction(0, append: [
                .run {
                    self.die(killedBy: self)
                }
            ])
        }),
        .setters([
            .contactDirections([])
        ])
    ]}
    var started = false
    var myActions: [SKAction] = [
        .sequence([
            .easeType(curve: .sine, easeType: .out, .moveBy(x: 0, y: 16*1, duration: 0.2)),
            .easeType(curve: .sine, easeType: .in, .moveTo(y: -100, duration: 1)),
        ])
    ]
    
    var actionSprite: SKNode = SKSpriteNode()
}




