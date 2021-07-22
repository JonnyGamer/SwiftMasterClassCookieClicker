//
//  Game.swift
//  EverMaze2
//
//  Created by Jonathan Pappas on 1/25/21.
//

import SpriteKit

class OO {
    var everMaze: NewEverMaze?
    var everNode: SKNode?
    var totalSwipes = 0
    var goal = 0
    var win = false
    var superYupReset: () -> () = {}
    
    func reset() {
        everMaze = nil; everNode = nil; totalSwipes = 0; goal = 0; win = false; superYupReset = {}
    }
}

/*
import Foundation

//extension SaveData {
//    @UserDefault(key: "orbs!!!-------------", defaultValue: 0)
//    static var orbs: Int
//
//    @UserDefault(key: "Level!!!-------------", defaultValue: 1)
//    static var level: Int
//
//    @UserDefault(key: "Current Level-------------", defaultValue: "")
//    static var currentLevel: String
//    static func deleteLevel() { currentLevel = "" }
//}



var misses = 0

protocol EverHostable: Hostable {
    //var supermastery: [String:Communication] { get set }
    var o: OO { get set }
    func swiped(_ direction: CGVector)
    //func keyPressed(_ key: KeyboardKey)
}

var lvlvlvl: (Int, Int, Int, Int) = (3,3,0,0)
struct EverMazeView: EverHostable {
    
    init() { that = SKNode(); this = SKNode(); o = OO() }
    var that: SKNode, this: SKNode, o: OO
    
    func begin() {
        //misses = 0
        //SaveData.level = SaveData.orbs + 1 // Level == current amt of orbs?
        o.reset()
        Music.o.playMusic(.everMaze)
        
        let bg = SKSpriteNode.init(color: .black, size: .fullScreen)
        bg.zPosition = -1000
        bg.position = .midScreen
        that.addChild(bg)
        //backgroundColor(.black)
        
        //let queue = DispatchQueue.init(label: "Foo")
        //queue.async {
        var trueLevel = lvlvlvl// (10,10)// choosableLevels[min(SaveData.level - 1, choosableLevels.count - 1)].0// (level, level)
        if w > h {
            trueLevel = (trueLevel.1, trueLevel.0, trueLevel.2, trueLevel.3)
        }
        
        // RESET THE SEED PER LEVEL - BUG
        seed = SaveData.level
        g = SeededGenerator.Build(seed: trueLevel.2) // Seed = level?
        
        var newMaze: NewEverMaze
        
        //SaveData.currentLevel = "evermaze://v1.size4,4.seed1"
        switch (trueLevel, SaveData.currentLevel) {
        
        // SHOULD I HAVE REMOVED THIS
//        case let (_, x) where x != "":
//            newMaze = NewEverMaze.init(parseDeepLink: x) // So there's this.
//            //newMaze = NewEverMaze.init(x, printo: false)
//            trueLevel = (newMaze.size[0], newMaze.size[1], 0)
            
            //UIPasteboard.general.string = x
            //newMaze.makeMaze()
        //case (3,3): newMaze = NewEverMaze(EverMazeLevel3.chooseRandomMaze())
        //case (4,4): newMaze = NewEverMaze(EverMazeLevel4.chooseRandomMaze())
        
        case ((1,3,_,_),_):

            newMaze = NewEverMaze.init([trueLevel.0, trueLevel.1], [.init(covers: [[0,0]], position: [0,0])], randomWalls: { false })
            newMaze.makeMaze()
            
        case ((_,_,_,let players),_):
            var superPlayers: Set<MovableDots> = []
            for i in 0..<players {
                superPlayers.insert(.init(covers: [[0,0]], position: [i,i]))
            }
            
            newMaze = NewEverMaze.init([trueLevel.0, trueLevel.1], [.init(covers: [[0,0]], position: [0,0])], randomWalls: { oneIn(4) })
            newMaze.makeMaze()
            
            while true {
                var pass = false
                let lvl = Int(sqrt(Double(trueLevel.0 * trueLevel.1)))
                let new = newMaze.end!.movements.count
                o.goal = newMaze.end!.movements.count
                
                if lvl == 1 {
                    print(new)
                    if new == 1 {
                        pass = true
                    }
                }
                if lvl == 3, new > 2 { pass = true }
                if lvl <= 55 { if Double(lvl)*1.5 <= Double(new) { pass = true } }
                else if lvl <= 84 { if Double(lvl) * 0.5 <= Double(new) { pass = true } }
                else if lvl <= 120 { if Double(lvl) * 0.4 <= Double(new) { pass = true } }
                else if Double(new) * 0.3 >= Double(lvl) { pass = true }
                if lvl > 3, newMaze.totalMazeCount / 2 < new { pass = false }
                
                if pass {
                    if lvl > 20 { break }
                    var testCell = Cell.init(newMaze.walls, dimen: (trueLevel.0, trueLevel.1))
                    var prevAutomata = testCell.automata
                    var currentAutomata = testCell.automata
                    for _ in 1...20 {
                        testCell.nextGeneration()
                        prevAutomata = currentAutomata
                        currentAutomata = testCell.automata
                    }
                    if prevAutomata != currentAutomata {
                        break
                    }
                }
                
                newMaze = NewEverMaze.init([trueLevel.0, trueLevel.1], superPlayers, randomWalls: { oneIn(4) })
                newMaze.makeMaze()
                misses += 1
            }
        }
            
        let newEverMaze = newMaze
            .createTileSet((trueLevel.0, trueLevel.1))
            .addTo(this)
            .setPosition(.midScreen)
            .setSize(maxWidth: w * 0.9, maxHeight: w > h ? h - 200 : h - 300)
            
        o.everMaze = newMaze
        o.everNode = newEverMaze
        o.goal = newMaze.end?.movements.count ?? -1
        
        //newMaze.saveDeepLink()
        SaveData.currentLevel = magicText//newMaze.description
        print(magicText)
        
        INVERSEgameOfLifeCustom(newMaze.walls, newMaze.size)
        
        
        
        //}
        
        this.alpha = 1; that.alpha = 1
        
        //gameOfLifeCustom(o.everMaze!.walls, .white)
        
        let back = Sprite
            .image(.darkBack, parent: that)
            .setSize(maxWidth: w * 0.15, maxHeight: 120)
            .setPosition(.left, .top)
            .becomeButtonGeneral {
                print("POOPS")
                (self.that.scene as? EverHostScene)?.gameType = .run
                (self.that.scene as? EverHostScene)?.returnToGame()
            }
            //.becomeButton(self, MainMenu.self) // RETURN_HERE
            .setName("Button 1")
        
        let levelName = EverLabel
            .text("Level \(SaveData.level)", color: .white, parent: that)
            .setSize(maxWidth: w * 0.5, maxHeight: 50)
            .setPosition(.center, .top)
        
        let swipes = EverLabel
            .text("Swipes: \(o.totalSwipes)", color: .white, parent: that)
            .setSize(maxHeight: 30)
            .setPosition(.left, .bottom)
            .setName("Swipes")
        //swipes.horizontalAlignmentMode = .left
        //swipes.position.x -= swipes.width/2
        
        let levelGoal = EverLabel
            .text("Goal: \(o.goal) Swipe\(o.goal == 1 ? "" : "s")", color: .white, parent: that)
            .setSize(maxHeight: 30)
            .setPosition(.left, .above(swipes))
            .setName("Button 3")
        levelGoal.position.y -= 20
        
        func yupReset() {
            if o.everNode?.hasActions() != true, !o.win {
                o.totalSwipes = 0
                
                let attributedText = NSMutableAttributedString(string: "Swipes: 0")
                let range = NSRange(location: 0, length: "Swipes: 0".count)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                paragraphStyle.minimumLineHeight = 20
                paragraphStyle.lineSpacing = -270
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
                attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.init(name: "Hand", size: 250) as Any], range: range)
                swipes.attributedText = attributedText
                
                //swipes.attributedText?.attr
                //swipes.attributedText?.set .string = "Swipes: 0"
                newMaze.reset(newEverMaze)
            }
        }
        o.superYupReset = yupReset
        
        let redo = Sprite
            .image(.darkReplay, parent: that)
            .setSize(maxWidth: w * 0.15, maxHeight: 120)
            .setPosition(.right, .top)
            .becomeButtonGeneral {
                yupReset()
            }
            .setName("Button 2")
        
        //fatalError()
        print("DOWN EHEE BRY")
    }

    
    func update() {}
    
    func touchBegan(_ pos: CGPoint, _ nodes: [SKNode]) { nodes.touchBegan(pos) }
    
    func touchMoved(_ moved: CGVector) {}
    
    func touchEnded(_ pos: CGPoint, _ nodes: [SKNode]) { nodes.touchEnd(pos) }
    func swiped(_ direction: CGVector) {
        if o.totalSwipes + 1 == o.goal, o.everNode?.hasActions() == true { return }
        
        // Determine swipe code
        var swiped: Pos = .init([0,0])
        if abs(direction.dx) > abs(direction.dy) {
            swiped = .init([direction.dx > 0 ? 1 : -1, 0])
        } else {
            swiped = .init([0, direction.dy > 0 ? 1 : -1])
        }
        
        let wow = o.everMaze?.swipe(swiped, everNode: o.everNode!)
        if wow != nil {
            o.totalSwipes += 1
            //print("Obviously a SWIPE")
            
            if let swipes = that.childNode(withName: "Swipes") as? SKLabelNode {
                let attributedText = NSMutableAttributedString(string: "Swipes: \(o.totalSwipes)")
                let range = NSRange(location: 0, length: "Swipes: \(o.totalSwipes)".count)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                paragraphStyle.minimumLineHeight = 20
                paragraphStyle.lineSpacing = -270
                attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
                attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.init(name: "Hand", size: 250) as Any], range: range)
                swipes.attributedText = attributedText
            }
            
            //(that.childNode(withName: "Swipes") as? SKLabelNode)?.text = "Swipes: \(o.totalSwipes)"
        } else {
            //print("pupu")
        }
        if wow == true {
            o.win = true
            SaveData.deleteLevel()
            gameOfLifeCustom(o.everMaze!.walls, o.everMaze!.size)
            
            for i in ["Button 1", "Button 2", "Button 3", "Swipes"] {
                that.childNode(withName: i)?.run(.fadeOut(withDuration: 0.2))
            }
            
            //present(MainMenu.self)
        }
    }
    
//    func keyPressed(_ key: KeyboardKey) {
//        switch key {
//        case .spacebar: //reset()
//
//            if o.win {
//                present(EverMazeView.self)
//            } else {
//                o.superYupReset()
//            }
//
//        case .upArrow: swiped(.init(dx: 0, dy: 1000))
//        case .downArrow: swiped(.init(dx: 0, dy: -1000))
//        case .leftArrow: swiped(.init(dx: -1000, dy: 0))
//        case .rightArrow: swiped(.init(dx: 1000, dy: 0))
//        case .back: present(MainMenu.self)
//        }
//    }
    
    func reset() {
        fatalError()
        //magicReset()
    }
    
    func dividing() -> CGFloat {
        let lvl = o.everMaze?.size[0] ?? 0
        // width 3 = 0.15
        // width 100 = 0.5
        return (0.00360825 * CGFloat(lvl)) + 0.139175
    }
    
    func INVERSEgameOfLifeCustom(_ n: [Bool],_ dimen: [Int]) {
        var a = Cell.init(n, dimen: (dimen[0], dimen[1]))
        
        var automata: [[Int : Set<Int>]] = [a.automata]
        for _ in 1...19 {
            a.nextGeneration()
            if automata.first != a.automata {
                automata = [a.automata] + automata
            }
        }
        
        guard let node = o.everNode else { return }
        let oldXScale = node.children[0].xScale
        let veryOldXSCALE = node.xScale
        node.setScale(veryOldXSCALE * dividing())
        _ = node.children.map { $0.alpha = 0 }
        let oldChildren = node.children
        var newCells: BitMap!
        
        var num = 0
        func newCell() {
            newCells = BitMap.CellularAutomata(square: 250, color: .currentColor(0.9), from: automata[num])
                .addTo(node)
            newCells.setScale(oldXScale)
            //newCells.setScale(oldXScale * veryOldXSCALE)
            newCells.position.x -= 8 * CGFloat(dimen[0] - 2)
            newCells.position.y -= 8 * CGFloat(dimen[1] - 2)
            num += 1
        }
        
        let placement = SKAction.run {
            newCell()
        }
        let remove = SKAction.run {
            newCells.removeFromParent()
        }
        let end = SKAction.run {
            _ = oldChildren.map {
                $0.removeFromParent()
                $0.addTo(node); $0.run(.fadeIn(withDuration: 0.2))
            }
        }
        
        
        node.run(
            .sequence([
                .repeat(SKAction.sequence([placement, .wait(forDuration: 0.1), remove]), count: automata.count - 1),
                placement,
                .wait(forDuration: 0.5),
                .group([
                    .scale(to: veryOldXSCALE, duration: 0.5),
                    .wait(forDuration: 0.2),
                    end,
                ]),
                .wait(forDuration: 0.5),
                remove,
            ])
        )
        
        _ = node.setZPosition(-1)
    }
    

    func gameOfLifeCustom(_ n: [Bool],_ dimen: [Int]) {
        var a = Cell.init(n, dimen: (dimen[0], dimen[1]))
        
        guard let node = o.everNode else { return }
        let oldXScale = node.children[0].xScale
        
        func newCell() {
            let newCells = BitMap.CellularAutomata(square: 250, color: .currentColor(0.9), from: a.automata)
                .addTo(node)
            newCells.setScale(oldXScale)
            newCells.position.x -= 8 * CGFloat(dimen[0] - 2)
            newCells.position.y -= 8 * CGFloat(dimen[1] - 2)
        }
        
        let placement = SKAction.run {
            newCell()
        }
        let remove = SKAction.run {
            node.removeAllChildren()
            a.nextGeneration()
        }
        
        let superScale = SKAction.scale(by: dividing(), duration: 0.5)
        superScale.timingMode = .easeInEaseOut
        let magic = SKAction.sequence([.wait(forDuration: 0.5), superScale])
        
        _ = node.children.map { $0.run(.sequence([.wait(forDuration: 0.7), .fadeOut(withDuration: 0.2), .removeFromParent()])) }
        node.run(magic)
        
        node.run(
            .sequence([
                .sequence([placement, .wait(forDuration: 1.5), remove]),
                .repeatForever(SKAction.sequence([placement, .wait(forDuration: 0.1), remove]))
            ])
        )
        
        // XP
        //let lvl = SaveData.level
        //var newXP = lvl + lvl - min(lvl, o.totalSwipes)
        //if o.totalSwipes == o.goal { newXP += lvl }
//        SaveData.orbs += 1//newXP
//        // Make a node that says: +5 XP!
//        let nowOrbs = SaveData.orbs
        let winText = "You beat the level!"// SaveData.orbs % 10 == 0 ? "Spaceship Upgrade!" : "You found a Power Orb!"
//        if ArtPieces.pieces.contains(where: { $0.0 == nowOrbs }) { winText = "Your Spaceship Upgraded!" }
//        //if SaveData.orbs >= 250 { winText = "You have reached Deep Space!" }
//
        let xpNode = EverLabel
            .text(winText, color: .white, parent: that)
            .setSize(maxWidth: w * 0.9, maxHeight: 40)
            .setPosition(.center, .top)
        xpNode.position.y += 430
        let moveMent2 = SKAction.moveBy(x: 0, y: -500, duration: 0.5)
        moveMent2.timingMode = .easeOut
        xpNode.run(.sequence([.wait(forDuration: 0.7), moveMent2]))
//
//        //perfection
        var perfection = false
        if o.totalSwipes == o.goal {
            let perfect = EverLabel
                .text("Perfect! Woo!", color: .white, parent: that)
                .setSize(maxHeight: 20)
                .setPosition(.center, .top)
            perfect.position.y += 370
            perfect.run(.sequence([.wait(forDuration: 1.3), moveMent2]))
            perfection = true
        }
        


        // Add continue buttons
        node.run(.wait(forDuration: 0.3)) {
            let play = Sprite
                .image(.darkNext, parent: that)
                .setSize(maxWidth: w / 3, maxHeight: 333)
                .setPosition(.center, .bottom)
                .becomeButtonGeneral {
                    if perfection {
                        (self.that.scene as? EverHostScene)?.gameType = .woo
                    } else {
                        (self.that.scene as? EverHostScene)?.gameType = .win
                    }
                    
                    (self.that.scene as? EverHostScene)?.returnToGame()
                }
            
            let moveMent = SKAction.moveBy(x: 0, y: 500, duration: 0.5)
            moveMent.timingMode = .easeOut

            play.position.y -= 500
            play.run(.sequence([.wait(forDuration: 0.9), moveMent]))
        }

        node.setZPosition(-1)

    }

    
}
*/
