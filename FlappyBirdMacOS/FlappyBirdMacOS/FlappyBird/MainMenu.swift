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
        removeAllChildren()
        decorate()
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if nodesFound.contains(play) {
            presentScene(.play)
        
        } else if nodesFound.contains(birdBtn) {
            // Change Difficulty
            scoreLabel.removeFromParent()
            mode.removeFromParent()
            birdBtn.removeFromParent()
            GameManager.incrementIndex()
            createBirdButton()
            createLabel()
            
        } else if nodesFound.contains(invBtn) {
            // Change Invisible Mode? (HARD!)
            GameManager.invisi.toggle()
            scoreLabel.removeFromParent()
            mode.removeFromParent()
            createLabel()
            birdBtn.removeFromParent()
            createBirdButton()
            
        } else if nodesFound.contains(bg) {
            // Change Day/Night?
            bg.removeFromParent()
            GameManager.night.toggle()
            scoreLabel.removeFromParent()
            mode.removeFromParent()
            createBG()
            createLabel()
        }
        
        //if nodesFound.count > 0 {
            //if nodesFound[0].name == "Play" {
                //let gameplay = GameplayScene(size: scene!.size)
                //gameplay.scaleMode = .aspectFit
                //self.view?.presentScene(gameplay, transition: .fade(withDuration: 1))
                
//            } else if nodesFound[0].name == "Bird" {
//                scoreLabel.removeFromParent()
//                mode.removeFromParent()
//                // Change game mode?
//                //GameManager.incrementIndex()
//                birdBtn.removeFromParent()
//                createBirdButton()
//                createLabel()
//            } else if nodesFound[0].name ==  "Invisible" {
//                if GameManager.getInvisi() {
//                    GameManager.setInvisi(invisible: false)
//                } else {
//                    GameManager.setInvisi(invisible: true)
//                }
//                scoreLabel.removeFromParent()
//                mode.removeFromParent()
//                createLabel()
//                birdBtn.removeFromParent()
//                createBirdButton()
//            } else if nodesFound[0].name == "BG" {
//                bg.removeFromParent()
//                if GameManager.getNight() {
//                    GameManager.setNight(Night: false)
//                } else {
//                    GameManager.setNight(Night: true)
//                }
//                scoreLabel.removeFromParent()
//                mode.removeFromParent()
//                createBG()
//                createLabel()
          //  }
        //}
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
        bg.name = "BG"
        bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        addChild(bg)
    }
    
    // Play Button
    let play = SKSpriteNode(imageNamed: "Play")
    func createButtons() {
        play.name = "Play"
        play.position.y = -50
        play.setScale(0.7)
        addChild(play)
    }
    
    // Bird Character!
    let birdBtn = SKSpriteNode()
    func createBirdButton() {
        birdBtn.name = "Bird"
        birdBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        birdBtn.position = CGPoint(x: 0, y: 200)
        birdBtn.setScale(1.3)
        birdBtn.zPosition = 3
        
        var birdAnim = [SKTexture]()
        for i in 1..<4 {
            let name = "\(GameManager.getBird()) \(i)"
            birdAnim.append(SKTexture(imageNamed: name))
            if GameManager.birdIndex > (GameManager.birds.count/3) - 1 && GameManager.birdIndex < 2*(GameManager.birds.count/3)  {
                birdBtn.setScale(0.6)
            } else if GameManager.birdIndex > (2*(GameManager.birds.count/3)) - 1 {
                birdBtn.setScale(0.8)
            }
        }
        
        let animateBird = SKAction.animate(with: birdAnim, timePerFrame: 0.1, resize: true, restore: true)
        birdBtn.run(SKAction.repeatForever(animateBird))
        if GameManager.invisi {
            let invisiAnim = SKAction.fadeOut(withDuration: 0.25)
            let invisiAnim1 = SKAction.fadeOut(withDuration: 1)
            let invisiAnim2 = SKAction.fadeIn(withDuration: 0.25)
            let invisiSequence = SKAction.sequence([invisiAnim, invisiAnim1, invisiAnim2])
            birdBtn.run(SKAction.repeatForever(invisiSequence), withKey: "InvisiSequence")
        } else {
            birdBtn.removeAction(forKey: "InvisiSequence")
            let fixInvisi = SKAction.fadeIn(withDuration: 0)
            birdBtn.run(fixInvisi)
        }
        self.addChild(birdBtn)
    }
    
    // Scope Label
    let scoreLabel = SKLabelNode.flappyFont()
    let mode = SKLabelNode.flappyFont()
    func createLabel() {
        scoreLabel.fontSize = 120
        scoreLabel.zPosition = 3
        scoreLabel.position = CGPoint(x: 0, y: -400)
        scoreLabel.text = String(GameManager.getHighscore(Bird: GameManager.getBird()))
        self.addChild(scoreLabel)
        
        mode.fontSize = 50
        mode.zPosition = 3
        mode.position = CGPoint(x: 0, y: 400)
        var inv = String()
        var nigh = String()
        if GameManager.invisi {
            inv = "Invisible "
        }
        if GameManager.night {
            nigh = " at Night"
        }
        mode.text = "\(inv)\(GameManager.levels[GameManager.birdIndex])\(nigh)"
        self.addChild(mode)
    }
    
    // Later!
    let invBtn = SKSpriteNode(imageNamed: "Invisible")
    func createInvButton() {
        invBtn.name = "Invisible"
        invBtn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        invBtn.position = CGPoint(x: 0, y: 500)
        invBtn.setScale(0.5)
        invBtn.zPosition = 10
        self.addChild(invBtn)
    }
    
    
}
