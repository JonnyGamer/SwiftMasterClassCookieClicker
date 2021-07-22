//
//  Cell.swift
//  EverMaze2
//
//  Created by Jonathan Pappas on 1/25/21.
//

import Foundation

var spaghettiMonster = """
"""
  
// MASSIVE AMOUNT OF SPITTING SPACESHIPS
//"""
//x = 294, y = 272, rule = B3/S23
//22b3o15b3o46bob2o95b3o10b3o47b3o$21bo3bo13bo3bo41b3ob2obob2o44bo42b3ob
//o7b2o7bob3o19bo22bo2bo4b3o$20b2o4bo11bo4b2o39bo6b2o2b4o40b3o45bo3bo2bo
//2bo2bo3bo22bobo21bo6bo2bo$19bobob2ob2o3b3o3b2ob2obobo39b2o3bo3bo4bo16b
//3o19bo3bo44bo5bo4bo5bo21bo2bo21bo3bo5bo$18b2obo4bob2ob3ob2obo4bob2o50b
//2o17bo21b2ob2o50b2o2b2o28b2o23bo4bo3bo$17bo4bo3bo4bobo4bo3bo4bo69bo28b
//o43bo3bo2bo3bo50bo3bo4bo$29bo5bo101b4obo2bobo42bobo6bobo21bo5bo21bobob
//2o3bo$17b2o7b2o9b2o7b2o90bo2bo2bo3bo42b10o21bobo3bo22bo6bo$144b2obo45b
//o4bo22bo2bo3b2o$145b2o44bo8bo20bo2b2o3bo23b2obo$145b2o43bo10bo53bo$
//146bo44bo8bo12$72b3o3b3o$68bob2o3bobo3b2obo16b2o$67b3o3bobobobo3b3o14b
//o2bo$66bo3bo4bobo4bo3bo13bo2bo$67bo7bobo7bo13bo4bo$74bobobo20bo4bo$74b
//obobo21b4o$99b2o2b2o$76bo22bo4bo$75bobo21bo4bo$73b2o3b2o$73bobobobo$
//73b2o3b2o20b4o$101b2o152bo$254b3o3b3o$254bob2o2bo2bo$248b3o4b3o2bo$
//247bo2bo4b3o2bo$250bo4b2o4bobo$246bo3bo4bo$250bo$247bobo5b3o$30b3o15b
//3o$29bo3bo13bo3bo$28b2o4bo11bo4b2o$27bobob2ob2o3b3o3b2ob2obobo$26b2obo
//4bob2ob3ob2obo4bob2o$25bo4bo3bo4bobo4bo3bo4bo$37bo5bo$25b2o7b2o9b2o7b
//2o$5b3o16bo$4bo3bo15bobo$3b2o4bo17b2o$2bobob2ob2o3b3o3bo2bobobo$b2obo
//4bob2ob3ob2ob3o3bob2o$o4bo3bo4bobo5bobobo2b2o$12bo5bo2bo7b2o$2o7b2o8bo
//5b2obo2b2o117b2o17b2o$25b2obo2bo118b2ob2o4b3o4b2ob2o$20b3o3bobobobo
//116bo3b2o4b3o4b2o3bo$22b3o3bo124bobo3bobo3bobo$21bob2o3b2o121bob2o2b2o
//bob2o2b2obo$23bobobobo119b3o2bobo7bobo2b3o80bo4b3o$25bobo120b2obo2bobo
//7bobo2bob2o78b3o2bo2bo$23bobo2bo118bo3bobo13bobo3bo77bob2o4bo$24b3o
//126bobob7obobo84b4o3bo$153bo13bo84b2o5bo$256bo2bo$153b2o11b2o89b2o$
//173bo84bo$171b3ob3o79bo$25b2o143b2o6bo78bo$24b2o139bo3bo2bo3b2o$160b2o
//2b4o$159bo7bo$159bo4bobo2bo$168bo$25b2o$24b2o$24b2o14$160b2o$156b2obo
//2bob2o103bo$156b2o6b2o99b2ob3o$156bobo4bobo97b2obo3b2o$158b2o2b2o99bo
//4bo2b2o$157b2ob2ob2o97b2obo5bo$159bo2bo97b2obo7b2o$157bo6bo96bo7bobob
//2o$54bo7bo94bo6bo93b2obob2o3b2obobo$50b2obobo5bobob2o47b3o11b3o127b2ob
//o5bo3bobob2o$50b2o4bo3bo4b2o46bo2bo10bo2bo26b8o93bo2bobo7bo3b2o$50b2o
//4bo3bo4b2o49bo4b3o6bo25b2o6b2o91b2obo6b2o3bob3o$52b2o9b2o51bo4bo2bo5bo
//128b2obo13b2o$41b2ob3ob2o3bob3ob3obo3b2ob3o7b3o30bobo5bob2o2bobo30b2o
//95b2o4bo$41b2o4bo4bo11bo4bo3bo5bo3b2obo171b2o2bo$40bo2bob2o24bobo5bobo
//3b3o70b2o2b2o95bo$55b3ob3o11b2o3b2o4bo3bo67b2o6b2o92bo3b2o$55b7o10bob
//2ob2obo6bo35bo29b3obobo2bobob3o76bo15bo2bo$53b2o7b2o7bo3bobo3bo40bo26b
//3o4b2ob4ob2o4b3o71b3ob3o7b4o$71bo2bo3bo2bo39bo2bo23bo3bob2o4b2o4b2obo
//3bo69b2o3bob2o5bo3bob2o$53bo2bobobo2bo58bobo24bo2b3ob3o4b3ob3o2bo69b2o
//2bobobob2o21bo$73b2o3b2o73bo14bo74bo4bo3bo4b2ob2obo7b2ob3o$73bobobobo
//70b3o5b2o2b2o5b3o70b2o4bobobob2o13b2obo3b2o$74b2ob2o70b2o8bo2bo8b2o67b
//2obobo8bob10o3bo4bo2b2o$75bobo78b2o6b2o75bobob2o7bobo7bob2obobo5bo$72b
//2obobob2o74bo3b4o3bo71b2obobo3bo8bo10bobo7b2o$72bobo3bobo74bo10bo71b2o
//3bo21bobo7bobob2o$154b2ob2o4b2ob2o70b3obo3b2o11b3o5bo6b2obobo$157bob4o
//bo72b2o34bo3bobob2o$152b2o2b10o2b2o107bo3b2o$153bo2bo8bo2bo104b2o3bob
//3o$152bo5b2o2b2o5bo112b2o$153bo14bo$159bo2bo$160b2o20$116bo19bo$115b3o
//17b3o$114bo3bo15bo3bo$114b2ob2o15b2ob2o$110bo31bo$109bobo2bob4o13b4obo
//2bobo$10b3o3b3o89bo3bo2bo2bo15bo2bo2bo3bo$10bo2bobo2bo90bob2o27b2obo$
//10bo7bo91b2o8bo11bo8b2o$10bo7bo91b2o9b2o7b2o9b2o$11bobobobo92bo12bo5bo
//12bo108bo17bo$120bo2b2o3b2o2bo117b3o15b3o$14bo106b2o2bobo2b2o117b2o4b
//3o5b3o4b2o$13b3o231b2obo2b3o2bo3bo2b3o2bob2o$13b3o105b2o2bobo2b2o116bo
//bo2bobo3bobo3bobo2bobo$20b3o97bo3bo3bo3bo112b2obobobobo4bobo4bobobobob
//2o$19bo2bo97bo11bo112b2o3bobo4bo5bo4bobo3b2o$22bo97bobo7bobo112b3obo3b
//o4bobobo4bo3bob3o$22bo98bo9bo112b2o9b2obobobob2o9b2o$19bobo100bo7bo
//125bo7bo$121bobo5bobo121b2obo7bob2o$121bo2bo3bo2bo122bo11bo$11bobo107b
//obo5bobo119b2obo11bob2o$11bobo106b2ob2o3b2ob2o118b2o15b2o$12bo107bobob
//o3bobobo118bobobob3ob3obobobo$125bobo122b2o3bo3bobo3bo3b2o$124b2ob2o
//121bo2bo3bobobobo3bo2bo$125bobo125b2o4bobo4b2o$126bo122b2o4bo3bobo3bo
//4b2o$253bob2obo3bob2obo$254bobobobobobobo$256bobo3bobo$256bobo3bobo$
//258b2ob2o$254bo11bo$119bo133bo13bo$118b3o133bobo7bobo$117b2ob2o2$113bo
//2bobobobo$112b3o3bo3b2o$111bo6bo3b2o$111bobo$113bobo$111bo2bo$111bo14$
//57b3o17b3o$52b2ob2obo19bob2ob2o$52b2o4bob2o13b2obo4b2o$51bo2bo3bobobo
//11bobobo3bo2bo$58bobobob2o5b2obobobo$56bo3bobob2o5b2obobo3bo187b3o15b
//3o$57bobobob3o5b3obobobo187bo3bo13bo3bo$266b2o4bo11bo4b2o$61b3o9b3o
//189bobob2ob2o3b3o3b2ob2obobo$61b3obobobobob3o188b2obo4bob2ob3ob2obo4bo
//b2o$62b5obob5o188bo4bo3bo4bobo4bo3bo4bo$67bobo205bo5bo$67b3o193b2o7b2o
//9b2o7b2o$64bobo3bobo170b3o16bo$242bo3bo15bobo$62b2ob3ob3ob2o166b2o4bo
//17b2o$62bo11bo165bobob2ob2o3b3o3bo2bobobo$61bo2bo7bo2bo163b2obo4bob2ob
//3ob2ob3o3bob2o$61bo4bo3bo4bo162bo4bo3bo4bobo5bobobo2b2o$66bo3bo179bo5b
//o2bo7b2o$60b6o5b6o161b2o7b2o8bo5b2obo2b2o$59b2o7bo7b2o185b2obo2bo$67bo
//bo188b3o3bobobobo$67b3o190b3o3bo$82bo176bob2o3b2o$80b3ob3o174bobobobo$
//79b2o6bo175bobo$74bo3bo2bo3b2o176bobo$73b4o185b2o7b3o$72bo3bo187bo6bo
//2bo$73bobo2bo192bo$67b3o7bo187b2o4bo3bo$65b2o195bo2b2o4bo3bo$65bo4bo
//191bob3o4bo$65bo4bo201bobo$66bo3bo$68bo14$141bo5bo$140b3o3b3o4$112b2o
//5b2o5b2o5b2o19b2o5b2o5b2o5b2o$110bo3bo3bo2bo3bo2bo3bo3bo15bo3bo3bo2bo
//3bo2bo3bo3bo$110bo3bobob3o5b3obobo3bo15bo3bobob3o5b3obobo3bo$110bo5b2o
//2b3ob3o2b2o5bo15bo5b2o2b3ob3o2b2o5bo$110b2ob3o15b3ob2o15b2ob3o15b3ob2o
//$110bo25bo15bo25bo$111bo3bo15bo3bo17bo3bo15bo3bo$112bo2bo15bo2bo19bo2b
//o15bo2bo!
//"""

