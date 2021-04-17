//
//  Platformer.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit


class GROUND: BasicSprite, Spriteable {
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        .collisionOn(.all()),
    ]
}

class Moving_GROUND: ActionSprite, Spriteable, SKActionable {
    
    
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
    var myActions: [SKAction] {[
        .ifTrue({ self.bumped == false }) {
            [
                .run { self.bumped = true },
                .easeType(curve: .sine, easeType: .out, .moveBy(x: 0, y: 4, duration: 0.1)),
                .killAction(self, 1),
                .setImage(.deadBlock),
                .easeType(curve: .sine, easeType: .inOut, .moveBy(x: 0, y: -4, duration: 0.1)),
            ]
        },
        .sequence([
            .setImage(.q2, 0.1333),
            .setImage(.q3, 0.1333),
            .setImage(.q2, 0.1333),
            .setImage(.q1, 0.4),
        ])
        //.animate([.q1, .q2, .q3, .q2])
    ]}
    var actionSprite: SKNode = SKSpriteNode()
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        
        // ? Box Action
        .runSKAction([(0, .wasBumped(.down))]),
        .runSKAction([(1, .when({ ($0 as? QuestionBox)?.bumped == false }))]),
        .collisionOn(.all()),

        
        // Brick Block Action
        //.die(.thisBumped(.down)),
    ]
}

class BrickBox: ActionSprite, SKActionable, Spriteable {
    var actionSprite: SKNode = SKSpriteNode()
    var myActions: [SKAction] = [
        .sequence([
            .easeType(curve: .sine, easeType: .out, .moveBy(x: 0, y: 4, duration: 0.1)),
            .easeType(curve: .sine, easeType: .inOut, .moveBy(x: 0, y: -4, duration: 0.1)),
        ]),
    ]
    var specificActions: [When] = [
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
        .stopObjectFromMoving(.up, when: .thisBumped(.up)),
        // Brick Block Action
        .die(.wasBumped(.down)),
        .collisionOn(.all()),
        
        .doThisWhen({
            guard let foo = $0 as? BrickBox else { return }
            let a = foo.spawnObject(BrickCrash.self, frame: (8,8), location: ($0.position), image: Images.brickCrash1.rawValue)
            a.bounceHeight = 8
            a.maxJumpSpeed = 3
            let b = foo.spawnObject(BrickCrash.self, frame: (8,8), location: ($0.position), image: Images.brickCrash1.rawValue)
            b.bounceHeight = 8
            b.maxJumpSpeed = 5
            let c = foo.spawnObject(BrickCrash.self, frame: (8,8), location: ($0.position), image: Images.brickCrash1.rawValue)
            c.reverseMovement = true
            c.bounceHeight = 8
            c.maxJumpSpeed = 3
            let d = foo.spawnObject(BrickCrash.self, frame: (8,8), location: ($0.position), image: Images.brickCrash1.rawValue)
            d.reverseMovement = true
            d.bounceHeight = 8
            d.maxJumpSpeed = 5
            
            
        }, when: .died)
    ]
}
class BrickCrash: MovableSprite, SKActionable, Spriteable {
    var myActions: [SKAction] = [
        .sequence([
            .setImage(.brickCrash1, 0.2),
            .setImage(.brickCrash2, 0.2),
        ])
    ]
    
    var actionSprite: SKNode = SKSpriteNode()
    
    var specificActions: [When] = [
        .moveLeftWhen(.always),
        .fallWhen(.notOnGround),
        .die(.onceOffScreen),
        .xSpeed(1, everyFrame: 2),
        
        .maxJump(2),
        .jumpWhen(.firstTimeOnScreen),
//        .maxJumpSpeed(3),
//        .minFallSpeed(-3),
        .gravity(-1, everyFrame: 3),
        
//        .jumpHeight(triangleOf: 1000),
//        .maxJumpSpeed(100),
//        .gravity(-1, everyFrame: 1),
//        .jumpWhen(.firstTimeOnScreen),
        
    ]
}


