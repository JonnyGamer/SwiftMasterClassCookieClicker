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
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        
        .moveLeftWhen(.pressedButton(.left)),
        .jumpWhen(.pressedButton(.jump)),
        .moveRightWhen(.pressedButton(.right)),
        //.stopObjectFromMoving(.down, when: .yPositionIsLessThanZeroThenSetPositionToZero),
        
        .fallWhen(.notOnGround),
    ]
    override var isPlayer: Bool { return true }
}

// ENDED AROUND 3:30?

// Rule For All Enemies
//class Enemy: Spriteable {
//    var specificActions: [When] { [] }
//}

// Rule for Specific Enemies
class Chaser: MovableSprite, Spriteable {
    override var bounceHeight: Int { 16 }
    
    var specificActions: [When] = [
        //.jumpWhen(.pressedButton(.jump)),
        .fallWhen(.notOnGround),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        
        //.stopObjectFromMoving(.left, when: .thisBumped(.left)),
        //.stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .allowObjectToPush(.right, when: .thisBumped(.right)),
        .allowObjectToPush(.left, when: .thisBumped(.left)),
        
        .allowObjectToPush(.up, when: .thisBumped(.up)),
        
        //.moveLeftWhen(.pressedButton(.left)),
        //.moveRightWhen(.pressedButton(.right)),
        //.moveLeftWhen(.playerIsLeftOfSelf),
        //.moveRightWhen(.playerIsRightOfSelf)
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







