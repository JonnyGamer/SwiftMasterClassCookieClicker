//
//  EverMazeScene.swift
//  EverMazeNextGeneration
//
//  Created by Jonathan Pappas on 7/22/21.
//

import Foundation
import SpriteKit

var trueLevel: (Int, Int) = (0,0)
class EverMazeScene: SKSceneNode {
    
    var o: OO = OO()
    
    override func begin() {
        draggable = false
        backgroundColor(.black)
        
        //print("Let's GOOO!")
        //let uwu = NewEverMaze.init([5,5], [.init(covers: [[0,0]], position: [0,0])], randomWalls: { oneIn(4) })
        //uwu.makeMaze()
    }
    
    func addEverMaze(_ maze: NewEverMaze) {
        let newEverMaze = maze
            .createTileSet(trueLevel)
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
                attributedText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.init(name: "Hand", size: 250) as Any], range: range)
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
            o.superYupReset()
        }
    }
    
    override func touchesMoved(_ at: CGVector) {
        var swiped: Pos = .init([0,0])
        if abs(at.dx) > abs(at.dy) {
            swiped = .init([at.dx > 0 ? 1 : -1, 0])
        } else {
            swiped = .init([0, at.dy > 0 ? 1 : -1])
        }
        
        let wow = o.everMaze?.swipe(swiped, everNode: o.everNode!)
    }
    
    override func touchesEnded(_ at: CGPoint, release: CGVector) {
    }
}
