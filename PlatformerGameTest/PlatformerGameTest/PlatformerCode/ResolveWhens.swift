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
        
        for i in foo.whenActions() {
            foo.resolveWhen(this, i)
        }
    }
    
}

extension BasicSprite {
    
    func resolveSetter(_ this: Scene,_ sett: Setters) {
        switch sett {
        case .contactDirections(let dirs): contactOn = dirs
        case .gravity(let n, let fps): (self as? MovableSprite)?.ySpeed = n; (self as? MovableSprite)?.yEveryFrame = fps
        case .jumpHeight(triangleOf: let m): (self as? MovableSprite)?.bounceHeight = m
        case .maxJump(let m): (self as? MovableSprite)?.maxJumps = m
        case .maxJumpSpeed(let m): (self as? MovableSprite)?.maxJumpSpeed = m
        case .minFallSpeed(let m): (self as? MovableSprite)?.minFallSpeed = m
        case .wallDirections(let w): (self as? MovableSprite)?.wallOn = w
        case .xSpeed(let n, let fps): (self as? MovableSprite)?.xSpeed = n; (self as? MovableSprite)?.everyFrameR = fps
        }
    }
    
    func resolveNewAction(_ this: Scene, newAction: NewAction, doThis: @escaping () -> ()) {
        switch newAction {
        case .afterJumpingNTimes(let jumps):
            guard let foo = (self as? MovableSprite) else { fatalError() }
            if foo.doThisAfterNJumps[jumps] == nil { foo.doThisAfterNJumps[jumps] = [] }
            foo.doThisAfterNJumps[jumps]?.append(doThis)
        case .always: everyFrame.append(doThis)
        case .falling:
            guard let foo = (self as? MovableSprite) else { return }
            everyFrame.append {
                if foo.falling { doThis() }
            }
            
        case .farOffScreen:do{}
        case .firstTimeOnScreen:
            if let foo = (self as? MovableSprite) {
                foo.everyFrame.append {
                    if foo.onScreen { return }
                    let bounds = foo.skNode.frame
                    guard var sceneBounds = foo.skNode.scene?.frame else { return }
                    guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
                    sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))

                    if bounds.intersects(sceneBounds) {
                        foo.onScreen = true
                        doThis()
                    }
                }
            }
            if let foo = (self as? ActionSprite) {
                foo.everyFrame.append {
                    if foo.onScreen { return }
                    let bounds = foo.skNode.frame
                    guard var sceneBounds = foo.skNode.scene?.frame else { return }
                    guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
                    sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))

