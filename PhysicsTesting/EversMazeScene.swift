//
//  Evers.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/2/21.
//

import Magic
import EverMazeKit

class EverMazeScene: SKSceneNode {
    
    var o: OO = OO()
    
    static var winner: Int = -2
    var realWinner: Bool = false
    var swipes = 0 {
        didSet { swipeCount.text = "swipes: \(swipes)" }
    }
    let swipeCount = SKLabelNode.init(text: "swipes: 0")
    
    static var raceMode = false
    
    
    override func begin() {
        print("foo")
        draggable = false
        backgroundColor(.black)
    }
    
    func addLabels() {
        let foo1 = SKLabelNode.init(text: "goal: \(o.goal) swipes")
        foo1.fontColor = .white
        foo1.fontSize *= (min((size.height * 0.7) / foo1.frame.width, (size.width * 0.65) / foo1.frame.width))
        //foo1.setScale(min((size.height * 0.7) / foo1.frame.width, (size.width * 0.65) / foo1.frame.width))
        foo1.verticalAlignmentMode = .center
        //foo.horizontalAlignmentMode = .left
        foo1.position.y = (size.height/2) - (size.height * 0.075)// + foo.frame.height
        foo1.zPosition = .infinity
        addChild(foo1)
        
        let foo = swipeCount
        foo.fontColor = .white
        foo.fontSize = foo1.fontSize
        //foo.setScale(foo1.xScale)
        foo.verticalAlignmentMode = .center
        foo.horizontalAlignmentMode = .left
        foo.position.x = (-size.width/2) + (size.width * 0.15)
        
        foo.position.y = (-size.height/2) + (size.height * 0.075)// + foo.frame.height
        foo.zPosition = .infinity
        addChild(foo)
    }
    
    func addEverMaze(_ maze: NewEverMaze) {
        let newEverMaze = maze
            .createTileSet((maze.size[0], maze.size[1]))
            .addTo(self)
        o.everMaze = maze
        o.everNode = newEverMaze
        o.goal = maze.end?.movements.count ?? 0
        
        addLabels()
        
        let paddo = newEverMaze.padding
        paddo.centerAt(point: .zero)
        paddo.keepInside(CGSize.init(width: size.width * 0.7, height: size.height * 0.7))
        

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
                attributedText.addAttributes([NSAttributedString.Key.foregroundColor : NSColor.white, NSAttributedString.Key.font : UIFont.init(name: "Hand", size: 250) as Any], range: range)
               // swipes.attributedText = attributedText
                
                //swipes.attributedText?.attr
                //swipes.attributedText?.set .string = "Swipes: 0"
                maze.reset(newEverMaze)
            }
        }
        o.superYupReset = yupReset
        let redo = Sprite
            .image(.darkReplay, parent: self)
            .setSize(maxWidth: width * 0.15, maxHeight: height*0.1)
            .setName("Button 2")
        redo.position = .init(x: (width/2)-(redo.size.width*1.2), y: (height/2)-(redo.size.height*1.2))
        self.redo = redo
        
    }
    
    var redo: Sprite!
    var cantSwipe = false
    
    override func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {
        if nodes.contains(redo) {
            swipes = 0
            cantSwipe = true
            
            if realWinner {
                let nextLevelSize = o.everMaze?.size.next() ?? []
                //SaveData.trueLevel += 1
                if Self.raceMode {
                    let sc = EverMazeSceneHost(sizePlease: nextLevelSize, screens: 1)
                    sc.scaleMode = .aspectFit
                    scene?.view?.presentScene(sc)
                } else {
                    realWinner = false
                    removeAllChildren()
                    let uwu = NewEverMaze.regularPuzzle(nextLevelSize)
                    addEverMaze(uwu.copy())
                    begin()
                }
                
                
            } else {
                o.superYupReset()
            }
        }
    }
    
    override func touchesMoved(_ at: CGVector) {
    }
    
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
        if cantSwipe { cantSwipe = false; return }
        if release == .zero { return }
        if Self.winner == 0 { return }
        
        var swiped: Pos = .init([0,0])
        if abs(release.dx) > abs(release.dy) {
            swiped = .init([release.dx > 0 ? 1 : -1, 0])
        } else {
            swiped = .init([0, release.dy > 0 ? 1 : -1])
        }
        
        let wow = o.everMaze?.swipe(swiped, everNode: o.everNode!)
        if wow != nil {
            swipes += 1
        }
        if wow == true {
            if Self.raceMode {
                Self.winner += 1
            }
            realWinner = true
            o.everNode?.run(.fadeOut(withDuration: 0.3))
            //o.everNode?.removeFromParent()
        }
    }
}
