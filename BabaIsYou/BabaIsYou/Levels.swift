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
        case 3: return level3()
        case 4: return level4()
        case 5: return level5()
        default: return [[nil]]
        }
    }
    
    static func level4() -> [[Objects?]] {
        return [
            [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil],
            [nil,nil,nil,.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),nil,nil,nil,nil,nil],
            [nil,nil,nil,.Wall(),nil,nil,nil,nil,nil,nil,.Wall(),nil,nil,nil,nil,nil],
            [nil,nil,nil,.Wall(),nil,.Baba(),nil,nil,.C(.rock),nil,.Wall(),nil,nil,nil,nil,nil],
            [nil,nil,.R(.water),.Wall(),nil,nil,nil,nil,nil,nil,.Wall(),.R(.baba),.R(.wall),nil,nil,nil],
            [nil,nil,.R(.is),.Wall(),nil,nil,nil,nil,.C(.rock),nil,.Wall(),.R(.is),.R(.is),nil,nil,nil],
            [nil,nil,.R(.sink),.Wall(),nil,nil,nil,nil,nil,nil,.Wall(),.R(.you),.R(.stop),nil,nil,nil],
            [nil,.Wall(),.Wall(),.Wall(),.Wall(),.Water(),.Water(),.Water(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),nil],
            [nil,.Wall(),nil,nil,nil,nil,nil,nil,.Wall(),nil,nil,nil,nil,nil,.Wall(),nil],
            [nil,.Wall(),nil,nil,nil,nil,nil,nil,.Wall(),nil,.R(.rock),.R(.is),.R(.push),nil,.Wall(),nil],
            [nil,.Wall(),nil,nil,nil,nil,nil,nil,.Wall(),nil,nil,nil,nil,nil,.Wall(),nil],
            [nil,.Wall(),.Water(),.Water(),.Water(),nil,.Wall(),nil,nil,nil,nil,nil,nil,nil,.Wall(),nil],
            [nil,.Wall(),.Water(),.Water(),.Water(),nil,nil,nil,.Wall(),nil,.R(.flag),.R(.is),.R(.win),nil,.Wall(),nil],
            [nil,.Wall(),.Flag(),.Water(),.Water(),nil,nil,nil,.Wall(),nil,nil,nil,nil,nil,.Wall(),nil],
            [nil,.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),.Wall(),nil],
            [nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil]
        ]
    }
    
    static func level3() -> [[Objects?]] {
        return [
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), nil],
            [nil, nil, nil, nil, nil, .Flag(), nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, nil, nil, nil, .Flag(), nil, .R(.is), nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, nil, nil, nil, .Flag(), nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), nil, nil, nil, nil, .R(.win), nil, .Flag(), nil],
            [nil, .Flag(), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, .Flag(), nil, .R(.baba), nil, nil, nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, .Flag(), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), nil],
            [nil, nil, nil, nil, nil, .Flag(), nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, .R(.wall), nil, nil, .Flag(), nil, .R(.flag), nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, .R(.is), nil, nil, .Flag(), nil, .R(.is), nil, nil, .Wall(), nil, .Flag(), nil],
            [nil, nil, .R(.you), nil, nil, .Flag(), nil, .R(.stop), nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, nil, nil, nil, .Flag(), nil, nil, nil, nil, nil, nil, .Flag(), nil],
            [nil, nil, nil, nil, nil, .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), .Flag(), nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        ]
    }
    
    static func level2() -> [[Objects?]] {
        return [
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, .R(.is), nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil, nil, nil, nil, .R(.win), nil, .Wall(), nil],
            [nil, .Wall(), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), nil, .R(.flag), nil, nil, nil, .Flag(), nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, .R(.baba), nil, nil, .Wall(), nil, .R(.wall), nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, .R(.is), nil, nil, .Wall(), nil, .R(.is), nil, nil, .Baba(), nil, .Wall(), nil],
            [nil, nil, .R(.you), nil, nil, .Wall(), nil, .R(.stop), nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), nil, nil, nil, nil, nil, nil, .Wall(), nil],
            [nil, nil, nil, nil, nil, .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), .Wall(), nil],
            [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
        ]
    }
    
    static func level0() -> [[Objects?]] {
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
    
    static func level5() -> [[Objects?]] {
        return [
            "FIW                           ",
            "BIY                           ",
            "                              ",
            "              sssssssssssssss ",
            " RIP          s             s ",
            "              s S           s ",
            "              s I           s ",
            "   s s        s D           s ",
            "   srs        s             s ",
            " sssrsss      s        f    s ",
            " s  r  s      s             s ",
            " s     s      sssssssssssssss ",
            " s  b  s                      ",
            " s     s                      ",
            
            
        ].level(ruleset: [
            "r":(.rock,.wall),
            "b":(.baba,.wall),
            "f":(.flag,.wall),
            "s":(.skull,.skull),
            
            "R":(.recursive,.rock),
            "B":(.recursive,.baba),
            "I":(.recursive,.is),
            "Y":(.recursive,.you),
            "F":(.recursive,.flag),
            "W":(.recursive,.win),
            "S":(.recursive,.skull),
            "P":(.recursive,.push),
            "D":(.recursive,.defeat),
        ])
        
    }
    
    static func level1() -> [[Objects?]] {
        return [
            "             ", // String.init(repeating: " ", count: 13),
            " BIY     FIE ",
            "             ",
            " wwwwwwwwwww ",
            "      r      ",
            "    b r   f  ",
            "      r      ",
            " wwwwwwwwwww ",
            "             ",
            " WIS     RIP ",
            "             ",
            
        ].level(ruleset: [
            "w":(.wall,.wall),
            "r":(.rock,.wall),
            "b":(.baba,.wall),
            "f":(.flag,.wall),
            
            
            "R":(.recursive,.rock),
            "B":(.recursive,.baba),
            "I":(.recursive,.is),
            "Y":(.recursive,.you),
            "F":(.recursive,.flag),
            "E":(.recursive,.win),
            "W":(.recursive,.wall),
            "S":(.recursive,.stop),
            "P":(.recursive,.push),
        ])
        
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

extension Array where Element == String {
    func level(ruleset: [String:(ObjectType,ObjectType)] = [:]) -> [[Objects?]] { return levelFromString(ruleset: ruleset, levelDesign: self) }
}

let myRuleset: [String:(ObjectType,ObjectType)] = [:]
func levelFromString(ruleset: [String:(ObjectType,ObjectType)] = [:], levelDesign: [String]) -> [[Objects?]] {
    var theRuleset = ruleset
    if ruleset.isEmpty { theRuleset = myRuleset }
    
    var level: [[Objects?]] = []
    
    for i in levelDesign {
        let f = i.map { Objects.buildFrom(this: theRuleset[String($0)]) }
        level.append(f)
    }
    return level
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