// EXTREME RAKE
// """
//x = 263, y = 79, rule = B3/S23
//18boo$16bo4bo$22bo$16bo5bo$17b6o3$33boo$31bo4bo$37bo$31bo5bo213boo8bo$
//32b6o132b6o74b4o8bo$169bo5bo74booboo3bo3bo$159b6o10bo76boo5b4o$107b5o
//46bo5bo9bo$106bo4bo52bo$41b6o64bo5b4o42bo$40bo5bo59bo3bo5b6o61boo73bo$
//46bo61bo7b4oboo56b4oboo73boo$40bo4bo74boo58b5o75bo$42boo137b3o76bo$89b
//o169bo$87booboo28bo$89bo14bo3bo3bo3bo5bo58b4o$104bo3bo3bo3bo6bo56bo3bo
//76bo$89bo14bo3bo3bo3bo6bo36bo23bo77bo$87booboo27b5o37bo13boo6bo74bo3bo
//$89bo65bo5bo9b4oboo64b4o13b4o$156b6o9b6o64bo3bo$bboo116b3o49b4o69bo$o
//4bo15b4o24boo57bo10b5o120bo$6bo13bo3bo21b3oboo54bo3bo8b3oboo$o5bo17bo
//21b5o60bo10boo$b6o13bobbo23b3o56bo4bo$107b5o25$251boo8bo$169b6o75b4o8b
//o$168bo5bo75booboo3bo3bo$174bo77boo5b4o$173bo3$182boo74bo$178b4oboo74b
//oo$179b5o76bo$180b3o77bo$259bo$$180b4o$179bo3bo77bo$183bo78bo$174boo6b
//o60bo14bo3bo$170b4oboo67bo14b4o$170b6o64bo3bo$171b4o66b4o!
//"""
//
//


