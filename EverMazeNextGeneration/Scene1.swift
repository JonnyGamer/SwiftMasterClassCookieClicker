//
//  Scene1.swift
//  EverMazeNextGeneration
//
//  Created by Jonathan Pappas on 7/22/21.
//

import SpriteKit

class Scene1: SKSceneNode {
    static var inverse: Bool = true
    
    var h: HStack!
    var inversion: Bool = true
    
    override func begin() {
        draggable = false
        
        inversion = Self.inverse
        Self.inverse.toggle()
        
        backgroundColor(.lightGray)
        print("Let's GOOO!")
        
        // physics body test
        let test1 = SKSpriteNode.init(color: .red, size: .hundred)
        test1.physicsBody = SKPhysicsBody.init(rectangleOf: test1.size)
        test1.physicsBody?.affectedByGravity = false
        addChild(test1)
        
        // Add the tree nodes
        let node1 = SKSpriteNode(color: .gray, size: .hundred)
        let node2 = SKSpriteNode(color: .gray, size: .hundred)
        node2.setScale(0.5)
        let node3 = SKSpriteNode(color: .gray, size: .hundred)
        node3.setScale(0.5)
        let node4 = SKSpriteNode(color: .gray, size: .hundred)
        
        h = HStack(nodes: [node1.padding, node2.padding, node3.padding, node4.padding])
        addChild(h)
        h.keepInside(size)
        h.centerAt(point: .zero)
    }
    
    override func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {
        let foo: [SKNode] = (1...h.children.count).map { _ in SKSpriteNode(color: .gray, size: .hundred).padding }
        
        if inversion {
            h.append(node: VStack.init(nodes: foo))
        } else {
            h.prepend(node: VStack.init(nodes: foo))
        }
        
        h.keepInside(size)
        h.centerAt(point: .zero)
        //removeAllChildren()
    }
    
    override func touchesMoved(_ at: CGVector) {
        h.run(.moveBy(x: at.dx, y: at.dy, duration: 0.1))
    }
    
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
//        if release == .zero {
//            scene?.view?.presentScene(GameScene(from: true)) // Scene presentation WORKS!
//        }
        h.run(.smoothMoveBy(release, duration: 0.5))
    }
}
