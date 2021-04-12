//
//  Whens.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation

enum When {
    case jumpWhen(UserAction)
    case moveLeftWhen(UserAction)
    case moveRightWhen(UserAction)
    case stopObjectFromMoving(Direction, when: UserAction)
    case bounceObjectWhen(UserAction)
}

enum UserAction {
    case pressedButton(Button)
    case thisBumped(Direction)
    case playerIsLeftOfSelf
    case playerIsRightOfSelf
    case playerHasSameXPositionAsSelf
}

enum Button {
    case jump, left, right
}
enum Direction {
    case up, down, left, right
}





