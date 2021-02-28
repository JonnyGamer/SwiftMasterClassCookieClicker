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
    
    
    var scoreLabel = SKLabelNode.flappyFont()
    var score = 0
    var isAlive = false
    var press = SKSpriteNode()
    var highscoreLabel = SKLabelNode.flappyFont()
    
    var pipeSpeed: Double {
        return [10.0, 5, 20, 10][GameManager.getDifficulty()]
    }
    
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
        
        createBackgrounds()
        createGrounds()
        createBird()
        createInstrctions()
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
        
        for bg in backgroundObjects {
            bg.run(.moveGroundAction(bg.size.width, duration: pipeSpeed * 2), withKey: "Move")
        }
        for ground in groundObjects {
            ground.run(.moveGroundAction(ground.size.width, duration: pipeSpeed), withKey: "Move")
        }
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
        press.anchorPoint.y = 1
        press.position.x = bird.position.x
        press.position.y = bird.frame.minY - 20
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
    
    
    var backgroundObjects: [SKSpriteNode] = []
    func createBackgrounds() {
        let bgTime = GameManager.backgroundImageName()
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: bgTime)
            bg.name = "BG"
            bg.zPosition = -2
            bg.position.x = CGFloat(i) * bg.size.width
            addChild(bg)
            backgroundObjects.append(bg)
        }
    }
    
    var groundObjects: [SKSpriteNode] = []
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
            addChild(ground)
            groundObjects.append(ground)
        }
    }
    
    func createPipes() {
        
        var pipeDistance: CGFloat = 0
        if GameManager.birdIsNormal() {
            pipeDistance = -100
        } else if GameManager.birdIsMega() {
            pipeDistance = -125
        } else {
            pipeDistance = -55
        }
        if GameManager.getDifficulty() == 3 {
            pipeDistance += 15
        }
        
        // Invisible Score Node!
        let scoreNode = SKSpriteNode()
        scoreNode.name = "Score"
        scoreNode.position = CGPoint(x: 0, y: 0)
        scoreNode.size = CGSize(width: 5, height: 300)
        scoreNode.hardObject()
        scoreNode.physicsBody?.categoryBitMask = ColliderType.Score
        scoreNode.physicsBody?.collisionBitMask = 0
    
        
        func makeDoublePipe(_ pipeHolderParent: SKNode) {
            let pipeNum = GameManager.pipeImageName()
            let pipe1 = SKSpriteNode(imageNamed: "Pipe \(pipeNum)")
            let pipe2 = SKSpriteNode(imageNamed: "Pipe \(pipeNum)")
            
            let differentPipes: [(pipe: SKSpriteNode, y: CGFloat, rotation: CGFloat)] = [(pipe1, 630 - pipeDistance, .pi), (pipe2, -630 + pipeDistance, 0)]
            for i in differentPipes {
                i.pipe.name = "Pipe"
                i.pipe.position.y = i.y
                i.pipe.setScale(0.8)
                i.pipe.hardObject()
                i.pipe.physicsBody?.categoryBitMask = ColliderType.Pipes
                i.pipe.zRotation = i.rotation
                pipeHolderParent.addChild(i.pipe)
            }
        }
        
        let pipeYPosition = CGFloat.random(-300...300)
        
        func makePipeHolder(reverseMode: Bool = false) -> SKNode {
            let pipeHolder = SKNode()
            let t: CGFloat = reverseMode ? -1 : 1
            
            pipeHolder.position.x = (t * self.frame.width) + (t * 100)
            pipeHolder.position.y = pipeYPosition
            addChild(pipeHolder)
            makeDoublePipe(pipeHolder)
            
            let move = SKAction.moveTo(x: -t * self.frame.width * 2, duration: pipeSpeed)
            pipeHolder.run(SKAction.sequence([move, .removeFromParent()]), withKey: "Move")
            
            return pipeHolder
        }
        
        let pipeHolder = makePipeHolder()
        pipeHolder.addChild(scoreNode)
        
        if GameManager.night {
            _ = makePipeHolder(reverseMode: true)
        }
        
    }
    
    func spawnObsticles() {
        let spawnDistance = [2, 1, 2, 1.5][GameManager.getDifficulty()]
        let delay = SKAction.wait(forDuration: spawnDistance)
        
        let spawn = SKAction.run { self.createPipes() }
        
        let sequence = SKAction.sequence([spawn, delay])
        run(.repeatForever(sequence), withKey: "Spawn")
    }
    
    func createLabel() {
        scoreLabel.zPosition = 1
        scoreLabel.position.y = 450
        scoreLabel.fontSize = 120
        scoreLabel.text = "0"
        addChild(scoreLabel)
        
        highscoreLabel.zPosition = 1
        highscoreLabel.position.y = 400
        highscoreLabel.fontSize = 40
        highscoreLabel.text = String(GameManager.getHighscore())
        addChild(highscoreLabel)
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    let retry = SKSpriteNode(imageNamed: "Retry")
    let quit = SKSpriteNode(imageNamed: "Quit")
    func birdDied() {
        bird.died()
        isAlive = false
        
        removeAction(forKey: "Spawn")
        for child in children {
            child.removeAction(forKey: "Move")
        }
        
        if GameManager.newHighscore(score) {
            let niceGoing = SKLabelNode.flappyFont()
            niceGoing.zPosition = 1
            niceGoing.fontSize = 90
            if !GameManager.night {
                niceGoing.fontColor = .black
            }
            niceGoing.text = "New Highscore!"
            addChild(niceGoing)
        }
        
        gameOverButton(retry, "Retry", -100)
        gameOverButton(quit, "Quit", -250)
    }
    
    func gameOverButton(_ node: SKNode,_ nodeName: String,_ y: CGFloat) {
        node.name = nodeName
        node.position.y = y
        node.zPosition = 2
        node.setScale(0)
        addChild(node)
        
        let scaleUp = SKAction.scale(to: 0.7, duration: TimeInterval(0.5))
        node.run(scaleUp)
    }
    
    let bounce = SKSpriteNode(imageNamed: "Button")
    func createBounce() {
        bounce.name = "Bounce"
        bounce.position = CGPoint(x: 250, y: -500)
        bounce.zPosition = 2
        bounce.setScale(0.5)
        addChild(bounce)
    }
    
}






