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
    
    override func begin() {
        print("foo")
        draggable = false
        backgroundColor(.black)
        
        //print("Let's GOOO!")
        //let uwu = NewEverMaze.init([5,5], [.init(covers: [[0,0]], position: [0,0])], randomWalls: { oneIn(4) })
        //uwu.makeMaze()
    }
    
    func addEverMaze(_ maze: NewEverMaze) {
        let newEverMaze = maze
            .createTileSet((maze.size[0], maze.size[1]))
            .addTo(self)
            //.setPosition(.midScreen)
            //.setSize(maxWidth: w * 0.9, maxHeight: w > h ? h - 200 : h - 300)
        o.everMaze = maze
        o.everNode = newEverMaze
        
        let paddo = newEverMaze.padding
        paddo.centerAt(point: .zero)
        paddo.keepInside(size)
        

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
        redo.position = .init(x: (width/2)-redo.size.width-20, y: (height/2)-redo.size.height-20)
        self.redo = redo
        
    }
    
    var redo: Sprite!
    
    override func touchesBegan(_ at: CGPoint, nodes: [SKNode]) {
        if nodes.contains(redo) {
            if realWinner {
                SaveData.trueLevel += 1
                scene?.view?.presentScene(EverMazeSceneHost(from: true))
            } else {
                o.superYupReset()
            }
        }
    }
    
    override func touchesMoved(_ at: CGVector) {

    }
    
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
        if release == .zero { return }
        if Self.winner == 0 { return }
        
        var swiped: Pos = .init([0,0])
        if abs(release.dx) > abs(release.dy) {
            swiped = .init([release.dx > 0 ? 1 : -1, 0])
        } else {
            swiped = .init([0, release.dy > 0 ? 1 : -1])
        }
        
        let wow = o.everMaze?.swipe(swiped, everNode: o.everNode!)
        if wow == true {
            Self.winner += 1
            realWinner = true
            o.everNode?.run(.fadeOut(withDuration: 0.3))
            //o.everNode?.removeFromParent()
        }
    }
}
