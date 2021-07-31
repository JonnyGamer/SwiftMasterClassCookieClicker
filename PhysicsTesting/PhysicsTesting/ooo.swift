//
//  ooo.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 7/31/21.
//

import Magic

class EverMazeSceneHost: HostingScene {
    
    override func didMove(to view: SKView) {
        //EverMazeSceneHost.screens = 2//Int.random(in: 1...4)
        launchScene = EverMazeScene.self
        EverMazeScene.winner = -2
        super.didMove(to: view)
        
        super.didMove(to: view)
        
    }
}