class Goomba: MovableSprite, SKActionable, Spriteable, Trampoline {
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
            .run { _=self.die(nil, []) }
        ])
    ]}
    
    var actionSprite: SKNode = SKSpriteNode()
    var specificActions: [When] = [
        .moveLeftWhen(.always),
        .xSpeed(0, everyFrame: 2),
        .runSKAction([(0, .always)]),
        //.runSKAction([(100, .wasBumped(.up))]), // Not working
        
        .bounceObjectWhen(.thisBumped(.down)),// Bounces mario when he hopes on it ;)
        
        .fallWhen(.notOnGround),
        .reverseDirection(.wasBumped(.left)),
        .reverseDirection(.wasBumped(.right)),
        .killObject(.left, when: .thisBumped(.left), id: [0]),
        .killObject(.right, when: .thisBumped(.right), id: [0]),
        .doThisWhen({ ($0 as? MovableSprite)?.xSpeed = 1 }, when: .firstTimeOnScreen),
        .gravity(-1, everyFrame: 2),
        .minFallSpeed(-3),
        .collisionOn(.all()),
    ]
    
    
}

class Inky: MovableSprite, Spriteable {
    var fireBallsActive = 0
    
    var specificActions: [When] = [
        
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        .allowObjectToPush(.up, when: .thisBumped(.up)),
        .allowObjectToPush(.right, when: .thisBumped(.right)),
        .allowObjectToPush(.left, when: .thisBumped(.left)),
        
        .moveLeftWhen(.pressedButton(.left)),
        .moveRightWhen(.pressedButton(.right)),
        
        // Jumping
        .jumpWhen(.pressedButton(.jump)),
        .jumpHeight(triangleOf: 12),
        .maxJumpSpeed(3),
        .minFallSpeed(-3),
        .gravity(-1, everyFrame: 3),
        .stopGoingUpWhen(.releasedButton(.jump)),
        .resetJumpsWhen(.wasBumped(.down)),
        //.maxJump(2),
        
        .fallWhen(.notOnGround),
        .collisionOn(.all()),
        
        //
        .canDieFrom(.all()),
        .deathId(0),
        
        .doThisWhen({ ($0 as? MovableSprite)?.skNode.run(.animate(with: [Cash.getTexture(Images.mario.rawValue)], timePerFrame: 0)) }, when: .notOnGround)
        
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
        
    ]
    override var isPlayer: Bool { return true }
}



// Rule for Specific Enemies
class Chaser: MovableSprite, Spriteable {
    
    var specificActions: [When] = [
        
        .fallWhen(.notOnGround),
        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
        
        //
        .moveLeftWhen(.always),
        .xSpeed(2, everyFrame: 1),
        
        // 
        .reverseDirection(.onLedge),
        .reverseDirection(.wasBumped(.left)),
        .reverseDirection(.wasBumped(.right)),
        
        .deathId(1),
        .killObject(.left, when: .thisBumped(.left), id: [0]),
        .killObject(.right, when: .thisBumped(.right), id: [0]),
    ]
}

// Rule for Specific Enemies
class FireBall: MovableSprite, Spriteable {
    
    var specificActions: [When] = [
        .fallWhen(.notOnGround),
        
        // Order matters here
        .resetJumpsWhen(.wasBumped(.down)),
        .jumpWhen(.wasBumped(.down)),
        
        .moveLeftWhen(.always),
        .jumpHeight(triangleOf: 5),
        .xSpeed(8, everyFrame: 1),
        
        .die(.wasBumped(.up)),
        .die(.wasBumped(.left)),
        .die(.wasBumped(.right)),
        .die(.afterJumpingNTimes(20)),
        .die(.onceOffScreen),
        .doThisWhen({ ($0.creator as? Inky)?.fireBallsActive -= 1 }, when: .died),
        
        .killObject(.left, when: .thisBumped(.left), id: [1]),
        .killObject(.right, when: .thisBumped(.right), id: [1]),
        .die(.afterKilledObjects(1)),
        
    ]
}

protocol Trampoline {
    var bounciness: Int { get set }
}

//class Trampoline: BasicSprite, Spriteable {
//
//    var bounciness: Int = 0
//
//    var specificActions: [When] {[
//        .bounceObjectWhen(.thisBumped(.up)),
//
//        .stopObjectFromMoving(.down, when: .thisBumped(.down)),
//        .stopObjectFromMoving(.left, when: .thisBumped(.left)),
//        .stopObjectFromMoving(.right, when: .thisBumped(.right)),
//    ]}
//
//}