//    """
//x = 27, y = 137
//8b3o5b3o$8bobo5bobo$8bobo5bobo$6bob2o3bo3b2obo$6b2o4bobo4b2o$10b2obob
//2o$9bo7bo$9bobo3bobo$5b5o7b5o$4bo2bo11bo2bo$5bob3o7b3obo$7bob2o5b2obo$
//6b2obobo3bobob2o$6b3obo5bob3o2$10b2o3b2o$12bobo$9bo7bo$9b2o5b2o$6b2o
//11b2o$4bob2o11b2obo$4b2o2b2o7b2o2b2o$4bo2bo2bo5bo2bo2bo$5bo4bo5bo4bo$
//5bo2bo2bo3bo2bo2bo$2bo5bo9bo5bo$3bobo15bobo$7bo11bo$3bo3bobo7bobo3bo$
//3bo2bo3bo5bo3bo2bo$4b2o2b2o7b2o2b2o$8bo9bo2$8b5ob5o$bo6b2ob2ob2ob2o6bo
//$3o7bo5bo7b3o$o2b2o5bo5bo5b2o2bo$2bo3b5o5b5o3bo$7bob2o5b2obo$bo3bo15bo
//3bo$bob2o2bo11bo2b2obo$bob4o13b4obo$4bo17bo2$2bo21bo$bobo19bobo$o25bo$
//o3bo17bo3bo$5bo15bo$2o23b2o$2bo3bo2bo7bo2bo3bo$2bo3bobobo5bobobo3bo$2b
//o5bob2o3b2obo5bo$2bo3b2obo7bob2o3bo$6b2o11b2o$4bo17bo$3bo19bo$3bo4bo9b
//o4bo$2b2o3b2o9b2o3b2o$2b2o3bobo7bobo3b2o$2b2o3b2o3b3o3b2o3b2o$2b3o2b3o
//bo3bob3o2b3o$6bob2obo3bob2obo$2b2o3b2obo5bob2o3b2o$3bob2o3bobobobo3b2o
//bo$11bobobo$8bo9bo$8b3o5b3o$10b2obob2o$10b7o$8b3o5b3o$7b2obobobobob2o$
//6bo3bo5bo3bo$11b2ob2o$5bo2bobobobobobo2bo$6b4o7b4o$9bo7bo$9bo7bo$6b2ob
//o2bobo2bob2o2$9b2o5b2o3$9bo7bo$9b3o3b3o$8bo2bo3bo2bo$9bo7bo$8bo2bo3bo
//2bo$11b2ob2o$12bobo$10bobobobo$9bo3bo3bo$9bo7bo$12bobo$7b2obo5bob2o$7b
//2o2bo3bo2b2o$7bo11bo$8bo9bo$6bobo9bobo$5b4o9b4o$5b2obobo5bobob2o$4bo2b
//o11bo2bo$9bobo3bobo$8b2obo3bob2o$4bo2bo3b2ob2o3bo2bo$9bo2bobo2bo$6bo2b
//ob2ob2obo2bo$7bobobobobobobo$8b2o2bobo2b2o$9bobo3bobo$10b2o3b2o$7b2o9b
//2o$7b3o7b3o$7bobo7bobo$5b2o2bo7bo2b2o$5b2o13b2o$11bo3bo$6bo4bo3bo4bo$
//6b2o3bo3bo3b2o$7bo2bo5bo2bo$7b3o7b3o$6bobo9bobo$6b2o11b2o$6bobo4bo4bob
//o$6b2o4b3o4b2o$6b2o3bo3bo3b2o$5b3o4b3o4b3o$3b2o17b2o$2bo5b2o2bobo2b2o
//5bo2$2bo2bob3ob2ob2ob3obo2bo$8b3o5b3o$10b3ob3o$5bo4b2obob2o4bo$11bo3bo
//2$11b2ob2o
//"""

