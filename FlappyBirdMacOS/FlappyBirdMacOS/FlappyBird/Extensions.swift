//
//  Extensions.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation
import SpriteKit

enum Presentation {
    case mainMenu, play
}
var scenesLoaded: [Presentation:SKScene] = [.mainMenu:MainMenu(size: CGSize(width: 750, height: 1334))]
extension SKScene {
    func presentScene(_ this: Presentation) {
        // Load a scene you've already been to
        if let preLoaded = scenesLoaded[this] {
            self.view?.presentScene(preLoaded, transition: .fade(withDuration: 0.5))
            return
        }
        
        // Otherwise, load a new scene!
        var gameplay: SKScene.Type
        switch this {
            case .mainMenu: gameplay = MainMenu.self
            case .play: gameplay = PlayScene.self
        }
        
        let gameplay2 = gameplay.init(size: scene!.size)
        gameplay2.scaleMode = .aspectFit
        gameplay2.anchorPoint = .init(x: 0.5, y: 0.5)
        self.view?.presentScene(gameplay2, transition: .fade(withDuration: 0.5))
    }
}

extension CGFloat {
    static func random(_ from: ClosedRange<Int>) -> CGFloat {
        return CGFloat(from.randomElement()!)
    }
}
extension SKLabelNode {
    static func flappyFont() -> SKLabelNode {
        return SKLabelNode(fontNamed: "04b_19")
    }
}

extension SKAction {
    static var birdFadeOut: SKAction {
        return .fadeOut(withDuration: 0.25)
    }
    static var birdFadeIn: SKAction {
        return .fadeIn(withDuration: 0.25)
    }
    static var waitForOneSecond: SKAction {
        return .wait(forDuration: 1)
    }
    
    static func moveBackGroundAction(_ width: CGFloat) -> SKAction {
        let moveX = SKAction.moveBy(x: width * -2, y: 0, duration: 20)
        let reset = SKAction.moveBy(x: width * 2, y: 0, duration: 0)
        return .repeatForever(.sequence([moveX, reset]))
    }
    static func moveGroundAction(_ width: CGFloat) -> SKAction {
        let moveX = SKAction.moveBy(x: width * -2, y: 0, duration: 10)
        let reset = SKAction.moveBy(x: width * 2, y: 0, duration: 0)
        return .repeatForever(.sequence([moveX, reset]))
    }
}
