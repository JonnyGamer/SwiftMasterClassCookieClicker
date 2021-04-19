//
//  QuestionBlock.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/19/21.
//

import Foundation
import SpriteKit

class QuestionBox: ActionSprite, WhenActions2, SKActionable {
    static var starterImage: Images = .brickBlock
    static var starterSize: (Int, Int) = (16, 16)
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
