//
//  DragSceneHost.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/4/21.
//

import Magic

class DragSceneHost: HostingScene {
    var levelSize: [Int] = [5,5]
    convenience init(sizePlease: [Int], screens: Int) {
        self.init(screens: screens)
        levelSize = sizePlease
    }
    
    override func didMove(to view: SKView) {
        DragScene.screens = screens
        launchScene = DragScene.self
        super.didMove(to: view)
        for i in 0..<c.count {
            if let io = (c[i].children[0] as? DragScene) {
                io.screenID = i
                io.addShadows()
            }
        }
    }
}

class DragScene: SKSceneNode {
    static var screens: Int = 1
    var screenID: Int = 0
    static var supraNode: [SKNode:[SKNode]] = [:]
    
    var myNode = SKSpriteNode(color: .white, size: .hundred)
    
    override func begin() {
        backgroundColor(.black)
        Self.supraNode[myNode] = []
        for _ in 1...Self.screens {
            Self.supraNode[myNode]?.append(myNode.copied)
        }
    }
    func addShadows() {
        Self.supraNode[myNode]?[screenID] = myNode
        for (_, j) in Self.supraNode {
            if j[screenID] !== myNode {
                j[screenID].alpha = 0.1
            }
            addChild(j[screenID])
        }
    }
    
    var drag = false
    override func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {
        if nodes.contains(myNode) {
            drag = true
        }
    }
    override func touchesMoved(_ at: CGVector) {
        if drag {
            myNode.position.x += at.dx
            myNode.position.y += at.dy
            for i in Self.supraNode[myNode] ?? [] {
                if i === myNode { continue }
                i.position.x += at.dx
                i.position.y += at.dy
            }
        }
    }
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
        drag = false
    }
}
