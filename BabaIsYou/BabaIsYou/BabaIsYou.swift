//
//  BabaIsYou.swift
//  BabaIsYou
//
//  Created by Jonathan Pappas on 3/22/21.
//

import Foundation
import SpriteKit

typealias FakeCGPoint = (x: Int, y: Int)

enum ObjectType: String {
    static var real: [ObjectType] = [.baba, .wall, .flag]
    
    case baba// = "B"
    case wall// = "w"
    //case bush = "b"
    case flag// = "f"
    
    case recursive = "r"
    
    case stop
    case die
    case win
    case you
    case `is`// = "is"
    case push// = "push"
}


class Objects {
    var objectType: ObjectType {
        didSet { updateImage() }
    }
    var position: (x: Int, y: Int) = (0, 0) {
        didSet { sprite.position = .init(x: position.0 * spriteGrid, y: position.1 * spriteGrid) }
    }
    var recursiveObjectType: ObjectType = .baba {
        didSet { updateImage() }
    }
    var triedToMove = false
    var sprite: SKSpriteNode!
    
    func updateImage() {
        var imageName = objectType.rawValue
        if objectType == .recursive { imageName = recursiveObjectType.rawValue + "String" }
        sprite = .init(imageNamed: imageName)
        sprite.size = CGSize.init(width: spriteGrid, height: spriteGrid)
        sprite.texture?.filteringMode = .nearest
    }
    
    required init(_ o: ObjectType) {
        objectType = o
    }
    
    static func Flag() -> Self { return Self.init(.flag) }
    static func Baba() -> Self { return Self.init(.baba) }
    static func Wall() -> Self { return Self.init(.wall) }
    static func Recursive(_ n: ObjectType) -> Self {
        let foo = Self.init(.recursive)
        foo.recursiveObjectType = n
        return foo
    }
}


class Game: CustomStringConvertible {
    var description: String {
        var magOP = ""
        for i in 0..<Int(gridSize.y) {
            var op = ""
            (0..<Int(gridSize.x)).forEach { op += trueFindAtLocation(($0, i))?.objectType.rawValue ?? "." }
            magOP = "\(op)\n" + magOP
        }
        return "---\n" + magOP + "---"
    }
    
    var alive = true
    var gridSize: FakeCGPoint = (0, 0)
    var totalObjects: [Objects] = []
    var grid: [[Objects?]] = []
    