typealias CellType = [Int:Set<Int>]
struct Cell {
    
    var automata = CellType()
    var modX = Int.max, modY = Int.max
    let liveCell = [2, 3]//[3, 4, 6, 7, 8]
    let deadCell = [3,]//[3, 6, 7, 8]
    
    init(_ automata: CellType) {
        self.automata = automata
    }
    
    init(mod: Int = .max, modX: Int = .max, rsl: String) {
        (self.modX, self.modY) = (min(mod, modX), mod)
        var len = 0, het = 0
        var currentAutomata = CellType(), x = 0, y = 0//-100
        for line in rsl.split(separator: "$") {
            var line = line
            if len == 0, line.hasPrefix("x") {
                len = Int(line.split(separator: " ")[2].dropLast().s) ?? 1
                het = Int(line.split(separator: " ")[5].dropLast().s) ?? 1
                line = line.split(separator: "\n")[1]
                y = -(het / 2)
//                if len > het {
//                    self.modX = len// * 2
//                } else {
//                    self.modY = het
//                }
                //continue
            }
            var num = ""
            for j in line {
                if currentAutomata[y] == nil { currentAutomata[y] = [] }
                if j == "\n" {
                    continue
                } else if j == "b" {
                    x += Int(num) ?? 1
                    num = ""
                } else if j == "o" {
                    for k in 1...(Int(num) ?? 1) {
                        currentAutomata[y]?.insert(x + k - (len / 2))
                    }
                    x += Int(num) ?? 1
                    num = ""
                } else {
                    num += String(j)
                }
                
                //if j != " " { currentAutomata[y]?.insert(x - (len/2)) }
                //x += 1
                //if x % len == 0 { x = 0; y += 1 }
            }
            if let woah = Int(num) {
                x = 0; y += woah
            } else {
                x = 0; y += 1; // += Int(num) ?? 0
            }
            
        }
//
//        let oop = currentAutomata.keys.sorted(by: <)
//        if let firsto = oop.first, let lasto = oop.last {
//            let yMovement = lasto - firsto
//            for i in oop.reversed() {
//                currentAutomata[Int("\(i)")! - yMovement] = currentAutomata[Int("\(i)")!]
//                currentAutomata[Int("\(i)")!] = nil
//            }
//        }
        
        //currentAutomata.values.map
        
        self.automata = currentAutomata
    }
    
