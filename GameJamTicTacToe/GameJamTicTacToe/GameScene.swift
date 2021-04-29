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
        
        line(10, 900, posx: 333, posy: 500)
        line(10, 900, posx: 667, posy: 500)
        line(900, 10, posx: 500, posy: 333)
        line(900, 10, posx: 500, posy: 667)
    }
    
    
    func line(_ width: Int,_ height: Int, posx: CGFloat, posy: CGFloat) {
        let rectangle = SKSpriteNode.init(color: .black, size: CGSize(width: width, height: height))
        rectangle.position.x = posx
        rectangle.position.y = posy
        addChild(rectangle)
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
    
    override func mouseDown(with event: NSEvent) {
        let loc = event.location(in: self)
        print(loc.x, loc.y)
        
        var xSide = 0
        if loc.x < 333 {
            xSide = 0
        } else if loc.x < 667 {
            xSide = 1
        } else {
            xSide = 2
        }

        var ySide = 0
        if loc.y < 333 {
            ySide = 0
        } else if loc.y < 667 {
            ySide = 1
        } else {
            ySide = 2
        }
        
        if game[ySide][xSide] == 0 {
            
            let circle = SKSpriteNode.init(color: .black, size: CGSize(width: 50, height: 50))
            circle.position.x = CGFloat([333/2, 500, 500 + (333)][xSide])
            circle.position.y = CGFloat([333/2, 500, 500 + (333)][ySide])
            addChild(circle)
            game[ySide][xSide] = 1
            
            var availableSpaces: [(Int, Int)] = []
            for y in 0...2 {
                for x in 0...2 {
                    if game[y][x] == 0 {
                        availableSpaces.append((x, y))
                    }
                }
            }
            
            if !availableSpaces.isEmpty {
                let chosen = availableSpaces.randomElement()!
                
                let circle = SKSpriteNode.init(color: .gray, size: CGSize(width: 50, height: 50))
                circle.position.x = CGFloat([333/2, 500, 500 + (333)][chosen.0])
                circle.position.y = CGFloat([333/2, 500, 500 + (333)][chosen.1])
                addChild(circle)
                game[chosen.1][chosen.0] = 1
            }
            
        }
        
    }
    
    var game: [[Int]] = [
        [0,0,0],
        [0,0,0],
        [0,0,0],
    ]
    
}
