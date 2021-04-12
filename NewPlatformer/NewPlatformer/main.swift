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

enum OnScreenObject {
    case sideWall
}

enum UserAction {
    case pressedButton(Button)
    
    case playerIsInside(OnScreenObject)
    case playerBumpedLeft(OnScreenObject)
    case playerBumpedTop(OnScreenObject)
    case playerBumpedRight(OnScreenObject)
    case playerBumpedBottom(OnScreenObject)
    
    case playerIsLeftOfSelf
    case playerIsRightOfSelf
}

enum When {
    case jumpWhen(UserAction)
    case moveLeftWhen(UserAction)
    case moveRightWhen(UserAction)
    //case dontMoveWhen(UserAction)
    
    case stopMovingLeftWhen(UserAction)
    case stopMovingRightWhen(UserAction)
    case stopFallingWhen(UserAction)
    
    case not
}


protocol Spriteable {
    var moveJump: When { get set }
    var moveLeft: When { get set }
    var moveRight: When { get set }
}

class Sprites {
    func jump() {}
    func move(_ direction: Button) {}
    var isPlayer: Bool { return false }
    var position: (x: Int, y: Int) = (0,0)
    func run(_ this: SKAction) {}
    //var whenBumped
}

class Inky: Sprites, Spriteable {
    var moveJump: When = .jumpWhen(.pressedButton(.jump))
    var moveLeft: When = .moveLeftWhen(.pressedButton(.left))
    var moveRight: When = .moveRightWhen(.pressedButton(.right))
    
    var stopMoving: When = .dontMoveWhen(.playerBumped(.sideWall))
    override var isPlayer: Bool { return true }
}

// Rule For All Enemies
class Enemy: Sprites {
    var moveJump: When = .not
}

// Rule for Specific Enemies
class Chaser: Enemy, Spriteable {
    var moveLeft: When = .moveLeftWhen(.playerIsLeftOfSelf)
    var moveRight: When = .moveRightWhen(.playerIsRightOfSelf)
}






class Scene {
    var charactersThatJumpWhenJumpButtonIsPressed: [Sprites] = []
    var charactersThatMoveLeftWhenLeftButtonIsPressed: [Sprites] = []
    var charactersThatMoveRightWhenRightButtonIsPressed: [Sprites] = []
    
    var doThisWhenJumpButtonIsPressed: [() -> ()] = []
    var doThisWhenLeftButtonIsPressed: [() -> ()] = []
    var doThisWhenRightButtonIsPressed: [() -> ()] = []
    
    var doThisWhenCharacterIsLeftOfSelf: [() -> ()] = []
    var doThisWhenCharacterIsRightOfSelf: [() -> ()] = []
    
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
        doThisWhenCharacterIsLeftOfSelf.run()
        doThisWhenCharacterIsRightOfSelf.run()
    }
    
}

extension Sprites {
    func add(_ this: Scene) {
        guard let foo = self as? (Sprites & Spriteable) else { fatalError() }
        
        switch foo.moveJump {
        case .jumpWhen(let j):
            let action = foo.jump
            
            switch j {
            case .pressedButton(let button):
                switch button {
                case .jump: this.doThisWhenJumpButtonIsPressed.append(action)
                case .left: this.doThisWhenLeftButtonIsPressed.append(action)
                case .right: this.doThisWhenRightButtonIsPressed.append(action)
                }
                
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
                
            default: fatalError()
            }
            
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
