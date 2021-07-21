//
//  PlayScene.swift
//  AmazingFlappyBirdWithBenjamin
//
//  Created by Jonathan Pappas on 5/19/21.
//

import Foundation
import SpriteKit

var highscore: Int {
    get { UserDefaults.standard.integer(forKey: "Highscore") }
    set(newValue) { UserDefaults.standard.setValue(newValue, forKey: "Highscore") }
}

class PlayScene : SKScene, SKPhysicsContactDelegate {
    
    let bg = SKSpriteNode(imageNamed: "BG Day")
    let bird = SKSpriteNode(imageNamed: "Bird1")
    var movingObjects: Set<SKNode> = []
    
    var score = 0 {
        didSet {
            scoreNode.text = String(score)
        }
    }
    var scoreNode = SKLabelNode(text: "0")
    var highscoreNode = SKLabelNode(text: String(highscore))
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        addChild(bg)
        
        addChild(scoreNode)
        scoreNode.fontColor = .white
        scoreNode.fontSize = 70
        scoreNode.position.y = 450
        scoreNode.zPosition = 1
        scoreNode.fontName = "Arial Black"
        
        addChild(highscoreNode)
        highscoreNode.fontColor = .white
        highscoreNode.position.y = 400
        highscoreNode.zPosition = 1
        highscoreNode.fontName = "Arial Black"
        
        
        addChild(bird)
        bird.position.y = 250
        bird.zPosition = 0.5
        
        let textureNames = ["Bird1", "Bird2", "Bird3"].map { SKTexture(imageNamed: $0) }
        let animation = SKAction.animate(with: textureNames, timePerFrame: 0.1)
        bird.run(.repeatForever(animation))
        
        let ground = SKSpriteNode(imageNamed: "Ground")
        addChild(ground)
        ground.position.y = (-frame.height/2) + (ground.frame.height/2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.contactTestBitMask = .max
        ground.zPosition = 1
        
        let moveGround = SKAction.moveBy(x: -ground.frame.width, y: 0, duration: 2.0)
        let moveBack = SKAction.moveBy(x: ground.frame.width, y: 0, duration: 0.0)
        let superGround = SKAction.repeatForever(.sequence([moveGround, moveBack]))
        ground.run(superGround)
        bg.run(superGround)
        bg.speed = 0.2
        
        let moreGround = ground.copy() as! SKSpriteNode
        addChild(moreGround)
        moreGround.position.x = ground.frame.width
        
        let moreBG = bg.copy() as! SKSpriteNode
        addChild(moreBG)
        moreBG.position.x = bg.frame.width
        moreBG.zPosition = -1
        
        movingObjects = [ground, moreGround, bg, moreBG]
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if gameover {
            let newScene = PlayScene(size: size)
            newScene.scaleMode = .aspectFit
            newScene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view?.presentScene(newScene)
            return
        }
        
        if bird.physicsBody == nil {
            bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.frame.height/2)
            bird.physicsBody?.contactTestBitMask = .max
            
            let gameAction = SKAction.run {
                self.createPipes()
            }
            let waitAction = SKAction.wait(forDuration: 1.0)
            
            let sequence = SKAction.sequence([gameAction, waitAction])
            let repeatForever = SKAction.repeatForever(sequence)
            self.run(repeatForever)
        }
        
        bird.physicsBody?.velocity.dy = 600
        birdAlive = true
    }
    
    func createPipes() {
        let pipeContainer = SKNode()
        addChild(pipeContainer)
        
        let pipe = SKSpriteNode(imageNamed: "Pipe 1")
        pipeContainer.addChild(pipe)
        pipe.position.y = pipe.size.height / -2
        
        pipe.physicsBody = SKPhysicsBody.init(rectangleOf: pipe.size)
        pipe.physicsBody?.affectedByGravity = false
        pipe.physicsBody?.isDynamic = false
        pipe.physicsBody?.contactTestBitMask = .max
        
        let pipe2 = pipe.copy() as! SKSpriteNode
        pipe2.yScale = -1
        pipeContainer.addChild(pipe2)
        pipe2.position.y += pipe2.size.height
        
        pipe.position.y -= 150
        pipe2.position.y += 150
        
        movingObjects.insert(pipeContainer)
        
        pipeContainer.position.y += CGFloat.random(in: -200...300)
        
        pipeContainer.position.x = size.width
        pipeContainer.run(.moveTo(x: -size.width, duration: 4.0)) {
            self.movingObjects.remove(pipeContainer)
            pipeContainer.removeFromParent()
        }
        pipeContainer.run(.wait(forDuration: 2.0)) {
            self.score += 1
        }
        
        
    }
    
    
    var birdAlive = false
    var gameover = false
    
    override func update(_ currentTime: TimeInterval) {
        if !birdAlive { return }
        
        let one = bird.physicsBody!.velocity.dy
        let two = CGFloat(one < 0.4 ? 0.003 : 0.001)
        let birdRotation = one * two
        
        let toAngle = min(max(-1.57, birdRotation), 0.6)
        let rotateAction: SKAction = .rotate(toAngle: toAngle, duration: 0.08)
        bird.run(rotateAction)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Collision has Occured!")
        
        bird.physicsBody = nil
        birdAlive = false
        gameover = true
        self.removeAllActions()
        highscore = max(score, highscore)
        
        for object in movingObjects {
            object.removeAllActions()
        }
        
    }
    
    
}



// [*] Stop all actions when bird hits something

// Add pipes
// Add score counter
// Save highscores

// Game Over Screen
// don't keep jumping when bird hits the ground
// bird flaps a little faster when nose diving