    init(mod: Int = .max, modX: Int = .max, fromString: [String]) {
        (self.modX, self.modY) = (min(mod, modX), mod)
        //self.modX = min(mod, modX)
        let len = fromString[0].count
        var currentAutomata = CellType(), x = 0, y = 0
        for i in fromString {
            for j in i {
                if currentAutomata[y] == nil { currentAutomata[y] = [] }
                if j != " " { currentAutomata[y]?.insert(x - (len/2)) }
                x += 1
                if x % len == 0 { x = 0; y += 1 }
            }
        }
        self.automata = currentAutomata
    }
    
    init(_ automata: [Bool], dimen: (Int, Int)) {
        var currentAutomata = CellType(), x = 0, y = 0
        for a in automata {
            if currentAutomata[y] == nil { currentAutomata[y] = [] }
            if !a { currentAutomata[y]?.insert(x) }
            x += 1
            if x % dimen.0 == 0 { x = 0; y += 1 }
        }
        self.automata = currentAutomata
    }
    
    init(_ size: Int, offSet: Bool = false) {
        var initAutomata = CellType()
        let loop = offSet ? -(size/2)..<(size/2) : 0..<size
        for i in loop {
            initAutomata[i] = loop.reduce(Set<Int>()) { .random() ? $0 : $0.union([$1]) }
        }
        automata = initAutomata
    }
    
