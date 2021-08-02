//
//  GameScene.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 7/31/21.
//

//import SpriteKit
import GameplayKit
import Magic



class GameScene: SKScene {
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
            EverMazeSceneHost.screens = n
            view?.presentScene(EverMazeSceneHost.init(from: true))
        }
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let num = nodes(at: touches.first?.location(in: self) ?? .zero).first(where: { Int($0.name ?? "") != nil }),
           let n = Int(num.name ?? "") {
            EverMazeSceneHost.screens = n
            view?.presentScene(EverMazeSceneHost.init(from: true))
        }
    }
    #endif
    
}
