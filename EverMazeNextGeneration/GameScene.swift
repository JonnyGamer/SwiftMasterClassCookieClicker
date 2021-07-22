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
        screens = 2//Int.random(in: 1...4)
        launchScene = EverMazeScene.self
        super.didMove(to: view)
        
        trueLevel = (10,10)
        let uwu = NewEverMaze.init(
            [trueLevel.0,trueLevel.1],
            [
                .init(covers: [[0,0]], position: [0,0]),
                .init(covers: [[0,0]], position: [1,1])
            ],
            randomWalls: { oneIn(4) }
        )
        uwu.makeMaze()
        
        super.didMove(to: view)
        
        for i in c {
            (i.children.first as? EverMazeScene)?.addEverMaze(uwu.copy())// ?.o.everMaze = uwu
        }
    }
}

class EverMazeSceneHost: HostingScene {
    override func didMove(to view: SKView) {
        screens = 4
        launchScene = EverMazeScene.self
    }
}

//class GameScene2: HostingScene {
//    override func didMove(to view: SKView) {
//        screens = 4
//        launchScene = Scene1.self
//        super.didMove(to: view)
//    }
//}
