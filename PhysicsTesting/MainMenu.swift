//
//  GameScene.swift
//  PhysicsTesting
//
//  Created by Jonathan Pappas on 7/31/21.
//

//import SpriteKit
import GameplayKit
import Magic

var (w, h): (CGFloat, CGFloat) = (1000, 1000)

class GameScene: HostingScene {
    
    func levelsHStack(_ from: ClosedRange<Int>? = nil, this: [String] = []) -> HStack {
        var playerNodes: [SKNode] = []
        for i in from?.map({ String($0) }) ?? this {
            //let button = Button(size: .hundred, text: "􀎡\(i)")//image: "lock-fill")
            let button = Button(size: .hundred, node: HStack.init(nodes: [
                SKSpriteNode.init(imageNamed: "lock-fill").then({
                    $0.keepInside(.hundred)
                }).padding,
                SKLabelNode(text: "\(i)").then({
                    $0.horizontalAlignmentMode = .center
                    $0.verticalAlignmentMode = .center
                    $0.fontSize *= 3
                    $0.fontColor = .black
                    $0.fontName = "Hand"
                })
            ])).then({
                $0.touchEndedOn = { [self] _ in
                    launchScene = EverMazeScene.self
                    let sc = EverMazeSceneHost(screens: 1)
                    sc.scaleMode = .aspectFit
                    let foo = SKTransition.fade(with: .black, duration: 0.5)
                    view?.presentScene(sc, transition: foo)
                }
            })
            playerNodes.append(button.padding)
        }
        let playerSelect = HStack.init(nodes: playerNodes)
        return playerSelect
    }
    
    override func didMove(to view: SKView) {
        print("􀄪")
        let stacko = HStack.init(nodes: [
            Button(size: .hundred, text: "􀄪").then({
                $0.touchBegan = { _ in
                    print("I was touched")
                }
                $0.touchEndedOn = { _ in
                    print("Let's MOVE ON")
                }
            }).padding,
            Button(size: .hundred, text: "Ever Maze, Stage 1").padding,
            Button(size: .hundred, text: "􀎡").padding,
        ]).then({
            bring(dir: .down, node: $0, delay: 0.6)
        })
        addChild(stacko)
        stacko.keepInside(size.times(0.9))
        stacko.centerAt(point: .init(x: CGPoint.midScreen.x, y: 900))
        
        
        let n1 = levelsHStack(1...5)
        let n2 = levelsHStack(6...10)
        let n3 = levelsHStack(11...15)
        let n4 = levelsHStack(16...20)
        let n5 = levelsHStack(21...25)
        let n6 = levelsHStack(this: ["boss level", "secret level"])
        
        // The level select will swing updward
        enum Direction: Double {
            case up = 2000, down = -2000
        }
        func bring(dir: Direction, node: SKNode, delay: Double) {
            let bringItUp = SKAction.moveBy(x: 0, y: CGFloat(dir.rawValue), duration: 0.7).easeOut()
            let startThisWay = SKAction.moveBy(x: 0, y: CGFloat(-dir.rawValue), duration: 0)
            let begin = SKAction.sequence([startThisWay, .wait(forDuration: delay), bringItUp])
            node.run(begin)
        }
        
        let startAction = SKAction.moveBy(x: 10, y: 0, duration: 1.5).easeOut()
        let movementAction = SKAction.moveBy(x: 20, y: 0, duration: 3).easeOut()
        let even = SKAction.sequence([startAction, .repeatForever(.sequence([movementAction.reversed(), movementAction]))])
        let odd = SKAction.sequence([startAction.reversed(), .repeatForever(.sequence([movementAction, movementAction.reversed()]))])
        
        
        let wow = VStack(
            nodes: [
                n1.then({ $0.run(odd); bring(dir: .up, node: $0, delay: 0.5) }),
                n2.then({ $0.run(even); bring(dir: .up, node: $0, delay: 0.6) }),
                n3.then({ $0.run(odd); bring(dir: .up, node: $0, delay: 0.7) }),
                n4.then({ $0.run(even); bring(dir: .up, node: $0, delay: 0.8) }),
                n5.then({ $0.run(odd); bring(dir: .up, node: $0, delay: 0.9) }),
                n6.then({ $0.run(even); bring(dir: .up, node: $0, delay: 1.0) }),
            ].reversed()
        )
        
        addChild(wow)
        wow.keepInside(.init(width: size.times(0.9).width, height: size.times(0.5).height))
        wow.centerAt(point: .midScreen)
        
        // DECORATION?
        let foo = SKSpriteNode.init(color: .gray, size: .hundred.doubled)
        addChild(foo)
        foo.position = .midScreen
        foo.position.x -= 50
        foo.position.y -= 100
        foo.zPosition = -100
        foo.jonnyAction()
        bring(dir: .up, node: foo, delay: 0)
        
        // let foo2 = SKSpriteNode.init(color: .gray, size: .hundred.doubled)
        // addChild(foo2)
        // foo2.position = .midScreen
        // foo2.jonnyAction()
        // foo2.zRotation = .pi
        // bring(dir: .down, node: foo2, delay: 0)
        
    }
    
    var nodesTouched: [SKNode] = []
    
    #if os(macOS)
    override func mouseDown(with event: NSEvent) {
        let nodesTouched = nodes(at: event.location(in: self))
        nodesTouched.touchBegan()
        self.nodesTouched += nodesTouched
    }
    override func mouseUp(with event: NSEvent) {
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
