//
//  GameScene.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 7/31/21.
//

//import SpriteKit
import GameplayKit
import Magic



class GameScene: SKScene {
    override func didMove(to view: SKView) {
        
        do {
            var playerNodes: [SKNode] = []
            
            for i in 1...4 {
                let n1 = SKSpriteNode.init(color: .white, size: .hundred)
                let textBar = SKLabelNode.init(text: "\(i)")
                textBar.fontColor = .black
                textBar.fontSize = 70
                textBar.keepInside(n1.size.halved)
                textBar.centerOn(n1)
                n1.addChild(textBar)
                playerNodes.append(n1.padding)
                n1.name = "\(i)"
            }
            
            let playerSelect = HStack.init(nodes: playerNodes)
            addChild(playerSelect)
            playerSelect.centerAt(point: .midScreen)
        }
        
    }
    
    #if os(macOS) 
    override func mouseDown(with event: NSEvent) {
        if let num = nodes(at: event.location(in: self)).first(where: { Int($0.name ?? "") != nil }),
           let n = Int(num.name ?? "") {
            EverMazeSceneHost.screens = n
            view?.presentScene(EverMazeSceneHost.init(from: true))
        }
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let num = nodes(at: touches.first?.location(in: self) ?? .zero).first(where: { Int($0.name ?? "") != nil }),
           let n = Int(num.name ?? "") {
            EverMazeSceneHost.screens = n
            view?.presentScene(EverMazeSceneHost.init(from: true))
        }
    }
    #endif
    
}
//class GameScene: SKScene, SKPhysicsContactDelegate {
//
//    override func didMove(to view: SKView) {
//        physicsWorld.contactDelegate = self
//
//        let ballRadius: CGFloat = 20
//        let redBall = SKShapeNode(circleOfRadius: ballRadius)
//        redBall.fillColor = .red
//        redBall.position = CGPoint(x: 280, y: 320)
//        redBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
//
//        let blueBall = SKShapeNode(circleOfRadius: ballRadius)
//        blueBall.fillColor = .blue
//        blueBall.position = CGPoint(x: 360, y: 320)
//        blueBall.physicsBody = SKPhysicsBody(circleOfRadius: ballRadius)
//
//        var splinePoints = [CGPoint(x: 0, y: 300),
//                            CGPoint(x: 100, y: 50),
//                            CGPoint(x: 400, y: 110),
//                            CGPoint(x: 640, y: 20),
//                            CGPoint(x: 800, y: 300),
//                            CGPoint(x: 900, y: 300),
//                            CGPoint(x: 1000, y: 300),
//                            CGPoint(x: 1000, y: 800),
//                            CGPoint(x: 0, y: 800),
//                            CGPoint(x: 0, y: 299),
//                            CGPoint(x: 0, y: 300)]
//
//        // points
//        // splinePoints
//        let ground = SKShapeNode(points: &splinePoints,
//                                 count: splinePoints.count)
//        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
//        ground.physicsBody?.restitution = 0.75
//        ground.physicsBody?.usesPreciseCollisionDetection = true
//
//        redBall.physicsBody?.resetMasks()
//        redBall.physicsBody?.collisionBitMask = 0b101
//        redBall.physicsBody?.categoryBitMask = 0b100
//        redBall.physicsBody?.restitution = 1.1
//        redBall.physicsBody?.usesPreciseCollisionDetection = true
//
//        //addChild(redBall)
//        //addChild(redBall.copy() as! SKNode)
//        //redBall.position.y += 200
//
//        let foo = HStack(nodes: [redBall, redBall.copied.padding, redBall.copied.padding, redBall.copied.padding, redBall.copied.padding, redBall.copied.padding, redBall.copied.padding, redBall.copied.padding])
//
//
//        foo.position = .init(x: 300, y: 300)
//        addChild(foo)
//
//        blueBall.physicsBody?.resetMasks()
//        blueBall.physicsBody?.collisionBitMask = 0b0011
//        blueBall.physicsBody?.categoryBitMask = 0b0010
//        blueBall.physicsBody?.restitution = 1.1
//        blueBall.physicsBody?.usesPreciseCollisionDetection = true
//        addChild(blueBall)
//        addChild(blueBall.copy() as! SKNode)
//        blueBall.position.y += 200
//
//        ground.physicsBody?.resetMasks()
//        ground.physicsBody?.categoryBitMask = 0b0001
//
//        addChild(ground)
//    }
//
//    func didBegin(_ contact: SKPhysicsContact) {
//        print("Contact")
//    }
//    func didEnd(_ contact: SKPhysicsContact) {
//        print(".")
//    }
//
//}
//
//
//extension SKPhysicsBody {
//    func resetMasks() {
//        contactTestBitMask = 0
//        collisionBitMask = 0
//        categoryBitMask = 0
//    }
//}
