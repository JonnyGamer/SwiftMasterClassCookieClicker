//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import SpriteKit

var (w, h): (CGFloat, CGFloat) = (1000, 1000)

class EverMazeSceneHost: HostingScene {
    override func didMove(to view: SKView) {
        //EverMazeSceneHost.screens = 2//Int.random(in: 1...4)
        launchScene = EverMazeScene.self
        EverMazeScene.winner = -2
        super.didMove(to: view)
        
        let uwu = NewEverMaze.init(LARGESTMAZES.levelEVIL9, printo: true)
        //uwu.makeMaze()
        
//        var uwu = NewEverMaze.init(
//            [SaveData.trueLevel,SaveData.trueLevel],
//            [
//                .init(covers: [[0,0],[0,2]], position: [0,0]),
//                .init(covers: [[0,0]], position: [1,1]),
//                //.init(covers: [[0,0]], position: [2,2])
//            ],
//            randomWalls: { oneIn(4) }
//        )
//        uwu.makeMaze()
//        while (uwu.end?.movements.count ?? 0) < SaveData.trueLevel {
//            uwu = NewEverMaze.init(
//                [SaveData.trueLevel,SaveData.trueLevel],
//                [
//                    .init(covers: [[0,0],[0,2]], position: [0,0]),
//                    .init(covers: [[0,0]], position: [1,1]),
//                ],
//                randomWalls: { oneIn(4) }
//            )
//            uwu.makeMaze()
//        }
        
        super.didMove(to: view)
        
        for i in c {
            (i.children.first as? EverMazeScene)?.addEverMaze(uwu.copy())// ?.o.everMaze = uwu
        }
    }
}

//class EverMazeSceneHost: HostingScene {
//    override func didMove(to view: SKView) {
//        screens = 4
//        launchScene = EverMazeScene.self
//    }
//}

//class GameScene2: HostingScene {
//    override func didMove(to view: SKView) {
//        screens = 4
//        launchScene = Scene1.self
//        super.didMove(to: view)
//    }
//}
