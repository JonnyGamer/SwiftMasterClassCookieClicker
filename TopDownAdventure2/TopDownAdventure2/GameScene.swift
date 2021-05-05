//
//  GameScene.swift
//  TopDownAdventure1
//
//  Created by Jonathan Pappas on 5/5/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player = SKSpriteNode.init(imageNamed: "Player")
    var magicCamera: SKCameraNode!

    override func didMove(to view: SKView) {
        addChild(player)
        player.physicsBody = .init(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        
        magicCamera = SKCameraNode()
        camera = magicCamera
        addChild(magicCamera)
        
        if let level1 = SKScene.init(fileNamed: "Level1") {
            for i in level1.children {
                if let io = i as? SKTileMapNode {
                    //io.removeFromParent()
                    //addChild(io)
                    
                    if i.name == "wall" {
                        for y in 0..<Int(io.mapSize.width) {
                            for x in 0..<Int(io.mapSize.height) {
                                
                                if let tilo = io.tileGroup(atColumn: x, row: y), let namo = tilo.name {
                                    wall(name: namo, size: CGSize(width: 100, height: 100), pos: CGPoint(x: x*100, y: y*100))
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    @discardableResult
    func wall(name: String, size: CGSize, pos: CGPoint) -> SKSpriteNode {
        let sprite = SKSpriteNode.init(texture: .init(imageNamed: name))// .init(color: .clear, size: size)
        sprite.size = size
        sprite.position = pos
        addChild(sprite)
        
        sprite.physicsBody = .init(rectangleOf: sprite.size)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = false
        
        return sprite
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //var d: CGVector = .zero
        
        if moving.up {// d.dy += 1000
            player.position.y += 10
        }
        
        if moving.down {// d.dy -= 1000
            player.position.y -= 10
        }
        
        if moving.right {// d.dx += 1000
            player.position.x += 10
        }
        
        if moving.left {// d.dx -= 1000
            player.position.x -= 10
        }
        
        //player.physicsBody?.applyForce(d)
        //player.physicsBody?.velocity = d
        
        magicCamera.run(.move(to: player.position, duration: 0.2))
        
    }
    
    
    var moving: (up: Bool, down: Bool, left: Bool, right: Bool) = (false, false, false, false)
    
    override func keyDown(with event: NSEvent) {
        
        if event.keyCode == 126 {
            moving.up = true
        } else if event.keyCode == 123 {
            moving.left = true
        } else if event.keyCode == 125 {
            moving.down = true
        } else if event.keyCode == 124 {
            moving.right = true
        }
        
    }
    
    override func keyUp(with event: NSEvent) {
        
        if event.keyCode == 126 {
            moving.up = false
        } else if event.keyCode == 123 {
            moving.left = false
        } else if event.keyCode == 125 {
            moving.down = false
        } else if event.keyCode == 124 {
            moving.right = false
        }
        
    }
    
}
