//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Magic
import EverMazeKit



class EverMazeSceneHost: HostingScene {
    var levelSize: [Int] = [5,5]
    convenience init(sizePlease: [Int], screens: Int) {
        self.init(screens: screens)
        levelSize = sizePlease
    }
    
    override func didMove(to view: SKView) {
        launchScene = EverMazeScene.self
        EverMazeScene.winner = -2
        super.didMove(to: view)
        //let uwu = NewEverMaze.regularPuzzle([5,5])
        //let uwu = NewEverMaze.init(LARGESTMAZES.levelEVIL9, printo: true)
        for i in c {
            let uwu = NewEverMaze.nPlayerPuzzle(players: 3, levelSize)// .regularPuzzle(levelSize)
            (i.children.first as? EverMazeScene)?.addEverMaze(uwu.copy())// ?.o.everMaze = uwu
        }
    }
}
