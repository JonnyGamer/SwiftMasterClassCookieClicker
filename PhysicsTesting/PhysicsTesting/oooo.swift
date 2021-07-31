//
//  oooo.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 7/31/21.
//

import Magic

class EverMazeScene: SKSceneNode {
    
    static var winner: Int = -2
    var realWinner: Bool = false
    
    override func begin() {
        draggable = false
        backgroundColor(.black)
        
        //print("Let's GOOO!")
        //let uwu = NewEverMaze.init([5,5], [.init(covers: [[0,0]], position: [0,0])], randomWalls: { oneIn(4) })
        //uwu.makeMaze()
    }
    
    override func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {
        addChild(SKLabelNode(text: String(Int.random(in: 1...100000))))
    }
    
    override func touchesMoved(_ at: CGVector) {

    }
    
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
    }
}
