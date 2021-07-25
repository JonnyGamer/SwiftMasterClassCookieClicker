//
//  DecodeEverMaze.swift
//  EverMaze2
//
//  Created by Jonathan Pappas on 1/26/21.
//

import Foundation
#if !os(macOS)
import UIKit
#endif

#if os(macOS)
import Cocoa
#endif

var everMazeVersion = 1

// Ever Maze Link Qualities
// v1 - Version History, So we now how it should be built
// size x, y - dimensions of the grid
// start x, y - start position
// end x, y - end point position
// length Int - solution goal
// Missed Int - Puzzles needed to generate ;)
// seed Int - Seed Used to Generate the Maze

var misses = 0
var magicText = ""

extension NewEverMaze {
    func saveDeepLink() {
        var deep = "evermaze://"
        
        deep += "v\(everMazeVersion)."
        deep += "size\(size[0]),\(size[1])."
        deep += "seed\(seed)."
        if end?.characters.first != nil {
            deep += "end0\(end!.characters.first!.position.x),\(end!.characters.first!.position.y)."
        }
        if start?.characters.first != nil, start?.characters.first?.position != Pos([0,0]) {
            deep += "sta0\(start!.characters.first!.position.x),\(start!.characters.first!.position.y)."
        }
        if misses > 0 {
            deep += "miss\(misses)."
        }
        //deep += "wall4."
        if end != nil {
            deep += "solu\(end!.movements.count)."
        }
        
        magicText = deep
        print(magicText)
        
        #if os(iOS)
        UIPasteboard.general.string = deep
        #endif
        #if os(macOS)
        NSPasteboard.general.setString(deep, forType: .string)
        #endif
    }
}

extension NewEverMaze {
    convenience init(parseDeepLink: String) {
        self.init([],[],randomWalls: { oneIn(4) })
        
        // Decrypt Parse Deep Link
        var decryptedLevel = parseDeepLink
        
        if decryptedLevel.hasPrefix("evermaze://") {
            decryptedLevel = decryptedLevel.dropFirst(11).s
        }
        
        let splittedLevel = decryptedLevel.split(separator: ".").map { $0.s }
        
        if let foo = splittedLevel.first, foo.hasPrefix("v"), let versionNumber = Int(foo.dropFirst()) {
            
            switch versionNumber {
            case 1: self.init(v1: splittedLevel)
            default: fatalError()
            }
        } else {
            fatalError()
        }
        
        saveDeepLink()
    }
}
// evermaze://v1.size5,5.seed1
extension NewEverMaze {
    convenience init(v1: [String]) {
        self.init([],[],randomWalls: { oneIn(4) })
        var generateNTimes = 0
        var atLeast = 2
        
        for line in v1 {
            
            // Parse the size = 'size5,5'
            if line.hasPrefix("size") {
                let sizeArray = line.dropFirst(4).s.split(separator: ",")
                size = sizeArray.map { Int($0.s)! }
            }
            
            // Parse the size = 'end5,5'
            else if line.hasPrefix("end0") {
                let endPosition = line.dropFirst(4).s.split(separator: ",")
                let endCovers: Set<Pos> = [Pos(size.map { _ in 0 })]
                let endLocation = Pos(endPosition.map { Int($0.s)! })
                end = .init([], [.init(covers: endCovers, position: endLocation)])
            }
            
            // Parse the size = 'end5,5'
            else if line.hasPrefix("sta0") {
                let startPosition = line.dropFirst(4).s.split(separator: ",")
                let startCovers: Set<Pos> = [Pos(size.map { _ in 0 })]
                let startLocation = Pos(startPosition.map { Int($0.s)! })
                
                characters = [.init(covers: startCovers, position: startLocation)]
                start = .init([], characters)
                
                //characters = [.init([], [.init(covers: startCovers, position: startLocation)])]
                //start = .init([], [.init(covers: startCovers, position: startLocation)])
            }
            
            // Parse the seed 'seed1837'
            else if line.hasPrefix("seed") {
                let seedo = line.dropFirst(4).s
                seed = Int(seedo)!
                //g = SeededGenerator.init(seed: UInt64(seed)!)
            }
            
            // Parse the wall type 'wall4' (walls appear 1 in 4)
            else if line.hasPrefix("wall") {
                let wallType = line.dropFirst(4).s
                randomWalls = { oneIn(Int(wallType)!) }
            }
            
            // Parse how many puzzles get passed over: miss4
            else if line.hasPrefix("miss") {
                let miss = line.dropFirst(4).s
                generateNTimes = Int(miss)!
            }
            
            // Create the solution length: 'solu100' - (Goal is 100 movees :0)
            else if line.hasPrefix("solu") {
                atLeast = Int(line.dropFirst(4).s)!
                end?.movements = [Pos].init(repeating: [], count: atLeast)
            }
        }
        
        // If Start is `nil`, create it at `0,0`
        if start == nil {
            let startCovers: Set<Pos> = [Pos(size.map { _ in 0 })]
            let startLocation = Pos(size.map { _ in 0 })
            
            characters = [.init(covers: startCovers, position: startLocation)]
            start = .init([], characters)
        }
        
        // If end is nil, create the mazo
        if end == nil {
            misses = -1
            for _ in 0..<generateNTimes {
                misses += 1
                walls = []
                makeMazeFAST()
            }
            
            misses += 1
            walls = []
            makeMaze()
            
            while end!.movements.count < atLeast {
                misses += 1
                walls = []
                makeMaze()
            }
            
        } else {
            misses = -1
            for _ in 0...generateNTimes {
                misses += 1
                walls = []
                makeMazeFAST()
            }
        }
        
        saveDeepLink()
    }
}


