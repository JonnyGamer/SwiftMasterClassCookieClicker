//
//  ResolveWhens.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation

extension BasicSprite {
    func add(_ this: Scene) {
        guard let foo = self as? (MovableSprite & Spriteable) else { return }
        
        for i in foo.specificActions {
            foo.resolveWhen(this, foo, i)
        }
    }
    
}

extension MovableSprite {

    func resolveWhen(_ this: Scene,_ foo: (MovableSprite & Spriteable),_ when: When) {
        
        switch when {
        case .jumpWhen(let userAction): resolveUserAction(this, userAction, foo.jump)
        case .moveLeftWhen(let userAction): resolveUserAction(this, userAction, {foo.move(.left)})
        case .moveRightWhen(let userAction): resolveUserAction(this, userAction, {foo.move(.right)})
        case .fallWhen(let userAction): resolveUserAction(this, userAction, foo.fall)
        case .standWhen(let userAction): resolveUserAction(this, userAction, foo.stand)
            
        case .bounceObjectWhen(let userAction): resolveUserActionSPRITE(this, userAction, { $0.jump((foo as? Trampoline)?.bounciness) })
            
        case .stopObjectFromMoving(let dir, when: let userAction): resolveUserActionSPRITE(this, userAction, { $0.stopMoving(dir) })
            
        }
        
    }
    
    func resolveUserActionSPRITE(_ this: Scene,_ userAction: UserAction,_ action: @escaping (MovableSprite) -> ()) {
        switch userAction {
        case .thisBumped(let dir): bumpedFromTop.append(action)
            switch dir {
            case .up: bumpedFromTop.append(action)
            case .down: bumpedFromBottom.append(action)
            case .left: bumpedFromLeft.append(action)
            case .right: bumpedFromRight.append(action)
            }
            
//        case .yPositionIsLessThanZeroThenSetPositionToZero:
//            this.annoyance.append {
//                if self.position.y < 0 {
//                    self.position.y = 0
//                    self.stopMoving(.down)
//                }
//            }
            
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

        case .neitherLeftNorRightButtonsAreBeingClicked:
            this.doThisWhenStanding.append(action)
            
        case .notOnGround:
            run(.repeatForever(.sequence([.wait(forDuration: 0.05), .run {
                if self.onGround.isEmpty {
                    action()
                }
            }])))
            
        case .playerIsLeftOfSelf:
            run(.repeatForever(.sequence([.wait(forDuration: 1/15.0), .run {
                if this.players.allSatisfy({ $0.position.x < self.position.x }) {
                    action()
                }
            }])))
        case .playerIsRightOfSelf:
            run(.repeatForever(.sequence([.wait(forDuration: 1/15.0), .run {
                if this.players.allSatisfy({ self.position.x < $0.position.x }) {
                    action()
                }
            }])))
        case .playerHasSameXPositionAsSelf:
            run(.repeatForever(.sequence([.wait(forDuration: 1/15.0), .run {
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

