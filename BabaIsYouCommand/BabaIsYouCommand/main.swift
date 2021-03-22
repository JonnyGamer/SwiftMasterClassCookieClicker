//
//  main.swift
//  BabaIsYouCommand
//
//  Created by Jonathan Pappas on 3/22/21.
//

import Foundation

typealias CGFloat = (x: Int, y: Int)

enum ObjectType: String {
    case baba = "B"
    case wall = "w"
    case bush = "b"
    case flag = "f"
    
    case recursive = "r"
    
    case win
    case you
    case `is` = "is"
    case push = "push"
    //case you
}


class Objects {
    var objectType: ObjectType
    var position: CGFloat = (0, 0)
    var recursiveObjectType: ObjectType = .baba
    
    required init(_ o: ObjectType) { objectType = o }
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
        for i in 0..<gridSize.y {
            var op = ""
            (0..<gridSize.x).forEach { op += trueFindAtLocation(($0, i))?.objectType.rawValue ?? "." }
            magOP = "\(op)\n" + magOP
        }
        return "---\n" + magOP + "---"
    }
    
    //var baba: [Objects] = []
    //var you: [Objects] = []
    
    var gridSize: CGFloat = (10, 10)
    var totalObjects: [Objects] = []
    var grid: [[Objects?]] = []
    
    func start() {
        
        grid = [
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, .Recursive(.baba), .Recursive(.is), .Recursive(.you), nil],
            [nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil],
            [.Bush(), nil, nil, nil, nil, nil],
            [.Baba(), nil, nil, nil, nil, nil],
        ]
        
//        let baba = Objects.Baba()
//        totalObjects.append(baba)
//        self.baba.append(baba)
//        self.you.append(baba)
//
//        let bush = Objects.Bush()
//        bush.position = (0, 1)
//        totalObjects.append(bush)
//
//        print(self)
        fixGrid()
    }
    
    func fixGrid() {
        gridSize.x = grid.count
        gridSize.y = grid[0].count
        
        for i in 0..<gridSize.y {
            let y = gridSize.y - i - 1
            
            for j in 0..<gridSize.x {
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
        ]
        
        let iso = totalObjects.filter { $0.objectType == .recursive && $0.recursiveObjectType == .is }
        
        for i in iso {
            // check up is down
            let check10 = findAtLocation(i.position, moveX: -1, moveY: 0)
            let check11 = findAtLocation(i.position, moveX: 1, moveY: 0)
            if let c10 = check10?.0, let c11 = check11?.0 {
                if c10.objectType == .recursive, c11.objectType == .recursive {
                    newFlounder[c10.recursiveObjectType] = [c11.recursiveObjectType]
                }
            }
            // check n is m (left is right)
            let check20 = findAtLocation(i.position, moveX: 0, moveY: 1)
            let check21 = findAtLocation(i.position, moveX: 0, moveY: -1)
            if let c10 = check20?.0, let c11 = check21?.0 {
                if c10.objectType == .recursive, c11.objectType == .recursive {
                    newFlounder[c10.recursiveObjectType] = [c11.recursiveObjectType]
                }
            }
            
        }
        
        flounder = newFlounder
    }
    
    
    @discardableResult
    func move(_ dir: Cardinal) -> Bool {
        var didAnythingMove = false
        
        let you = totalObjects.filter { $0.objectType == .you || flounder[$0.objectType]?.contains(.you) == true }
        
        for i in you {
            
            if tryToMove(i, dir) {
                didAnythingMove = true
            } else {
                print("You did not move up!")
            }
            
        }
        
        return didAnythingMove
    }
    
    enum Cardinal: Int { case up, down, left, right
        func xMove() -> Int { return [0, 0, -1, 1][self.rawValue] }
        func yMove() -> Int { return [1, -1, 0, 0][self.rawValue] }
    }
    
    func tryToMove(_ i: Objects,_ dir: Cardinal) -> Bool {
        
        guard let f = findAtLocation(i.position, moveX: dir.xMove(), moveY: dir.yMove()) else { return false }
        guard let found = f.0 else { reallyMove(i, dir); return true }
        
        if flounder[found.objectType]?.contains(.push) == true {
            if tryToMove(found, dir) {
                reallyMove(i, dir)
                return true
            } else {
                return false
            }
        }
        
        return false
        //fatalError()
    }
    
    func reallyMove(_ i: Objects,_ dir: Cardinal) {
        i.position.x += dir.xMove()
        i.position.y += dir.yMove()
        print("\(i.objectType) Moved (\(dir.xMove()), \(dir.yMove())) spaces")
    }
    
    func findAtLocation(_ currentPos: CGFloat, moveX: Int, moveY: Int) -> (Objects?, Bool)? {
        let yo = currentPos.y + moveY
        if yo < 0 || yo >= gridSize.y { return nil }
        
        let xo = currentPos.x + moveX
        if xo < 0 || xo >= gridSize.x { return nil }
        
        return (totalObjects.first(where: { $0.position == (xo, yo) }), true)
    }
    func trueFindAtLocation(_ currentPos: CGFloat) -> Objects? {
        return totalObjects.first(where: { $0.position == currentPos })
    }
    
}

print("Hello World WASSUP")
let game = Game()
game.start()

while game.move(.up) {
    print(game)
}
while game.move(.right) {
    print(game)
}

print("Good-bye World")

extension Array where Element == [Objects?] {
    func findPosition(_ currentPos: CGFloat, moveX: Int, moveY: Int) -> (Element.Element, Bool)? {
        
        let yo = currentPos.y + moveY
        if yo < 0 || yo >= count { return nil }
        
        let xo = currentPos.x + moveX
        if xo < 0 || xo > self[yo].count { return nil }
        
        return (self[yo][xo], true)
    }
}

