//
//  EverHost.swift
//  Antilone
//
//  Created by Jonathan Pappas on 6/11/21.
//

/*
import Foundation
import SpriteKit



class EverHostScene: SKScene {
    var currentTouches: Set<UITouch> = []
    var host: Hostable = EverMazeView()
    var previouslyHosted: [String:Hostable] = [:]
    var gameType: GameType = .none
    
    var isLoading = false
    
//    override func didChangeSize(_ oldSize: CGSize) {
//        if olderSizo != .zero, size != oldSize {
//            host.reset()
//            (w, h) = (h, w)
//        }
//    }
    
    func returnToGame() {
        view?.presentTheScene()
    }
    
    func loading() {
        
        if let blocko = childNode(withName: "Blocko") {
            blocko.removeFromParent()
        }
        let blocko = SKShapeNode.init(rectOf: CGSize.init(width: 4 * w, height: 4 * h))
        blocko.fillColor = backgroundColor//.black// .white// SaveData.Settings.chatBoxColor == "White" ? .white : .black
        blocko.strokeColor = backgroundColor//.black// .white// SaveData.Settings.chatBoxColor == "White" ? .white : .black
        blocko.alpha = 0
        blocko.zPosition = 10000000
        addChild(blocko)
        blocko.name = "Blocko"
        blocko.run(.fadeIn(withDuration: 0.1))
        
        if let loader = childNode(withName: "Loader") {
            loader.removeFromParent()
        }
//        if SaveData.Settings.wittyLoadingText {
//            let loaderNode = ChatBox.InfinityText(["Loading..."] + (SaveData.Settings.loadingText.randomElement() ?? ["oof."]))
//            loaderNode.zPosition = .infinity
//            loaderNode.name = "Loader"
//            loaderNode.alpha = 1
//            loaderNode.zPosition = 20000000
//            loaderNode.position = .init(x: (w / 2) - (loaderNode.width / 2), y: (h / 2) - (loaderNode.height / 2))
//            addChild(loaderNode)
//        }
    }
    func finishedLoading() {
        isLoading = false
        if let loader = childNode(withName: "Loader") {
            loader.alpha = 0
            loader.run(.fadeOut(withDuration: 0.1)) {
                loader.removeFromParent()
            }
//            loader.run(.fadeOut(withDuration: 0.1)) {
//                loader.removeFromParent()
//            }
        }
        if let blocko = childNode(withName: "Blocko") {
            blocko.run(.fadeOut(withDuration: 0.1)) {
                blocko.removeFromParent()
            }
        }
    }
    
    override init() {
        let foo = DispatchQueue.init(label: "foo")
        super.init(size: .init(width: w, height: h))
        //physicsWorld.contactDelegate = self
        isLoading = true
        //musical(.begin)
        backgroundColor = .white
        foo.async { [self] in
            loading()
            anchorPoint = .zero
            backgroundColor = .white
            
            addChild(host.this)
            addChild(host.that)
            
            host.this.name = "THIS"
            host.that.name = "THAT"
            
            host.begin()
            
            previouslyHosted["\(type(of: host))"] = host
            finishedLoading()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func detectTouches(_ touches: Set<UITouch>) {
//        if checkIfPresenting() { return }
//        var nodesFound: Set<SKNode> = []
//        for touch in touches {
//            currentTouches.insert(touch)
//            nodesFound = nodesFound.union(nodes(at: touch.location(in: self)))
//        }
//    }
    
    func checkIfPresenting() -> Bool { return host.this.hasActions() || host.that.hasActions() }
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        if checkIfPresenting() { return }
        let location = event.location(in: self)
        let thisNodes = nodes(at: location)
        originalLocation = location
        host.touchBegan(location, thisNodes)
        previousLocation = location
    }
    #endif
//    func keyPressed(key: KeyboardKey) {
//        if let c = cursor, key == .spacebar {
//            cursorPress(c)
//        } else {
//            (host as? SuperHostable)?.keyPressed(key)
//        }
//    }

    
    #if os(iOS) || os(tvOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        let thisNodes = touches.reduce([SKNode]()) { (foo, bar) -> [SKNode] in
            if bar.phase == .began {
                return foo + nodes(at: bar.location(in: self))
            } else {
                return foo
            }
        }
        guard let pos = touches.first?.location(in: self) else {return}
        originalLocation = pos
        #if os(tvOS)
        cursorBegan()
        #elseif os(iOS)
        host.touchBegan(pos, thisNodes)
        #endif
        
    }
    #endif
    
    
    var originalLocation = CGPoint.zero
    #if os(macOS)
    override func mouseUp(with event: NSEvent) {
        if checkIfPresenting() { return }
        let location = event.location(in: self)
        let thisNodes = nodes(at: location)
        (host as? SuperHostable)?.swiped(CGVector.init(dx: location.x - originalLocation.x, dy: location.y - originalLocation.y))
        host.touchEnded(location, thisNodes)
    }
    #endif
    #if os(iOS) || os(tvOS)
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        let thisNodes = touches.reduce([SKNode]()) { (foo, bar) -> [SKNode] in
            if bar.phase == .ended || bar.phase == .cancelled {
                return foo + nodes(at: bar.location(in: self))
            } else {
                return foo
            }
        }
        guard let pos = touches.first?.location(in: self) else {return}
        (host as? EverHostable)?.swiped(CGVector.init(dx: pos.x - originalLocation.x, dy: pos.y - originalLocation.y))
        #if os(tvOS)
        cursorEnded()
        #elseif os(iOS)
        host.touchEnded(pos, thisNodes)
        #endif
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        #if os(tvOS)
        cursorEnded()
        #elseif os(iOS)
        touchesEnded(touches, with: event)
        #endif
    }
    #endif
    
    override func update(_ currentTime: TimeInterval) {
        if checkIfPresenting() { return }
        host.update()
        
        if let cursor = cursor {
            cursor.position.x += cursorX * 20
            cursor.position.y += cursorY * 20
            
            if cursor.position.x < 0 {
                cursor.position.x = 0
            }
            if cursor.position.x > w {
                cursor.position.x = w
            }
            if cursor.position.y < 0 {
                cursor.position.y = 0
            }
            if cursor.position.y > h { cursor.position.y = h }
        }
    }
    
    #if os(macOS)
    var previousLocation: CGPoint = .zero
    override func mouseDragged(with event: NSEvent) {
        if checkIfPresenting() { return }
        let loc = event.location(in: self)
        let prevLoc = previousLocation
        let d = CGVector(dx: (loc.x - prevLoc.x), dy: (loc.y - prevLoc.y))
        host.touchMoved(d)
        previousLocation = loc
    }
    #endif
    func mouseScrolled(_ d: CGVector) {
        if checkIfPresenting() { return }
        host.touchMoved(d)
    }
    #if os(iOS) || os(tvOS)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if checkIfPresenting() { return }
        for i in touches {
            if i.phase == .moved {
                let loc = i.location(in: self)
                let prevLoc = i.previousLocation(in: self)
                let d = CGVector(dx: (loc.x - prevLoc.x), dy: (loc.y - prevLoc.y))
                #if os(tvOS)
                cursorX = d.dx
                cursorY = d.dy
                //cursorMoved(d)
                #elseif os(iOS)
                host.touchMoved(d)
                #endif
            }
        }
    }
    #endif
    
    var cursorPosition: CGPoint = .midScreen
    var cursor: SKShapeNode?
    var cursorX: CGFloat = 0
    var cursorY: CGFloat = 0
    func cursorBegan() {
        if !tooLate {
            removeAction(forKey: "FADE")
        }
        tooLate = false
        
        if cursor == nil {
            cursor = SKShapeNode.init(circleOfRadius: 25)
            cursor?.zPosition = .infinity
            cursor?.fillColor = .black
            cursor?.strokeColor = .white
            cursor?.alpha = 0
            cursor?.position = cursorPosition
            addChild(cursor!)
            cursor?.run(.fadeIn(withDuration: 0.2))
        }
        
    }
    
    var tooLate = false
    func cursorEnded() {
        run(.sequence([.wait(forDuration: 1), .run {
            if self.cursorX == 0, self.cursorY == 0 {
                self.tooLate = true
                
                if let c = self.cursor {
                    self.cursor = nil
                    self.cursorPress(c)
                    
                    c.removeAllActions()
                    self.cursorPosition = c.position
                    
                    c.run(.sequence([.fadeOut(withDuration: 0.2), .removeFromParent()]), withKey: "BYE")
                    
                }
                
            }
        }]), withKey: "FADE")
    }
    
    func cursorPress(_ c: SKNode) {
        let n = self.nodes(at: c.position)
        self.host.touchBegan(c.position, n)
        self.host.touchEnded(c.position, n)
    }
    
    func dragged(_ d: CGVector) {
        cursorX = d.dx
        cursorY = d.dy
        //host.touchMoved(d)
    }
    
}

*/
