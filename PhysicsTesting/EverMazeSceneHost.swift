//
//  GameScene.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Magic
import EverMazeKit



class EverMazeSceneHost: HostingScene {
    var levelSize: [Int] = [5,5]
    convenience init(sizePlease: [Int], screens: Int) {
        self.init(screens: screens)
        levelSize = sizePlease
    }
    
    override func didMove(to view: SKView) {
        launchScene = EverMazeScene.self
        EverMazeScene.winner = -2
        super.didMove(to: view)
        //let uwu = NewEverMaze.regularPuzzle([5,5])
        //let uwu = NewEverMaze.init(LARGESTMAZES.levelEVIL9, printo: true)
        for i in c {
            let uwu = NewEverMaze.nPlayerPuzzle(players: 3, levelSize)// .regularPuzzle(levelSize)
            (i.children.first as? EverMazeScene)?.addEverMaze(uwu.copy())// ?.o.everMaze = uwu
        }
    }
    
    
    // Touching Button Code
    var nodesTouched: [SKNode] = []
    
    #if os(macOS)
    var loc: CGPoint = .zero
    override func mouseDown(with event: NSEvent) {
        loc = event.location(in: self)
        c.forEach {
            ($0.children.first as? SKSceneNode)?.touchesBegan(loc, nodes: nodes(at: loc))
        }
        let nodesTouched = nodes(at: event.location(in: self))
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
    }
    override func mouseUp(with event: NSEvent) {
        let newLoc = event.location(in: self)
        c.forEach {
            ($0.children.first as? SKSceneNode)?.touchesEnded(newLoc, release: .init(dx: loc.x - newLoc.x, dy: loc.y - newLoc.y))
        }
        let nodesEndedOn = nodes(at: event.location(in: self))
        nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()
    }
    #endif
    
    #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesTouched = nodes(at: touches.first?.location(in: self) ?? .zero)
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nodesEndedOn = nodes(at: touches.first?.location(in: self) ?? .zero)
        nodesTouched.touchReleased()
        nodesTouched = []
        nodesEndedOn.touchEndedOn()
    }
    #endif
}
