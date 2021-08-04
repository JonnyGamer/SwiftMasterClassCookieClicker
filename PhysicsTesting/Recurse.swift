//
//  Recurse.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/3/21.
//

import Magic


//class RecurseHostScene: HostingScene {
//    override func didMove(to view: SKView) {
//        launchScene = GameScene2.self
//        super.didMove(to: view)
//    }
//}
//
//
//class GameScene2: MagicHostingNode {
//    var oof = 0
//    var recursed: [SKNode] = []
//    
//    override func begin() {
//        print("woot")
//        super.begin()
//        backgroundColor(.black)
//        do {
//            var playerNodes: [SKNode] = []
//            
//            for i in 1...4 {
//                let n1 = SKSpriteNode.init(color: .white, size: .hundred)
//                let textBar = SKLabelNode.init(text: "\(Int.random(in: 1...4))")
//                textBar.fontColor = .black
//                textBar.fontSize = 70
//                textBar.keepInside(n1.size.halved)
//                textBar.centerOn(n1)
//                n1.addChild(textBar)
//                playerNodes.append(n1.padding)
//                n1.name = "\(i)"
//            }
//            
//            let playerSelect = HStack.init(nodes: playerNodes)
//            addChild(playerSelect)
//            playerSelect.centerAt(point: .zero)
//        }
//    }
//    
//    #if os(macOS)
//    override func mouseDown(with event: NSEvent) {
//        launchScene = GameScene2.self
//        print(oof, c)
//        
//        super.mouseDown(with: event)
//        
//        if !recursed.isEmpty {
//            return
//        }
//        if let num = nodes(at: event.location(in: self)).first(where: { Int($0.name ?? "") != nil }),
//           let n = Int(num.name ?? "") {
//            //EverMazeSceneHost.screens = n
//            //let sc = EverMazeSceneHost.init(from: true)
//            
//            let sc = GameScene2.init() // GameScene2
//            //sc.launchScene = launchScene
//            sc.width = width + 40
//            sc.height = height + 40 // (or * 1.1)
//            
//            sc.screens = n
//            sc.oof = oof + 1
//            print(sc.oof)
//            sc.setScale(xScale * 0.9)
//            if sc.size.width < 0 {
//                return
//            }
//            removeAllChildren()
//            sc.framed(.black)
//            addChild(sc.parent!)
//            sc.position.x -= width/2
//            sc.position.y -= height/2
//            
//            sc.begin()
//            alpha = 0.5
//            //c.append(<#T##newElement: SKNode##SKNode#>)
//            
//            recursed.append(sc)
//            
//            print(c)
//        }
//    }
//    #endif
//    
////    #if os(iOS)
////    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
////        if let num = nodes(at: touches.first?.location(in: self) ?? .zero).first(where: { Int($0.name ?? "") != nil }),
////           let n = Int(num.name ?? "") {
////            EverMazeSceneHost.screens = n
////            let sc = EverMazeSceneHost.init(from: true)
////            sc.scaleMode = .aspectFit
////            view?.presentScene(sc)
////        }
////    }
////    #endif
//}
