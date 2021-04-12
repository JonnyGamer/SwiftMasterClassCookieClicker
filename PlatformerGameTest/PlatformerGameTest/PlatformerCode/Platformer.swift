//
//  Platformer.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit


class GROUND: BasicSprite, Spriteable {
    var specificActions: [When] { [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
    ] }
}




class Sprites: MovableSprite, Spriteable {
    var specificActions: [When] { [
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        
        //.stopObjectFromMoving(.down, when: .yPositionIsLessThanZeroThenSetPositionToZero),
        
        .fallWhen(.notOnGround),
    ] }
}

class Inky: Sprites {
    override var specificActions: [When] {
        return super.specificActions + [
            .jumpWhen(.pressedButton(.jump)),
            .moveLeftWhen(.pressedButton(.left)),
            .moveRightWhen(.pressedButton(.right)),
            .standWhen(.neitherLeftNorRightButtonsAreBeingClicked),
        ]
    }
    override var isPlayer: Bool { return true }
}



// Rule For All Enemies
class Enemy: MovableSprite, Spriteable {
    var specificActions: [When] { [] }
}

// Rule for Specific Enemies
class Chaser: Enemy {
    override var bounceHeight: Int { 10 }
    
    override var specificActions: [When] {
        return super.specificActions + [
            .jumpWhen(.pressedButton(.jump)),
            .fallWhen(.notOnGround),
            //.stopObjectFromMoving(.down, when: .yPositionIsLessThanZeroThenSetPositionToZero),
            
            .moveLeftWhen(.playerIsLeftOfSelf),
            .moveRightWhen(.playerIsRightOfSelf)
        ]
    }
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







