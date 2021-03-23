//
//  Levels.swift
//  BabaIsYou
//
//  Created by Jonathan Pappas on 3/22/21.
//

import Foundation

var level = 1

struct BabaIsYouLevels {
    
    static func getLevel() -> [[Objects?]] {
        switch level {
        case 1: return level1()
        case 2: return level2()
        default: return [[nil]]
        }
    }
    
    static func level2() -> [[Objects?]] {
        return [
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, .R(.is), nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil, nil, nil, nil, .R(.wall), nil, .Wall(), nil],
            [nil, .Wall(), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), nil, .R(.flag), nil, nil, nil, .Flag(), nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil],
            [nil, nil, .R(.baba), nil, nil, .Wall(), nil, .R(.wall), nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, .R(.is), nil, nil, .Wall(), nil, .R(.is), nil, nil, .Baba(), nil, .Wall(), nil],
            [nil, nil, .R(.you), nil, nil, .Wall(), nil, .R(.stop), nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        ]
        
    }
    
    static func level1() -> [[Objects?]] {
        return [
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, .R(.baba), .R(.is), .R(.you), nil, nil, nil, nil, nil, .R(.flag), .R(.is), .R(.win), nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, .Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(), nil],
            [nil, nil, nil, nil, nil, nil, .C(.rock), nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, .Baba(), nil, .C(.rock), nil, nil, nil, .Flag(), nil, nil],
            [nil, nil, nil, nil, nil, nil, .C(.rock), nil, nil, nil, nil, nil, nil],
            [nil, .Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(), nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, .R(.wall), .R(.is), .R(.stop), nil, nil, nil, nil, nil, .R(.rock), .R(.is), .R(.push), nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
        ]
        
        
    }
    
    
}

//        grid = [
//            [nil, nil, nil, nil, nil, .Wall()],
//            [.Recursive(.baba), .Recursive(.is), .Recursive(.you), nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, .Recursive(.wall), .Recursive(.is), .Recursive(.push)],
//            [.Wall(), nil, nil, nil, nil, nil],
//            [.Baba(), nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, .Recursive(.flag), .Recursive(.is), .Recursive(.win)],
//            [nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, .Flag(), nil],
//            [nil, nil, nil, nil, nil, nil],
//            [nil, nil, nil, nil, nil, nil],
//        ]
