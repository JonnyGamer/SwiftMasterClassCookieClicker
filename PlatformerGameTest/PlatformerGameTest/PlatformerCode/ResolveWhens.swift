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
            case .xSpeed(let n, let fps): foo.xSpeed = n; foo.everyFrame = fps
            case .gravity(let n, let fps): foo.ySpeed = n; foo.yEveryFrame = fps
            case .reverseDirection(let userAction): resolveUserAction(this, userAction, { foo.xSpeed *= -1 })
            case .die(let userAction): resolveUserAction(this, userAction, { foo.die(nil) })
            case .canDieFrom(let dir): foo.canDieFrom = dir
            case .stopGoingUpWhen(let userAction): resolveUserAction(this, userAction, foo.stopMovingUp)
            
            case .doThisWhen(let doThis, when: let userAction):  resolveUserAction(this, userAction, { doThis(foo) })
            case .resetJumpsWhen(let userAction):  resolveUserAction(this, userAction, { foo.jumps = 0 })
            case .maxJump(let m): foo.maxJumps = m
            case .jumpHeight(triangleOf: let m): foo.bounceHeight = m
            case .maxJumpSpeed(let m): foo.maxJumpSpeed = m
            case .minFallSpeed(let m): foo.minFallSpeed = m
                
            default: break
            }
            
        }
            
        switch when {
            
        case .bounceObjectWhen(let userAction): resolveUserActionSPRITE(this, userAction, { $0.jump((foo as? Trampoline)?.bounciness) })
            
        case .stopObjectFromMoving(let dir, when: let userAction): resolveUserActionSPRITE(this, userAction, { $0.stopMoving(self, dir) })
        case .allowObjectToPush(let dir, when: let userAction): resolveUserActionSPRITE(this, userAction, { $0.pushDirection(self, dir) })
        case .killObject(let dir, let userAction): resolveUserActionSPRITE(this, userAction, { $0.die(dir) })
        case .runSKAction(let actions):
            if let foo = foo as? (BasicSprite & SKActionable) {
                for (id, action) in actions {
                    resolveUserAction(this, action, {
                        if foo.actionSprite.action(forKey: "\(id)") == nil {
                            foo.actionSprite.run(foo.myActions[id], withKey: "\(id)")
                            foo.skNode.run(foo.myActions[id], withKey: "\(id)")
                        }
                    })
                }
            }
        default: break
        }
        
        
        
    }
    
    func resolveUserActionSPRITE(_ this: Scene,_ userAction: UserAction,_ action: @escaping (MovableSprite) -> ()) {
        switch userAction {
        case .thisBumped(let dir):
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
        case .releasedButton(let button):
            switch button {
            case .jump: this.doThisWhenJumpButtonIsReleased.append(action)
            default: fatalError("Add your own.")
            }
            
        case .onLedge:
            (self as? MovableSprite)?.standingOnLedgeAction.append(action)

        case .neitherLeftNorRightButtonsAreBeingClicked:
            doThisWhenNotOnGround.append(action)
            
        case .notOnGround:
            (self as? MovableSprite)?.doThisWhenNotOnGround.append(action)
            //break
            
        case .always:
            annoyance.append(action)
            
        case .playerIsLeftOfSelf:
            annoyance.append {
                if this.players.allSatisfy({ $0.midX < self.midX }) {
                    action()
                }
            }
        case .playerIsRightOfSelf:
            annoyance.append {
                if this.players.allSatisfy({ self.midX < $0.midX }) {
                    action()
                }
            }
        case .playerHasSameXPositionAsSelf:
            annoyance.append {
                if this.players.allSatisfy({ self.midX == $0.midX }) {
                    action()
                }
            }
        case .thisBumped(let dir):
            if dir == .left {
                (self as? MovableSprite)?.runWhenBumpLeft.append(action)
            } else if dir == .right {
                (self as? MovableSprite)?.runWhenBumpRight.append(action)
            } else if dir == .down {
                (self as? MovableSprite)?.runWhenBumpDown.append(action)
            } else if dir == .up {
                (self as? MovableSprite)?.runWhenBumpUp.append(action)
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
extension Array where Element == (BasicSprite) -> () {
    func run(_ n: BasicSprite) {
        forEach { $0(n) }
    }
}

