//
//  GameScene.swift
//  SpriteKitTemplate
//
//  Created by Jonathan Pappas on 4/19/21.
//

import SpriteKit
import GameplayKit

//
//  GameScene.swift
//  PlatformerWithAlek
//
//  Created by Jonathan Pappas on 4/14/21.
//
import SpriteKit
import GameplayKit

extension SKScene {
    @discardableResult
    func addLabel(_ text: String) -> SKLabelNode {
        let label = SKLabelNode.init(text: text)
        label.fontName = ""
        label.setScale(0.1)
        label.fontColor = .white
        addChild(label)
        return label
    }
}

protocol P {}
class A:P {}
class B {
  func myFunc() -> some P {
    return A()
  }
}

//extension NSObject: Foo {}

//protocol Foo {}
//extension Foo {
//    func o<T: Foo, U>(_ this: ReferenceWritableKeyPath<T, U>, _ setTo: (T) -> U) -> T {
//        (self as! T)[keyPath: this] = setTo(self as! T)
//        return self as! T
//    }
//    func o<T: Foo, U>(_ this: ReferenceWritableKeyPath<T, U>, _ setTo: U) -> T {
//        return o(this, { _ in setTo })
//    }
//}

extension SKLabelNode {
    func o<T: SKLabelNode, U>(_ this: ReferenceWritableKeyPath<T, U>, _ setTo: (T) -> U) -> T {
        (self as! T)[keyPath: this] = setTo(self as! T)
        return self as! T
    }
    func o<T: SKLabelNode, U>(_ this: ReferenceWritableKeyPath<T, U>, _ setTo: U) -> T {
        return o(this, { _ in setTo })
    }
}

extension SKNode {
    func o<T: SKNode, U>(_ this: ReferenceWritableKeyPath<T, U>, _ setTo: (T) -> U) -> T {
        (self as! T)[keyPath: this] = setTo(self as! T)
        return self as! T
    }
    func o<T: SKNode, U>(_ this: ReferenceWritableKeyPath<T, U>, _ setTo: U) -> T {
        return o(this, { _ in setTo })
    }
    
//    func xPosition<T: SKNode>(_ setTo: CGFloat) -> T {
//        self.position.x = setTo
//        return self as! T
//    }
//    func xPosition<T: SKNode>(_ setTo: (T) -> CGFloat) -> T {
//        return self.xPosition(setTo(self as! T))
//    }
//    func yPosition<T: SKNode>(_ setTo: CGFloat) -> T {
//        self.position.y = setTo
//        return self as! T
//    }
//    func yPosition<T: SKNode>(_ setTo: (T) -> CGFloat) -> T {
//        return self.yPosition(setTo(self as! T))
//    }
    
    // Operators make compiler slower
//    static func -<T: SKNode, U>(rhs: SKNode, lhs: (ReferenceWritableKeyPath<T, U>, U)) -> T {
//        return rhs.o(lhs.0, lhs.1)
//    }
}

