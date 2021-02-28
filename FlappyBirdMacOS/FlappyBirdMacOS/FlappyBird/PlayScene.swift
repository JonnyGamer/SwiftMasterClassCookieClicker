//
//  PlayScene.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation
import SpriteKit


class PlayScene: SKScene, SKPhysicsContactDelegate {
    
    let flapAction = SKAction.playSoundFileNamed("sounds/sfx_wing.caf", waitForCompletion: false)
    let dieAction = SKAction.playSoundFileNamed("sounds/sfx_die.caf", waitForCompletion: false)
    
    var bird = Bird.Make()
    var score = 0
    var isAlive = false
    var pipeSpeed: Double {
        return [10.0, 5, 20, 10][GameManager.getDifficulty()]
    }
    
    override func didMove(to view: SKView) {
        reset()
    }
    func reset() {
        self.removeAllActions()
        self.removeAllChildren()
        
        gameStarted = false
        isAlive = false
        score = 0
        physicsWorld.contactDelegate = self
        
        createBackgrounds()
        createGrounds()
        createBird()
        createInstrctions()
        createLabel()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Official Bird Rotation
        if isAlive, !GameManager.birdIsMega() {
            let birdRotation = bird.physicsBody!.velocity.dy * (bird.physicsBody!.velocity.dy < 0.4 ? 0.003 : 0.001)
            bird.run(SKAction.rotate(toAngle: min(max(-1.57, birdRotation), 0.6), duration: 0.08))
        }
        
    }

    func beginGame() {
        isAlive = true
        gameStarted = true
        press.removeFromParent()
        getReady.removeFromParent()
        //bird.removeAllActions()
        bird.flap()
        
        spawnObsticles()
        
        for bg in backgroundObjects {
            bg.run(.moveGroundAction(bg.size.width, duration: pipeSpeed * 2), withKey: "Move")
        }
        for ground in groundObjects {
            ground.run(.moveGroundAction(ground.size.width, duration: pipeSpeed / 1.55), withKey: "Move")
        }
    }
    
    func playSound(_ sound: SKAction) {
        DispatchQueue.main.async {
            self.run(sound)
        }
    }
    
    var gameStarted = false
    override func mouseDown(with event: NSEvent) {
        if !gameStarted {
            playSound(flapAction)
            beginGame()
        } else if isAlive {
            playSound(flapAction)
            bird.flap()
        }
        
        let location = event.location(in: self)
        let nodesFound = nodes(at: location)
        
        if nodesFound.contains(retry) {
            presentScene(.play)
        } else if nodesFound.contains(quit) {
            presentScene(.mainMenu)
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let contacts = [contact.bodyA.node, contact.bodyB.node].compactMap { $0 }
        
        let hitObstacle = contacts.contains(where: { ["Pipe", "Ground"].contains($0.name) })
        let hitPipe = contacts.contains(where: { ["Pipe"].contains($0.name) })
        let hitScore = contacts.first(where: { ["Score"].contains($0.name) })
        
        if contacts.contains(bird) {
            if hitObstacle, isAlive {
                if hitPipe {
                    bird.smackedPipe()
                    birdDied()
                } else {
                    bird.die()
                    birdDied()
                }
            } else if let scoreNode = hitScore {
                incrementScore()
                scoreNode.removeFromParent()
            }
        }
    }
    
    var press = SKSpriteNode(imageNamed: "Press")
    var getReady = SKSpriteNode(imageNamed: "get-ready")
    func createInstrctions() {
        press.anchorPoint.y = 1
        press.position = CGPoint(x: bird.position.x, y: bird.frame.minY - 20)
        press.setScale(1.8)
        press.texture?.filteringMode = .nearest
        addChild(press)
        
        getReady.anchorPoint.y = 0
        getReady.position = CGPoint(x: bird.position.x, y: bird.frame.maxY + 20)
        getReady.setScale(1.8)
        getReady.texture?.filteringMode = .nearest
        addChild(getReady)
    }
    
    func createBird() {
        if !GameManager.night {
            bird.position.x = -50
        }
        addChild(bird)
        bird.initialize()
    }
    
    
    var backgroundObjects: [SKSpriteNode] = []
    func createBackgrounds() {
        backgroundObjects.removeAll()
        let bgTime = GameManager.backgroundImageName()
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: bgTime)
            bg.zPosition = -2
            bg.position.x = CGFloat(i) * bg.size.width
            addChild(bg)
            backgroundObjects.append(bg)
        }
    }
    
    var groundObjects: [SKSpriteNode] = []
    func createGrounds() {
        groundObjects.removeAll()
        for i in 0...2 {
            let ground = SKSpriteNode(imageNamed: "Ground")
            ground.name = "Ground"
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: self.frame.size.height / -2)
            ground.hardObject()
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            ground.zPosition = 0.1
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
        //scoreNode.physicsBody?.collisionBitMask = 0
    
        
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
    
    var scoreLabel = SKLabelNode.flappyFont()
    func createLabel() {
        regularLabel(scoreLabel, "0", 450, 120)
        let highscoreLabel = SKLabelNode.flappyFont()
        regularLabel(highscoreLabel, String(GameManager.getHighscore()), 400, 40)
    }
    func regularLabel(_ node: SKLabelNode,_ text: String,_ y: CGFloat,_ fontSize: CGFloat) {
        node.zPosition = 1
        node.position.y = y
        node.fontSize = fontSize
        node.text = text
        addChild(node)
    }
    func incrementScore() {
        score += 1
        scoreLabel.text = String(score)
    }
    
    let gameover = SKSpriteNode(imageNamed: "gameover")
    let retry = SKSpriteNode(imageNamed: "Retry")
    let quit = SKSpriteNode(imageNamed: "Quit")
    func birdDied() {
        playSound(dieAction)
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
        gameOverButton(gameover, "gameover", 100, 3)
    }
    
    func gameOverButton(_ node: SKSpriteNode,_ nodeName: String,_ y: CGFloat,_ scaleTo: CGFloat = 0.7) {
        node.name = nodeName
        node.position.y = y
        node.zPosition = 3
        node.setScale(0)
        node.texture?.filteringMode = .nearest
        addChild(node)
        
        let scaleUp = SKAction.scale(to: scaleTo, duration: 0.25)
        node.run(scaleUp)
    }
    
}






