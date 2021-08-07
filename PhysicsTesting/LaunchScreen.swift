//
//  LaunchScreen.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/7/21.
//

import Foundation
import Magic

class LaunchScreen: HostingScene {
    
    var magicCamera: SKCameraNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = .darkGray
        
        magicCamera = SKCameraNode()
        camera = magicCamera
        magicCamera.position = .midScreen
        addChild(magicCamera!)
        
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
        
        enum Direction: Double {
            case up = 2000, down = -2000
        }
        func bring(dir: Direction, node: SKNode, delay: Double) {
            let bringItUp = SKAction.moveBy(x: 0, y: CGFloat(dir.rawValue), duration: 0.7).easeOut()
            let startThisWay = SKAction.moveBy(x: 0, y: CGFloat(-dir.rawValue), duration: 0)
            let begin = SKAction.sequence([startThisWay, .wait(forDuration: delay), bringItUp])
            node.run(begin)
        }
        
        let stacko = HStack.init(nodes: [
            Button(size: .hundred, text: "􀥏").then({
                $0.touchEndedOn = { _ in }
            }).padding,
            Button(size: .hundred, text: "Ever Maze").padding,
            Button(size: .hundred, text: "􀎡").padding,
        ]).then({
            bring(dir: .down, node: $0, delay: 0.0)
        })
        let newStacko = VStack.init(nodes: [
            stacko,
            Button(size: .hundred, text: "􀊄").then({
                $0.touchBegan = { [self] _ in
                    magicCamera.run(.scale(to: 0.9, duration: 0.1).easeOut())
                }
                $0.touchReleased = { [self] _ in
                    magicCamera.run(.scale(to: 1.0, duration: 0.1).easeOut())
                }
                $0.touchEndedOn = { [self] _ in
                    magicCamera.removeAllActions()
                    magicCamera.run(.scale(to: 0.1, duration: 0.5).easeOut())
                    launch(launch: GameScene(size: .screen))
                }
            })
        ].reversed()).then({
            bring(dir: .up, node: $0, delay: 0.1)
        })
        
        addChild(newStacko)
        newStacko.keepInside(size.times(0.9))
        newStacko.centerAt(point: .midScreen)
        
    }
    
    var nodesTouched: [SKNode] = []
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        let nodesTouched = nodes(at: event.location(in: self))
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
    }
    override func mouseUp(with event: NSEvent) {
        let nodesEndedOn = nodes(at: event.location(in: self))
        nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()
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
