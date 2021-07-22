//
//  EverMazeScene.swift
//  EverMazeNextGeneration
//
//  Created by Jonathan Pappas on 7/22/21.
//

import Foundation
import SpriteKit

var trueLevel: (Int, Int) = (0,0)
class EverMazeScene: SKSceneNode {
    
    var o: OO = OO()
    
    override func begin() {
        draggable = false
        backgroundColor(.black)
        
        //print("Let's GOOO!")
        //let uwu = NewEverMaze.init([5,5], [.init(covers: [[0,0]], position: [0,0])], randomWalls: { oneIn(4) })
        //uwu.makeMaze()
    }
    
    func addEverMaze(_ maze: NewEverMaze) {
        let newEverMaze = maze
            .createTileSet(trueLevel)
            .addTo(self)
            //.setPosition(.midScreen)
            //.setSize(maxWidth: w * 0.9, maxHeight: w > h ? h - 200 : h - 300)
        o.everMaze = maze
        o.everNode = newEverMaze
        
        let paddo = newEverMaze.padding
        paddo.centerAt(point: .zero)
        paddo.keepInside(size)
    }
    
    override func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {
        
    }
    
    override func touchesMoved(_ at: CGVector) {
        var swiped: Pos = .init([0,0])
        if abs(at.dx) > abs(at.dy) {
            swiped = .init([at.dx > 0 ? 1 : -1, 0])
        } else {
            swiped = .init([0, at.dy > 0 ? 1 : -1])
        }
        
        let wow = o.everMaze?.swipe(swiped, everNode: o.everNode!)
    }
    
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
    }
}
