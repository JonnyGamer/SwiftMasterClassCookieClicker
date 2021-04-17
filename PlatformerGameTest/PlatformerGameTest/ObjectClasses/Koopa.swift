//
//  Koopa.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/17/21.
//

import Foundation
import SpriteKit

class Koopa: MovableSprite, SKActionable, Spriteable {
    
    // Squash the Koopa?
    func squash(_ mario: Inky) {
        mario.jump(mario.maxJumpSpeed)
        self.spawnObject(KoopaShell.self, frame: (16,16), location: self.position, image: Images.shell.rawValue)
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
    
    func whenActions() -> [Whens] {[

        // If Koopa Hits Something, reverse it's movement
        .bumped(.left, doThis: { _ in
            self.movementDirection = .right
            
        }),
        .bumped(.right, doThis: { _ in
            self.movementDirection = .left
        }),
        
        // If Koopa falls on Mario
        .bumped(.down, doThis: { if let mario = $0 as? Inky { _ = mario.die(nil, [], killedBy: self) } }),
        // If Mario uses Koopa like a ? Box
        .wasBumpedBy(.up, doThis: { if let mario = $0 as? Inky { _ = mario.die(killedBy: self) } }),
        
        // If Mario Falls on Koopa
        .wasBumpedBy(.down, doThis: {
            if let mario = $0 as? Inky {
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
            self.doubleMyHeight()
            self.skNode.xScale *= -1
            self.xSpeed = 1
        }),
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
    ]}
    
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


class KoopaShell: MovableSprite, SKActionable, Spriteable {
    
    // Koopa Smashes into something
    func smash(_ this: BasicSprite) {
        if self.moving, let mario = this as? Inky {
            _ = mario.die(killedBy: self)
        } else if let foo = this as? MovableSprite {
            _ = foo.die(killedBy: self)
        }
    }
    
    // Squash the Goomba!
    func squash(_ mario: Inky) {
        self.moving.toggle()
        if self.moving == true {
            if mario.midX < self.midX {
                self.movementDirection = .left
            } else {
                self.xSpeed = 10
            }
        }
        
        mario.jump(mario.maxJumpSpeed)
//        if !self.squashed {
//            self.squashed = true
//            self.xSpeed = 0
//            mario.jump(mario.maxJumpSpeed)
//            self.runAction(1, append: [
//                .run { _=self.die(nil, [], killedBy: mario) }
//            ])
//        }
    }
    
    func whenActions() -> [Whens] {[

        // If Koopa Hits Something, reverse it's movement
        .bumped(.left, doThis: {
            self.smash($0)
            if $0 as? MovableSprite == nil {
                self.movementDirection = .right
            }
        }),
        .bumped(.right, doThis: {
            self.smash($0)
            if $0 as? MovableSprite == nil {
                self.movementDirection = .left
            }
        }),
        
        // If Goomba falls on Mario
        .bumped(.down, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(nil, [], killedBy: self) }
        }),
        // If Mario uses Goomba like a ? Box
        .wasBumpedBy(.up, doThis: {
            if let mario = $0 as? Inky {
                _ = mario.die(killedBy: self)
            }
        }),
        // If Mario Falls on Goomba
        .wasBumpedBy(.down, doThis: {
            if let mario = $0 as? Inky {
                self.squash(mario)
            }
        }),
        
        
        // If Mario walks into Koopa Shell, he kicks it.
        .wasBumpedBy(.left, doThis: {
            if !self.moving, let mario = $0 as? Inky {
                self.moving = true
                mario.willStopMoving(self, .left)
                self.movementDirection = .left
            }
        }),
        .wasBumpedBy(.right, doThis: {
            if !self.moving, let mario = $0 as? Inky {
                self.moving = true
                mario.willStopMoving(self, .right)
                self.movementDirection = .right
            }
        }),
        
        // Koopa Shell Falls
        .when(.notOnGround, doThis: {
            self.fall()
        }),
        
        // Goomba always moves left
        .when(.always, doThis: {
            if !self.moving { return }
            //self.runAction(0)
            self.move(self.movementDirection)
        }),
        
        // Goomba starts walking once on Screen
        .when(.firstTimeOnScreen, doThis: {
            
        }),
        
        .setters([
            .xSpeed(10, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
    ]}
    
    var moving = false
    var movementDirection: Direction = .left
    var bounciness: Int = 5
    var myActions: [SKAction] {[
//        .sequence([
//            .ifTrue({ self.squashed == false }, {[
//                .setImage(.goomba1, 0.15),
//                .setImage(.goomba2, 0.15),
//            ]})
//        ]),
//        .sequence([
//            .killAction(self, 0),
//            .setImage(.goombaFlat, 0.3),
//        ])
    ]}

    var actionSprite: SKNode = SKSpriteNode()
}
