//
//  Goomba.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/17/21.
//

import Foundation
import SpriteKit

class Goomba: MovableSprite, SKActionable, Spriteable {
    
    // Squash the Goomba!
    func squash(_ mario: Inky) {
        if !self.squashed {
            self.run(.playSoundFileNamed("smb_stomp", waitForCompletion: false))
            self.squashed = true
            self.xSpeed = 0
            mario.jump(mario.maxJumpSpeed)
            self.runAction(1, append: [
                .run { _=self.die(nil, [], killedBy: mario) }
            ])
        }
    }
    
    func whenActions() -> [Whens] {[

        // If Goomba Hits Something, reverse it's movement
        .bumped(.left, doThis: { _ in
            self.reverseMovement.toggle()
            self.move(.left)
        }),
        .bumped(.right, doThis: { _ in
            self.reverseMovement.toggle()
            self.move(.left)
        }),
        
        // If Goomba falls on Mario
        .bumped(.down, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(nil, [], killedBy: self) }
        }),
        // If Mario uses Goomba like a ? Box
        .wasBumpedBy(.up, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(killedBy: self) } else {
                print("Pushed up :::)")
            }
        }),
        // If Mario Falls on Goomba
        .wasBumpedBy(.down, doThis: {
            if let mario = $0 as? Inky {
                self.squash(mario)
            }
        }),
        
        
        // If Mario walks into Goomba, he dies
        .wasBumpedBy(.left, doThis: {
            if !self.squashed, let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        .wasBumpedBy(.right, doThis: {
            if !self.squashed, let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        
        // Goomba Falls, Unless squashed
        .when(.notOnGround, doThis: {
            if self.squashed { return }
            self.fall()
        }),
        
        // Goomba always moves left
        .when(.always, doThis: {
            if self.squashed { return }
            self.runAction(0)
            self.move(.left)
        }),
        
        // Goomba starts walking once on Screen
        .when(.firstTimeOnScreen, doThis: {
            self.xSpeed = 1
        }),
        // Goomba falls off the screen
        .when(.offScreen, doThis: {
            if self.maxY < 0 {
                self.squashed = true
                self.die(killedBy: self)
            }
        }),
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ]),
        
        .killedBy({ _ in
            if self.squashed { return }
            self.spawnObject(DeadGoomba.self, frame: (16,16), location: self.position, image: Images.goomba1.rawValue)
        })
        
    ]}
    
    var squashed = false
    var bounciness: Int = 5
    var myActions: [SKAction] {[
        .sequence([
            .ifTrue({ self.squashed == false }, {[
                .setImage(.goomba1, 0.15),
                .setImage(.goomba2, 0.15),
            ]})
        ]),
        .sequence([
            .killAction(self, 0),
            .setImage(.goombaFlat, 0.3),
        ]),
    ]}

    var actionSprite: SKNode = SKSpriteNode()
}


class DeadGoomba: MovableSprite, Spriteable, SKActionable {
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
