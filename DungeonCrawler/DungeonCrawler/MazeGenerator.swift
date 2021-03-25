//
//  MazeGenerator.swift
//  DungeonCrawler
//
//  Created by Jonathan Pappas on 3/25/21.
//

import Foundation

struct Maze {
    var paths: [[Int]]
    let w: Int
    let h: Int
    init(_ width: Int,_ height: Int) {
        w = width; h = height
        paths = Array(repeating: Array(repeating: 0, count: w), count: h)
    }
    init() { self.init(1, 1) }
}

struct MakeMaze {
    
    var maze = Maze(10,10)
    mutating func jonnyMazeAlgorithm() {
        var distanceTracker = Array(repeating: Array(repeating: 0, count: maze.w), count: maze.h)
        var numbers = Array(1...(maze.w * maze.h))
        numbers.shuffle()
        var totalCellsFound = 1
        
        var ePoint = maze.w / 2// 0//findElement(numbers, 1)
        //start = (maze.w / 2,0)//(ePoint % maze.w, ePoint / maze.w)
        for i in 1...(maze.w * maze.h) {
            let sPoint = ePoint
            //ePoint = findElement(numbers, i + 1)
            
            let xDist = (ePoint % maze.w) - (sPoint % maze.w)
            var dir = xDist.signum()
            if dir != 0 {
                for i in 1...Int(abs(xDist)) {
                    if maze.paths[sPoint / maze.w][(sPoint + (i * dir)) % maze.w] == 0 {
                        totalCellsFound += 1
                        // distanceTracker[sPoint / maze.w][(sPoint + (i * dir)) % maze.w] = maze.paths[sPoint / maze.w][(sPoint + (i * dir) - dir) % maze.w] + 1
                        distanceTracker[sPoint / maze.w][(sPoint + (i * dir)) % maze.w] = distanceTracker[sPoint / maze.w][(sPoint + ((i - 1) * dir)) % maze.w] + 1
                        maze.paths[sPoint / maze.w][(sPoint + (i * dir)) % maze.w] += (dir == 1 ? 8 : 2)
                        maze.paths[sPoint / maze.w][(sPoint + ((i - 1) * dir)) % maze.w] += (dir == 1 ? 2 : 8)
                    }
                }
            }
            let yDist = (ePoint / maze.w) - (sPoint / maze.w)
            dir = yDist.signum()
            if dir != 0 {
                for i in 1...Int(abs(yDist)) {
                    if (sPoint / maze.w) + (i * dir) == maze.w {
                        
                        for i in 0..<maze.paths.count {
                            for j in 0..<maze.paths[i].count {
                                maze.paths[i][j] = 0
                            }
                        }
                        
                        jonnyMazeAlgorithm()
                        return
                    }
                    if maze.paths[(sPoint / maze.w) + (i * dir)][(sPoint + xDist) % maze.w] == 0 {
                        totalCellsFound += 1
                        distanceTracker[(sPoint / maze.w) + (i * dir)][(sPoint + xDist) % maze.w] = distanceTracker[(sPoint / maze.w) + ((i - 1) * dir)][(sPoint + xDist) % maze.w] + 1
                        // distanceTracker[(sPoint / maze.w) + (i * dir)][(sPoint + xDist) % maze.w] = maze.paths[(sPoint / maze.w) + (i * dir) - dir][(sPoint + xDist) % maze.w] + 1
                        maze.paths[(sPoint / maze.w) + ((i - 1) * dir)][(sPoint + xDist) % maze.w] += (dir == 1 ? 4 : 1)
                        maze.paths[(sPoint / maze.w) + (i * dir)][(sPoint + xDist) % maze.w] += (dir == 1 ? 1 : 4)
                    }
                }
            }
            if totalCellsFound == maze.w * maze.h {
                //end = distanceTracker
                return
            }
        }

    }

    
}
