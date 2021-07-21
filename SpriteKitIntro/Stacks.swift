//
//  HStack.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit

protocol Stackable {
    var orderedChildren: [SKNode] { get set }
    init(nodes: [SKNode])
    func repositionNodes()
    func append(node: SKNode)
    func append(nodes: [SKNode])
    func prepend(nodes: [SKNode])
}
extension Stackable {
    func append(node: SKNode) { append(nodes: [node]) }
    func prepend(node: SKNode) { prepend(nodes: [node]) }
}




class HStack: SKNode, Stackable {
    var orderedChildren: [SKNode] = []
    
    override init() {
        super.init()
        print("HUH?")
    }
    required init(nodes: [SKNode]) {
        super.init()
        orderedChildren = nodes
        for i in nodes {
            addChild(i)
        }
        repositionNodes()
    }
    
    func repositionNodes() {
        var maxXo: CGFloat = 0
        for i in orderedChildren {
            i.centerAt(point: .zero)
            i.position.x = maxXo// + (i.calculateAccumulatedFrame().width/2)
            i.position.x += i.position.x - i.calculateAccumulatedFrame().minX
            maxXo = i.calculateAccumulatedFrame().maxX
        }
    }
    
    func append(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren += nodes
        self.repositionNodes()
    }
    func prepend(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren = nodes + orderedChildren
        self.repositionNodes()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class VStack: SKNode, Stackable {
    var orderedChildren: [SKNode] = []
    
    override init() {
        super.init()
        print("HUH?")
    }
    required init(nodes: [SKNode]) {
        super.init()
        orderedChildren = nodes
        for i in nodes {
            addChild(i)
        }
        repositionNodes()
    }
    
    func repositionNodes() {
        var maxXo: CGFloat = 0
        for i in orderedChildren {
            i.centerAt(point: .zero)
            i.position.y = maxXo// + (i.calculateAccumulatedFrame().width/2)
            i.position.y += i.position.y - i.calculateAccumulatedFrame().minY
            maxXo = i.calculateAccumulatedFrame().maxY
        }
    }
    
    func append(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren += nodes
        self.repositionNodes()
    }
    func prepend(nodes: [SKNode]) {
        for i in nodes { addChild(i) }
        orderedChildren = nodes + orderedChildren
        self.repositionNodes()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
