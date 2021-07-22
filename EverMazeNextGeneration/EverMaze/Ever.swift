//
//  Eever.swift
//  EverSleek
//
//  Created by Jonathan Pappas on 1/7/21.
//

import Foundation

public let t = true
public let f = false
public var r: Bool { .randomRandom() }

public struct Pos: ExpressibleByArrayLiteral, Hashable, CustomStringConvertible {
    public var description: String {
        switch positions {
        case [-1,0]: return "←"
        case [1,0]: return "→"
        case [0,-1]: return "↓"
        case [0,1]: return "↑"
        default: return "\(positions)"
        }
    }
    public init(_ this: [Int]) { positions = this }
    public init(arrayLiteral elements: Int...) { positions = elements }
    public typealias ArrayLiteralElement = Int
    public var positions: [Int]
    public var x: Int { get { positions[0] } set { positions[0] = newValue } }
    public var y: Int { get { positions[1] } set { positions[1] = newValue } }
    public var z: Int { get { positions[2] } set { positions[2] = newValue } }
    public func addPosition(_ pos: Pos) -> Pos {
        var newPosition = self
        for i in 0..<pos.positions.count {
            newPosition.positions[i] += pos.positions[i]
        }
        return newPosition
    }
}

public struct MovableDots: Equatable, Hashable, CustomStringConvertible {
    public var description: String { "[\(position):\(covers)]" }
    public var covers: Set<Pos>
    public var position: Pos//, movement: [Pos] = []
    var name = 0
    
    public init (covers: Set<Pos>, position: Pos) {
        self.covers = covers; self.position = position//; self.name = name
    }
    public static func == (lhs: MovableDots, rhs: MovableDots) -> Bool { lhs.position == rhs.position && lhs.covers == rhs.covers }
    public mutating func addPosition(_ pos: Pos) {
        for i in 0..<pos.positions.count {
            position.positions[i] += pos.positions[i]
        }
    }
    public mutating func subtractPosition(_ pos: Pos) {
        for i in 0..<pos.positions.count {
            position.positions[i] -= pos.positions[i]
        }
    }
    public func bumpedWall(_ size: [Int],_ wall: [Bool]) -> Bool {
        return covers.contains { (try? wall[$0.addPosition(position).positions.powerfy(size)]) ?? true }
    }
    public func becomeWall(_ size: [Int],_ wall: [Bool]) -> [Bool] {
        var newWall = wall
        for i in covers {
            try! newWall[i.addPosition(position).positions.powerfy(size)] = true // (should be false turning to true every time)
        }
        return newWall
    }
    public func clearWalls(_ size: [Int],_ wall: [Bool]) -> [Bool] {
        var newWall = wall
        for i in covers {
            try! newWall[i.addPosition(position).positions.powerfy(size)] = false
        }
        return newWall
    }
}

public struct SaveMovement: Hashable, CustomStringConvertible {
    public var description: String { return "SaveMovement\n\t- movement: \(movements)\n\t- characters: \(characters)" }
    public var movements: [Pos] = []
    // Describing characters as [Pos] vs Set<Pos>
    public var characters: Set<MovableDots> = []
    public init(_ movements: [Pos],_ characters: Set<MovableDots>) {
        self.movements = movements; self.characters = characters
    }
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.characters == rhs.characters }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(characters)
    }
}

public class NewEverMaze {
    
    // Dimensions
    public var size: [Int]
    public var x: Int { size[0] }
    public var y: Int { size[1] }
    // Walls
    public var walls: [Bool] = []
    public var characters: Set<MovableDots> = []
    public var start: SaveMovement?
    public var end: SaveMovement?
    public var randomWalls: () -> Bool
    public var totalMazeCount = 0
    public var totalTime: Double = 0
    
    func copy() -> NewEverMaze {
        let newone = NewEverMaze.init(size: size, characters: characters, wallos: [walls])
        newone.start = start
        newone.end = end
        newone.randomWalls = randomWalls
        newone.totalMazeCount = totalMazeCount
        newone.totalTime = totalTime
        return newone
    }
    public init(_ size: [Int],_ characters: Set<MovableDots>, randomWalls: @escaping () -> Bool) {
        self.size = size
        self.characters = characters
        self.randomWalls = randomWalls
    }
    
    public init(size: [Int], characters: Set<MovableDots>, wallos: [[Bool]]) {
        self.size = size
        self.characters = characters
        self.walls = wallos.reduce([Bool]()) { $1 + $0 }
        self.randomWalls = { true }
    }

