//
//  EverMazeExtensions.swift
//  EverMaze2
//
//  Created by Jonathan Pappas on 1/25/21.
//

import Foundation
import SpriteKit

extension NewEverMaze {
    /// Creating The Tile Set
    func createTileSet(_ size: (Int, Int)) -> SKNode {
        let everNode = SKNode()
        let everMazeData = BitMap.EverMazeData(size: size, from: walls)
        
        let cgSize = (CGFloat(size.0), CGFloat(size.1)), tileSize: CGFloat = 16
        let node = BitMap.FromData(size: size, nsData: everMazeData)
            .addTo(everNode)
            .setSize(maxWidth: cgSize.0 * tileSize, maxHeight: cgSize.1 * tileSize)
            .setColor(.currentColor(0.9))
        let node2 = BitMap.FromData(size: size, nsData: everMazeData)
            .addTo(everNode)
            .setSize(maxWidth: cgSize.0 * tileSize, maxHeight: cgSize.1 * tileSize)
            .setZPosition(-1)
            .setColor(.currentColor(0.8))
        node2.position.y -= tileSize * 0.1
        let node3 = BitMap.FromData(size: size, nsData: everMazeData)
            .addTo(everNode)
            .setSize(maxWidth: cgSize.0 * tileSize, maxHeight: cgSize.1 * tileSize)
            .setZPosition(-2)
            .setColor(.currentColor(0.6))
        node3.position.y -= tileSize * 0.2
        
        print("-", start!.characters.count)
        
        /// Create the Start and End
        var on = 0
        var newChars: Set<MovableDots> = []
        for i in start!.characters {
            let pos = codeToPos(i.position)
            let magicMode: (CGFloat, CGFloat) = SaveData.minimal ? (0,0) : (7, -7)
            
            if SaveData.minimal {
                let dot1 = Shape
                    .circle(CGFloat(tileSize) / 2 - CGFloat(tileSize) / 16, parent: everNode) // hide this
                    .setColor(.white) // hide this
                    .setZPosition(4)
                    .setPosition(.init(x: pos.x + magicMode.0, y: pos.y + magicMode.1))
                    .setName("Ball \(on)") // i.name
                dot1.xScale *= -1
            } else {
                
                if i.covers == [[0,0]] {
                    let dot1 = Sprite
                        .image(.inky, parent: everNode)
                        .setSize(maxWidth: 14, maxHeight: 14)
                        .setZPosition(4)
                        .setPosition(.init(x: pos.x + magicMode.0, y: pos.y + magicMode.1))
                        .setName("Ball \(on)") // i.name
                    dot1.xScale *= -1
                } else if i.covers == [[0,0],[0,1]] {
                    let dot1 = Sprite
                        .image(.inky_1_2, parent: everNode)
                        .setSize(maxWidth: 14, maxHeight: 14*2)
                        .setZPosition(4)
                        .setPosition(.init(x: pos.x + magicMode.0, y: pos.y + magicMode.1))
                        .setName("Ball \(on)") // i.name
                    dot1.xScale *= -1
                } else if i.covers == [[0,0],[-1,0]] {
                    let dot1 = Sprite
                        .image(.inky_2_1, parent: everNode)
                        .setSize(maxWidth: 14*2, maxHeight: 14)
                        .setZPosition(4)
                        .setPosition(.init(x: pos.x + magicMode.0, y: pos.y + magicMode.1))
                        .setName("Ball \(on)") // i.name
                    dot1.xScale *= -1
                } else if i.covers == [[0,0],[0,2]] {
                    let dot1 = Sprite
                        .image(.stretchInkyTall, parent: everNode)
                        .setSize(maxWidth: 14, maxHeight: 14*3)
                        .setZPosition(4)
                        .setPosition(.init(x: pos.x + magicMode.0, y: pos.y + magicMode.1))
                        .setName("Ball \(on)") // i.name
                    dot1.xScale *= -1
                } else if i.covers == [[0,0],[-2,0]] {
                    let dot1 = Sprite
                        .image(.stretchInkyLong, parent: everNode)
                        .setSize(maxWidth: 14*3, maxHeight: 14)
                        .setZPosition(4)
                        .setPosition(.init(x: pos.x + magicMode.0, y: pos.y + magicMode.1))
                        .setName("Ball \(on)") // i.name
                    dot1.xScale *= -1
                    
                } else {
                    fatalError()
                }
            }
            
            var ooo = i
            ooo.name = on
            newChars.insert(ooo)
            
            on += 1
        }
        start!.characters = newChars
        characters = newChars
        
        var dotNum = 0
        for i in end!.characters {
            for j in i.covers {
                
                let dot1 = Shape
                    .circle(CGFloat(tileSize) / 4, parent: everNode)
                    .setColor(.currentColor(0.2))
                    .setZPosition(3)
                    .setPosition(codeToPos(i.position.addPosition(j)))
                    .setName("End \(dotNum)--\(j.x)-\(j.y)")
                let dot2 = Shape
                    .circle(CGFloat(tileSize) / 4 + CGFloat(tileSize) / 16, parent: everNode)
                    .setColor(.white)
                    .setZPosition(2)
                    .setPosition(codeToPos(i.position.addPosition(j)))
                    .setName("End \(dotNum)2--\(j.x)-\(j.y)")
                let owo = Shape
                    .circle(CGFloat(tileSize) / 4 + CGFloat(tileSize) / 16, parent: everNode)
                    .setColor(.white)
                    .setZPosition(1)
                    .setPosition(codeToPos(i.position.addPosition(j)))
                    .setName("owo \(dotNum)-\(j.x)-\(j.y)")
                
                /// Flashy End
                let flash = SKAction.run {
                    owo.setScale(1)
                    owo.alpha = 1.0
                    let size = SKAction.scale(by: 2.0, duration: TimeInterval(1))
                    let bye = SKAction.fadeAlpha(to: 0.0, duration: TimeInterval(1.5))
                    size.timingMode = .easeInEaseOut
                    bye.timingMode = .easeInEaseOut
                    owo.run(size)
                    owo.run(bye)
                }
                let wait = SKAction.wait(forDuration: TimeInterval(2.5))
                let seq = SKAction.sequence([flash, wait])
                owo.run(.sequence([.wait(forDuration: 2.5), .repeatForever(seq)]))
                
                dotNum += 1
            }
        }
        
        self.printMe()
        return everNode
    }
    
