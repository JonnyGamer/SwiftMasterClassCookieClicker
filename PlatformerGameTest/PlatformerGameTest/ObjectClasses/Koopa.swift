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
        self.stomped = true
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
                self.run(.playSoundFileNamed("smb_stomp", waitForCompletion: false))
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
            if self.frame.y == 16 { self.doubleMyHeight() }
            //self.doubleMyHeight()
            self.skNode.xScale *= -1
            self.xSpeed = 1
        }),
        
        .killedBy({ _ in
            if self.stomped {
                return
            }
            self.spawnObject(DeadKoopa.self, frame: (16,32), location: self.position, image: Images.koopa1.rawValue)
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

class DeadKoopa: MovableSprite, Spriteable, SKActionable {
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



class KoopaShell: MovableSprite, SKActionable, Spriteable {
    
    // Koopa Smashes into something
    func smash(_ this: BasicSprite) {
        if self.moving, let mario = this as? Inky {
            self.run(.playSoundFileNamed("smb_kick", waitForCompletion: false))
            _ = mario.die(killedBy: self)
        } else if let foo = this as? MovableSprite {
            self.run(.playSoundFileNamed("smb_kick", waitForCompletion: false))
            _ = foo.die(killedBy: self)
        }
    }
    
    // Stomp on the Koopa shell
    func squash(_ mario: Inky) {
        self.moving.toggle()
        if self.moving {
            self.run(.playSoundFileNamed("smb_kick", waitForCompletion: false))
            if mario.midX < self.midX {
                self.movementDirection = .right
            } else {
                self.movementDirection = .left
            }
        }
        
        mario.jump(mario.maxJumpSpeed)
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
        
        // When Koopa Shell moves off screen, get rid of it
        .when(.offScreen, doThis: {
            self.die(killedBy: self)
        }),
        
        
        // If Mario walks into Koopa Shell, he kicks it.
        .wasBumpedBy(.left, doThis: {
            if !self.moving, let mario = $0 as? Inky {
                self.run(.playSoundFileNamed("smb_kick", waitForCompletion: false))
                self.moving = true
                mario.willStopMoving(self, .left)
                self.movementDirection = .left
            }
        }),
        .wasBumpedBy(.right, doThis: {
            if !self.moving, let mario = $0 as? Inky {
                self.run(.playSoundFileNamed("smb_kick", waitForCompletion: false))
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
            if !self.moving {
                self.runAction(0, append: [
                    .run {
                        print("OK")
                        self.spawnObject(Koopa.self, frame: (16,32), location: self.position, image: Images.koopa1.rawValue)
                        self.die(killedBy: self)
                    }
                ])
                return
            } else {
                self.killAction(0)
                self.run(.setImage(.shell))
            }
            //self.runAction(0)
            self.xSpeed = 10
            self.move(self.movementDirection)
        }),
        
        // Goomba starts walking once on Screen
        .when(.firstTimeOnScreen, doThis: {
            //
        }),
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
    ]}
    
    var moving = false
    var movementDirection: Direction = .left
    var bounciness: Int = 5
    var myActions: [SKAction] {[
        .sequence([
            .wait(forDuration: 5),
            .setImage(.climbingOutOfShell, 0.5),
            .setImage(.shell, 0.5),
            .setImage(.climbingOutOfShell, 0.5),
            .setImage(.shell, 0.5),
            .setImage(.climbingOutOfShell, 0.25),
            .setImage(.shell, 0.25),
            .setImage(.climbingOutOfShell, 0.25),
            .setImage(.shell, 0.25),
            .setImage(.climbingOutOfShell, 0.25),
        ])
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
