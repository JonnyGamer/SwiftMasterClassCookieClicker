//
//  CopyFromBaba.swift
//  DungeonCrawler
//
//  Created by Jonathan Pappas on 3/24/21.
//

import Foundation
import SpriteKit

typealias FakeCGPoint = (x: Int, y: Int)

enum ObjectType: String {
    static var real: [ObjectType] = [.baba, .wall, .flag, .rock, water, skull, lava, ice, jelly, crab, star, keke, love]
    case baba, wall, flag, rock, water, skull, lava, grass, ice, jelly, crab, star, keke, love, algae, door, key, pillar
    
    case recursive = "r"
    case stop
    case defeat
    case win
    case you
    case `is`// = "is"
    case push, sink, hot, melt
    case and, move, open, shut, collect // Move is the only new one
}


class Objects: Equatable {
    
    static func == (lhs: Objects, rhs: Objects) -> Bool {
        if lhs.objectType == .recursive, rhs.objectType == .recursive { return lhs.recursiveObjectType == rhs.recursiveObjectType }
        return lhs.objectType == rhs.objectType
    }
    
    var objectType: ObjectType {
        didSet { updateImage() }
    }
    var position: (x: Int, y: Int) = (0, 0) {
        willSet(to) { halfX = position.x - to.x; halfY = position.y - to.y }
    }
    var position2: (x: Int, y: Int) = (0, 0) {
        didSet { sprite.position = .init(x: position2.0 * spriteGrid, y: position2.1 * spriteGrid) }
    }
    var recursiveObjectType: ObjectType = .baba {
        didSet { updateImage() }
    }
    var triedToMove = false
    var sprite: SKSpriteNode!
    
    var halfX: Int = 0 {
        willSet(to) {
            if to == 0 {
                position2.x = position2.x
            } else if to == 1 {
                sprite.position.x += halfSpriteGrid/4
            } else if to != 1 {
                halfX = ((to % 2) + 10) % 2
                position2.x += to / 2
            }
        }
    }
    
    var halfY: Int = 0 {
        didSet {
            if halfY == 0 {
                position2.y = position2.y
            } else if halfY == 1 {
                sprite.position.x += halfSpriteGrid/4
            } else if halfY != 1 {
                halfY = ((halfY % 2) + 10) % 2
                position2.y += halfY / 2
            }
            
            if halfY == 0 {
                position2.y = position2.y
            } else if halfY == 1 {
                position2.y = position2.y
                //sprite.position.y += 100
            }
        }
    }
    
    func updateImage() {
        var imageName = objectType.rawValue
        if objectType == .recursive { imageName = recursiveObjectType.rawValue + "String" }
        sprite = .init(imageNamed: imageName)
        sprite.size = CGSize.init(width: spriteGrid, height: spriteGrid)
        sprite.texture?.filteringMode = .nearest
        if objectType == .baba { sprite.zPosition = 2 }
        if objectType == .recursive { sprite.zPosition = 1 }
    }
    
    required init(_ o: ObjectType) {
        objectType = o
    }
    
    static func Flag() -> Self { return Self.init(.flag) }
    static func Baba() -> Self { return Self.init(.baba) }
    static func Wall() -> Self { return Self.init(.wall) }
    static func Water() -> Self { return Self.init(.water) }
    static func C(_ n: ObjectType) -> Self { return .init(n) }
    static func R(_ n: ObjectType) -> Self { return Recursive(n) }
    static func Recursive(_ n: ObjectType) -> Self {
        let foo = Self.init(.recursive)
        foo.recursiveObjectType = n
        return foo
    }
    
    static func buildFrom(this: (ObjectType,ObjectType)?) -> Objects? {
        if let t = this {
            return t.0 == .recursive ? .R(t.1) : .C(t.0)
        }; return nil
    }
}

