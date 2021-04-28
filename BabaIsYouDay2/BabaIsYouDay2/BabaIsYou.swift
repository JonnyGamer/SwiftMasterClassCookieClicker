//
//  BabaIsYou.swift
//  BabaIsYouDay2
//
//  Created by Jonathan Pappas on 4/28/21.
//

import Foundation
import SpriteKit

typealias FakeCGPoint = (x: Int, y: Int)

enum ObjectType: String {
    case baba, wall, flag, rock
    
    case recursive = "r"
    
    case stop, win, you, push
    
    case `is`
}

var rules: [ObjectType:[ObjectType]] = [
    .baba:[.you]
]


class Objects: Equatable {
    
    static func == (lhs: Objects, rhs: Objects) -> Bool {
        // Remember to Fix for recursive objects
        return lhs.objectType == rhs.objectType
    }
    
    var objectType: ObjectType {
        didSet {
            updateImage()
        }
    }
    
    var recursiveObjectType: ObjectType = .baba
    
    var position: FakeCGPoint = (0,0) {
        // STEP 5
        didSet { sprite.position = .init(x: position.0 * spriteGrid, y: position.1 * spriteGrid) }
    }
    
    var triedToMove = false
    var sprite: SKSpriteNode!
    
    required init(_ o: ObjectType) {
        objectType = o
        updateImage()
    }
    
    // Step n. Work on this
    func updateImage() {
        var imageName = objectType.rawValue
        sprite = .init(imageNamed: imageName)
    }
    
    // Step n. Work on the Static funcs
    
}

           // Step 3, conform to CustomStringConvertible
class Game: CustomStringConvertible {
    
    // STEP 4 (Print out the grid)
    var description: String {
        var magOP = ""
        for i in 0..<Int(gridSize.y) {
            var op = ""
            (0..<Int(gridSize.x)).forEach { op += trueFindAtLocation(($0, i))?.objectType.rawValue ?? "." }
            magOP = "\(op)\n" + magOP
        }
        return "---\n" + magOP + "---"
    }
    
    // STEP 1 - Find the objects at a specific location
    func findAtLocation(_ currentPos: FakeCGPoint, moveX: Int, moveY: Int) -> [Objects]? {
        let yo = currentPos.y + moveY
        if yo < 0 || yo >= gridSize.y { return nil }
        
        let xo = currentPos.x + moveX
        if xo < 0 || xo >= gridSize.x { return nil }
        
        return totalObjects.filter { $0.position == (xo, yo) }// (totalObjects.first(where: { $0.position == (xo, yo) }), true)
    }
    func trueFindAtLocation(_ currentPos: FakeCGPoint) -> Objects? {
        return totalObjects.first(where: { $0.position == currentPos })
    }
    
    
    
    var grid: [[Objects?]] = []
    var totalObjects: [Objects] = []
    
    var gridSize: FakeCGPoint = (5,5)
    
    func start() {
        
        grid = [
            [nil, nil, nil, nil, Objects.init(.baba)],
            [nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil],
            [Objects.init(.baba), nil, nil, nil, nil],
        ]
        
        // STEP 2 ish
        gridSize = (grid[0].count, grid.count)
        spriteGrid = 1000 / max(gridSize.x, gridSize.y)
        
        // FOR STEP 2
        var y = grid.count - 1//new
        for i in grid {
            var x = 0//new
            for j in i {
                if let k = j {
                    totalObjects.append(k)
                    // STEP 2 when an object is created, remember it's position
                    k.position = (x, y)
                }
                x += 1//new
            }
            y -= 1//new
        }
        
    }
    
    enum Direction: Int { case up, down, left, right, none
        
        func xMove() -> Int { return [0, 0, -1, 1, 0][self.rawValue] }
        func yMove() -> Int { return [1, -1, 0, 0, 0][self.rawValue] }
        
    }
    
    
    
    func move(_ dir: Direction) -> Bool {
        
        let you = totalObjects.filter {
            rules[$0.objectType]?.contains(.you) == true
        }
        
        for i in you {
            
            // Was pushed
            if i.triedToMove {
                continue
            }
            
            // Step 7 - apply really move (then run project)
            if tryToMove(i, dir) {
                reallyMove(i, dir)
            }
        }
        
        return true
    }
    
    // STEP 6 - check for REALLY Move
    func tryToMove(_ i: Objects,_ dir: Direction) -> Bool {
        //i.triedToMove = true
        
        guard let f = findAtLocation(i.position, moveX: dir.xMove(), moveY: dir.yMove()) else {
            return false
        }
        return true
    }
    
    
    func reallyMove(_ i: Objects,_ dir: Direction) -> Bool {
        if i.triedToMove { return false }
        i.triedToMove = false
        
        i.position.x += dir.xMove()
        i.position.y += dir.yMove()
        return true
    }
    
    
    
}


// STEP n. Awesome filtering methods
extension Dictionary where Key == ObjectType, Value == [ObjectType] {
    subscript(_ this: [ObjectType]) -> Value {
        return this.map { self[$0] ?? [] }.flatMap { $0 }
    }
}
extension Array where Element == Objects {
    var objectTypes: [ObjectType] {
        return self.map { $0.objectType }
    }
    func firstWith(_ type: ObjectType) -> Objects {
        return first(where: { rules[$0.objectType]?.contains(type) == true })!
    }
    func allThatAre(_ type: ObjectType) -> [Objects] {
        return filter { rules[$0.objectType]?.contains(type) == true }
    }
    func allThatAreNot(_ type: [ObjectType]) -> [Objects] {
        return filter { Set(type).intersection(rules[$0.objectType] ?? []).isEmpty }
    }
    func allContain(_ type: ObjectType) -> Bool {
        return filter { rules[$0.objectType]?.contains(type) == false }.isEmpty
    }
}

