//
//  GameScene.swift
//  AmazingFlappyBirdWithBenjamin
//
//  Created by Jonathan Pappas on 5/19/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let bg = SKSpriteNode(imageNamed: "BG Day")
    let play = SKSpriteNode(imageNamed: "Play")
    let logo = SKSpriteNode(imageNamed: "flappy")
    let bird = SKSpriteNode(imageNamed: "Bird1")
    
    override func didMove(to view: SKView) {
        addChild(bg)
        addChild(play)
        
        addChild(logo)
        logo.position.y = 500
        logo.setScale(2)
        logo.texture?.filteringMode = .nearest
        
        addChild(bird)
        bird.position.y = 250
        
        let textureNames = ["Bird1", "Bird2", "Bird3"].map { SKTexture(imageNamed: $0) }
        let animation = SKAction.animate(with: textureNames, timePerFrame: 0.1)
        bird.run(.repeatForever(animation))
        
        let move = SKAction.moveBy(x: 0, y: 100, duration: 1.0)
        bird.run(.repeatForever(.sequence([move, move.reversed()])))
        
        let ground = SKSpriteNode(imageNamed: "Ground")
        addChild(ground)
        ground.position.y = (-frame.height/2) + (ground.frame.height/2)
        
        let moveGround = SKAction.moveBy(x: -ground.frame.width, y: 0, duration: 2.0)
        let moveBack = SKAction.moveBy(x: ground.frame.width, y: 0, duration: 0.0)
        let superGround = SKAction.repeatForever(.sequence([moveGround, moveBack]))
        ground.run(superGround)
        
        let moreGround = ground.copy() as! SKSpriteNode
        addChild(moreGround)
        moreGround.position.x = ground.frame.width
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if nodesFound.contains(play) {
            print("Play the game!")
            let newScene = PlayScene(size: size)
            newScene.scaleMode = .aspectFit
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(newScene)
        }
        
    }
    
    
}
