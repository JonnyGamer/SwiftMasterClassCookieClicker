//
//  Platformer.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit


class GROUND: BasicSprite, Spriteable {
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
    ]
}

class Moving_GROUND: BasicSprite, Spriteable, SKActionable {
    var myActions: [SKAction] = [
        .figureEight(height: 320, time: 4),
    ]
    var actionSprite: SKNode = SKNode()
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .runSKAction([(0, .always)]),
    ]
}


class Inky: MovableSprite, Spriteable {
    var fireBallsActive = 0
    
    var specificActions: [When] = [
        
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .allowObjectToPush(.up, when: .thisBumped(.up)),
        .allowObjectToPush(.right, when: .thisBumped(.right)),
        .allowObjectToPush(.left, when: .thisBumped(.left)),
        
        .moveLeftWhen(.pressedButton(.left)),
        .moveRightWhen(.pressedButton(.right)),
        
        // Jumping
        .jumpWhen(.pressedButton(.jump)),
        .jumpHeight(triangleOf: 20),
        .maxJumpSpeed(5),
        .minFallSpeed(-5),
        .gravity(-1, everyFrame: 3),
        .stopGoingUpWhen(.releasedButton(.jump)),
        .resetJumpsWhen(.thisBumped(.down)),
        .maxJump(2),
        
        .fallWhen(.notOnGround),
        
        //
        .canDieFrom(.all()),
        .deathId(0),
        
        // Fire Ball Power!
        .doThisWhen({
            if let fireBalls = ($0 as? Inky)?.fireBallsActive, fireBalls < 2 {
                ($0 as? Inky)?.fireBallsActive += 1
                if $0.lastMovedThisDirection == .left {
                    $0.spawnObject(FireBall.self, frame:(4,4), location: ($0.minX - 2, $0.midY))
                } else if $0.lastMovedThisDirection == .right {
                    $0.spawnObject(FireBall.self, frame:(4,4), location: ($0.maxX, $0.midY), reverseMovement: true)
                }
            }
        }, when: .pressedButton(.jump))
        
    ]
    override var isPlayer: Bool { return true }
}



// Rule for Specific Enemies
class Chaser: MovableSprite, Spriteable {
    
    var specificActions: [When] = [
        
        .fallWhen(.notOnGround),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        
        //
        .moveLeftWhen(.always),
        .xSpeed(2, everyFrame: 1),
        
        // 
        .reverseDirection(.onLedge),
        .reverseDirection(.thisBumped(.left)),
        .reverseDirection(.thisBumped(.right)),
        
        .deathId(1),
        .killObject(.left, when: .thisBumped(.left), id: [0]),
        .killObject(.right, when: .thisBumped(.right), id: [0]),
    ]
}

// Rule for Specific Enemies
class FireBall: MovableSprite, Spriteable {
    
    var specificActions: [When] = [
        .fallWhen(.notOnGround),
        
        // Order matters here
        .resetJumpsWhen(.thisBumped(.down)),
        .jumpWhen(.thisBumped(.down)),
        
        .moveLeftWhen(.always),
        .jumpHeight(triangleOf: 5),
        .xSpeed(8, everyFrame: 1),
        
        .die(.thisBumped(.up)),
        .die(.thisBumped(.left)),
        .die(.thisBumped(.right)),
        .die(.afterJumpingNTimes(20)),
        .die(.onceOffScreen),
        .doThisWhen({ ($0.creator as? Inky)?.fireBallsActive -= 1 }, when: .died),
        
        .killObject(.left, when: .thisBumped(.left), id: [1]),
        .killObject(.right, when: .thisBumped(.right), id: [1]),
        .die(.afterKilledObjects(1)),
        
    ]
}


class Trampoline: BasicSprite, Spriteable {

    var bounciness: Int = 0

    var specificActions: [When] {[
        .bounceObjectWhen(.thisBumped(.up)),

        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
    ]}

}







