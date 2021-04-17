//
//  Platformer.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit


class GROUND: BasicSprite, Spriteable {
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
    
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .collisionOn(.all()),
    ]
}

class Moving_GROUND: ActionSprite, Spriteable, SKActionable {
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
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .runSKAction([(0, .always)]),
        .collisionOn(.all()),
    ]
}



class QuestionBox: ActionSprite, Spriteable, SKActionable {
    var bumped = false
    
    func whenActions() -> [Whens] {[
        .wasBumpedBy(.down, doThis: { $0.willStopMoving(self, .down) }),
        .wasBumpedBy(.left, doThis: { $0.willStopMoving(self, .left) }),
        .wasBumpedBy(.right, doThis: { $0.willStopMoving(self, .right) }),
        .wasBumpedBy(.up, doThis: {
            $0.willStopMoving(self, .up)
            if self.bumped { return }
            self.bumped = true
            self.runAction(0)
        }),
        .when(.always, doThis: {
            if self.bumped { return }
            self.runAction(1)
        })
        
    ]}
    
    var myActions: [SKAction] {[
        .sequence([
            .easeType(curve: .sine, easeType: .out, .moveBy(x: 0, y: 8, duration: 0.1)),
            .killAction(self, 1),
            .setImage(.deadBlock),
            .easeType(curve: .sine, easeType: .inOut, .moveBy(x: 0, y: -8, duration: 0.1)),
        ]),
        .animation([
            (.q2, 0.1333),
            (.q3, 0.1333),
            (.q2, 0.1333),
            (.q1, 0.4),
        ])
    ]}
    var actionSprite: SKNode = SKSpriteNode()
}

class BrickBox: ActionSprite, SKActionable, Spriteable {
    
    
    
    func whenActions() -> [Whens] {[
        .wasBumpedBy(.down, doThis: { $0.willStopMoving(self, .down) }),
        .wasBumpedBy(.left, doThis: { $0.willStopMoving(self, .left) }),
        .wasBumpedBy(.right, doThis: { $0.willStopMoving(self, .right) }),
        .wasBumpedBy(.up, doThis: {
            $0.willStopMoving(self, .up)
            
            guard let mario = $0 as? Inky else { return }
            self.runAction(0, append: [
                .run {
                    
                    let a = self.spawnObject(BrickCrash.self, frame: (8,8), location: (self.midX-4, self.midY-4), image: Images.brickCrash1.rawValue)
                    a.bounceHeight = 8
                    a.maxJumpSpeed = 3
                    let b = self.spawnObject(BrickCrash.self, frame: (8,8), location: (self.midX-4, self.midY-4), image: Images.brickCrash1.rawValue)
                    b.bounceHeight = 8
                    b.maxJumpSpeed = 5
                    let c = self.spawnObject(BrickCrash.self, frame: (8,8), location: (self.midX-4, self.midY-4), image: Images.brickCrash1.rawValue)
                    c.reverseMovement = true
                    c.bounceHeight = 8
                    c.maxJumpSpeed = 3
                    let d = self.spawnObject(BrickCrash.self, frame: (8,8), location: (self.midX-4, self.midY-4), image: Images.brickCrash1.rawValue)
                    d.reverseMovement = true
                    d.bounceHeight = 8
                    d.maxJumpSpeed = 5
                    
                    self.die(nil, [], killedBy: mario)
                    
                }
            ])
            
        }),
    ]}
    
    var actionSprite: SKNode = SKSpriteNode()
    var myActions: [SKAction] = [
        .sequence([
            .easeType(curve: .sine, easeType: .out, .moveBy(x: 0, y: 4, duration: 0.1)),
        ]),
    ]
}
class BrickCrash: MovableSprite, SKActionable, Spriteable {
    func whenActions() -> [Whens] {[
        .when(.always, doThis: { self.move(.left); self.jump() }),
        .when(.notOnGround, doThis: { self.fall() }),
        .when(.offScreen, doThis: { self.die(nil, [], killedBy: self) }),
        .setters([
            .xSpeed(1, everyFrame: 2),
            .maxJump(2),
            .gravity(-1, everyFrame: 3),
            .contactDirections([])
        ])
    ]}
    

    var myActions: [SKAction] = [
        .sequence([
            .setImage(.brickCrash1, 0.2),
            .setImage(.brickCrash2, 0.2),
        ])
    ]

    var actionSprite: SKNode = SKSpriteNode()
}


class Goomba: MovableSprite, SKActionable, Spriteable {
    
