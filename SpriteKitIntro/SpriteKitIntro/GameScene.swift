//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit
import GameplayKit


class SKSceneNode: SKCropNode {
    var size: CGSize { .init(width: width, height: height) }
    var minPoint: CGPoint { .init(x: parent!.position.x - size.halved.width, y: parent!.position.y - size.halved.height) }
    var width: CGFloat = 0
    var height: CGFloat = 0
    func touchedInside(_ point: CGPoint) -> Bool {
        return CGRect(origin: minPoint, size: size).contains(point)
    }
    
    func begin() {}
    func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {}
    func touchesMoved(_ at: CGVector) {}
    func touchesEnded(_ at: CGPoint) {}
}


class Scene1: SKSceneNode {
    static var inverse: Bool = true
    
    var h: HStack!
    var inversion: Bool = true
    
    override func begin() {
        inversion = Self.inverse
        Self.inverse.toggle()
        
        backgroundColor(.lightGray)
        print("Let's GOOO!")
        
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
}





class GameScene: SKScene {
        
    var i: HStack!
    var c1: SKNode!
    var c2: SKNode!
    
    override func didMove(to view: SKView) {
        
        backgroundColor = .black
        
        let node1 = SKSpriteNode(color: .gray, size: .hundred)
        let node2 = SKSpriteNode(color: .gray, size: .hundred)
        node2.setScale(0.5)
        let node3 = SKSpriteNode(color: .gray, size: .hundred)
        node3.setScale(0.5)
        let node4 = SKSpriteNode(color: .gray, size: .hundred)
        
        i = HStack(nodes: [node1.copied.padding, node2.copied.padding, node3.copied.padding, node4.copied.padding])
        i.keepInside(size)
        //keepInsideScene(i)
        i.centerOn(self)
        
        // FRAME 1
        let cropper = Scene1.Rect(width: 500-20, height: 500-20) {
            $0.position = .zero
        }
        cropper.position.x = 250
        cropper.position.y = 500
        addChild(cropper)
        cropper.maskNode?.alpha = 0.5
        cropper.framed(.darkGray)
        c1 = cropper.parent
        cropper.begin()
        
        // FRAME 1
        let cropper2 = SKCropNode.Rect(width: 500-20, height: 1000-20, add: i) {
            $0.position = .zero
        }
        cropper2.position.x = 900//750
        cropper2.position.y = 500
        addChild(cropper2)
        cropper2.maskNode?.alpha = 0.5
        cropper2.framed(.darkGray)
        cropper2.backgroundColor(.lightGray)
        c2 = cropper2.parent
        
    }
    

    func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }

    var previous: CGPoint = .zero
    var dragged = false
    
    
    var touching: [SKNode] = []
    override func mouseDown(with event: NSEvent) {
        touching = []
        
        let loc = event.location(in: self)
        previous = loc
        dragged = false
        
        if (c1.children[0] as! Scene1).touchedInside(loc) {
            touching.append(c1)
            (c1.children[0] as! Scene1).touchesBegan(.zero, nodes: [])
        }
        
        
        let bar: [SKNode] = (1...i.children.count).map { _ in SKSpriteNode(color: .gray, size: .hundred).padding }
        i.prepend(node: VStack.init(nodes: bar))
        
        i.keepInside(size)
        i.centerAt(point: .zero)
    }
    
    override func mouseDragged(with event: NSEvent) {
        dragged = true
        
        for i in touching {
            (i.children[0] as! SKSceneNode).touchesMoved(CGVector.init(dx: event.deltaX, dy: -event.deltaY))
            i.run(.moveBy(x: event.deltaX, y: -event.deltaY, duration: 0.1))
        }
        
        i.run(.moveBy(x: event.deltaX, y: -event.deltaY, duration: 0.1))
        c2.run(.moveBy(x: event.deltaX, y: -event.deltaY, duration: 0.1))
        
        (previous.x, previous.y) = (event.deltaX, event.deltaY)
    }
    
    override func mouseUp(with event: NSEvent) {
        if dragged {
            let uwu = SKAction.moveBy(x: previous.x*20, y: -previous.y*20, duration: 0.5)
            uwu.timingFunction = SineEaseOut(_:)
            
            for i in touching {
                i.run(uwu)
            }
            
            i.run(uwu)
            c2.run(uwu)
        }
    }
    
    
}






