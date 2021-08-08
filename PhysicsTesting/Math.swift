//
//  Mth.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/7/21.
//

import Foundation
import Magic

class Math: HostingScene {
    var nodesTouched: Set<SKNode> = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        
        for _ in 1...100 {
            let wo = SKSpriteNode.init(color: .gray, size: .hundred)
            wo.setScale(CGFloat.random(in: CGFloat(0.1)...CGFloat(3)))
            wo.zRotation = CGFloat.random(in: 1...100)
            wo.position.x = CGFloat.random(in: 1...w)
            wo.position.y = CGFloat.random(in: 1...h)
            wo.zPosition = -1000
            wo.alpha = 0.1
            wo.run(.repeatForever(.sequence([
                .wait(forDuration: Double.random(in: 0...10)),
                .rotate(byAngle: .pi, duration: 4).circleOut()
            ])))
            addChild(wo)
        }
        
        begin()
    }
    func begin() {
        
    }
    
    enum Direction: Double {
        case up = 2000, down = -2000
    }
    func bring(dir: Direction, node: SKNode, delay: Double) {
        let bringItUp = SKAction.moveBy(x: 0, y: CGFloat(dir.rawValue), duration: 0.7).easeOut()
        let startThisWay = SKAction.moveBy(x: 0, y: CGFloat(-dir.rawValue), duration: 0)
        let begin = SKAction.sequence([startThisWay, .wait(forDuration: delay), bringItUp])
        node.run(begin)
    }
    
    func backArrow(_ to: HostingScene) {
        let backArrow = Button(size: .hundred, text: "􀯶").then({
            $0.touchEndedOn = { [self] _ in
                launch(launch: to)
            }
        })
        addChild(backArrow.padding)
        backArrow.centerAt(point: .init(x: (backArrow.button.frame.width/2)+20, y: (980 - (backArrow.button.frame.height/2))))
    }
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        let nodesTouched = nodes(at: event.location(in: self))
        nodesTouched.touchBegan()
        self.nodesTouched = self.nodesTouched.union(nodesTouched)
    }
    override func mouseUp(with event: NSEvent) {
        print("stop")
        let nodesEndedOn = nodes(at: event.location(in: self))
        Array(nodesTouched).touchReleased()
        Array(nodesTouched.subtracting(nodesEndedOn)).touchEndedOn()
        //nodesEndedOn.touchEndedOn()
        nodesTouched = []
        previous = .zero
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesTouched = nodes(at: touches.first?.location(in: self) ?? .zero)
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesEndedOn = nodes(at: touches.first?.location(in: self) ?? .zero)
        nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()

    }
    #endif
}


class MathScene: Math {
    
    override func begin() {
        backArrow(LaunchScreen(size: .screen))
        
        let bigger = HStack.init(nodes: [
            Button(size: .hundred, text: "􀅼").padding,
            Button(size: .hundred, text: "􀅾").padding,
            Button(size: .hundred, text: "􀄨").padding,
            Button(size: .hundred, text: "􀄨􀄨").padding,
        ]).then({
            bring(dir: .down, node: $0, delay: 0.1)
        })
        
        let smaller = HStack.init(nodes: [
            Button(size: .hundred, text: "􀁎").padding,
            Button(size: .hundred, text: "􀅿").padding,
            Button(size: .hundred, text: "􀓪").then({
                $0.touchEndedOn = { [self] _ in
                    launch(launch: SquareRootScene(size: .screen))
                }
            }).padding,
            Button(size: .hundred, text: "􀛺").padding,
        ]).then({
            bring(dir: .down, node: $0, delay: 0.0)
        })
        
        let menu = HStack.init(nodes: [
            Button(size: .hundred, text: "Operators").padding
        ]).then({
            bring(dir: .down, node: $0, delay: 0.2)
        })
        
        let newStacko = VStack.init(nodes: [
            menu,
            bigger,
            smaller
        ].reversed())
        
        addChild(newStacko)
        newStacko.keepInside(size.times(0.9))
        newStacko.centerAt(point: .midScreen)
    }
    
}


class SquareRootScene: Math {
    var stackem: VStack!
    
    func words(_ string: [String]) -> SKShapeNode {
        let text = SKLabelNode.init(text: string.reduce("") { $0 + "\n" + $1 })
        text.text?.removeFirst()
        text.fontName = "Hand"
        text.numberOfLines = text.text?.split(separator: "\n").count ?? 1
        text.horizontalAlignmentMode = .center
        text.verticalAlignmentMode = .center
        addChild(text)
        text.framed()
        text.fontSize *= 2
        guard let frameParent = text.parent as? SKShapeNode else { fatalError() }
        frameParent.centerAt(point: .midScreen)
        frameParent.removeFromParent()
        return frameParent
    }
    
    override func begin() {
        backArrow(MathScene(size: .screen))
        
        stackem = VStack.init(nodes: [
            words(["􀓪 Square Roots 􀓪"]).padding,
            words(["Lesson 1.","Welcome to Square Roots!","What are they?"]).padding,
            words(["􀓪 Square Roots"]).padding,
        ].reversed())
        addChild(stackem)
        stackem.centerAt(point: .midScreen)
    }
    
    override func mouseDragged(with event: NSEvent) {
        super.mouseDown(with: event)
        if previous == .zero { previous = event.location(in: self); return }
        stackem.position.y += event.location(in: self).y - previous.y
        previous = event.location(in: self)
        //stackem.draggingRangeWithin(size)
        
        let woo = stackem.calculateAccumulatedFrame()
        if woo.maxY < (size.height.half) {
            stackem.position.y = -(woo.height - size.height/2)
        } else if woo.minY > (size.height.half) {
            stackem.position.y = size.height.half
        }
    }
}