    mutating func nextGeneration() {
        //let maxMod = mod == .max
        var willCheck = automata
        for (columnN, row) in willCheck {
            for i in row {
                let i1 = i + 1 >= modX ? -modX + 1 : i + 1
                let i_1 = i - 1 <= -modX ? modX - 1 : i - 1
                let y1 = columnN + 1 >= modY ? -modY + 1 : columnN + 1
                let y_1 = columnN - 1 <= -modY ? modY - 1 : columnN - 1
            //_ = row.map { i in
                willCheck.safeInsert(at: columnN, [i1, i_1])
                willCheck.safeInsert(at: y1, [i, i1, i_1])
                willCheck.safeInsert(at: y_1, [i, i1, i_1])
            }
        }
        var newAutomata = CellType()
        for (columnN, row) in willCheck {
            for i in row {
                let i1 = i + 1 >= modX ? -modX + 1 : i + 1// (i + 1) % mod
                let i_1 = i - 1 <= -modX ? modX - 1 : i - 1 //maxMod ? (i - 1) : (i - 1 + mod) % mod
                let y1 = columnN + 1 >= modY ? -modY + 1 : columnN + 1
                let y_1 = columnN - 1 <= -modY ? modY - 1 : columnN - 1
                var neighbors = automata[columnN]?.intersection([i1, i_1]).count ?? 0
                neighbors += automata[y1]?.intersection([i, i1, i_1]).count ?? 0
                neighbors += automata[y_1]?.intersection([i, i1, i_1]).count ?? 0
                // check for was on or off I forget
                if automata[columnN]?.contains(i) == true {
                    if liveCell.contains(neighbors) {
                        newAutomata.safeInsert(at: columnN, i)
                    }
                } else {
                    if deadCell.contains(neighbors) {
                        newAutomata.safeInsert(at: columnN, i)
                    }
                }
            }
        }
        automata = newAutomata
    }
    
}
extension CellType {
    mutating func safeInsert(at: Key,_ element: Value.Element) {
        if self[at] == nil { self[at] = [] }
        self[at]?.insert(element)
    }
    mutating func safeInsert(at: Key,_ element: Value) {
        if self[at] == nil { self[at] = [] }
        self[at] = self[at]?.union(element) ?? []
    }
}


