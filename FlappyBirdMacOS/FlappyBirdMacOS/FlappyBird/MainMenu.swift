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
    func createButtons() {
        play.position.y = -50
        play.setScale(0.7)
        addChild(play)
    }
    
    // Bird Character!
    let bird = SKSpriteNode()
    func createBirdButton() {
        bird.position = CGPoint(x: 0, y: 200)
        bird.setScale(1.3)
        GameManager.birdIsTiny() ? bird.setScale(0.6) : ()
        GameManager.birdIsMega() ? bird.setScale(0.8) : ()
        addChild(bird)
        
        // Bird Animation
        let birdAnim: [SKTexture] = (1...3).map {
            SKTexture(imageNamed: GameManager.getBird() + " \($0)")
        }
        let animateBird = SKAction.animate(with: birdAnim, timePerFrame: 0.1, resize: true, restore: true)
        bird.run(.repeatForever(animateBird))
        
        // Invisi Action
        let invisiActionKey = "InvisiSequence"
        if GameManager.invisi {
            let invisiSequence = SKAction.sequence([.birdFadeOut, .waitForOneSecond, .birdFadeIn])
            bird.run(.repeatForever(invisiSequence), withKey: invisiActionKey)
        } else {
            bird.removeAction(forKey: invisiActionKey)
            bird.alpha = 1
        }
    }
    
    func createLabel() {
        // Highscore Label
        let scoreLabel = SKLabelNode.flappyFont()
        scoreLabel.fontSize = 120
        scoreLabel.position.y = -400
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
