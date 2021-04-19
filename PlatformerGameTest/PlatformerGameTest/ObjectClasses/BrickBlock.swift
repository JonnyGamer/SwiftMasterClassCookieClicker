//
//  BrickBlock.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/19/21.
//

import Foundation
import SpriteKit

class BrickBox: ActionSprite, SKActionable, WhenActions2 {
    static var starterImage: Images = .brickBlock
    static var starterSize: (Int, Int) = (16, 16)
    
    
    func whenActions() -> [Whens] {[
        .wasBumpedBy(.down, doThis: { $0.willStopMoving(self, .down) }),
        .wasBumpedBy(.left, doThis: { $0.willStopMoving(self, .left) }),
        .wasBumpedBy(.right, doThis: { $0.willStopMoving(self, .right) }),
        .wasBumpedBy(.up, doThis: {
            $0.willStopMoving(self, .up)
            self.run(.sound(.breakBrickBlock))
            
            guard let mario = $0 as? Inky else { return }
            self.runAction(0, append: [
                .run {
                    
                    let a = self.spawnObject(BrickCrash.self, location: (self.midX-4, self.midY-4))
                    a.bounceHeight = 8
                    a.maxJumpSpeed = 3
                    let b = self.spawnObject(BrickCrash.self, location: (self.midX-4, self.midY-4))
                    b.bounceHeight = 8
                    b.maxJumpSpeed = 5
                    let c = self.spawnObject(BrickCrash.self, location: (self.midX-4, self.midY-4))
                    c.reverseMovement = true
                    c.bounceHeight = 8
                    c.maxJumpSpeed = 3
                    let d = self.spawnObject(BrickCrash.self, location: (self.midX-4, self.midY-4))
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
class BrickCrash: MovableSprite, SKActionable, WhenActions2 {
    static var starterImage: Images = .brickCrash1
    static var starterSize: (Int, Int) = (8,8)
    
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


