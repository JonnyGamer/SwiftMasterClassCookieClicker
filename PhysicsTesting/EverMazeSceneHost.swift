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
    var levelSize: [Int] = [5,5]
    convenience init(sizePlease: [Int]) {
        self.init(from: true)
        levelSize = sizePlease
    }
    
    override func didMove(to view: SKView) {
        launchScene = EverMazeScene.self
        EverMazeScene.winner = -2
        super.didMove(to: view)
        
        //let uwu = NewEverMaze.regularPuzzle([5,5])
        
        //let uwu = NewEverMaze.init(LARGESTMAZES.levelEVIL9, printo: true)
        
        super.didMove(to: view)
        
        for i in c {
            let uwu = NewEverMaze.nPlayerPuzzle(players: 3, levelSize)// .regularPuzzle(levelSize)
            (i.children.first as? EverMazeScene)?.addEverMaze(uwu.copy())// ?.o.everMaze = uwu
        }
    }
}

// Extra Extensions
extension Array where Element == Int {
    func next() -> Self {
        return map { $0 + 1 }
    }
}
extension NewEverMaze {
    static func regularPuzzle(_ someSize: [Int]) -> NewEverMaze {
        let xrand = Int.random(in: 0...(someSize[0]-1))
        let yrand = Int.random(in: 0...(someSize[1]-1))
        
        let uwu = NewEverMaze.init(
            someSize,
            [.init(covers: [[0,0]], position: [xrand, yrand])],
            randomWalls: { .random() && .random() }
        )
        uwu.makeMaze()
        
        if (uwu.end?.movements.count ?? 0) < min(someSize[0], someSize[1]) {
            return regularPuzzle(someSize)
        }
        
        return uwu
    }
    
    static func nPlayerPuzzle(players: Int,_ someSize: [Int]) -> NewEverMaze {
        var rands: Set<MovableDots> = []
        this: for _ in 1...players {
            if !rands.isEmpty {
                for _ in 1...100 {
                    let xrand = Int.random(in: 0...(someSize[0]-1))
                    let yrand = Int.random(in: 0...(someSize[1]-1))
                    let poso = Pos([xrand, yrand])
                    if !rands.contains(where: { $0.position == poso }) {
                        rands.insert(.init(covers: [[0,0]], position: poso))
                        continue this
                    }
                }
                fatalError("Not enough spaces bro...")
            } else {
                let xrand = Int.random(in: 0...(someSize[0]-1))
                let yrand = Int.random(in: 0...(someSize[1]-1))
                rands.insert(.init(covers: [[0,0]], position: [xrand, yrand]))
            }
        }
        
        let uwu = NewEverMaze.init(
            someSize,
            rands,
            randomWalls: { .random() && .random() }
        )
        uwu.makeMaze()
        
        if (uwu.end?.movements.count ?? 0) < min(someSize[0], someSize[1]) {
            return nPlayerPuzzle(players: players, someSize)
        }
        
        return uwu
    }
}
