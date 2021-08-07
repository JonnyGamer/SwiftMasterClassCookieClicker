//
//  ButtonClass.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/7/21.
//

import SpriteKit

class Button: SKNode, SuperTouchable {
    func _touchBegan() {
        button.run(.moveBy(x: 0, y: -size.times(0.1).height, duration: 0.1).circleOut())
        text.run(.moveBy(x: 0, y: -size.times(0.1).height, duration: 0.1).circleOut())
        touchBegan(self)
    }
    func _touchReleased() {
        button.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        text.run(.moveBy(x: 0, y: size.times(0.1).height, duration: 0.1).circleOut())
        touchReleased(self)
    }
    func _touchEndedOn() {
        touchEndedOn(self)
    }
    var touchBegan: (Button) -> () = { _ in }
    var touchReleased: (Button) -> () = { _ in }
    var touchEndedOn: (Button) -> () = { _ in }
    
    var size: CGSize
    var button: SKShapeNode
    var buttonShadow: SKShapeNode
    var text: SKLabelNode
    
    init(size: CGSize, text: String) {

        self.text = SKLabelNode.init(text: text).then {
            $0.verticalAlignmentMode = .center
            $0.horizontalAlignmentMode = .center
            $0.fontColor = .black
            $0.zPosition = 1
            $0.keepInside(.init(width: 1000.0, height: size.times(0.75).height))
            $0.fontSize *= $0.xScale
            $0.setScale(1)
        }
        let newSize = CGSize.init(width: max(100, self.text.frame.size.padding(40).width), height: size.height)
        self.size = newSize
        
        button = SKShapeNode(rectOf: newSize, cornerRadius: 10).then {
            $0.fillColor = .white
            $0.strokeColor = .black
            $0.zPosition = -1
        }
        buttonShadow = button.coppied.then {
            $0.fillColor = .black
            $0.strokeColor = .black
            $0.position.y -= size.times(0.1).height
            $0.zPosition = -2
            $0.alpha = 0.5
        }
//        self.text.then {
//            //$0.keepInside(size.times(0.75))
//            //$0.fontSize *= $0.xScale
//            //$0.setScale(1)
//        }
        
        super.init()
        addChild(button)
        addChild(buttonShadow)
        addChild(self.text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
