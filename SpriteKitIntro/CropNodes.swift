//
//  CropNodes.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit

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
    func touchesEnded(_ at: CGPoint, release: CGVector) {}
    var draggable = true
}

extension SKCropNode {
    func backgroundColor(_ acolor: NSColor) {
        childNode(withName: "_bg_")?.removeFromParent()
        let bg = SKSpriteNode.init(color: acolor, size: maskNode?.calculateAccumulatedFrame().size.doubled ?? .zero)
        bg.position = maskNode?.position ?? .zero
        bg.name = "_bg_"
        bg.zPosition = -.infinity
        addChild(bg)
    }
    static func Circle(radius: CGFloat, doThis: ((SKShapeNode) -> ())? = nil) -> Self {
        let cropper = Self.init()
        if let c = cropper as? SKSceneNode {
            c.width = radius*2
            c.height = radius*2
        }
        
        let uwu = SKShapeNode.init(circleOfRadius: radius/2)
        uwu.lineWidth = radius
        doThis?(uwu)
        cropper.maskNode = uwu
        return cropper
    }
    static func RoundRect(width: CGFloat, height: CGFloat, corner: CGFloat, doThis: ((SKShapeNode) -> ())? = nil) -> Self {
        let cropper = Self.init()
        if let c = cropper as? SKSceneNode {
            c.width = width
            c.height = height
        }
        
        let smallSide = min(width, height)
        let takeaway = smallSide/2
        
        let uwu = SKShapeNode.init(rectOf: .init(width: width-takeaway, height: height-takeaway), cornerRadius: corner/2)
        
        uwu.lineWidth = takeaway + 1
        
        doThis?(uwu)
        cropper.maskNode = uwu
        
        // additional crop nodage ;)
        //let boyoyoyo = SKSpriteNode.init(color: .gray, size: .hundred)
        //boyoyoyo.position.x += 500
        //uwu.addChild(boyoyoyo)
        
        return cropper
    }
    static func Rect(width: CGFloat, height: CGFloat, doThis: ((SKSpriteNode) -> ())? = nil) -> Self {
        let cropper = Self.init()
        
        if let c = cropper as? SKSceneNode {
            c.width = width
            c.height = height
        }
        
        let uwu = SKSpriteNode.init(color: .gray, size: .init(width: width, height: height))
        doThis?(uwu)
        cropper.maskNode = uwu
        return cropper
    }
    
}
