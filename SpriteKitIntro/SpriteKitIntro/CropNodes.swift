//
//  CropNodes.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit


extension SKCropNode {
    func backgroundColor(_ acolor: NSColor) {
        childNode(withName: "_bg_")?.removeFromParent()
        let bg = SKSpriteNode.init(color: acolor, size: maskNode?.calculateAccumulatedFrame().size.doubled ?? .zero)
        bg.position = maskNode?.position ?? .zero
        bg.name = "_bg_"
        bg.zPosition = -.infinity
        addChild(bg)
    }
    static func Circle(radius: CGFloat, add: SKNode, doThis: (SKShapeNode) -> ()) -> SKCropNode {
        let cropper = SKCropNode.init()
        cropper.addChild(add)
        
        let uwu = SKShapeNode.init(circleOfRadius: radius/2)
        uwu.lineWidth = radius
        doThis(uwu)
        cropper.maskNode = uwu
        return cropper
    }
    static func RoundRect(width: CGFloat, height: CGFloat, corner: CGFloat, add: SKNode, doThis: (SKShapeNode) -> ()) -> SKCropNode {
        let cropper = SKCropNode.init()
        cropper.addChild(add)
        
        let smallSide = min(width, height)
        let takeaway = smallSide/2
        
        let uwu = SKShapeNode.init(rectOf: .init(width: width-takeaway, height: height-takeaway), cornerRadius: corner/2)
        
        uwu.lineWidth = takeaway + 1
        
        doThis(uwu)
        cropper.maskNode = uwu
        
        // additional crop nodage ;)
        //let boyoyoyo = SKSpriteNode.init(color: .gray, size: .hundred)
        //boyoyoyo.position.x += 500
        //uwu.addChild(boyoyoyo)
        
        return cropper
    }
    static func Rect(width: CGFloat, height: CGFloat, add: SKNode, doThis: (SKSpriteNode) -> ()) -> SKCropNode {
        let cropper = SKCropNode.init()
        cropper.addChild(add)
        
        let uwu = SKSpriteNode.init(color: .gray, size: .init(width: width, height: height))
        doThis(uwu)
        cropper.maskNode = uwu
        return cropper
    }
    
}
