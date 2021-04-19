//
//  KoopaShell.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/19/21.
//

import Foundation
import SpriteKit

class KoopaShell: MovableSprite, WhenActions2 {
    static var starterImage: Images = .shell
    static var starterSize: (Int, Int) = (16, 16)
    
    var actionSprite: SKNode = SKSpriteNode()
    
    var moving = false
    var movementDirection: Direction = .left
    
    func startMoving(_ direction: Direction) {
        self.run(.sound(.kick))
        moving = true
        self.xSpeed = 5
        moveMe(direction)
    }
    func reverseMovement() {
        // self.run(.sound(.bumpAgainstWall))
        moveMe(self.movementDirection.reversed)
    }
    func moveMe(_ dir: Direction) {
        self.movementDirection = dir
        self.move(dir)
    }
    func stopMoving() {
        self.run(.sound(.stomp))
        moving = false
        self.xSpeed = 0
    }
    func toggleMovement(_ dir: Direction) {
        self.moving.toggle()
        print("TOGLE")
        if !self.moving {
            print("")
        }
        self.moving ? startMoving(dir) : stopMoving()
    }
    
    
    // Koopa Smashes into something
    func smash(_ this: BasicSprite) {
        if self.moving, let mario = this as? Inky {
            self.run(.sound(.kick))
            _ = mario.die(killedBy: self)
        } else if let foo = this as? MovableSprite {
            self.run(.sound(.kick))
            _ = foo.die(killedBy: self)
        }
    }
    
 
    func whenActions() -> [Whens] {[

        // If Shell hits a wall, reverse it's movement
        .bumped(.left, doThis: {
            self.smash($0)
            if $0 as? MovableSprite == nil {
                self.reverseMovement()
            }
        }),
        .bumped(.right, doThis: {
            self.smash($0)
            if $0 as? MovableSprite == nil {
                self.reverseMovement()
            }
        }),
        // If Shell falls on any Movable thing.
        .bumped(.down, doThis: {
            if let mover = $0 as? MovableSprite {
                _ = mover.die(killedBy: self)
            }
        }),
        
        
        // If Mario uses Goomba like a ? Box
        .wasBumpedBy(.up, doThis: {
            _ = $0.die(killedBy: self)
        }),
        // If Mario Falls on Goomba
        .wasBumpedBy(.down, doThis: {
            if let mario = $0 as? Inky {
                if mario.position.x < self.position.x {
                    self.toggleMovement(.right)
                    mario.smallJump()
                } else {
                    self.toggleMovement(.left)
                    mario.smallJump()
                }
            }
        }),
        
        // If Mario walks into Koopa Shell, he kicks it.
        .wasBumpedBy(.left, doThis: {
            if !self.moving, let mario = $0 as? Inky {
                self.startMoving(.left)
                mario.willStopMoving(self, .left)
            } else {
                $0.die(killedBy: self)
            }
        }),
        .wasBumpedBy(.right, doThis: {
            if !self.moving, let mario = $0 as? Inky {
                self.startMoving(.right)
                mario.willStopMoving(self, .right)
            } else {
                $0.die(killedBy: self)
            }
        }),
        
        
        // When Koopa Shell moves off screen, get rid of it
        .when(.offScreen, doThis: {
            self.die(killedBy: self)
        }),
        
        // Koopa Shell Falls
        .when(.notOnGround, doThis: {
            self.fall()
        }),
        
        // Shell always moves.
        .when(.always, doThis: {
            self.moveMe(self.movementDirection)
        }),
        
        .setters([
            .xSpeed(0, everyFrame: 2),
            .gravity(-1, everyFrame: 2),
            .minFallSpeed(-3),
        ])
    ]}
    
    
    
    var myActions: [SKAction] {[
        // Koopa will climb out of shell action
        .sequence([
            .wait(forDuration: 5),
            .setImage(.climbingOutOfShell, 0.5),
            .setImage(.shell, 0.5),
            .setImage(.climbingOutOfShell, 0.5),
            .setImage(.shell, 0.5),
            .setImage(.climbingOutOfShell, 0.25),
            .setImage(.shell, 0.25),
            .setImage(.climbingOutOfShell, 0.25),
            .setImage(.shell, 0.25),
            .setImage(.climbingOutOfShell, 0.25),
        ])
    ]}

    
}
