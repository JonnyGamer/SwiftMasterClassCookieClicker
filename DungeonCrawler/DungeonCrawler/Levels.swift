//
//  Levels.swift
//  DungeonCrawler
//
//  Created by Jonathan Pappas on 3/24/21.
//

import Foundation

var level = 1

var flounder: [ObjectType:[ObjectType]] = [
    .recursive:[.push],
    .baba:[.you],
    .wall:[.stop],
    .rock:[.push],
    .algae:[.collect],
    .skull:[.defeat],
]

struct BabaIsYouLevels {
    
    static func newLevel() -> [[Objects?]] {
        return [
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwww                     wwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwww                           wwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwww                               wwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwww                               wwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwww                            wwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwww",
            "www           wwwwwwwwwwwwwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwww",
            "www     wwwww wwwwwwww              wwwwwwwwwwwwwwwwwwwwwwwwwww",
            "www     wwwww     wwwwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "www     wwwwwwwww wwwwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "www wwwwwwwwwwwww wwwwwwwwwwww             wwwwwwwwwwwwwwwwwwww",
            "www wwwwwwwwwwwww wwwwwwwwwwwwwwww              s    wwwwwwwwww",
            "www wwwwwwwwwwwww wwwwwwwwwwwwwwww       a      s   awwwwwwwwww",
            "www wwwwwwwwwwww   wwwwwwwwwwwwwww              s    wwwwwwwwww",
            "wwwwwwwwwwww     r                         wwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwww   r             a      wwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwww   r    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwww   a    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwww   a    wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "w wwwwwwwwww wwwwww wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "w    ww   a  wwwwww wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "w ww ww wwwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "w ww  a  wwwwwwwwww wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wba wwwwa  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
            "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww",
        ].level(ruleset: [
            "w":(.wall,.wall),
            "b":(.baba,.wall),
            "r":(.rock,.wall),
            "a":(.algae,.collect),
            "s":(.skull,.collect)
        ])
        
        
    }
    