                    if bounds.intersects(sceneBounds) {
                        foo.onScreen = true
                        doThis()
                    }
                }
            }
            
        //case .ifTrue(let check): everyFrame.append { if check(self) { doThis($0) } }
            
        case .jumpingUp:
            guard let foo = self as? MovableSprite else { fatalError() }
            everyFrame.append {
                if foo.movingUp { doThis() }
            }
            
        case .moving(let dir): fatalError()
            
            //guard let foo = (self as? MovableSprite) else { return }
            //everyFrame.append { if foo.doThisWhenKilledBy.isEmpty { doThis() } }
            
        case .notOnGround:
            guard let foo = (self as? MovableSprite) else { fatalError() }
            everyFrame.append { if foo.onGround.isEmpty { doThis() } }
            
        case .offScreen:
            guard let foo = (self as? MovableSprite) else { fatalError() }
            foo.everyFrame.append {
                let bounds = foo.skNode.frame
                guard var sceneBounds = foo.skNode.scene?.frame else { return }
                guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
                sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))

                if !bounds.intersects(sceneBounds) {
                    doThis()
                }
            }
            
        case .onceEveryNFrames(let frames):
            var framos = 0
            let modFrame = frames
            everyFrame.append {
                if modFrame % framos == 0 { doThis() }
                framos += 1
            }
            
        case .onGround:
            guard let foo = (self as? MovableSprite) else { fatalError() }
            everyFrame.append { if !foo.onGround.isEmpty { doThis() } }
        case .onScreen: fatalError()
        case .onLedge: (self as? MovableSprite)?.standingOnLedgeAction.append(doThis)
        case .playerHasSameXPositionAsSelf:
            everyFrame.append {
                if this.players.allSatisfy({ self.midX == $0.midX }) {
                    doThis()
                }
            }
        case .playerIsLeftOfSelf:
            everyFrame.append {
                if this.players.allSatisfy({ $0.midX < self.midX }) {
                    doThis()
                }
            }
            
        case .playerIsRightOfSelf:
            everyFrame.append {
                if this.players.allSatisfy({ self.midX < $0.midX }) {
                    doThis()
                }
            }
            
        case .pressedButton(let button):
            switch button {
            case .jump: doThisWhenJumpButtonIsPressed.append(doThis)
            case .left: doThisWhenLeftButtonIsPressed.append(doThis)
            case .right: doThisWhenRightButtonIsPressed.append(doThis)
            }
            
        case .releasedButton(let button):
            switch button {
            case .jump: doThisWhenJumpButtonIsReleased.append(doThis)
            default: fatalError("Add your own.")
            }
            
        case .somewhatOffScreen: fatalError()
        case .standing: fatalError()
        }
    }

    func resolveWhen(_ this: Scene,_ when: Whens) {
        
        
        switch when {
        case .killed(let action): doThisWhenKilledObject.append(action)
        case .killedBy(let action): doThisWhenKilledBy.append(action)
            
        case .setters(let setters): do{}
            for set in setters {
                resolveSetter(this, set)
            }
            
        case .wasBumpedBy(let dir, doThis: let action):
            if dir == .up {
                wasBumpedFromUp.append(action)
            } else if dir == .down {
                wasBumpedFromDown.append(action)
            } else if dir == .left {
                wasBumpedFromLeft.append(action)
            } else if dir == .right {
                wasBumpedFromRight.append(action)
            }
            
        case .when(let check, doThis: let action): do{}
            resolveNewAction(this, newAction: check, doThis: action)
            
        default: break
        }
        
        
        if let foo = self as? MovableSprite {
            switch when {
            case .bumped(let dir, doThis: let action): do{}
                if dir == .up {
                    foo.runWhenBumpUp.append(action)
                } else if dir == .down {
                    foo.runWhenBumpDown.append(action)
                } else if dir == .left {
                    foo.runWhenBumpLeft.append(action)
                } else if dir == .right {
                    foo.runWhenBumpRight.append(action)
                }
            default: break
            }
        }
            
//        switch when {
//
//        case .collisionOn(let n): foo.collisionOn = n
//        case .deathId(let n): foo.deathID = n
//        case .canDieFrom(let dir): foo.canDieFrom = dir
//        case .die(let userAction): resolveUserAction(this, userAction, { _ = foo.die(nil, []) })
//        case .doThisWhen(let doThis, when: let userAction):  resolveUserAction(this, userAction, { doThis(foo) })
//
//        case .bounceObjectWhen(let userAction):
//            resolveUserActionSPRITE(this, userAction, {
//                ($0 as? MovableSprite)?.jumps = 0
//                ($0 as? MovableSprite)?.jump((foo as? Trampoline)?.bounciness)
//            })
//        case .stopObjectFromMoving(let dir, when: let userAction):
//            resolveUserActionSPRITE(this, userAction, { $0.willStopMoving(self, dir) })
//        case .allowObjectToPush(let dir, when: let userAction):
//            resolveUserActionSPRITE(this, userAction, { ($0 as? MovableSprite)?.pushDirection(self, dir) })
//        case .killObject(let dir, let userAction, let id):
//            resolveUserActionSPRITE(this, userAction, {
//                if $0.die(dir, id) {
//                    self.killedObjects += 1
//                    self.doThisWhenKilledObject[self.killedObjects]?.run($0)
//                }
//            })
//        case .runSKAction(let actions):
//            if let foo = foo as? (MovableSprite & SKActionable) {
//                for (id, action) in actions {
//                    resolveUserAction(this, action, {
//                        if foo.actionSprite.action(forKey: "\(id)") == nil {
//                            foo.actionSprite.run(foo.myActions[id], withKey: "\(id)")
//                            foo.skNode.run(foo.myActions[id], withKey: "\(id)")
//                        }
//                    })
//                }
//            } else if let foo = foo as? (ActionSprite & SKActionable) {
//                for (id, action) in actions {
//                    resolveUserAction(this, action, {
//                        if foo.actionSprite.action(forKey: "\(id)") == nil {
//                            foo.actionSprite.run(foo.myActions[id], withKey: "\(id)")
//                            foo.skNode.run(foo.myActions[id], withKey: "\(id)")
//                        }
//                    })
//                }
//            }
//        default: break
//        }
//
        
        
    }
    