    func swipe(_ direction: Pos, everNode: SKNode) -> Bool? {
        let balls = everNode.children.filter( { $0.name?.hasPrefix("Ball") == true })
        if balls.contains(where: { $0.hasActions() }) { return nil }
        
        let newPos = moveCharacter(.init([], characters), direction)
        if let newPos = newPos {
            characters = newPos.characters
            var on = 0
            for ball in balls {
                let pos = ball.position
                let oldPos = posToCode(pos)
                
                // This is only true for a 1 circle game.
                guard let newnewPos1 = newPos.characters.first(where: { $0.name == on })?.position else { fatalError() }
                let newnewPos = codeToPos(newnewPos1)
                //let newnewPos = codeToPos(Array(newPos.characters)[on].position) //.first { _ in 0 == 0 }!.position)
                //BAD: let newnewPos = codeToPos(Array(newPos.characters).first { _ in 0 == 0 }!.position)
                let magicMode: (CGFloat, CGFloat) = SaveData.minimal ? (0,0) : (7, -7)
                
                let action = SKAction.move(to: .init(x: newnewPos.x + magicMode.0, y: newnewPos.y + magicMode.1), duration: 0.2)
                action.timingMode = .easeInEaseOut
                ball.run(action)
                on += 1
            }
            
        } else {
            return nil
        }
        
        var ooowooo = newPos
        var ooowooch: Set<MovableDots> = []
        for i in ooowooo?.characters ?? [] {
            var opo = i
            opo.name = 0
            ooowooch.insert(opo)
        }
        ooowooo?.characters = ooowooch
        
        if ooowooo == end { return true }
        return false
    }
    
    func MINIcodeToPos(_ pos: Pos) -> CGPoint {
        var tileSize = 16
        let posx = CGFloat(pos.x * tileSize)
        let posy = CGFloat(pos.y * tileSize)
        return CGPoint(x: posx, y: posy)
    }
    func codeToPos(_ pos: Pos) -> CGPoint {
        var tileSize = 16
        let posx = CGFloat(pos.x * tileSize) + CGFloat(tileSize) / 2 - CGFloat(size[0] * tileSize / 2)
        let posy = CGFloat(pos.y * tileSize) + CGFloat(tileSize) / 2 - CGFloat(size[1] * tileSize / 2)
        return CGPoint(x: posx, y: posy)
    }
    func posToCode(_ pos: CGPoint) -> Pos {
        var tileSize = 16
        let posx = (CGFloat(pos.x) - CGFloat(tileSize) / 2 + CGFloat(size[0] * tileSize / 2)) / CGFloat(tileSize)
        let posy = (CGFloat(pos.y) - CGFloat(tileSize) / 2 + CGFloat(size[1] * tileSize / 2)) / CGFloat(tileSize)
        return Pos([Int(posx), Int(posy)])
    }
    
    func reset(_ everNode: SKNode) {
        let balls = everNode.children.filter( { $0.name?.hasPrefix("Ball") == true })
        if balls.contains(where: { $0.hasActions() }) { return }
        
        characters = []
        
        for i in start!.characters {
            let ball = balls[i.name]
            //let ball = everNode.childNode(withName: "Ball 0")! //\(i.name)
            ball.removeAllActions()
            let pos = codeToPos(i.position)
            let magicMode: (CGFloat, CGFloat) = SaveData.minimal ? (0,0) : (7, -7)
            ball.position = .init(x: pos.x + magicMode.0, y: pos.y + magicMode.1)
            var newww = MovableDots.init(covers: i.covers, position: i.position)
            newww.name = i.name
            characters.insert(newww)
        }
    }
}


extension NewEverMaze: CustomStringConvertible {
    public var description: String {
        var printo = ""
        
        printo += "–––––" + "\n"
        printo += ("Ever Maze v1") + "\n"
        printo += ("name: Welcome to my Level 1!") + "\n"
        printo += ("dimensions: \(size)") + "\n"
        
        printo += "\(start!)" + "\n"
        printo += ("    - Total Characters: \(start!.characters.count)") + "\n"
        
        if size.count > 2 {
            printo += "\(walls)" + "\n"
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
                printo += (i.reduce("[") { $0 + $1 } + "]") + "\n"
            }
        }
        
        printo += "\(end!)" + "\n"
        printo += ("    - Solution Length:" + " " + "\(end!.movements.count)") + "\n"
        printo += ("    - Total Checks: \(totalMazeCount)") + "\n"
        printo += ("    - Total Time: \(totalTime)") + "\n"
        var wall2 = walls; wall2.removeAll(where: { $0 == true })
        printo += ("    - Total Empty Spaces: \(wall2.count)") + "\n"
        printo += ("–––––") + "\n"
        //print(printo)
        return printo
    }
}
