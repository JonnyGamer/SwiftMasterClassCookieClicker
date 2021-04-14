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
        //.stopObjectFromMoving(.down, when: .yPositionIsLessThanZeroThenSetPositionToZero),
        
        //.die(.pressedButton(.jump)),
        .canDieFrom(.all()),
        .fallWhen(.notOnGround),
    ]
    override var isPlayer: Bool { return true }
}



// Rule For All Enemies
//class Enemy: Spriteable {
//    var specificActions: [When] { [] }
//}

// Rule for Specific Enemies
class Chaser: MovableSprite, Spriteable {
    override var bounceHeight: Int { 10 }
    
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
        .xSpeed(5, everyFrame: 2),
        
        //.jumpWhen(.onLedge),
        .reverseDirection(.onLedge),
        //.jumpWhen(.thisBumped(.left)),
        //.jumpWhen(.thisBumped(.right)),
        .reverseDirection(.thisBumped(.left)),
        .reverseDirection(.thisBumped(.right)),
        //.jumpWhen(.thisBumped(.down)),
        
        .killObject(.left, when: .thisBumped(.left)),
        .killObject(.right, when: .thisBumped(.right)),
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







