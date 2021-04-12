//
//  main.swift
//  NewPlatformer
//
//  Created by Jonathan Pappas on 4/11/21.
//

import Foundation
import SpriteKit

print("Hello, World!")

enum Button {
    case jump, left, right
}
enum Direction {
    case up, down, left, right
}; extension Array where Element == Direction { static func all() -> Self { return [.up, .down, .left, .right] } }

//enum OnScreenObject {
//    case wall
//}

enum UserAction {
    case pressedButton(Button)
    
    case thisBumped(Direction)
    
    case playerIsLeftOfSelf
    case playerIsRightOfSelf
    case playerHasSameXPositionAsSelf
}

enum When {
    case jumpWhen(UserAction)
    case moveLeftWhen(UserAction)
    case moveRightWhen(UserAction)
    
    case stopObjectFromMoving(Direction, when: UserAction)
    
    case bounceObjectWhen(UserAction)
    
    case not
}


protocol Spriteable {
//    var moveJump: When { get set }
//    var moveLeft: When { get set }
//    var moveRight: When { get set }
//
//    //var stopMovingUp: When { get set }
//    //var stopMovingDown: When { get set }
//    //var startMovingDown: When { get set }
//    //var stopMovingLeft: When { get set }
//    //var stopMovingRight: When { get set }
//    var bounceObject: When { get set }
//    var stopObject: [When] { get set }
    
    var specificActions: [When] { get }
}

class BasicSprite {
    var isPlayer: Bool { return false }
    var position: (x: Int, y: Int) = (0,0)
    func run(_ this: SKAction) {}
    var bounceHeight = 0
    
    func jump() { jump(nil) }
    func jump(_ height: Int?) {}
    
    func move(_ direction: Button) {}
    func stopMoving(_ direction: Direction) {}
    
    var bumpedFromTop: [(Sprites) -> ()] = []
    var bumpedFromBottom: [(Sprites) -> ()] = []
    var bumpedFromLeft: [(Sprites) -> ()] = []
    var bumpedFromRight: [(Sprites) -> ()] = []
    
}

class Sprites: BasicSprite, Spriteable {
    var specificActions: [When] { [
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
    ] }
}

class Inky: Sprites {
    override var specificActions: [When] {
        return super.specificActions + [
            .jumpWhen(.pressedButton(.jump)),
            .moveLeftWhen(.pressedButton(.left)),
            .moveRightWhen(.pressedButton(.right)),
        ]
    }
    override var isPlayer: Bool { return true }
}



// Rule For All Enemies
class Enemy: BasicSprite, Spriteable {
    var specificActions: [When] { [] }
}

// Rule for Specific Enemies
class Chaser: Enemy {
    override var specificActions: [When] {
        return super.specificActions + [
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





class Scene {
    var charactersThatJumpWhenJumpButtonIsPressed: [Sprites] = []
    var charactersThatMoveLeftWhenLeftButtonIsPressed: [Sprites] = []
    var charactersThatMoveRightWhenRightButtonIsPressed: [Sprites] = []
    
    var doThisWhenJumpButtonIsPressed: [() -> ()] = []
    var doThisWhenLeftButtonIsPressed: [() -> ()] = []
    var doThisWhenRightButtonIsPressed: [() -> ()] = []
    
    var players: [Sprites] = []
    
    func begin() {
        let player = Inky()
        player.add(self)
        players.append(player)
        
        let enemy = Chaser()
    }
    
    func buttonPressed(_ button: Button) {
        switch button {
        case .jump: doThisWhenJumpButtonIsPressed.run()// .forEach { $0() }//  charactersThatJumpWhenJumpButtonIsPressed.forEach { $0.jump() }
        case .left: doThisWhenLeftButtonIsPressed.run()
        case .right: doThisWhenRightButtonIsPressed.run()
        }
    }
    
    func upate() {
        
    }
    
}

extension BasicSprite {
    func add(_ this: Scene) {
        guard let foo = self as? (BasicSprite & Spriteable) else { fatalError() }
        
        for i in foo.specificActions {
            resolveWhen(this, foo, i)
        }
    }
    
    func resolveWhen(_ this: Scene,_ foo: (BasicSprite & Spriteable),_ when: When) {
        
        switch when {
        case .jumpWhen(let userAction): resolveUserAction(this, userAction, foo.jump)
        case .moveLeftWhen(let userAction): resolveUserAction(this, userAction, {foo.move(.left)})
        case .moveRightWhen(let userAction): resolveUserAction(this, userAction, {foo.move(.right)})
        
        case .bounceObjectWhen(let userAction): resolveUserActionSPRITE(this, userAction, { $0.jump((foo as? Trampoline)?.bounciness) })
            
        case .stopObjectFromMoving(let dir, when: let userAction): resolveUserActionSPRITE(this, userAction, { $0.stopMoving(dir) })
            
        default: fatalError()
        }
        
    }
    
    func resolveUserActionSPRITE(_ this: Scene,_ userAction: UserAction,_ action: @escaping (BasicSprite) -> ()) {
        switch userAction {
        case .thisBumped(let dir): bumpedFromTop.append(action)
            switch dir {
            case .up: bumpedFromTop.append(action)
            case .down: bumpedFromBottom.append(action)
            case .left: bumpedFromLeft.append(action)
            case .right: bumpedFromRight.append(action)
            }
            
        default: fatalError()
        }
    }
    
    func resolveUserAction(_ this: Scene,_ userAction: UserAction,_ action: @escaping () -> ()) {
        switch userAction {
        case .pressedButton(let button):
            switch button {
            case .jump: this.doThisWhenJumpButtonIsPressed.append(action)
            case .left: this.doThisWhenLeftButtonIsPressed.append(action)
            case .right: this.doThisWhenRightButtonIsPressed.append(action)
            }
            
        //case .playerBumpedBottom(let objectType):
            
            
        case .playerIsLeftOfSelf:
            run(.repeatForever(.sequence([.wait(forDuration: 0.1), .run {
                if this.players.allSatisfy({ $0.position.x < self.position.x }) {
                    action()
                }
            }])))
        case .playerIsRightOfSelf:
            run(.repeatForever(.sequence([.wait(forDuration: 0.1), .run {
                if this.players.allSatisfy({ self.position.x < $0.position.x }) {
                    action()
                }
            }])))
        case .playerHasSameXPositionAsSelf:
            run(.repeatForever(.sequence([.wait(forDuration: 0.1), .run {
                if this.players.allSatisfy({ self.position.x == $0.position.x }) {
                    action()
                }
            }])))
            
        default: fatalError()
        }
    }
}

extension Array where Element == () -> () {
    func run() {
        forEach { $0() }
    }
}


//this.doThisWhenCharacterIsLeftOfSelf.append {
//    if this.players.allSatisfy({ $0.position.x < self.position.x }) {
//        action()
//    }
//}
