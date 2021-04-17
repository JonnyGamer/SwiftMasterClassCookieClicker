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
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
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
        ])
    ]}

    var actionSprite: SKNode = SKSpriteNode()
}