    public func printMe() {
        print("–––––")
        print("Ever Maze v1")
        print("name: Welcome to my Level 1!")
        print("dimensions: \(size)")
        
        print(start!)
        print("\t- Total Characters: \(start!.characters.count)")
        
        if size.count > 2 {
            print(walls)
        } else {
            var wallos = [[String]]()
            for i in 0..<size[1] {
                wallos.append([])
                for j in 0..<size[0] {
                    
                    var containsStart = false
                    for k in start!.characters {
                        for l in k.covers {
                            if k.position.addPosition(l) == [j, i] {
                                containsStart = true
                            }
                        }
                    }
                    var containsEnd = false
                    for k in end!.characters {
                        for l in k.covers {
                            if k.position.addPosition(l) == [j, i] {
                                containsEnd = true
                            }
                        }
                    }
                    
                    if containsStart || containsEnd {
                        if containsStart, containsEnd {
                            wallos[wallos.count - 1].append("b")
                        } else {
                            wallos[wallos.count - 1].append(containsStart ? "s" : "e")
                        }
                    } else {
                        wallos[wallos.count - 1].append(walls[i * size[0] + j] ? "•" : ".")
                    }
                }
            }
            
            for i in wallos.reversed() {
                print(i.reduce("[") { $0 + $1 } + "]")
            }
        }
        
        print(end!)
        print("\t- Solution Length:", end!.movements.count)
        print("\t- Total Checks: \(totalMazeCount)")
        print("\t- Total Time: \(totalTime)")
        var wall2 = walls; wall2.removeAll(where: { $0 == true })
        print("\t- Total Empty Spaces: \(wall2.count)")
        print("–––––")
    }
    
    public func makeMaze() {
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
        
        var blueBlocks = [SaveMovement([], characters)]
        var totalBlocks = Set(blueBlocks)
        var lastSeenCharacters = blueBlocks[0]
        
        while let newBlueBlock = blueBlocks.first {
            
            for j in 0..<repeatLoopCount {
                for k in [1,-1] {
                    // Create the movement direction
                    var newDirection = repeatLoop
                    newDirection.positions[j] = k
                    // Slide time! (All Nodes get to SLIDE!)
                    if let newBlock = moveCharacter(newBlueBlock, newDirection) {
                        if totalBlocks.insert(newBlock).inserted {
                            blueBlocks.append(newBlock)
                        }
                    }
                }
            }
            
            blueBlocks.removeFirst()
            lastSeenCharacters = newBlueBlock
        }
        
        start = SaveMovement([], characters)
        end = lastSeenCharacters
        totalMazeCount = totalBlocks.count
        let d2 = Date().timeIntervalSince1970
        totalTime = Double(Int((d2 - d1) * 100)) / 100
    }
    
    public func moveCharacter(_ theseCharacters: SaveMovement,_ dir: Pos) -> SaveMovement? {
        var newWalls = walls
        var saveCharacterMovement = theseCharacters.characters
        var hitCharacters: Set<MovableDots> = []
        
        moveLoop: while true {
            var currentMovement = Array(saveCharacterMovement)
            if hitCharacters.count == saveCharacterMovement.count {
                // If not a new position, don't give it
                if theseCharacters.characters == saveCharacterMovement {
                    return nil
                }
                // New position, give it
                return SaveMovement(theseCharacters.movements + [dir], saveCharacterMovement)
            }
            for i in 0..<currentMovement.count {
                if hitCharacters.contains(currentMovement[i]) { continue }
                currentMovement[i].addPosition(dir)
                if currentMovement[i].bumpedWall(size, newWalls) {
                    // Subtract position
                    currentMovement[i].subtractPosition(dir)
                    // Add to hit walls
                    hitCharacters.insert(currentMovement[i])
                    // Add those positions to the walls YUM
                    newWalls = currentMovement[i].becomeWall(size, newWalls)
                    //
                    //saveCharacterMovement[i] = currentMovement[i]
                    // Then, continue the movement for all other movers ;)
                    continue moveLoop
                }
            }
            // All have worked! Save new movements. YUM!
            saveCharacterMovement = Set(currentMovement)
        }
    }
}



public extension Bool {
    static func oneIn(_ num: Int) -> Self {
        return Int.random(in: 1...num) == num
    }
    static func randomRandom() -> Self { .random() && .random() }
}

public extension Array where Element: Numeric {
    func multiplication() -> Element {
        return reduce(1) { $0 * $1 }
    }
}
public extension Array where Element == Int {
    func powerfy(_ size: [Element]) throws -> Element {
        var newNum = 0, posCount = count
        for i in 1...posCount {
            // If outof bounds, It's obviously a wall. So throw this error please :)
            if self[posCount - i] < 0 || self[posCount - i] >= size[posCount - i] {
                throw ""
            }
            newNum += self[posCount - i]
            if i != posCount {
                newNum *= size[posCount - i - 1]
            }
        }
        return newNum
    }
    func powerfy2(_ size: [Element]) throws -> Element {
        var newNum = 0
        var current = 0
        for i in size {
            // If outof bounds, It's obviously a wall. So throw this error please :)
            if self[current] < 0 || self[current] >= i {
                throw ""
            }
            newNum += Int(pow(Double(i), Double(current))) * self[current]
            current += 1
        }
        return newNum
    }
}
public extension Array {
    init(repeating: () -> Element, count: Int) {
        var newArray: [Element] = []
        for _ in 0..<count {
            newArray.append(repeating())
        }
        self = newArray
    }
}
extension String: Error {}


public extension SetAlgebra {
    init(repeating: (Int) -> Element, count: Int) {
        var newArray: [Element] = []
        for i in 0..<count {
            newArray.append(repeating(i))
        }
        self = .init(newArray)
    }
    init(repeating: (Int, Int) -> Element, xCount: Int, yCount: Int) {
        var newArray: [Element] = []
        for x in 0..<xCount {
            for y in 0..<xCount {
                newArray.append(repeating(x, y))
            }
        }
        self = .init(newArray)
    }
}
