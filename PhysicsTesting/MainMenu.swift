//
//  GameScene.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 7/31/21.
//

//import SpriteKit
import GameplayKit
import Magic

var (w, h): (CGFloat, CGFloat) = (1000, 1000)

class GameScene: HostingScene {
    override func didMove(to view: SKView) {
        
        do {
            var playerNodes: [SKNode] = []
            
            for i in 1...4 {
                let n1 = SKSpriteNode.init(color: .white, size: .hundred)
                let textBar = SKLabelNode.init(text: "\(i)")
                textBar.fontColor = .black
                textBar.fontSize = 70
                textBar.keepInside(n1.size.halved)
                textBar.centerOn(n1)
                n1.addChild(textBar)
                playerNodes.append(n1.padding)
                n1.name = "\(i)"
            }
            
            let playerSelect = HStack.init(nodes: playerNodes)
            addChild(playerSelect)
            playerSelect.centerAt(point: .midScreen)
        }
        
    }
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        if let num = nodes(at: event.location(in: self)).first(where: { Int($0.name ?? "") != nil }),
           let n = Int(num.name ?? "") {
            
            launchScene = DragScene.self
            let sc = DragSceneHost(screens: n)
            
            //launchScene = EverMazeScene.self
            //let sc = EverMazeSceneHost(screens: n)
            
            //launchScene = GameScene2.self
            //let sc = RecurseHostScene(screens: n)
            sc.scaleMode = .aspectFit
            view?.presentScene(sc)
        }
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let num = nodes(at: touches.first?.location(in: self) ?? .zero).first(where: { Int($0.name ?? "") != nil }),
           let n = Int(num.name ?? "") {
            EverMazeSceneHost.screens = n
            let sc = EverMazeSceneHost.init(from: true)
            sc.scaleMode = .aspectFit
            view?.presentScene(sc)
        }
    }
    #endif
    
}
