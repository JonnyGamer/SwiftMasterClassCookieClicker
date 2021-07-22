//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import SpriteKit

var (w, h): (CGFloat, CGFloat) = (1000, 1000)

class GameScene: HostingScene {
    override func didMove(to view: SKView) {
        screens = Int.random(in: 1...4)
        launchScene = Scene1.self
        super.didMove(to: view)
    }
}

//class GameScene2: HostingScene {
//    override func didMove(to view: SKView) {
//        screens = 4
//        launchScene = Scene1.self
//        super.didMove(to: view)
//    }
//}
