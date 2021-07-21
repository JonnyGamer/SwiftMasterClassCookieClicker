//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit
import GameplayKit

let M_PI_2_f = Float(Double.pi / 2)
let M_PI_f = Float(Double.pi)
public func sinFloat(_ num:Float)->Float {
    return sin(num)
}
public func SineEaseOut(_ p:Float)->Float {
    return sinFloat(p * M_PI_2_f)
}



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
        
        h = HStack(nodes: [node1.padding, node2.padding, node3.padding, node4.padding])
        addChild(h)
        keepInsideScene(h)
        h.centerOn(self)
        //h.centerAt(point: .midScreen)
    }
    

    func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }

    var (previousX, previousY): (CGFloat, CGFloat) = (0, 0)
    override func mouseDragged(with event: NSEvent) {
        h.run(.moveBy(x: event.deltaX, y: -event.deltaY, duration: 0.1))
        (previousX, previousY) = (event.deltaX, event.deltaY)
        //print(event.deltaX)
    }
    override func mouseUp(with event: NSEvent) {
        let uwu = SKAction.moveBy(x: previousX*20, y: -previousY*20, duration: 0.5)
        uwu.timingFunction = SineEaseOut(_:)
        h.run(uwu)
    }
    
    override func mouseDown(with event: NSEvent) {
        (previousX, previousY) = (0,0)
        let foo: [SKNode] = (1...h.children.count).map { _ in SKSpriteNode(color: .gray, size: .hundred).padding }
        h.append(node: VStack.init(nodes: foo))
        //h.append(node: h.copied)
        //h.append(nodes: h.copiedChildren)
        
        keepInsideScene(h)
        h.centerOn(self)
        //h.centerAt(point: .midScreen)
        //center(h)
    }
    
}



extension CGSize {
    func padding(_ with: CGFloat) -> Self {
        return .init(width: self.width + with, height: self.height + with)
    }
}

extension SKNode {
    var padding: SKNode {
        let oldScale = (self.xScale, self.yScale)
        setScale(1)
        let newNode = SKSpriteNode.init(color: .white, size: self.calculateAccumulatedFrame().size.padding(20))
        addChild(newNode)
        (xScale, yScale) = oldScale
        newNode.alpha = 0
        return self
    }
    
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



