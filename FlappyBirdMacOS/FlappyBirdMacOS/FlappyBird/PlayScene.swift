//
//  PlayScene.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation
import SpriteKit


class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = Bird()
    
    var pipesHolder = SKNode()
    var darkPipesHolder = SKNode()
    var scoreLabel = SKLabelNode.flappyFont()
    var score = 0
    var isAlive = false
    var press = SKSpriteNode()
    var highscoreLabel = SKLabelNode.flappyFont()
    var niceGoing = SKLabelNode.flappyFont()
    var check = true
    
    override func didMove(to view: SKView) {
        
        // let scene11 = GameplayScene(fileNamed: "GameplayScene")
        // scene11?.physicsWorld.gravity = CGVector(dx: 110.0, dy: -100.0)
        //initialize()
        reset()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isAlive {
            moveBackgroundsAndGrounds()
        }
        if GameManager.birdIndex < 2*(GameManager.birds.count/3) {
            bird.zRotation = ((bird.physicsBody?.velocity.dy)! / 2000) * 1.5
        }
    }
    
    func reset() {
        self.removeAllActions()
        self.removeAllChildren()
        initialize()
    }
    
    var gameStarted = false
    override func mouseDown(with event: NSEvent) {
        if !gameStarted {
            isAlive = true
            gameStarted = true
            press.removeFromParent()
            spawnObsticles()
            bird.physicsBody?.affectedByGravity = true
            bird.physicsBody?.restitution = 0
            bird.flap()
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
            //let mainMenu = MainMenuScene(fileNamed: "MainMenuScene")
            //mainMenu!.scaleMode = .aspectFit
            //self.view?.presentScene(mainMenu!, transition: SKTransition.fade(withDuration: TimeInterval(1)))
        } else if nodesFound.contains(bounce) {
            if isAlive {
                bird.superFlap()
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Bird" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            secondBody = contact.bodyA
            firstBody = contact.bodyB
        }
        
        if firstBody.node?.name == "Bird" && secondBody.node?.name == "Score" {
            if check {
                check = false
                incrementScore()
                secondBody.node?.removeFromParent()
            } else {
                check = true
                if GameManager.birdIndex < 2*(GameManager.birds.count/3) {
                    incrementScore()
                }
            }

        } else if firstBody.node?.name == "Bird" && secondBody.node?.name == "Pipe" {
            if isAlive {
                birdDied()
            }
        } else if firstBody.node?.name == "Bird" && secondBody.node?.name == "Ground" {
            if isAlive {
                birdDied()
            }
        }
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
    
    func createInstrctions() {
        press = SKSpriteNode(imageNamed: "Press")
        press.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        press.position = CGPoint(x: 0, y: 0)
        press.setScale(1.8)
        press.zPosition = 10
        self.addChild(press)
        
    }
    
    func createBird() {
        bird = Bird(imageNamed: "\(GameManager.getBird()) 1")
        if GameManager.night {
            bird.position = CGPoint(x: 0, y: 0)
        } else {
            bird.position = CGPoint(x: -50, y: 0)
        }
        bird.physicsBody?.restitution = 0
        self.addChild(bird)
        bird.initialize()
        
        if GameManager.birdIndex > ((GameManager.birds.count/3) - 1) && GameManager.birdIndex < (2*(GameManager.birds.count/3))  {
            bird.setScale(0.6)
        } else if GameManager.birdIndex < (GameManager.birds.count/3) + 1 {
            bird.setScale(1.0)
        } else if GameManager.birdIndex > (2*(GameManager.birds.count/3)) - 1 {
            bird.setScale(0.8)
        }
        
    }
    
    func createBackgrounds() {
        
        let bgTime = GameManager.backgroundImageName()
        
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: bgTime)
            bg.name = "BG"
            bg.zPosition = 0.1
            bg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            self.addChild(bg)
        }
    }
    
    func createGrounds() {
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.zPosition = 4
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            ground.physicsBody?.restitution = 0
            self.addChild(ground)
        }
    }
    
    func moveBackgroundsAndGrounds() {
        enumerateChildNodes(withName: "BG", using: ({
            (node, Error) in
            node.position.x -= 1
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
        }))
        enumerateChildNodes(withName: "Ground", using: ({
            (node, Error) in
            node.position.x -= 2
            if node.position.x < -(self.frame.width) {
                node.position.x += self.frame.width * 3
            }
        }))
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
        scoreNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: scoreNode.size)
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.isDynamic = false
    
        
        pipeUp.name = "Pipe"
        pipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeUp.position = CGPoint(x: 0, y: 630 - pipeDistance)
        pipeUp.setScale(0.8)
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.affectedByGravity = false
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeUp.zRotation = CGFloat(Double.pi)
        pipeUp.physicsBody?.restitution = 0

        
        
        pipeDown.name = "Pipe"
        pipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        pipeDown.position = CGPoint(x: 0, y: -630 + pipeDistance)
        pipeDown.setScale(0.8)
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.affectedByGravity = false
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes
        pipeDown.physicsBody?.restitution = 0
        
        pipesHolder.zPosition = 5
        pipesHolder.position.x = self.frame.width + 100
        pipesHolder.position.y = .random(-300...300)
        pipesHolder.addChild(pipeUp)
        pipesHolder.addChild(pipeDown)
        pipesHolder.addChild(scoreNode)
        
        if GameManager.night {
            darkPipeUp.name = "Pipe"
            darkPipeUp.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            darkPipeUp.position = CGPoint(x: 0, y: 630 - pipeDistance)
            darkPipeUp.setScale(0.8)
            darkPipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
            darkPipeUp.physicsBody?.affectedByGravity = false
            darkPipeUp.physicsBody?.isDynamic = false
            darkPipeUp.physicsBody?.categoryBitMask = ColliderType.Pipes
            darkPipeUp.zRotation = CGFloat(Double.pi )
            darkPipeUp.physicsBody?.restitution = 0

            
            darkPipeDown.name = "Pipe"
            darkPipeDown.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            darkPipeDown.position = CGPoint(x: 0, y: -630 + pipeDistance)
            darkPipeDown.setScale(0.8)
            darkPipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
            darkPipeDown.physicsBody?.affectedByGravity = false
            darkPipeDown.physicsBody?.isDynamic = false
            darkPipeDown.physicsBody?.categoryBitMask = ColliderType.Pipes
            darkPipeDown.physicsBody?.restitution = 0
            
            
            darkPipesHolder.zPosition = 5
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
        retry.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        retry.position = CGPoint(x: 0, y: -100)
        retry.zPosition = 7
        retry.setScale(0)
        
        quit.name = "Quit"
        quit.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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






