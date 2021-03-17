//
//  GameScene.swift
//  FlamboyantBirds
//
//  Created by Jonathan Pappas on 3/3/21.
//

import SpriteKit
import GameplayKit

class MainMenu: SKScene {
    
    override func didMove(to view: SKView) {
        decorate()
    }
    
    func decorate() {
        
        createBG()
        createBird()
        
    }
    
    
    
    let bg = SKSpriteNode(imageNamed: "BG Day")
    let play = SKSpriteNode(imageNamed: "Play")
    let flappyBirdLogo = SKSpriteNode(imageNamed: "flappybird")
    
    
    func createBG() {
        addChild(bg)
        
        play.position.y = -50
        play.setScale(0.7)
        addChild(play)
        
        flappyBirdLogo.position.y = -400
        addChild(flappyBirdLogo)
        
    }
    
    
    
    let bird = Bird.Make()
    func createBird() {
        bird.position.y = 200
        addChild(bird)
    }
    
    
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if nodesFound.contains(play) {
            let newScene = PlayScene(size: size)
            newScene.scaleMode = .aspectFit
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(newScene, transition: .fade(withDuration: 0.5))
        }
        
        
    }
    
    // Present new Scenes
    // Animations!
    
    // Let's do it, I'm ready to go
    // Let's go, I'm ready to do it
    
    
    
}