// Not Quite there
//infix operator ++
//func ++<T, U>(rhs: T, lhs: (ReferenceWritableKeyPath<T, U>, U)) -> T {
//    rhs[keyPath: lhs.0] = lhs.1; return rhs
//}


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKNode!
    var magicCamera: SKCameraNode!
    var doubleJump = 0
    

    
    override func didMove(to view: SKView) {
        
        ground(0, 50)
        ground(60, 200)
        ground(220, 300, 30)
        ground(330, 360, 30)
        ground(390, 450, 20)
        ground(470, 550, 50)
        
        let hi = ground(600, 700, 5)
        let hi2 = ground(720, 740, 5, actualHeight: 300)
        
        
//        let foo: SKLabelNode = addLabel("You Win!")
//            .o(\.fontName, "")
//            .o(\.position.x) { hi.frame.maxX - $0.frame.width - 5 }
//            .o(\.position.y, 20)
//            .o(\.name, "Hello")
//            .o(\.name, "Hello")
//            .o(\.name, "Hello")
//            .o(\.name, "Hello")
//            .o(\.name, "Hello")
//            .o(\.alpha, 0)
//            .o(\.fontName, "")
        
        
        let youWin: SKLabelNode = SKLabelNode(text: "You Win!")
            .o(\.alpha, 0.1)
            .o(\.xScale, 0.1)
            .o(\.fontName, "")
            .o(\.fontName, "")
            
//            .o(\.xScale, 0.1)
//            .o(\.xScale, 0.1)
//            .o(\.xScale, 0.1)
//            .o(\.xScale, 0.1)
        
//            .o(\.yScale, 0.1)
//            .o(\.fontColor, .white)
//            .o(\.fontColor, .white)
//
        //addChild(youWin)

        func addLabel(_ text: String) -> SKLabelNode {
            let label = SKLabelNode.init(text: text)
            label.fontName = ""
            label.setScale(0.1)
            label.fontColor = .white
            addChild(label)
            return label
        }
        
//            - (\.name, "Hi")
//            - (\.name, "HI THERE MOD")
//            - (\.name, "HI THERE MOD")
//            - (\.name, "HI THERE MOD")
//            - (\.name, "HI THERE MOD")
//            - (\.name, "HI THERE MOD")

        
        //addLabel("Secret!", x: hi2.frame.midX, y: hi2.frame.maxY + 20)
        
        
        
        player = character()
        
        magicCamera = SKCameraNode()
        camera = magicCamera
        magicCamera.position.x = player.position.x
        magicCamera.position.y = frame.height/2
        addChild(magicCamera)
        
        physicsWorld.contactDelegate = self
    }
    
    
    func ground(_ minX: CGFloat,_ maxX: CGFloat, _ height: CGFloat = 5, actualHeight: CGFloat = 10) -> SKShapeNode {
        let g = SKShapeNode.init(rectOf: CGSize.init(width: maxX - minX, height: actualHeight), cornerRadius: 0)
        g.fillColor = .white
        g.strokeColor = .clear
        g.position.x = minX + g.frame.width/2
        g.position.y = height
        
        g.physicsBody = .init(polygonFrom: g.path!)
        g.physicsBody?.affectedByGravity = false
        g.physicsBody?.isDynamic = false
        g.physicsBody?.contactTestBitMask = 1
        
        addChild(g)
        return g
    }
    
    func character() -> SKShapeNode {
        let g = SKShapeNode.init(rectOf: CGSize.init(width: 10, height: 10), cornerRadius: 0)
        g.fillColor = .white
        g.strokeColor = .clear
        g.position.x = 5
        g.position.y = 55
        
        g.physicsBody = .init(polygonFrom: g.path!)
        g.physicsBody?.contactTestBitMask = 1
        
        addChild(g)
        return g
    }
    
    
    var pressingLeft = false
    var pressingRight = false
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        
        if event.keyCode == 123 {
            // Move Left
            pressingLeft = true
            player.physicsBody?.velocity.dx = -100
            
        } else if event.keyCode == 124 {
            // Move Right
            pressingRight = true
            player.physicsBody?.velocity.dx = 100
        }
        
        if event.keyCode == 49, doubleJump < 2 {
            // Jump
            player.physicsBody?.velocity.dy = 250
            doubleJump += 1
        }
        
    }
    
    override func keyUp(with event: NSEvent) {
        if event.keyCode == 123 {
            pressingLeft = false
        } else if event.keyCode == 124 {
            pressingRight = false
        }
        
        if event.keyCode == 49, player.physicsBody!.velocity.dy > 100 {
            player.physicsBody?.velocity.dy = 100
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if pressingLeft {
            player.physicsBody?.velocity.dx = -100
        }
        if pressingRight {
            player.physicsBody?.velocity.dx = 100
        }
        
        magicCamera.run(.moveTo(x: player.position.x+(player.physicsBody!.velocity.dx/2), duration: 0.3))
        magicCamera.run(.moveTo(y: max(frame.height/2, (player.position.y)), duration: 0.3))
        
        if player.frame.maxY < 0 {
            removeAllChildren()
            didMove(to: view!)
        }
        
    }
    
    override func didFinishUpdate() {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        print("Contact")
        if contact.bodyA.node === player {
            doubleJump = 0
        } else if contact.bodyB.node === player {
            doubleJump = 0
        }
        
        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        
    }
    

}
