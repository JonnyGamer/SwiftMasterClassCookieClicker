//
//  GameScene.swift
//  GameJamTicTacToe
//
//  Created by Jonathan Pappas on 4/28/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = NSColor.init(red: 1, green: 0.988, blue: 0.905, alpha: 1)
        for _ in 1...50 {
            superSquareMe()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // djdwkjdqw
    }
    
    override func didFinishUpdate() {
        
    }
    
    func superSquareMe() {
        let randomNumber = Int.random(in: 1...5)
        let square = SKSpriteNode.init(color: NSColor.init(red: 0.9, green: 0.888, blue: 0.805, alpha: 1), size: CGSize(width: randomNumber * 50, height: randomNumber * 50))
        square.zRotation = CGFloat.random(in: 0...(.pi))
        square.position.x = CGFloat.random(in: 0...1000)
        square.position.y = CGFloat.random(in: 0...1000)
        
        let massiveRotate = SKAction.rotate(byAngle: .pi, duration: 1)
        square.run(.repeatForever(massiveRotate))
        
        let brilliantMove = SKAction.moveBy(x: 0, y: CGFloat(randomNumber) * 10, duration: 0.5)
        brilliantMove.timingMode = .easeInEaseOut
        square.run(.repeatForever(.sequence([brilliantMove, brilliantMove.reversed()])))
        
        addChild(square)
    }
    
    override func mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self)
        print(loc.x, loc.y)
    }
    
}
