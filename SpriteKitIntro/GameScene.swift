//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import SpriteKit

class GameScene: SKScene {
    
    var magicCamera: SKCameraNode!
    var c: [SKNode] = []
    
    override func didMove(to view: SKView) {
        magicCamera = SKCameraNode()
        camera = magicCamera
        addChild(magicCamera)
        
        //magicCamera.run(.moveBy(x: 1000, y: 0, duration: 10))
        
        backgroundColor = .black
        
        // Random 1 to 10 Magicallness
//        for i in 1...10 { // [(500, 500, 250, 500), (500, 1000, 900, 750), (400, 200, 0, 0)]
//            let cropper = Scene1.Rect(width: CGFloat.random(in: 100...1000), height: CGFloat.random(in: 100...1000)) {
//                $0.position = .zero
//            }
//            cropper.position.x = CGFloat.random(in: -1000...1000)
//            cropper.position.y = CGFloat.random(in: -1000...1000)
//            addChild(cropper)
//            //cropper.maskNode?.alpha = 0.5
//            cropper.framed(.darkGray)
//            c.append(cropper.parent!)
//            cropper.begin()
//        }
        
        for i in [(500, 1000, -250, 0), (500, 1000, 250, 0)] {
            let cropper = Scene1.Rect(width: CGFloat(i.0)-20, height: CGFloat(i.1)-20) {
                $0.position = .zero
            }
            cropper.position.x = CGFloat(i.2)
            cropper.position.y = CGFloat(i.3)
            addChild(cropper)
            //cropper.maskNode?.alpha = 0.5
            cropper.framed(.darkGray)
            c.append(cropper.parent!)
            cropper.begin()
        }
        
    }
    

    func keepInsideScene(_ node: SKNode) {
        let nodeSize = node.calculateAccumulatedFrame()
        node.setScale(min((size.width / nodeSize.width) * node.xScale, (size.height / nodeSize.height) * node.yScale))
    }

    var velocity: CGVector = .zero
    var previous: CGPoint = .zero
    var dragged = false
    var touching: [SKNode] = []
    
    // Touch Down
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        genericTouchesBegan(loc: loc)
    }
    #elseif os(macOS)
    override func mouseDown(with event: NSEvent) {
        let loc = event.location(in: self)
        genericTouchesBegan(loc: loc)
    }
    #endif
    // Generic Touch Down
    func genericTouchesBegan(loc: CGPoint) {
        touching = []
        previous = loc
        dragged = false
        for c1 in c {
            if (c1.children[0] as! Scene1).touchedInside(loc) {
                touching.append(c1)
                (c1.children[0] as! Scene1).touchesBegan(.zero, nodes: [])
            }
        }
        // Zoom Out ;)
        //if touching.isEmpty {
            //touching = c
            //magicCamera.setScale(event.locationInWindow.x / 200)
        //}
    }
    
    // Dragging
    #if os(iOS)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        guard let loc2 = touches.first?.previousLocation(in: self) else { return }
        velocity = .init(dx: loc.x - loc2.x, dy: loc.y - loc2.y)
        genericTouchesMoved()
        previous = loc
    }
    #elseif os(macOS)
    override func mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self)
        velocity = .init(dx: loc.x - previous.x, dy: loc.y - previous.y)
        genericTouchesMoved()
        previous = loc
    }
    #endif
    func genericTouchesMoved() {
        dragged = true
        for i in touching {
            guard let io = (i.children[0] as? SKSceneNode) else { continue }
            io.touchesMoved(CGVector.init(dx: velocity.dx, dy: velocity.dy))
            
            if io.draggable {
                i.run(.moveBy(x: velocity.dx, y: velocity.dy, duration: 0.1))
            }
        }
    }
    
    // Touches Ended
    #if os(iOS)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let loc = touches.first?.location(in: self) else { return }
        genericTouchEnded(loc: loc)
    }
    #elseif os(macOS)
    override func mouseUp(with event: NSEvent) {
        let loc = event.location(in: self)
        genericTouchEnded(loc: loc)
    }
    #endif
    func genericTouchEnded(loc: CGPoint) {
        if dragged {
            let uwu = SKAction.moveBy(x: velocity.dx*10, y: velocity.dy*10, duration: 0.5)
            uwu.timingFunction = SineEaseOut(_:)
            
            for i in touching {
                guard let io = (i.children[0] as? SKSceneNode) else { continue }
                io.touchesEnded(loc, release: CGVector.init(dx: velocity.dx*10, dy: velocity.dy*10))
                
                if io.draggable {
                    i.run(uwu)
                }
            }
            
        }
    }
    
}






