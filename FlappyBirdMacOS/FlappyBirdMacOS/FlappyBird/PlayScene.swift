//
//  PlayScene.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation
import SpriteKit


class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = Bird(imageNamed: "\(GameManager.getBird()) 1")
    
    var pipesHolder = SKNode()
    var darkPipesHolder = SKNode()
    var scoreLabel = SKLabelNode.flappyFont()
    var score = 0
    var isAlive = false
    var press = SKSpriteNode()
    var highscoreLabel = SKLabelNode.flappyFont()
    var niceGoing = SKLabelNode.flappyFont()
    
    override func didMove(to view: SKView) {
        reset()
    }
    func reset() {
        self.removeAllActions()
        self.removeAllChildren()
        initialize()
    }
    func initialize() {
        gameStarted = false
        isAlive = false
        score = 0
        physicsWorld.contactDelegate = self
        
        createInstrctions()
        createBackgrounds()
        createGrounds()
        createBird()
        createLabel()
        createBounce()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if GameManager.birdIndex < 2*(GameManager.birds.count/3) {
            bird.zRotation = ((bird.physicsBody?.velocity.dy)! / 2000) * 1.5
        }
    }

    func beginGame() {
        isAlive = true
        gameStarted = true
        press.removeFromParent()
        
        bird.flap()
        spawnObsticles()
    }
    
    var gameStarted = false
    override func mouseDown(with event: NSEvent) {
        if !gameStarted {
            beginGame()
        }
        if isAlive {
            bird.flap()
        }
        
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if nodesFound.contains(retry) {
            presentScene(.play)
        } else if nodesFound.contains(quit) {
            presentScene(.mainMenu)
        } else if nodesFound.contains(bounce) {
            if isAlive {
                bird.superFlap()
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contacts = [contact.bodyA.node, contact.bodyB.node].compactMap { $0 }
        
        let hitObstacle = contacts.contains(where: { ["Pipe", "Ground"].contains($0.name) })
        let hitScore = contacts.first(where: { ["Score"].contains($0.name) })
        
        if contacts.contains(bird) {
            if hitObstacle, isAlive {
                birdDied()
            } else if let scoreNode = hitScore {
                incrementScore()
                scoreNode.removeFromParent()
            }
        }
    }
    
    
    func createInstrctions() {
        press = SKSpriteNode(imageNamed: "Press")
        press.position = CGPoint(x: 0, y: 0)
        press.setScale(1.8)
        addChild(press)
    }
    
    func createBird() {
        if !GameManager.night {
            bird.position.x = -50
        }
        addChild(bird)
        bird.initialize()
        
        GameManager.birdIsTiny() ? bird.setScale(0.6) : ()
        GameManager.birdIsMega() ? bird.setScale(0.8) : ()
    }
    
    
    func createBackgrounds() {
        let bgTime = GameManager.backgroundImageName()
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: bgTime)
            bg.name = "BG"
            bg.zPosition = -2
            bg.position.x = CGFloat(i) * bg.size.width
            addChild(bg)
            
            bg.run(.moveBackGroundAction(bg.size.width))
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            ground.physicsBody?.restitution = 0
            ground.zPosition = -1
            self.addChild(ground)
            
            ground.run(.moveGroundAction(ground.size.width))
        }
    }
    
    func createPipes() {
        
        let pipeNum = GameManager.pipeImageName()
        
        var pipeDistance = Int()
        if GameManager.birdIndex < (GameManager.birds.count/3) {
            pipeDistance = -100
        } else if GameManager.birdIndex > (2*(GameManager.birds.count/3)) - 1  {
            pipeDistance = -125
        } else {
            pipeDistance = -55
        }
        
        if GameManager.getDifficulty() == 3 {
            pipeDistance += 15
        }
        
        pipesHolder = SKNode()
        darkPipesHolder = SKNode()
        pipesHolder.name = "Holder"
        darkPipesHolder.name = "Dark Holder"
        
        let pipeUp = SKSpriteNode(imageNamed: "Pipe \(pipeNum)")
        let pipeDown = SKSpriteNode(imageNamed: "Pipe \(pipeNum)")
        let darkPipeUp = SKSpriteNode(imageNamed: "Pipe \(pipeNum)")
        let darkPipeDown = SKSpriteNode(imageNamed: "Pipe \(pipeNum)")
        let scoreNode = SKSpriteNode()
        // scoreNode.color = SKColor.red
        
        scoreNode.name = "Score"
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
    
        
        pipeUp.name = "Pipe"
        pipeUp.position = CGPoint(x: 0, y: 630 - pipeDistance)
        pipeUp.setScale(0.8)
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.affectedByGravity = false
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeUp.zRotation = CGFloat(Double.pi)
        pipeUp.physicsBody?.restitution = 0

        
        
        pipeDown.name = "Pipe"
        pipeDown.position = CGPoint(x: 0, y: -630 + pipeDistance)
        pipeDown.setScale(0.8)
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.affectedByGravity = false
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeDown.physicsBody?.restitution = 0
        
        pipesHolder.position.x = self.frame.width + 100
        pipesHolder.position.y = .random(-300...300)
        pipesHolder.addChild(pipeUp)
        pipesHolder.addChild(pipeDown)
        pipesHolder.addChild(scoreNode)
        
        if GameManager.night {
            darkPipeUp.name = "Pipe"
            darkPipeUp.position = CGPoint(x: 0, y: 630 - pipeDistance)
            darkPipeUp.setScale(0.8)
            darkPipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
            darkPipeUp.physicsBody?.affectedByGravity = false
            darkPipeUp.physicsBody?.isDynamic = false
            darkPipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes
            darkPipeUp.zRotation = CGFloat(Double.pi )
            darkPipeUp.physicsBody?.restitution = 0

            
            darkPipeDown.name = "Pipe"
            darkPipeDown.position = CGPoint(x: 0, y: -630 + pipeDistance)
            darkPipeDown.setScale(0.8)
            darkPipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
            darkPipeDown.physicsBody?.affectedByGravity = false
            darkPipeDown.physicsBody?.isDynamic = false
            darkPipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes
            darkPipeDown.physicsBody?.restitution = 0
            
            
            darkPipesHolder.position.x = -self.frame.width - 100
            darkPipesHolder.position.y = pipesHolder.position.y
            darkPipesHolder.addChild(darkPipeUp)
            darkPipesHolder.addChild(darkPipeDown)
            self.addChild(darkPipesHolder)
        }
        
        self.addChild(pipesHolder)
        
        var speed: Double = 10
        if GameManager.getDifficulty() == 1 {
            speed = 5
        } else if GameManager.getDifficulty() == 2 {
            speed = 20
        } else if GameManager.getDifficulty() == 3 {
            speed = 10
        }
        
        let destination = self.frame.width * 2
        let move = SKAction.moveTo(x: -destination, duration: TimeInterval(speed))
        let nightMove = SKAction.moveTo(x: destination, duration: TimeInterval(speed))
        let remove = SKAction.removeFromParent()
        
        pipesHolder.run(SKAction.sequence([move, remove]), withKey: "Move")
        
        if GameManager.night {
            darkPipesHolder.run(SKAction.sequence([nightMove, remove]), withKey: "Dark Move")
        }
        
    }
    
    func spawnObsticles() {
        
        var time: Double = 2
        if GameManager.getDifficulty() == 1 {
            time = 1
        } else if GameManager.getDifficulty() == 2 {
            time = 2
        } else if GameManager.getDifficulty() == 3 {
            time = 1.5
        }
        
        let spawn = SKAction.run({ () -> Void in
            self.createPipes()
        })
        
        let delay = SKAction.wait(forDuration: TimeInterval(time))
        let sequence = SKAction.sequence([spawn, delay])
        self.run(SKAction.repeatForever(sequence), withKey: "Spawn")
    }
    
    func createLabel() {
        scoreLabel.zPosition = 6
        scoreLabel.position = CGPoint(x: 0, y: 450)
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        self.addChild(scoreLabel)
        
        highscoreLabel.zPosition = 6
        highscoreLabel.position = CGPoint(x: 0, y: 400)
        highscoreLabel.fontSize = 40
        highscoreLabel.text = String(GameManager.getHighscore())
        self.addChild(highscoreLabel)
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    let retry = SKSpriteNode(imageNamed: "Retry")
    let quit = SKSpriteNode(imageNamed: "Quit")
    func birdDied() {
        
        self.removeAction(forKey: "Spawn")
        
        for child in children {
            if child.name == "Holder" {
                child.removeAction(forKey: "Move")
            }
        }
        
        for child in children {
            if child.name == "Dark Holder" {
                child.removeAction(forKey: "Dark Move")
            }
        }
        
        isAlive = false
        bird.texture = bird.diedTexture
        let highscore = GameManager.getHighscore()
        if highscore < score {
            GameManager.setHighscore(highscore: score, Bird: GameManager.getBird())
            niceGoing.zPosition = 11
            niceGoing.position = CGPoint(x: 0, y: 0)
            niceGoing.fontSize = 90
            if !GameManager.night {
                niceGoing.fontColor = SKColor.black
            }
            niceGoing.text = "New Highscore!"
            self.addChild(niceGoing)
        }
        
        
        retry.name = "Retry"
        retry.position = CGPoint(x: 0, y: -100)
        retry.zPosition = 7
        retry.setScale(0)
        
        quit.name = "Quit"
        quit.position = CGPoint(x: 0, y: -250)
        quit.zPosition = 7
        quit.setScale(0)
        
        let scaleUp = SKAction.scale(to: 0.7, duration: TimeInterval(0.5))
        
        retry.run(scaleUp)
        quit.run(scaleUp)
        
        self.addChild(retry)
        self.addChild(quit)
        
    }
    
    let bounce = SKSpriteNode(imageNamed: "Button")
    func createBounce() {
        bounce.name = "Bounce"
        bounce.position = CGPoint(x: 250, y: -500)
        bounce.zPosition = 10
        bounce.setScale(0.5)
        self.addChild(bounce)
    }
    
}






