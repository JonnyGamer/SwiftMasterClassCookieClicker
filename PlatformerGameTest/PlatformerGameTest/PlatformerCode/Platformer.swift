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
        .sequence([
            .move(to: .init(x: 100, y: 100), duration: 10),
            .moveBy(x: -100, y: -10, duration: 1),
            .wait(forDuration: 1),
            .moveBy(x: -100, y: 10, duration: 1),
            .wait(forDuration: 1),
            .fadeAlpha(to: 0.1, duration: 1),
            .moveBy(x: 0, y: -1000, duration: 0),
            .fadeAlpha(to: 1, duration: 1),
            .moveBy(x: 0, y: 1000, duration: 0),
        ]),
        
        .figureEight(height: 320, time: 4),
        //.moveBy(x: 100, y: 0, duration: 1)
    ]
    var actionSprite: SKNode = SKNode()
    
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .runSKAction([(1, .always)]), // (2, .always)
    ]
}




class Inky: MovableSprite, Spriteable {
    var specificActions: [When] = [
        .allowObjectToPush(.up, when: .thisBumped(.up)),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        //.stopObjectFromMoving(.left, when: .thisBumped(.left)),
        //.stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .allowObjectToPush(.right, when: .thisBumped(.right)),
        .allowObjectToPush(.left, when: .thisBumped(.left)),
        
        .moveLeftWhen(.pressedButton(.left)),
        .jumpWhen(.pressedButton(.jump)),
        .moveRightWhen(.pressedButton(.right)),
        .jumpHeight(triangleOf: 20),
        .maxJumpSpeed(5),
        .minFallSpeed(-5),
        .gravity(-1, everyFrame: 3),
        .stopGoingUpWhen(.releasedButton(.jump)),
        
        //.stopObjectFromMoving(.down, when: .yPositionIsLessThanZeroThenSetPositionToZero),
        
        //.die(.pressedButton(.jump)),
        .canDieFrom(.all()),
        .fallWhen(.notOnGround),
        
        
        //.doThisWhen({ $0.jumps = 0 }, when: .thisBumped(.down)), // alternative
        .resetJumpsWhen(.thisBumped(.down)),
        .maxJump(2),
        .doThisWhen({ $0.spawnObject(FireBall.self, frame:(4,4), location: ($0.minX - 1 - 2, $0.midY)) }, when: .pressedButton(.jump))
        
    ]
    override var isPlayer: Bool { return true }
}



// Rule For All Enemies
//class Enemy: Spriteable {
//    var specificActions: [When] { [] }
//}

// Rule for Specific Enemies
class Chaser: MovableSprite, Spriteable {
    
    var specificActions: [When] = [
        //.jumpWhen(.pressedButton(.jump)),
        .fallWhen(.notOnGround),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        
        //.stopObjectFromMoving(.left, when: .thisBumped(.left)),
        //.stopObjectFromMoving(.right, when: .thisBumped(.right)),
        //.allowObjectToPush(.right, when: .thisBumped(.right)),
        //.allowObjectToPush(.left, when: .thisBumped(.left)),
        
        .allowObjectToPush(.up, when: .thisBumped(.up)),
        
        .moveLeftWhen(.always), // .playerIsLeftOfSelf
        //.moveRightWhen(.playerIsRightOfSelf),
        
        .xSpeed(2, everyFrame: 1),
        
        .jumpWhen(.onLedge),
        .reverseDirection(.onLedge),
        //.jumpWhen(.thisBumped(.left)),
        //.jumpWhen(.thisBumped(.right)),
        .reverseDirection(.thisBumped(.left)),
        .reverseDirection(.thisBumped(.right)),
        //.jumpWhen(.thisBumped(.down)),
        //.killObject(.left, when: .thisBumped(.left)),
        //.killObject(.right, when: .thisBumped(.right)),
        //.canDieFrom(.all()),
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
        .xSpeed(4, everyFrame: 2),
        
        .die(.thisBumped(.up)),
        .die(.thisBumped(.left)),
        .die(.thisBumped(.right)),
        .die(.afterJumpingNTimes(20))
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