//    func resolveUserActionSPRITE(_ this: Scene,_ userAction: UserAction,_ action: @escaping (BasicSprite & Spriteable) -> ()) {
//        switch userAction {
//        case .thisBumped(let dir):
//            switch dir {
//            case .up: bumpedFromTop.append(action)
//            case .down: bumpedFromBottom.append(action)
//            case .left: bumpedFromLeft.append(action)
//            case .right: bumpedFromRight.append(action)
//            }
//            
////        case .yPositionIsLessThanZeroThenSetPositionToZero:
////            this.annoyance.append {
////                if self.position.y < 0 {
////                    self.position.y = 0
////                    self.stopMoving(.down)
////                }
////            }
//            
//        default: fatalError()
//        }
//    }
//    
//    func resolveUserAction(_ this: Scene,_ userAction: UserAction,_ action: @escaping () -> ()) {
//        switch userAction {
//        case .pressedButton(let button):
//            switch button {
//            case .jump: doThisWhenJumpButtonIsPressed.append(action)
//            case .left: doThisWhenLeftButtonIsPressed.append(action)
//            case .right: doThisWhenRightButtonIsPressed.append(action)
//            }
//        case .releasedButton(let button):
//            switch button {
//            case .jump: doThisWhenJumpButtonIsReleased.append(action)
//            default: fatalError("Add your own.")
//            }
//            
//        case .afterKilledObjects(let n):
//            if self.doThisWhenKilledObject[n] == nil {
//                self.doThisWhenKilledObject[n] = [{
//                    if $0 !== self {
//                        action()
//                    }
//                }]
//            } else {
//                self.doThisWhenKilledObject[n]?.append {
//                    if $0 !== self {
//                        action()
//                    }
//                }
//            }
//        
//       // case .somethingBumpedThis(let n):
//            
//        case .firstTimeOnScreen:
//            guard let foo = (self as? MovableSprite) else { return }
//            foo.everyFrame.append {
//                if foo.onScreen { return }
//                let bounds = foo.skNode.frame
//                guard var sceneBounds = foo.skNode.scene?.frame else { return }
//                guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
//                sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))
//
//                if bounds.intersects(sceneBounds) {
//                    foo.onScreen = true
//                    action()
//                }
//            }
//        
//        case .onceOffScreen:
//            guard let foo = (self as? MovableSprite) else { return }
//            foo.everyFrame.append {
//                let bounds = foo.skNode.frame
//                guard var sceneBounds = foo.skNode.scene?.frame else { return }
//                guard let cameraPos = foo.skNode.scene?.camera?.position else { return }
//                sceneBounds = sceneBounds.offsetBy(dx: cameraPos.x - (sceneBounds.width/2), dy: cameraPos.y - (sceneBounds.height/2))
//
//                if !bounds.intersects(sceneBounds) {
//                    action()
//                }
//            }
//            
//        case .died:
//            self.doThisOnceDead.append(action)
//            
//        case .afterJumpingNTimes(let n):
//            guard let foo = (self as? MovableSprite) else { return }
//            if foo.doThisAfterNJumps[n] == nil {
//                foo.doThisAfterNJumps[n] = [action]
//            } else {
//                foo.doThisAfterNJumps[n]?.append(action)
//            }
//            
//        case .onLedge:
//            (self as? MovableSprite)?.standingOnLedgeAction.append(action)
//
//        case .neitherLeftNorRightButtonsAreBeingClicked:
//            doThisWhenNotOnGround.append(action)
//            
//        case .notOnGround:
//            (self as? MovableSprite)?.doThisWhenNotOnGround.append(action)
//            //break
//            
//        case .always:
//            everyFrame.append(action)
//        case .when(let n):
//            everyFrame.append {
//                if n(self) {
//                    action()
//                }
//            }
//            
//        case .playerIsLeftOfSelf:
//            everyFrame.append {
//                if this.players.allSatisfy({ $0.midX < self.midX }) {
//                    action()
//                }
//            }
//        case .playerIsRightOfSelf:
//            everyFrame.append {
//                if this.players.allSatisfy({ self.midX < $0.midX }) {
//                    action()
//                }
//            }
//        case .playerHasSameXPositionAsSelf:
//            everyFrame.append {
//                if this.players.allSatisfy({ self.midX == $0.midX }) {
//                    action()
//                }
//            }
//        case .wasBumped(let dir):
//            if dir == .left {
//                runWhenBumpLeft.append(action)
//            } else if dir == .right {
//                runWhenBumpRight.append(action)
//            } else if dir == .down {
//                runWhenBumpDown.append(action)
//            } else if dir == .up {
//                runWhenBumpUp.append(action)
//            }
//        
//        default: fatalError()
//        }
//    }
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

extension Array where Element == (BasicSprite, MovableSprite) -> () {
    func run(_ a: BasicSprite, _ m: MovableSprite) {
        forEach { $0(a, m) }
    }
}
extension Array where Element == (BasicSprite, BasicSprite) -> () {
    func run(_ a: BasicSprite, _ m: BasicSprite) {
        forEach { $0(a, m) }
    }
}


//extension Array where Element == (BasicSprite) -> () {
//    func run(_ n: BasicSprite & Spriteable) {
//        forEach { $0(n) }
//    }
//    func run(_ n: BasicSprite) {
//        if let n = n as? (BasicSprite & Spriteable) {
//            forEach { $0(n) }
//        }
//    }
//    func run(_ n: MovableSprite) {
//        if let n = n as? (BasicSprite & Spriteable) {
//            forEach { $0(n) }
//        }
//    }
//}
