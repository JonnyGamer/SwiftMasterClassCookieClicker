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
            case .reverseDirection(let userAction): resolveUserAction(this, userAction, { foo.reverseMovement.toggle() })
            case .stopGoingUpWhen(let userAction): resolveUserAction(this, userAction, foo.stopMovingUp)
                
            case .resetJumpsWhen(let userAction):  resolveUserAction(this, userAction, { foo.jumps = 0 })
            case .maxJump(let m): foo.maxJumps = m
            case .jumpHeight(triangleOf: let m): foo.bounceHeight = m
            case .maxJumpSpeed(let m): foo.maxJumpSpeed = m
            case .minFallSpeed(let m): foo.minFallSpeed = m
                
            default: break
            }
            
        }
            
        switch when {
            
        case .collisionOn(let n): foo.collisionOn = n
        case .deathId(let n): foo.deathID = n
        case .canDieFrom(let dir): foo.canDieFrom = dir
        case .die(let userAction): resolveUserAction(this, userAction, { _ = foo.die(nil, []) })
        case .doThisWhen(let doThis, when: let userAction):  resolveUserAction(this, userAction, { doThis(foo) })
            
        case .bounceObjectWhen(let userAction):
            resolveUserActionSPRITE(this, userAction, {
                ($0 as? MovableSprite)?.jumps = 0
                ($0 as? MovableSprite)?.jump((foo as? Trampoline)?.bounciness)
            })
        case .stopObjectFromMoving(let dir, when: let userAction):
            resolveUserActionSPRITE(this, userAction, { $0.willStopMoving(self, dir) })
        case .allowObjectToPush(let dir, when: let userAction):
            resolveUserActionSPRITE(this, userAction, { ($0 as? MovableSprite)?.pushDirection(self, dir) })
        case .killObject(let dir, let userAction, let id):
            resolveUserActionSPRITE(this, userAction, {
                if $0.die(dir, id) {
                    self.killedObjects += 1
                    self.doThisWhenKilledObject[self.killedObjects]?.run($0)
                }
            })
        case .runSKAction(let actions):
            if let foo = foo as? (MovableSprite & SKActionable) {
                for (id, action) in actions {
                    resolveUserAction(this, action, {
                        if foo.actionSprite.action(forKey: "\(id)") == nil {
                            foo.actionSprite.run(foo.myActions[id], withKey: "\(id)")
                            foo.skNode.run(foo.myActions[id], withKey: "\(id)")
                        }
                    })
                }
            } else if let foo = foo as? (ActionSprite & SKActionable) {
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
    
    func resolveUserActionSPRITE(_ this: Scene,_ userAction: UserAction,_ action: @escaping (BasicSprite & Spriteable) -> ()) {
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
            
        case .afterKilledObjects(let n):
            if self.doThisWhenKilledObject[n] == nil {
                self.doThisWhenKilledObject[n] = [{
                    if $0 !== self {
                        action()
                    }
                }]
            } else {
                self.doThisWhenKilledObject[n]?.append {
                    if $0 !== self {
                        action()
                    }
                }
            }
        
       // case .somethingBumpedThis(let n):
            
        case .firstTimeOnScreen:
            guard let foo = (self as? MovableSprite) else { return }
            this.doThisWhenMovedOnScreen.append {
                if foo.onScreen { return }
                let bounds = foo.skNode.frame
                guard var sceneBounds = foo.skNode.scene?.frame else { return }
                guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
                sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))

                if bounds.intersects(sceneBounds) {
                    foo.onScreen = true
                    action()
                }
            }
        
        case .onceOffScreen:
            guard let foo = (self as? MovableSprite) else { return }
            this.doThisWhenMovedOffScreen.append {
                let bounds = foo.skNode.frame
                guard var sceneBounds = foo.skNode.scene?.frame else { return }
                guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
                sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))

                if !bounds.intersects(sceneBounds) {
                    action()
                }
            }
            
        case .died:
            self.doThisOnceDead.append(action)
            
        case .afterJumpingNTimes(let n):
            guard let foo = (self as? MovableSprite) else { return }
            if foo.doThisAfterNJumps[n] == nil {
                foo.doThisAfterNJumps[n] = [action]
            } else {
                foo.doThisAfterNJumps[n]?.append(action)
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
        case .when(let n):
            annoyance.append {
                if n(self) {
                    action()
                }
            }
            
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
        case .wasBumped(let dir):
            if dir == .left {
                runWhenBumpLeft.append(action)
            } else if dir == .right {
                runWhenBumpRight.append(action)
            } else if dir == .down {
                runWhenBumpDown.append(action)
            } else if dir == .up {
                runWhenBumpUp.append(action)
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
extension Array where Element == (BasicSprite) -> () {
    func run(_ n: MovableSprite) {
        forEach { $0(n) }
    }
}
extension Array where Element == (MovableSprite) -> () {
    func run(_ n: MovableSprite) {
        forEach { $0(n) }
    }
}
extension Array where Element == (BasicSprite & Spriteable) -> () {
    func run(_ n: BasicSprite & Spriteable) {
        forEach { $0(n) }
    }
    func run(_ n: BasicSprite) {
        if let n = n as? (BasicSprite & Spriteable) {
            forEach { $0(n) }
        }
    }
    func run(_ n: MovableSprite) {
        if let n = n as? (BasicSprite & Spriteable) {
            forEach { $0(n) }
        }
    }
}
