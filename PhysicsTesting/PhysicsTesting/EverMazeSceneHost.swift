//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Magic
import EverMazeKit

var (w, h): (CGFloat, CGFloat) = (1000, 1000)

class EverMazeSceneHost: HostingScene {
    override func didMove(to view: SKView) {
        //EverMazeSceneHost.screens = 2//Int.random(in: 1...4)
        launchScene = EverMazeScene.self
        EverMazeScene.winner = -2
        super.didMove(to: view)
        
        let uwu = NewEverMaze.init(LARGESTMAZES.levelEVIL9, printo: true)
        
        super.didMove(to: view)
        
        for i in c {
            (i.children.first as? EverMazeScene)?.addEverMaze(uwu.copy())// ?.o.everMaze = uwu
        }
    }
}
