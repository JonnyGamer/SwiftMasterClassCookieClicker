//
//  CrazyTrailAtGuy.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 8/7/21.
//

import Magic

extension SKSpriteNode {
    func jonnyAction() {
        anchorPoint = .zero
        run(.repeatForever(.sequence([
            .moveBy(x: 100, y: 200, duration: 0.5).easeInOut(),
            .moveBy(x: -100, y: -200, duration: 0.5).easeInOut()
        ])))
        run(.repeatForever(.sequence([
            .group([
                .scaleX(to: 0.5, duration: 0.5).easeInOut(),
                .scaleY(to: 2.0, duration: 0.5).easeInOut(),
            ]),
            .group([
                .scaleY(to: 0.5, duration: 0.5).easeInOut(),
                .scaleX(to: 2.0, duration: 0.5).easeInOut(),
            ])
        ])))
        run(.repeatForever(.rotate(byAngle: .pi, duration: 4.0)))
        
        func perfectLabel(text: String) -> SKNode {
            SKLabelNode(text: text).then({
                $0.verticalAlignmentMode = .center
                $0.horizontalAlignmentMode = .center
                $0.fontColor = .black
                $0.fontName = "Hand"
            }).padding.then({
                $0.keepInside(.hundred.doubled.times(0.9))
            })
        }

        let wow = VStack(
            nodes: [
                perfectLabel(text: "Ever Maze!"),
                perfectLabel(text: "Stage 1!"),
                perfectLabel(text: "What Secrets?"),
            ].reversed()
        )
        wow.centerAt(point: .init(x: 100, y: 100))
        //wow.position = CGPoint(x: 100, y: 100)
        addChild(wow)
    }
}

