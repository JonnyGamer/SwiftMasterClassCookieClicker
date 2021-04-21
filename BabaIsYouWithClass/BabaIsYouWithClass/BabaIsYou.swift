//
//  BabaIsYou.swift
//  BabaIsYouWithClass
//
//  Created by Jonathan Pappas on 4/21/21.
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
        // Fix for recursive objects
        return lhs.objectType == rhs.objectType
    }
    
    var objectType: ObjectType {
        didSet {
            updateImage()
        }
    }
    
    var recursiveObjectType: ObjectType = .baba
    
    var position: FakeCGPoint = (0,0) {
        didSet {
            sprite.position.x = 500 + CGFloat(position.x) * 10
            sprite.position.y = 500 + CGFloat(position.y) * 10
        }
    }
    
    var triedToMove = false
    var sprite: SKSpriteNode!
    
    required init(_ o: ObjectType) {
        objectType = o
        updateImage()
    }
    
    func updateImage() {
        var imageName = objectType.rawValue
        sprite = .init(imageNamed: imageName)
    }
    
}

class Game {
    
    
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
        
        for i in grid {
            for j in i {
                if let k = j {
                    totalObjects.append(k)
                }
            }
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
            reallyMove(i, dir)
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