    static func getLevel() -> [[Objects?]] {
        switch level {
        case 1: return newLevel()
        case 2: return level2()
        case 3: return level3()
        case 4: return level4()
        case 5: return level5()
        case 6: return level6()
        case 7: return level7()
        case 8: return level8()
        case 9: return level9()
        case 10: return level10()
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
    
    static func level10() -> [[Objects?]] {
        return [
            "                           ",
            "     SIDwwwwwwwwwwww       ",
            "    wwwww          w   j   ",
            "    w   w          w       ",
            "    w   www  3IL   wWIZ    ",
            "  c w C s 2        wwwwww  ",
            "    w   www  RIP    r w w  ",
            "    w   w          ww b w  ",
            "    wwBww    r A   ww w w  ",
            "     wIw           wwwwww  ",
            "   f wYw           w       ",
            "     wwwwwwwwwwwwwww  j    ",
            "  FIE                      ",
            "                  j        ",
            "                           ",
        ].level(ruleset: [
            "b":(.baba,.wall),
            "w":(.wall,.wall),
            "j":(.jelly,.wall),
            "c":(.crab,.wall),
            "s":(.skull,.skull),
            "2":(.star,.star),
            "r":(.rock,.star),
            "f":(.flag,.star),
            
            "F":(.recursive,.flag),
            "E":(.recursive,.win),
            "W":(.recursive,.wall),
            "B":(.recursive,.baba),
            "A":(.recursive,.and),
            "I":(.recursive,.is),
            "Y":(.recursive,.you),
            "R":(.recursive,.rock),
            "P":(.recursive,.push),
            
            "L":(.recursive,.sink),
            "S":(.recursive,.skull),
            "D":(.recursive,.defeat),
            "Z":(.recursive,.stop),
            "C":(.recursive,.crab),
            "3":(.recursive,.star),
        ])
        
    }
    
    static func level9() -> [[Objects?]] {
        return [
            "FIEiii     iii  ii       JIZ",
            "iiii        iiiii i         ",
            "ii           iiii  i   jjj  ",
            "i    wwwww   iiiiiiii jj jj ",
            "     w   w    iiiiiii j f j ",
            "     w b w    iii   iijj jj ",
            "     w   w    ii     i jjj  ",
            "     ww ww     i  W  ii     ",
            "               i     iii    ",
            "               ii   iiii    ",
            "        wwww    iiiiiii i   ",
            "     w  BIYAZw   iiiiii ii  ",
            "     wwwwwww      iiiiii    ",
            "i                  iiiiiii  ",
            "ii                  iiiiiii ",
            "iiiii i    i         iiiiWIS",
        ].level(ruleset: [
            "b":(.baba,.wall),
            "f":(.flag,.flag),
            "j":(.jelly,.flag),
            "i":(.ice,.flag),
            "w":(.wall,.flag),
            
            "B":(.recursive,.baba),
            "I":(.recursive,.is),
            "Y":(.recursive,.you),
            "A":(.recursive,.and),
            "Z":(.recursive,.sink),
            "1":(.recursive,.ice),
            
            "J":(.recursive,.jelly),
            "F":(.recursive,.flag),
            "E":(.recursive,.win),
            "W":(.recursive,.wall),
            "S":(.recursive,.stop),
        ])
        
    }
    
    static func level8() -> [[Objects?]] {
        return [
            "                    ",
            "   wwwwwwwwwwwwww   ",
            "   w    g       w   ",
            "   w BIY      f w   ",
            "   wg      g    w   ",
            "   w        g g w  G",
            "   w   b  g  g gw  I",
            "   wg     g F W w  S",
            "   w g    g  g  w   ",
            "   w    g  g    w   ",
            "   wwwwwwwwwwwwww   ",
            "                    ",

        ].level(ruleset: [
            "g":(.grass,.wall),
            "w":(.wall,.wall),
            "b":(.baba,.wall),
            "f":(.flag,.flag),
            
            "B":(.recursive,.baba),
            "I":(.recursive,.is),
            "Y":(.recursive,.you),
            "F":(.recursive,.flag),
            "W":(.recursive,.win),
            "G":(.recursive,.grass),
            "S":(.recursive,.stop),
        ])
        
    }
    
    static func level7() -> [[Objects?]] {
        return [
            "RIS r       s           ",
            "    r     wwswwwwwww    ",
            "ZID r     w s  w   w    ",
            "    r     w s    f w    ",
            "FIE r wwwww s  w   w    ",
            "    r w   w s  wwwww    ",
            "rrrrr w b   swww        ",
            "      w   w ssssssssssss",
            "      wwwww    w        ",
            "          w WISw        ",
            "        B w    w        ",
            "        I wwwwww        ",
            "        Y               ",
            "                        ",
            
        ].level(ruleset: [
            "r":(.rock,.wall),
            "w":(.wall,.wall),
            "b":(.baba,.wall),
            "s":(.skull,.wall),
            "f":(.flag,.flag),
            
            "B":(.recursive,.baba),
            "I":(.recursive,.is),
            "Y":(.recursive,.you),
            "R":(.recursive,.rock),
            "S":(.recursive,.stop),
            "Z":(.recursive,.skull),
            "D":(.recursive,.defeat),
            "F":(.recursive,.flag),
            "E":(.recursive,.win),
            "W":(.recursive,.wall),
            
        ])
        
    }
    
    static func level6() -> [[Objects?]] {
        return [
            "WISll w     w   w   llllll      ",
            "llll  w       b w  llllll       ",
            "ll    w     w   w  llllll       ",
            "l     w BIY wwwww llllll        ",
            "      ww   ww     llllll        ",
            "      w     r     llllll        ",
            "      wwwwwww    llllll         ",
            "      wRw        llllll         ",
            "       I         lllll          ",
            "       P        lllll           ",
            "            L   lllll           ",
            "               lllll            ",
            "       wBIMw   lllll            ",
            "       wwwww  lllll     f       ",
            "       wLIHw  lllll             ",
            "       wwwww lllll     FIE     l",
            "            lllll             ll",
            "           lllll             lll",
            
            
        ].level(ruleset: [
            "r":(.rock,.wall),
            "b":(.baba,.wall),
            "f":(.flag,.wall),
            "l":(.lava,.skull),
            "w":(.wall,.wall),
            
            "W":(.recursive,.wall),
            "I":(.recursive,.is),
            "S":(.recursive,.stop),
            "B":(.recursive,.baba),
            "Y":(.recursive,.you),
            "R":(.recursive,.rock),
            "P":(.recursive,.push),
            "L":(.recursive,.lava),
            "M":(.recursive,.melt),
            "H":(.recursive,.hot),
            "F":(.recursive,.flag),
            "E":(.recursive,.win),
        ])
        
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