//
///// Cellular Automata
//struct Cell {
//
//    var currentAutomata: [Int:Set<Int>]
//    var totalAutomata: Set<[Int:Set<Int>]>
//    var newAutomata = [Int:Set<Int>]()
//    var colors = [Int:[Int:Bool]]()
//    var newColors = [Int:[Int:Bool]]()
//    var total = 0
//
//
//    init(_ automata: [Bool], dimen: (Int, Int)) {
//        currentAutomata = [:]
//        var initColors = [Int:[Int:Bool]]()
//
//        var x = 0
//        var y = 0
//        for a in automata {
//            if currentAutomata[y] == nil {
//                currentAutomata[y] = []
//            }
//            if initColors[y] == nil {
//                initColors[y] = [:]
//            }
//
//            if !a {
//                currentAutomata[y]?.insert(x)
//                initColors[y]?[x] = .random()
//            }
//            x += 1
//            if x % dimen.0 == 0 {
//                x = 0; y += 1
//            }
//        }
//        totalAutomata = [currentAutomata]
//        colors = initColors
//    }
//
//    init(_ automata: [Int:Set<Int>]) {
//        self.currentAutomata = automata
//        self.totalAutomata = [automata]
//    }
//
//    init(_ size: Int, offSet: Bool = false) {
//        var initAutomata = [Int:Set<Int>]()
//        var initColors = [Int:[Int:Bool]]()
//
//        let loop = offSet ? -(size/2)..<(size/2) : 0..<size
//
//        for i in loop {
//            var hello: Set<Int> = Set<Int>()
//            var hellp = [Int:Bool]()
//            for j in loop {
//                if Bool.random() {
//                    hello.insert(j); hellp[j] = Bool.random()
//                }
//            }
//            initAutomata[i] = hello
//            initColors[i] = hellp
//        }
//        colors = initColors
//        currentAutomata = initAutomata
//        totalAutomata = [initAutomata]
//    }
//
//
//    mutating func sequence() -> Bool {
//        newColors = colors
//        newAutomata = [Int:Set<Int>]()
//        for i in currentAutomata {
//            for j in i.value {
//                neighbor(i.key, x: j + 1)
//                neighbor(i.key, x: j)
//                neighbor(i.key, x: j - 1)
//                neighbor(i.key + 1, x: j + 1)
//                neighbor(i.key + 1, x: j)
//                neighbor(i.key + 1, x: j - 1)
//                neighbor(i.key - 1, x: j + 1)
//                neighbor(i.key - 1, x: j)
//                neighbor(i.key - 1, x: j - 1)
//            }
//        }
//        currentAutomata = newAutomata
//        colors = newColors
//        if totalAutomata.contains(currentAutomata) { return false }
//        totalAutomata.insert(currentAutomata)
//        total += 1
//        return true
//    }
//
//    mutating func neighbor(_ y: Int, x: Int) {
//        var neighbors = 0
//        var whichColor = 0
//        let a = currentAutomata[y] ?? []
//        let b = currentAutomata[y + 1] ?? []
//        let c = currentAutomata[y - 1] ?? []
//
//        if a.contains(x + 1) { neighbors += 1; whichColor += colors[y]![x + 1]! ? 1 : -1 }
//        if a.contains(x - 1) { neighbors += 1; whichColor += colors[y]![x - 1]! ? 1 : -1 }
//        if b.contains(x + 1) { neighbors += 1; whichColor += colors[y + 1]![x + 1]! ? 1 : -1 }
//        if b.contains(x) { neighbors += 1; whichColor += colors[y + 1]![x]! ? 1 : -1 }
//        if b.contains(x - 1) { neighbors += 1; whichColor += colors[y + 1]![x - 1]! ? 1 : -1 }
//        if c.contains(x + 1) { neighbors += 1; whichColor += colors[y - 1]![x + 1]! ? 1 : -1 }
//        if c.contains(x) { neighbors += 1; whichColor += colors[y - 1]![x]! ? 1 : -1 }
//        if c.contains(x - 1) { neighbors += 1; whichColor += colors[y - 1]![x - 1]! ? 1 : -1 }
//
//        if neighbors == 3 {
//            newAutomata[y] = newAutomata[y] ?? []
//            newAutomata[y]?.insert(x)
//            if newColors[y] != nil {
//                newColors[y]![x] = whichColor < 0 ? false : true
//            } else {
//                newColors[y] = [x:(whichColor < 0 ? false : true)]
//            }
//        } else if neighbors == 2 {
//            if (currentAutomata[y] ?? []).contains(x) {
//                newAutomata[y] = newAutomata[y] ?? []
//                newAutomata[y]?.insert(x)
//            }
//        } else {
//            newAutomata[y]?.remove(x)
//            newColors[y]?[x] = nil
//        }
//    }
//
//}
//


//var a = Cell(mod: 30, fromString: [
//    "  .       " + "   " + "  .       ".backwards,
//    " . ..     " + "   " + " . ..     ".backwards,
//    ".    .    " + "   " + ".    .    ".backwards,
//    " .  ..    " + "   " + " .  ..    ".backwards,
//    "  .. . .  " + "   " + "  .. . .  ".backwards,
//    "      .  ." + "   " + "      .  .".backwards,
//    "         ." + "   " + "         .".backwards,
//    "       . ." + "   " + "       . .".backwards,
//    "    .. .. " + "   " + "    .. .. ".backwards,
//    "    .. .. " + "   " + "    .. .. ".backwards,
//    "       . ." + "   " + "       . .".backwards,
//    "         ." + "   " + "         .".backwards,
//    "      .  ." + "   " + "      .  .".backwards,
//    "  .. . .  " + "   " + "  .. . .  ".backwards,
//    " .  ..    " + "   " + " .  ..    ".backwards,
//    ".    .    " + "   " + ".    .    ".backwards,
//    " . ..     " + "   " + " . ..     ".backwards,
//    "  .       " + "   " + "  .       ".backwards,
//])
