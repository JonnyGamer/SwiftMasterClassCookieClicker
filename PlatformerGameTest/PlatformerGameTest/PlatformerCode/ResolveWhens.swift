//
//  ResolveWhens.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation

extension BasicSprite {
    func add(_ this: Scene) {
        guard let foo = self as? (BasicSprite & Spriteable) else { return }
        
        for i in foo.specificActions {
            foo.resolveWhen(this, foo, i)
        }
    }
    
}

extension BasicSprite {

    func resolveWhen(_ this: Scene,_ foo: (BasicSprite & Spriteable),_ when: When) {
        
        if let foo = foo as? MovableSprite {
            
            switch when {
            case .jumpWhen(let userAction): resolveUserAction(this, userAction, foo.jump)
            case .moveLeftWhen(let userAction): resolveUserAction(this, userAction, {foo.move(.left)})
            case .moveRightWhen(let userAction): resolveUserAction(this, userAction, {foo.move(.right)})
            case .fallWhen(let userAction): resolveUserAction(this, userAction, foo.fall)
            case .standWhen(let userAction): resolveUserAction(this, userAction, foo.stand)
            case .xSpeed(let n): foo.xSpeed = n
            default: break
            }
            
        }
            
            switch when {
                
            case .bounceObjectWhen(let userAction): resolveUserActionSPRITE(this, userAction, { $0.jump((foo as? Trampoline)?.bounciness) })
                
            case .stopObjectFromMoving(let dir, when: let userAction): resolveUserActionSPRITE(this, userAction, { $0.stopMoving(self, dir) })
            case .allowObjectToPush(let dir, when: let userAction): resolveUserActionSPRITE(this, userAction, { $0.pushDirection(self, dir) })
                
            default: break
            }
        
        
        
    }
    
    func resolveUserActionSPRITE(_ this: Scene,_ userAction: UserAction,_ action: @escaping (MovableSprite) -> ()) {
        switch userAction {
        case .thisBumped(let dir):
            switch dir {
            case .up:
                print("OK")
                print(bumpedFromTop.count)
                bumpedFromTop.append(action)
                print(bumpedFromTop.count)
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
            
        case .notOnGround: break
//        case .notOnGround:
//            run(.repeatForever(.sequence([.wait(forDuration: 0.05), .run {
//                if self.onGround.isEmpty {
//                    action()
//                }
//            }])))
            
        case .playerIsLeftOfSelf:
            this.annoyance.append {
                if this.players.allSatisfy({ $0.midX < self.midX }) {
                    action()
                }
            }
//            run(.repeatForever(.sequence([.wait(forDuration: 1/15.0), .run {
//                if this.players.allSatisfy({ $0.midX < self.midX }) {
//                    action()
//                }
//            }])))
        case .playerIsRightOfSelf:
            this.annoyance.append {
                if this.players.allSatisfy({ self.midX < $0.midX }) {
                    action()
                }
            }
//            run(.repeatForever(.sequence([.wait(forDuration: 1/15.0), .run {
//                if this.players.allSatisfy({ self.midX < $0.midX }) {
//                    action()
//                }
//            }])))
        case .playerHasSameXPositionAsSelf:
            this.annoyance.append {
                if this.players.allSatisfy({ self.midX == $0.midX }) {
                    action()
                }
            }
            
//            run(.repeatForever(.sequence([.wait(forDuration: 1/15.0), .run {
//                if this.players.allSatisfy({ self.midX == $0.midX }) {
//                    action()
//                }
//            }])))
            
        default: fatalError()
        }
    }
}

extension Array where Element == () -> () {
    func run() {
        forEach { $0() }
    }
}