extension NewEverMaze {
    convenience init(_ from: String, printo: Bool = true) {
        
        self.init([],[],randomWalls: { fiftyFifty() })
        var onStart = true
        var capturedEffect = false
        var movementos: [Pos] = []
        
        for line in from.split(separator: "\n") {
            
            if line.hasPrefix("Ever Maze v") {
                if let versionNum = Int(line.dropFirst(11).s), versionNum > everMazeVersion {
                    if printo { print("Invalid Version Number... Please update your app!") }
                    fatalError()
                }
            } else if line.hasPrefix("dimensions: ") {
                if case let dimen = line.dropFirst(12).s, let resolved = Array<Int>(dimen) {
                    if printo { print("Dimension: \(resolved)") }
                    size = resolved
                }
            } else if line.hasPrefix("    - characters: ") {
                end = .init([], [])
                if onStart {
                    onStart.toggle()
                    let getDict = line.dropFirst("    - characters: ".count).s
                    if let resolved = [[[Int]:[[Int]]]](getDict) {
                        if printo { print("START POSITIONS: \(resolved)") }
                        var newSaveMove = SaveMovement.init([], [])
                        for res in resolved {
                            let wow = res.values.reduce(into: [[Int]]()) { $0 += $1 }
                            let hereItIs: Set<Pos> = wow.reduce(into: Set<Pos>()) { $0 = $0.union([Pos($1)]) }
                            newSaveMove.characters.insert(.init(covers: hereItIs, position: .init(res.keys.first!)))
                        }
                        start = newSaveMove
                        characters = start!.characters
                    }
                } else {
                    let getDict = line.dropFirst("    - characters: ".count).s
                    if let resolved = [[[Int]:[[Int]]]](getDict) {
                        if printo { print("END POSITIONS: \(resolved)") }
                        var newSaveMove = SaveMovement.init([], [])
                        for res in resolved {
                            let wow = res.values.reduce(into: [[Int]]()) { $0 += $1 }
                            let hereItIs: Set<Pos> = wow.reduce(into: Set<Pos>()) { $0 = $0.union([Pos($1)]) }
                            newSaveMove.characters.insert(.init(covers: hereItIs, position: .init(res.keys.first!)))
                        }
                        end = newSaveMove
                        end?.movements = movementos
                    }
                }
            } else if line.hasPrefix("    - movement: ") {
                let getDict = line.dropFirst("    - movement: ".count).s
                if let resolved = [[Int]](getDict) {
                    movementos = resolved.reduce([Pos]()) { $0 + [Pos($1)] }
                    //total = end?.movements.count ?? -1
                }
            
            } else if line.hasPrefix("[true") || line.hasPrefix("[false") {
                capturedEffect = true
                
                if let wow = Array<Bool>.init(line.s) {
                    walls = wow
                }
                
            } else if line.hasPrefix("[r") {
                if line.s == "[r]" {
                    let newWalrus = [Bool].init(repeating: { oneIn(4) }, count: size[0])
                    walls = newWalrus + walls
                } else if line.s == "[rr]" {
                    let newWalrus = [Bool].init(repeating: { oneIn(4) }, count: size[0])
                    walls = newWalrus + walls
                }
                
            } else if !capturedEffect, line.hasPrefix("[") {
                var newWalrus = [Bool]()
                loop: for hello in line {
                    if "[]".contains(hello) { continue loop }
                    if hello.s == "R" {
                        newWalrus.append(oneIn(4))
                    } else {
                        newWalrus.append(hello.s == "•")
                    }
                }
                walls = newWalrus + walls
            }
        }
        
        if printo { print("–––––") }
        if printo { print(walls) }
        printMe()
        
        //makeMaze()
        if printo { print(end!.movements) }
        
    }
    
    func buildMazeVersion1(_ from: String) {
        
    }
    
}



extension NewEverMaze {
    public func makeMazeFAST() {
        let d1 = Date().timeIntervalSince1970
        let repeatLoop = Pos(.init(repeating: 0, count: size.count))
        let repeatLoopCount = size.count
        
        if walls.isEmpty {
            walls = .init(repeating: randomWalls, count: size.multiplication())
            
            // Keep clear all characters from the walls.
            for i in characters {
                walls = i.clearWalls(size, walls)
            }
        }
        
//        var blueBlocks = [SaveMovement([], characters)]
//        var totalBlocks = Set(blueBlocks)
//        var lastSeenCharacters = blueBlocks[0]
//
//        while let newBlueBlock = blueBlocks.first {
//
//            for j in 0..<repeatLoopCount {
//                for k in [1,-1] {
//                    // Create the movement direction
//                    var newDirection = repeatLoop
//                    newDirection.positions[j] = k
//                    // Slide time! (All Nodes get to SLIDE!)
//                    if let newBlock = moveCharacter(newBlueBlock, newDirection) {
//                        if totalBlocks.insert(newBlock).inserted {
//                            blueBlocks.append(newBlock)
//                        }
//                    }
//                }
//            }
//
//            blueBlocks.removeFirst()
//            lastSeenCharacters = newBlueBlock
//        }
//
//        start = SaveMovement([], characters)
//        end = lastSeenCharacters
//        totalMazeCount = totalBlocks.count
        let d2 = Date().timeIntervalSince1970
        totalTime = Double(Int((d2 - d1) * 100)) / 100
    }
}