    func start() {
        
        grid = [
            [nil, nil, nil, nil, nil, .Wall()],
            [.Recursive(.baba), .Recursive(.is), .Recursive(.you), nil, nil, nil],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .Recursive(.wall), .Recursive(.is), .Recursive(.push)],
            [.Wall(), nil, nil, nil, nil, nil],
            [.Baba(), nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .Recursive(.flag), .Recursive(.is), .Recursive(.win)],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil],
        ]
        
        fixGrid()
    }
    
    func fixGrid() {
        gridSize = (grid[0].count, grid.count)
        spriteGrid = 1000 / max(gridSize.x, gridSize.y)
        //imageGrid = 1000 / min(gridSize.x, gridSize.y)
        grid.forEach { i in i.forEach { j in j?.updateImage() } }
        
        for i in 0..<Int(gridSize.y) {
            let y = Int(gridSize.y) - i - 1
            
            for j in 0..<Int(gridSize.x) {
                let x = j//gridSize.x - j - 1
                
                if let wow = grid[y][x] {
                    wow.position = (j, i)
                    totalObjects.append(wow)
                }
                
            }
        }
        
        findAllMatches()
        print(self)
    }
    
    var flounder: [ObjectType:[ObjectType]] = [:]
    
    func findAllMatches() {
        var newFlounder: [ObjectType:[ObjectType]] = [
            .recursive:[.push],
            //.wall:[.push],
        ]
        
        let iso = totalObjects.filter { $0.objectType == .recursive && $0.recursiveObjectType == .is }
        
        for i in iso {
            // check up is down
            let check10 = findAtLocation(i.position, moveX: -1, moveY: 0)
            let check11 = findAtLocation(i.position, moveX: 1, moveY: 0)
            if let c10 = check10?.0, let c11 = check11?.0 {
                if c10.objectType == .recursive, c11.objectType == .recursive {
                    newFlounder[c10.recursiveObjectType] = (newFlounder[c10.recursiveObjectType] ?? []) + [c11.recursiveObjectType]
                }
            }
            // check n is m (left is right)
            let check20 = findAtLocation(i.position, moveX: 0, moveY: 1)
            let check21 = findAtLocation(i.position, moveX: 0, moveY: -1)
            if let c10 = check20?.0, let c11 = check21?.0 {
                if c10.objectType == .recursive, c11.objectType == .recursive {
                    newFlounder[c10.recursiveObjectType] = (newFlounder[c10.recursiveObjectType] ?? []) + [c11.recursiveObjectType]
                }
            }
        }
        
        for i in totalObjects {
            if ObjectType.real.contains(i.objectType) {
                if let cops = newFlounder[i.objectType]?.first(where: { ObjectType.real.contains($0) }) {
                    i.objectType = cops
                }
            }
        }
        
        if !newFlounder.contains(where: { $0.value.contains(.you) }) {
            print("GAME OVER BRUH")
            alive = false
            return
        }
        if !totalObjects.contains(where: { newFlounder[$0.objectType]?.contains(.you) == true }) {
            print("ALSO GAME OVER BRUH")
            alive = false
            return
        }
        alive = true
        flounder = newFlounder
    }
    
    
    @discardableResult
    func move(_ dir: Cardinal) -> Bool {
        if !alive { return false }
        
        undo.append(totalObjects.map { ($0, $0.position, $0.objectType) })
        var didAnythingMove = false
        
        let you = totalObjects.filter { $0.objectType == .you || flounder[$0.objectType]?.contains(.you) == true }
        
        for i in you {
            if i.triedToMove {
                print("\(i.objectType) was already pushed")
                continue
            }
            
            if tryToMove(i, dir) {
                didAnythingMove = true
            } else {
                print("You did not move up!")
            }
            
        }
        
        for i in totalObjects {
            i.triedToMove = false
        }
        
        
        findAllMatches()
        return didAnythingMove
    }
    
    enum Cardinal: Int { case up, down, left, right, none
        func xMove() -> Int { return [0, 0, -1, 1, 0][self.rawValue] }
        func yMove() -> Int { return [1, -1, 0, 0, 0][self.rawValue] }
    }
    
    func tryToMove(_ i: Objects,_ dir: Cardinal) -> Bool {
        i.triedToMove = true
        
        guard let f = findAtLocation(i.position, moveX: dir.xMove(), moveY: dir.yMove()) else { return false }
        guard let found = f.0 else { reallyMove(i, dir); return true }
        
        // Push YOU is first priority
        if flounder[found.objectType]?.contains(.you) == true {
            if tryToMove(found, dir) {
                return reallyMove(i, dir)
            } else {
                return false
            }
        }
        
        // Stop is first priority
        if flounder[found.objectType]?.contains(.stop) == true {
            return false
        }
        
        // Push is first priority
        if flounder[found.objectType]?.contains(.push) == true {
            if tryToMove(found, dir) {
                return reallyMove(i, dir)
            } else {
                return false
            }
        }
        
        // Die is 2nd priority (Destory any objects with a die)
        if flounder[found.objectType]?.contains(.die) == true {
            reallyMove(i, dir)
            totalObjects = totalObjects.filter { $0 !== i }
            return true
        }
        
        // Win is FINAL priority
        if flounder[found.objectType]?.contains(.win) == true {
            reallyMove(i, dir)
            print("YOU WIN THE GAME")
            return false
        }
        
        return false
    }
    
    @discardableResult
    func reallyMove(_ i: Objects,_ dir: Cardinal) -> Bool {
        i.position.x += dir.xMove()
        i.position.y += dir.yMove()
        print("\(i.objectType) Moved (\(dir.xMove()), \(dir.yMove())) spaces")
        return true
    }
    
    func findAtLocation(_ currentPos: FakeCGPoint, moveX: Int, moveY: Int) -> (Objects?, Bool)? {
        let yo = currentPos.y + moveY
        if yo < 0 || yo >= gridSize.y { return nil }
        
        let xo = currentPos.x + moveX
        if xo < 0 || xo >= gridSize.x { return nil }
        
        return (totalObjects.first(where: { $0.position == (xo, yo) }), true)
    }
    func trueFindAtLocation(_ currentPos: FakeCGPoint) -> Objects? {
        return totalObjects.first(where: { $0.position == currentPos })
    }
    
    var undo: [[(Objects, FakeCGPoint, ObjectType)]] = []
    func undoMove() {
        if let woah = undo.last {
            print("TRYING TO UNDO")
            undo.removeLast()
            totalObjects = woah.map {
                $0.0.position = $0.1
                $0.0.objectType = $0.2
                return $0.0
            }
            findAllMatches()
        }
    }
    
}
