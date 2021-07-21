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







class GameScene: SKScene {
        
    var h: HStack!
    var i: HStack!
    
    override func didMove(to view: SKView) {
        
        
        
        backgroundColor = .black
        
        let node1 = SKSpriteNode(color: .gray, size: .hundred)
        let node2 = SKSpriteNode(color: .gray, size: .hundred)
        node2.setScale(0.5)
        let node3 = SKSpriteNode(color: .gray, size: .hundred)
        node3.setScale(0.5)
        let node4 = SKSpriteNode(color: .gray, size: .hundred)
        
        h = HStack(nodes: [node1.padding, node2.padding, node3.padding, node4.padding])
        keepInsideScene(h)
        h.centerOn(self)
        i = HStack(nodes: [node1.copied.padding, node2.copied.padding, node3.copied.padding, node4.copied.padding])
        keepInsideScene(i)
        i.centerOn(self)
        
        // FRAME 1
        let cropper = SKCropNode.Rect(width: 500-20, height: 1000-20, add: h) {
            $0.position = .zero
        }
        cropper.position.x = 250
        cropper.position.y = 500
        addChild(cropper)
        cropper.maskNode?.alpha = 0.5
        cropper.framed(.darkGray)
        cropper.backgroundColor(.lightGray)
        
        // FRAME 1
        let cropper2 = SKCropNode.Rect(width: 500-20, height: 1000-20, add: i) {
            $0.position = .zero
        }
        cropper2.position.x = 750
        cropper2.position.y = 500
        addChild(cropper2)
        cropper2.maskNode?.alpha = 0.5
        cropper2.framed(.darkGray)
        cropper2.backgroundColor(.lightGray)
    }
    

    func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }

    var (previousX, previousY): (CGFloat, CGFloat) = (0, 0)
    override func mouseDragged(with event: NSEvent) {
        h.run(.moveBy(x: event.deltaX, y: -event.deltaY, duration: 0.1))
        i.run(.moveBy(x: event.deltaX, y: -event.deltaY, duration: 0.1))
        (previousX, previousY) = (event.deltaX, event.deltaY)
        //print(event.deltaX)
    }
    override func mouseUp(with event: NSEvent) {
        let uwu = SKAction.moveBy(x: previousX*20, y: -previousY*20, duration: 0.5)
        uwu.timingFunction = SineEaseOut(_:)
        h.run(uwu)
        i.run(uwu)
    }
    
    override func mouseDown(with event: NSEvent) {
        (previousX, previousY) = (0,0)
        let foo: [SKNode] = (1...h.children.count).map { _ in SKSpriteNode(color: .gray, size: .hundred).padding }
        h.append(node: VStack.init(nodes: foo))
        
        let bar: [SKNode] = (1...h.children.count).map { _ in SKSpriteNode(color: .gray, size: .hundred).padding }
        i.prepend(node: VStack.init(nodes: bar))
        
        //h.append(node: h.copied)
        //h.append(nodes: h.copiedChildren)
        
        keepInsideScene(h)
        h.centerAt(point: .zero)
        
        keepInsideScene(i)
        i.centerAt(point: .zero)
        
        //h.centerAt(point: .midScreen)
        //center(h)
    }
    
}






