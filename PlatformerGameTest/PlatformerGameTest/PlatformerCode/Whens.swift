//
//  Whens.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation

enum When {
    case reverseDirection(UserAction)
    case jumpWhen(UserAction)
    case moveLeftWhen(UserAction)
    case moveRightWhen(UserAction)
    
    /// SPRITE
    case stopObjectFromMoving(Direction, when: UserAction)
    /// SPRITE
    case allowObjectToPush(Direction, when: UserAction)
    /// SPRITE
    case bounceObjectWhen(UserAction)
    case fallWhen(UserAction)
    case standWhen(UserAction)
    
    case xSpeed(Int, everyFrame: Int)
    case die(UserAction), deathId(Int)
    
    /// SPRITE
    case killObject(Direction, when: UserAction, id: [Int])
    case canDieFrom([Direction])
    case runSKAction([(Int, UserAction)])
    case jumpHeight(triangleOf: Int)
    case maxJumpSpeed(Int)
    case minFallSpeed(Int)
    case gravity(Int, everyFrame: Int)
    case stopGoingUpWhen(UserAction)
    case maxJump(Int)
    
    case collisionOn([Direction])
    
    case doThisWhen((BasicSprite) -> (), when: UserAction)
    case resetJumpsWhen(UserAction)
}

enum UserAction {
    case releasedButton(Button)
    case pressedButton(Button)
    
    case wasBumped(Direction)
    case thisBumped(Direction)
    case playerIsLeftOfSelf
    case playerIsRightOfSelf
    case playerHasSameXPositionAsSelf
    case onLedge
    case afterJumpingNTimes(Int)
    case onceOffScreen
    case firstTimeOnScreen
    case died
    case afterKilledObjects(Int)
    
    //case touchingNoWall(Direction)
    case notOnGround
    case neitherLeftNorRightButtonsAreBeingClicked
    case always, when((BasicSprite) -> Bool)
    //case yPositionIsLessThanZeroThenSetPositionToZero
}

enum Button {
    case jump, left, right
}
enum Direction {
    case up, down, left, right
}
extension Array where Element == Direction { static func all() -> Self { return [.up, .down, .left, .right] } }





