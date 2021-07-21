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
        
        for i in [(500, 500, 250, 500), (500, 1000, 900, 750), (400, 200, 0, 0)] {
            let cropper = Scene1.Rect(width: CGFloat(i.0)-20, height: CGFloat(i.1)-20) {
                $0.position = .zero
            }
            cropper.position.x = CGFloat.random(in: 0...1000)
            cropper.position.y = CGFloat.random(in: 0...1000)
            addChild(cropper)
            cropper.maskNode?.alpha = 0.5
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
    override func mouseDown(with event: NSEvent) {
        touching = []
        
        let loc = event.location(in: self)
        previous = loc
        dragged = false
        
        for c1 in c {
            if (c1.children[0] as! Scene1).touchedInside(loc) {
                touching.append(c1)
                (c1.children[0] as! Scene1).touchesBegan(.zero, nodes: [])
            }
        }
        if touching.isEmpty {
            touching = c
            magicCamera.setScale(event.locationInWindow.x / 200)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        dragged = true
        let loc = event.location(in: self)
        velocity = .init(dx: loc.x - previous.x, dy: loc.y - previous.y)
        
        for i in touching {
            (i.children[0] as! SKSceneNode).touchesMoved(CGVector.init(dx: velocity.dx, dy: velocity.dy))
            i.run(.moveBy(x: velocity.dx, y: velocity.dy, duration: 0.1))
        }
        
        previous = loc
    }
    
    override func mouseUp(with event: NSEvent) {
        let loc = event.location(in: self)
        
        if dragged {
            let uwu = SKAction.moveBy(x: velocity.dx*10, y: velocity.dy*10, duration: 0.5)
            uwu.timingFunction = SineEaseOut(_:)
            
            for i in touching {
                i.run(uwu)
                (i.children[0] as! SKSceneNode).touchesEnded(loc, release: CGVector.init(dx: velocity.dx*10, dy: velocity.dy*10))
            }
            
        }
    }
    
    
}