    // Squash the Goomba!
    func squash(_ mario: Inky) {
        if !self.squashed {
            self.squashed = true
            self.xSpeed = 0
            mario.jump()
            self.runAction(1, append: [
                .run { _=self.die(nil, [], killedBy: mario) }
            ])
        }
    }
    
    func whenActions() -> [Whens] {[

        // If Goomba Hits Something, reverse it's movement
        .bumped(.left, doThis: { _ in
            self.reverseMovement.toggle()
        }),
        .bumped(.right, doThis: { _ in
            self.reverseMovement.toggle()
        }),
        
        // If Goomba falls on Mario
        .bumped(.down, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(nil, [], killedBy: self) }
        }),
        // If Mario uses Goomba like a ? Box
        .wasBumpedBy(.up, doThis: {
            if let mario = $0 as? Inky { _ = mario.die(killedBy: self) } else {
                print("Pushed up :::)")
            }
        }),
        // If Mario Falls on Goomba
        .wasBumpedBy(.down, doThis: {
            if let mario = $0 as? Inky {
                self.squash(mario)
            }
        }),
        
        
        // If Mario walks into Goomba, he dies
        .wasBumpedBy(.left, doThis: {
            if !self.squashed, let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        .wasBumpedBy(.right, doThis: {
            if !self.squashed, let mario = $0 as? Inky { _ = mario.die(killedBy: self) }
        }),
        
        // Goomba Falls, Unless squashed
        .when(.notOnGround, doThis: {
            if self.squashed { return }
            self.fall()
        }),
        
        // Goomba always moves left
        .when(.always, doThis: {
            if self.squashed { return }
            self.runAction(0)
            self.move(.left)
        }),
        
        // Goomba starts walking once on Screen
        .when(.firstTimeOnScreen, doThis: {
            self.xSpeed = 1
        }),
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
        

//        .moveLeftWhen(.always),
//        .xSpeed(0, everyFrame: 2),
//        .runSKAction([(0, .always)]),
//        .runSKAction([(1, .wasBumped(.up))]),
//
//        .bounceObjectWhen(.thisBumped(.down)),// Bounces mario when he hopes on it ;)
//        //.die(.wasBumped(.up)),
//
//        .fallWhen(.notOnGround),
//        .reverseDirection(.wasBumped(.left)),
//        .reverseDirection(.wasBumped(.right)),
//        .killObject(.left, when: .thisBumped(.left), id: [0]),
//        .killObject(.right, when: .thisBumped(.right), id: [0]),
//        .doThisWhen({ ($0 as? MovableSprite)?.xSpeed = 1 }, when: .firstTimeOnScreen),
//        .gravity(-1, everyFrame: 2),
//        .minFallSpeed(-3),
//        .collisionOn(.all()),
    ]}
    
    var squashed = false
    var bounciness: Int = 5
    var myActions: [SKAction] {[
        .sequence([
            .ifTrue({ self.squashed == false }, {[
                .setImage(.goomba1, 0.15),
                .setImage(.goomba2, 0.15),
            ]})
        ]),
        .sequence([
            .killAction(self, 0),
            .setImage(.goombaFlat, 0.3),
        ])
    ]}

    var actionSprite: SKNode = SKSpriteNode()


}

class DeadMario: MovableSprite, Spriteable, SKActionable {
    func whenActions() -> [Whens] {[
        // Die when off screen
        .when(.firstTimeOnScreen, doThis: {
            self.skNode.zPosition = .infinity
            self.runAction(0, append: [
                .run { self.die(killedBy: self) }
            ])
        }),
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

class Inky: MovableSprite, Spriteable, SKActionable {
    var myActions: [SKAction] = [
        .setImage(.mario),
        .sequence([
            .setImage(.m1, 0.1),
            .setImage(.m2, 0.1),
            .setImage(.m3, 0.1),
        ]),
        .setImage(.marioJump),
    ]
    
    var actionSprite: SKNode = SKSpriteNode()
    
    func whenActions() -> [Whens] {[
        // Reset Jumps
        .bumped(.down, doThis: { _ in self.jumps = 0 }),
        // Jump Button
        .when(.pressedButton(.jump), doThis: { self.jump() }),
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
            self.spawnObject(DeadMario.self, frame: (16,16), location: self.position, image: Images.deadMario.rawValue)
        }),
        
        // Die when off screen
        .when(.offScreen, doThis: {
            if self.position.y < 0 {
                _ = self.die(killedBy: self)
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
