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
        
    }
    
    func whenActions() -> [Whens] {[

        // If Koopa Hits Something, reverse it's movement
        .bumped(.left, doThis: { _ in self.reverseMovement.toggle() }),
        .bumped(.right, doThis: { _ in self.reverseMovement.toggle() }),
        
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
            if !self.squashed, let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        .wasBumpedBy(.right, doThis: {
            if !self.squashed, let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        
        // Koopa Falls, Unless stomped
        .when(.notOnGround, doThis: {
            if self.squashed { return }
            self.fall()
        }),
        
        // Koopa always moves left
        .when(.always, doThis: {
            if self.squashed { return }
            self.runAction(0)
            self.move(.left)
        }),
        
        // Koopa starts walking once on Screen
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
                .setImage(.koopa1, 0.15),
                .setImage(.koopa2, 0.15),
            ]})
        ]),
        .sequence([
            .killAction(self, 0),
            .setImage(.goombaFlat, 0.3),
        ])
    ]}

    var actionSprite: SKNode = SKSpriteNode()
}
