//
//  TouchHostingScene.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/12/21.
//

import Magic

class TouchHostingScene: HostingScene {
    var nodesTouched: [SKNode] = []
    
    func realTouchBegan(at: CGPoint, nodes: [SKNode]) {}
    func realTouchMoved(with: CGVector) {}
    func realTouchEnd(at: CGPoint, with: CGVector) {}
    
    #if os(macOS)
    var startingLoc: CGPoint = .zero
    override func mouseDown(with event: NSEvent) {
        let loc = event.location(in: self)
        let nodesTouched = nodes(at: loc)
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
        startingLoc = loc
        currentPos = loc
        realTouchBegan(at: loc, nodes: nodesTouched)
    }
    var currentPos: CGPoint = .zero
    override func mouseDragged(with event: NSEvent) {
        let loc = event.location(in: self)
        realTouchMoved(with: .init(dx: loc.x - currentPos.x, dy: loc.y - currentPos.y))
        currentPos = loc
    }
    override func mouseUp(with event: NSEvent) {
        let loc = event.location(in: self)
        let nodesEndedOn = nodes(at: loc)
        Array(Set(nodesTouched).subtracting(nodesEndedOn)).touchReleased()
        //nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()
        realTouchEnd(at: loc, with: .init(dx: loc.x - startingLoc.x, dy: loc.y - startingLoc.y))
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesTouched = nodes(at: touches.first?.location(in: self) ?? .zero)
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
    }
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let nodesTouched = nodes(at: touches.first?.location(in: self) ?? .zero)
//        nodesTouched.touchBegan()
//        self.nodesTouched += nodesTouched
//    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesEndedOn = nodes(at: touches.first?.location(in: self) ?? .zero)
        nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()
    }
    #endif
}

