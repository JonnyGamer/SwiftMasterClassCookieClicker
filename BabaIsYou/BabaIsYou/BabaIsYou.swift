//
//  BabaIsYou.swift
//  BabaIsYou
//
//  Created by Jonathan Pappas on 3/22/21.
//

import Foundation
import SpriteKit

//extension CGPoint {
//    init(_ x: Int,_ y: Int) { self.init(x: x, y: y) }
//}

typealias FakeCGPoint = (x: Int, y: Int)

enum ObjectType: String {
    static var real: [ObjectType] = [.baba, .wall, .bush, .flag]
    
    case baba = "B"
    case wall = "w"
    case bush = "b"
    case flag = "f"
    
    case recursive = "r"
    
    case stop
    case die
    case win
    case you
    case `is` = "is"
    case push = "push"
}


class Objects {
    var objectType: ObjectType
    var position: (x: Int, y: Int) = (0, 0) {
        didSet { sprite.position = .init(x: position.0 * 100, y: position.1 * 100) }
    }
    var recursiveObjectType: ObjectType = .baba
    var triedToMove = false
    var sprite: SKSpriteNode// = .init()
    
    required init(_ o: ObjectType) {
        objectType = o
        sprite = .init(imageNamed: o.rawValue)
        sprite.size = CGSize.init(width: 100, height: 100)
        sprite.texture?.filteringMode = .nearest
    }
    
    static func Baba() -> Self { return Self.init(.baba) }
    static func Bush() -> Self { return Self.init(.bush) }
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
            [nil, nil, nil, nil, nil, .Bush()],
            [.Recursive(.baba), .Recursive(.is), .Recursive(.you), nil, nil, nil],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, .Recursive(.bush), .Recursive(.is), .Recursive(.you)],
            [.Bush(), nil, nil, nil, nil, nil],
            [.Baba(), nil, nil, nil, nil, nil],
        ]
        
        fixGrid()
    }
    
    func fixGrid() {
        gridSize = (grid.count, grid[0].count)
        
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
            .bush:[.push],
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
        }
        if !totalObjects.contains(where: { newFlounder[$0.objectType]?.contains(.you) == true }) {
            print("ALSO GAME OVER BRUH")
            alive = false
        }
        
        flounder = newFlounder
    }
    
    
    @discardableResult
    func move(_ dir: Cardinal) -> Bool {
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
            alive = false
            print("YOU WIN THE GAME")
            return true
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
    
}

//print("Hello World WASSUP")
//let game = Game()
//game.start()
//
//while game.alive {
//    let foo = readLine() ?? " "
//    let ind = ["w", "s", "a", "d", " "].firstIndex(of: foo) ?? 5
//
//    game.move(Game.Cardinal.init(rawValue: ind) ?? .none)
//    print(game)
//}
//
//print("Good-bye World")

//extension Array where Element == [Objects?] {
//    func findPosition(_ currentPos: FakeCGPoint, moveX: Int, moveY: Int) -> (Element.Element, Bool)? {
//
//        let yo = currentPos.y + moveY
//        if yo < 0 || yo >= count { return nil }
//
//        let xo = currentPos.x + moveX
//        if xo < 0 || xo > self[yo].count { return nil }
//
//        return (self[yo][xo], true)
//    }
//}

