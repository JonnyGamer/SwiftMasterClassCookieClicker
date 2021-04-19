//
//  Platformer.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit


class GROUND: BasicSprite, WhenActions {
    func whenActions() -> [Whens] {[
        .wasBumpedBy(.down, doThis: {
            $0.willStopMoving(self, .down)
        }),
        .wasBumpedBy(.left, doThis: { $0.willStopMoving(self, .left) }),
        .wasBumpedBy(.right, doThis: { $0.willStopMoving(self, .right) }),
        .wasBumpedBy(.up, doThis: {
            $0.willStopMoving(self, .up)
        }),
    ]}
}

class Moving_GROUND: ActionSprite, WhenActions, SKActionable {
    func whenActions() -> [Whens] {[
        .wasBumpedBy(.down, doThis: { $0.willStopMoving(self, .down) }),
        .wasBumpedBy(.left, doThis: { $0.willStopMoving(self, .left) }),
        .wasBumpedBy(.right, doThis: { $0.willStopMoving(self, .right) }),
        .wasBumpedBy(.up, doThis: { $0.willStopMoving(self, .up) }),
    ]}
    
    var myActions: [SKAction] {[
        .figureEight(height: 320, time: 4)
    ]}
    var actionSprite: SKNode = SKNode()
}





class Inky: MovableSprite, WhenActions2, SKActionable {
    static var starterImage: Images = .mario
    static var starterSize: (Int, Int) = (16,16)
    var actionSprite: SKNode = SKSpriteNode()
    
    var myActions: [SKAction] = [
        .setImage(.mario),
        .sequence([
            .setImage(.m1, 0.1),
            .setImage(.m2, 0.1),
            .setImage(.m3, 0.1),
        ]),
        .setImage(.marioJump),
    ]
    
    func whenActions() -> [Whens] {[
        // Reset Jumps
        .bumped(.down, doThis: { _ in self.jumps = 0 }),
        // Jump Button
        .when(.pressedButton(.jump), doThis: {
            if self.jump() {
                self.run(.sound(.jump))
            }
        }),
        // Fall when not on ground
        .when(.notOnGround, doThis: { self.fall() }),
        // Jump Heights
        .when(.releasedButton(.jump), doThis: { self.stopMovingUp() }),
        // Move Left
        .when(.pressedButton(.left), doThis: { self.move(.left) }),
        // Move Right
        .when(.pressedButton(.right), doThis: { self.move(.right) }),
        // Stand
        .when(.pressedButtons([.right, .left]), doThis: {
            if self.onGround.isEmpty { return }
            self.runAction(1)
        }),
        
        // When Killed, run the 'Dead Mario Animation'
        .killedBy({ _ in
            self.spawnObject(DeadMario.self, location: (self.position.x, max(self.position.y, -16)))
        }),
        
        // Die when off screen
        .when(.offScreen, doThis: {
            if self.position.y < 0 {
                _ = self.die(killedBy: self)
                self.spawnObject(DeadMario.self, location: (self.position.x, -16))
            }
        }),
        
        .setters([
            .jumpHeight(triangleOf: 12),
            .maxJumpSpeed(3),
            .minFallSpeed(-3),
            .gravity(-1, everyFrame: 3),
        ]),
        .when(.notPressingLeftOrRight, doThis: {
            if self.onGround.isEmpty { return }
            self.killAction(1)
            self.runAction(0)
        }),
        .when(.notOnGround, doThis: {
            self.killAction(1)
            self.runAction(2)
        }),
        
        
        //.doThisWhen({ ($0 as? MovableSprite)?.skNode.run(.animate(with: [Cash.getTexture(Images.mario.rawValue)], timePerFrame: 0)) }, when: .notOnGround)

         //Fire Ball Power!
//        .doThisWhen({
//            if let inky = $0 as? Inky, let fireBalls = ($0 as? Inky)?.fireBallsActive, fireBalls < 2 {
//                inky.fireBallsActive += 1
//                if inky.lastMovedThisDirection == .left {
//                    inky.spawnObject(FireBall.self, frame:(4,4), location: ($0.minX - 2, $0.midY))
//                } else if inky.lastMovedThisDirection == .right {
//                    inky.spawnObject(FireBall.self, frame:(4,4), location: ($0.maxX, $0.midY), reverseMovement: true)
//                }
//            }
//        }, when: .pressedButton(.jump))
    ]}
    
    
    var fireBallsActive = 0

    override var isPlayer: Bool { return true }
}



//// Rule for Specific Enemies
//class Chaser: MovableSprite, Spriteable {
//
//    var specificActions: [When] = [
//
//        .fallWhen(.notOnGround),
//        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
//
//        //
//        .moveLeftWhen(.always),
//        .xSpeed(2, everyFrame: 1),
//
//        //
//        .reverseDirection(.onLedge),
//        .reverseDirection(.wasBumped(.left)),
//        .reverseDirection(.wasBumped(.right)),
//
//        .deathId(1),
//        .killObject(.left, when: .thisBumped(.left), id: [0]),
//        .killObject(.right, when: .thisBumped(.right), id: [0]),
//    ]
//}
//
//// Rule for Specific Enemies
//class FireBall: MovableSprite, Spriteable {
//
//    var specificActions: [When] = [
//        .fallWhen(.notOnGround),
//
//        // Order matters here
//        .resetJumpsWhen(.wasBumped(.down)),
//        .jumpWhen(.wasBumped(.down)),
//
//        .moveLeftWhen(.always),
//        .jumpHeight(triangleOf: 5),
//        .xSpeed(8, everyFrame: 1),
//
//        .die(.wasBumped(.up)),
//        .die(.wasBumped(.left)),
//        .die(.wasBumped(.right)),
//        .die(.afterJumpingNTimes(20)),
//        .die(.onceOffScreen),
//        .doThisWhen({ ($0.creator as? Inky)?.fireBallsActive -= 1 }, when: .died),
//
//        .killObject(.left, when: .thisBumped(.left), id: [1]),
//        .killObject(.right, when: .thisBumped(.right), id: [1]),
//        .die(.afterKilledObjects(1)),
//
//    ]
//}
//
//protocol Trampoline {
//    var bounciness: Int { get set }
//}
//
////class Trampoline: BasicSprite, Spriteable {
////
////    var bounciness: Int = 0
////
////    var specificActions: [When] {[
////        .bounceObjectWhen(.thisBumped(.up)),
////
////        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
////        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
////        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
////    ]}
////
////}
//
//
//
//
//
//
//

class DeadMario: MovableSprite, WhenActions2, SKActionable {
    static var starterImage: Images = .deadMario
    static var starterSize: (Int, Int) = (16,16)
    
    func whenActions() -> [Whens] {[
        // Die when off screen
        .when(.firstTimeOnScreen, doThis: {
            self.skNode.zPosition = .infinity
            self.runAction(0, append: [
                .run {
                    self.die(killedBy: self)
                }
            ])
            BackgroundMusic.stop()
            self.run(.sound(.die))
        }),
        .setters([
            .contactDirections([])
        ])
    ]}
    
    var myActions: [SKAction] = [
        .sequence([
            .wait(forDuration: 1),
            .easeType(curve: .sine, easeType: .out, .moveBy(x: 0, y: 16*4, duration: 0.5)),
            .easeType(curve: .sine, easeType: .in, .moveTo(y: -100, duration: 1)),
        ])
    ]
    
    var actionSprite: SKNode = SKSpriteNode()
}


