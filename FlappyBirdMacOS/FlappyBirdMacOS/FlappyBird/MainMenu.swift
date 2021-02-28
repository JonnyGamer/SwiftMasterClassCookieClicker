//
//  GameScene.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import SpriteKit
import GameplayKit



class MainMenu: SKScene {
    
    override func didMove(to view: SKView) {
        reset()
    }
    func reset() {
        self.removeAllActions()
        self.removeAllChildren()
        decorate()
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if nodesFound.contains(play) {
            presentScene(.play)
        } else if nodesFound.contains(bird) {
            GameManager.changeDifficulty()
            reset()
        } else if nodesFound.contains(invBtn) {
            GameManager.invisi.toggle()
            reset()
        } else if nodesFound.contains(bg) {
            GameManager.night.toggle()
            reset()
        }
    }
    
    func decorate() {
        createBG()
        createButtons()
        createBirdButton()
        createLabel()
        createInvButton()
    }
    
    // Background
    let bg = SKSpriteNode(imageNamed: GameManager.backgroundImageName())
    func createBG() {
        bg.texture = SKTexture(imageNamed: GameManager.backgroundImageName())
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        addChild(bg)
    }
    
    // Play Button
    let play = SKSpriteNode(imageNamed: "Play")
    let flappyBirdLogo = SKSpriteNode(imageNamed: "flappybird")
    func createButtons() {
        play.position.y = -50
        play.setScale(0.7)
        addChild(play)
        
        flappyBirdLogo.position.y = -400
        addChild(flappyBirdLogo)
    }
    
    // Bird Character!
    let bird = Bird.Make()
    func createBirdButton() {
        bird.initialize(withoutPhysics: true)
        bird.position.y = 200
        addChild(bird)
    }
    
    func createLabel() {
        // Highscore Label
        let scoreLabel = SKLabelNode.flappyFont()
        scoreLabel.fontSize = 120
        scoreLabel.position.y = -550
        scoreLabel.text = String(GameManager.getHighscore())
        addChild(scoreLabel)
        
        // Game Mode Label
        let mode = SKLabelNode.flappyFont()
        mode.fontSize = 50
        mode.position.y = 400
        let inv = GameManager.invisi ? "Invisible " : ""
        let nigh = GameManager.night ? " at Night" : ""
        mode.text = "\(inv)\(GameManager.getLevel())\(nigh)"
        addChild(mode)
    }
    
    let invBtn = SKSpriteNode(imageNamed: "Invisible")
    func createInvButton() {
        invBtn.position = CGPoint(x: 0, y: 500)
        invBtn.setScale(0.5)
        addChild(invBtn)
    }
    
    
}