var winDir = Game.Cardinal.none
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
    
    var alive = true, win = false
    var totalObjects: [Objects] = []
    var grid: [[Objects?]] = []
    var gridSize: FakeCGPoint = (0, 0)
    
    func start() {
        grid = BabaIsYouLevels.getLevel(winDir)
        fixGrid()
    }
    
    func fixGrid() {
        gridSize = (grid[0].count, grid.count)
        spriteGrid = 1000 / max(gridSize.x, gridSize.y)
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
    
    func findAllMatches() {
        var newFlounder = flounder
        
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
    func move(_ dir: Cardinal, moveEnemies: Bool = false) -> Bool {
        if !alive { return false }
        
        undo.append(totalObjects.map { ($0, $0.position, $0.objectType) })
        for i in totalObjects { i.triedToMove = false }
        var didAnythingMove = false
        
        let you = totalObjects.filter { $0.objectType == .you || flounder[$0.objectType]?.contains(.you) == true }
        let baddies = totalObjects.filter { $0.objectType == .defeat || flounder[$0.objectType]?.contains(.defeat) == true }
        
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
        
        if moveEnemies {
            for i in baddies {
                if i.triedToMove {
                    print("\(i.objectType) was already pushed")
                    continue
                }
                
                if tryToMove(i, Game.Cardinal.allCases.randomElement()!) {
                    didAnythingMove = true
                } else {
                    print("You did not move up!")
                }
            }
        }
        
        findAllMatches()
        return didAnythingMove
    }
    
    enum Cardinal: Int, CaseIterable { case up, down, left, right, none
        func xMove() -> Int { return [0, 0, -1, 1, 0][self.rawValue] }
        func yMove() -> Int { return [1, -1, 0, 0, 0][self.rawValue] }
        func inverse() -> Self { return [Self.up:Self.down,Self.down:Self.up,Self.left:Self.right,Self.right:Self.left][self] ?? .none }
    }
    
    func tryToMove(_ i: Objects,_ dir: Cardinal) -> Bool {
        //i.triedToMove = true
        
        guard let f = findAtLocation(i.position, moveX: dir.xMove(), moveY: dir.yMove()) else {
            if flounder[[i.objectType]].contains(.you) {
                win = true
                winDir = dir
                return false
            } else {
                totalObjects = totalObjects.filter { $0 !== i }
                
                // When you push a rock off the map, spawn a star!
                if !flounder[[i.objectType]].contains(.defeat) {
                    let newObject = Objects.C(.star)
                    newObject.updateImage()
                    while true {
                        let spawnPosition = (Int.random(in: 1...19), Int.random(in: 1...19))
                        let woah = findAtLocation(spawnPosition, moveX: 0, moveY: 0)
                        if woah == nil || woah?.isEmpty == true {
                            newObject.position = spawnPosition
                            break
                        }
                    }
                    totalObjects.append(newObject)
                }
                
                return true
            }
        }
        
        if f.isEmpty { reallyMove(i, dir); return true }
        guard let _ = f.first(where: { flounder[$0.objectType]?.isEmpty == false }) else { reallyMove(i, dir); return true }
        
        let myTypes = flounder[[i.objectType]]
        let foundTypes = flounder[f.objectTypes]
        
        if foundTypes.contains(.collect) {
            if !myTypes.contains(.you) { return false }
            totalObjects = totalObjects.filter { j in !f.allThatAre(.collect).contains(where: { m in j === m }) }
            if f.objectTypes.contains(.algae) { algaeEaten += 1 }
            if f.objectTypes.contains(.star) { starsEaten += 1 }
            if f.objectTypes.contains(.love) { loveEaten += 1 }
        }
        if foundTypes.contains(.sink) {
            totalObjects = totalObjects.filter { j in j !== i && !f.allThatAre(.sink).contains(where: { m in j === m }) }
        }
        
        // If skull hits you
        if foundTypes.contains(.you) {
            if myTypes.contains(.defeat) {
                totalObjects = totalObjects.filter { j in !f.allThatAre(.you).contains(j) }
            }
        }
        // If you hits skull
        if foundTypes.contains(.defeat) {
            if flounder[[i.objectType]].contains(.you) {
                totalObjects = totalObjects.filter { $0 !== i }
                return true
            }
        }
        
        
        
        // Push is first priority
        if foundTypes.contains(.push) {
            if f.firstWith(.push) === i { return false }
            if !tryToMove(f.firstWith(.push), dir) {
                print(f.map { $0.objectType })
                return false
            }
        }
        
        // Stop is NEXT priority
        if foundTypes.contains(.stop) {
            return false
        }
        

        // Win is FINAL priority
        if flounder[f.objectTypes].contains(.win)  {
            if flounder[i.objectType]?.contains(.you) == true {
                win = true
                print("YOU WIN THE GAME")
                return false
            }
        }
        
        return reallyMove(i, dir)
    }
    
    @discardableResult
    func reallyMove(_ i: Objects,_ dir: Cardinal) -> Bool {
        i.triedToMove = true
        i.position = (i.position.x + dir.xMove(), i.position.y + dir.yMove())
        //i.position.x += dir.xMove()
        //i.position.y += dir.yMove()
        print("\(i.objectType) Moved (\(dir.xMove()), \(dir.yMove())) spaces")
        return true
    }
    
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
    func reset() {
        if !undo.isEmpty {
            undo = [undo[0]]
            undoMove()
        }
    }
    
}

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
        return first(where: { flounder[$0.objectType]?.contains(type) == true })!
    }
    func allThatAre(_ type: ObjectType) -> [Objects] {
        return filter { flounder[$0.objectType]?.contains(type) == true }
    }
    func allThatAreNot(_ type: [ObjectType]) -> [Objects] {
        return filter { Set(type).intersection(flounder[$0.objectType] ?? []).isEmpty }
    }
    func allContain(_ type: ObjectType) -> Bool {
        return filter { flounder[$0.objectType]?.contains(type) == false }.isEmpty
    }
}
