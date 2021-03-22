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
    //case you
}


class Objects {
    var objectType: ObjectType
    var position: CGFloat = (0, 0)
    
    required init(_ o: ObjectType) { objectType = o }
    static func Baba() -> Self { return Self.init(.baba) }
    static func Bush() -> Self { return Self.init(.bush) }
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
    
    var baba: [Objects] = []
    var you: [Objects] = []
    
    var gridSize: CGFloat = (10, 10)
    var totalObjects: [Objects] = []
 
    func start() {
        let baba = Objects.Baba()
        totalObjects.append(baba)
        self.baba.append(baba)
        self.you.append(baba)
        
        let bush = Objects.Bush()
        bush.position = (0, 1)
        totalObjects.append(bush)
        
        print(self)
    }
    
    
    @discardableResult
    func move(_ dir: Cardinal) -> Bool {
        var didAnythingMove = false
        
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
        
        if found.objectType == .wall { return false }
        if found.objectType == .bush {
            if tryToMove(found, dir) {
                reallyMove(i, dir)
                return true
            } else {
                return false
            }
        }
        
        fatalError()
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

