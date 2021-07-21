//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import SpriteKit
import GameplayKit


extension CGPoint {
    static var midScreen: Self { .init(x: 500, y: 500) }
}
extension CGSize {
    static var hundred: Self { .init(width: 100, height: 100) }
}

class GameScene: SKScene {
        
    var h: HStack!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .white
        
        let node1 = SKSpriteNode(color: .gray, size: .hundred)
        let node2 = SKSpriteNode(color: .gray, size: .hundred)
        node2.setScale(0.5)
        let node3 = SKSpriteNode(color: .gray, size: .hundred)
        node3.setScale(0.5)
        let node4 = SKSpriteNode(color: .gray, size: .hundred)
        
        h = HStack(nodes: [node1, node2, node3, node4])
        addChild(h)
        keepInsideScene(h)
        h.centerOn(self)
        //h.centerAt(point: .midScreen)
    }
    

    func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }

    override func mouseDown(with event: NSEvent) {
        let foo: [SKSpriteNode] = (1...h.children.count).map { _ in SKSpriteNode(color: .gray, size: .hundred) }
        h.append(node: VStack.init(nodes: foo))
        //h.append(node: h.copied)
        //h.append(nodes: h.copiedChildren)
        keepInsideScene(h)
        h.centerOn(self)
        //h.centerAt(point: .midScreen)
        //center(h)
    }
    
}



extension SKNode {
    var copied: SKNode {
        return self.copy() as! SKNode
    }
    var copiedChildren: [SKNode] {
        return self.children.map { $0.copied }
    }
    
    func centerOn(_ node: SKScene) {
        let whereThis: CGPoint = .init(x: node.size.width/2, y: node.size.height/2)
        position = whereThis
        let newWhereThis = calculateAccumulatedFrame()
        position.x += whereThis.x - newWhereThis.midX
        position.y += whereThis.y - newWhereThis.midY
    }
    func centerOn(_ node: SKNode) {
        let whereThis = node.calculateAccumulatedFrame()
        position = .init(x: whereThis.midX, y: whereThis.midY)
        let newWhereThis = calculateAccumulatedFrame()
        position.x += whereThis.midX - newWhereThis.midX
        position.y += whereThis.midY - newWhereThis.midY
    }
    func centerAt(point: CGPoint) {
        position = point
        let whereThis = calculateAccumulatedFrame()
        position.x += point.x - whereThis.midX
        position.y += point.y - whereThis.midY
    }
}



