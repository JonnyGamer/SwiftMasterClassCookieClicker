//
//  Collision.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/13/21.
//

import Foundation
import SpriteKit

extension Scene {
    func checkForCollision(_ i: BasicSprite) {
        
        for j in sprites.shuffled() {
            if i === j { continue }
            
            // Falling Down
            foo: if let j = j as? MovableSprite {
                if !(i.minX..<i.maxX).overlaps(j.minX..<j.maxX) { break foo }
                if i.velocity.dy == 0, j.velocity.dy == 0 { break foo }
                
                if j.onGround.contains(where: { $0 === i }) { break foo }
                if (i as? MovableSprite)?.onGround.contains(where: { $0 === j }) == true { break foo }
                
                if j.velocity.dy < 0, i.velocity.dy == 0 {
                    if ((j.minY + (j.velocity.dy-1))...(j.maxY)).contains(i.maxY) {
                        i.bumpedFromBottom.forEach { $0(j) }
                    }
                }
                
                else if j.velocity.dy < 0, i.velocity.dy >= 0 {
                    // This line is needed, Otherwise bad bugs when pushing -> then jumping
                    //if j.maxX - j.velocity.dx <= i.minX { break foo }
                    //if j.minX - j.velocity.dx >= i.minX { break foo }
                    if ((j.minY + (j.velocity.dy-1))...(j.maxY)).contains(i.maxY) {
                        i.bumpedFromBottom.forEach { $0(j) }
                    } //else if ((i.minY)...(i.maxY+(i.velocity.dy+1))).contains(j.minY) {
//                        i.bumpedFromBottom.forEach { $0(j) }
//                        print("FOO")
//                    }
                
                } else if j.velocity.dy > 0, i.velocity.dy <= 0 {
                    // This line is needed, Otherwise bad bugs when pushing -> then jumping
                    //if j.maxX - j.velocity.dx <= i.minX { break foo }
                    //if j.minX - j.velocity.dx >= i.minX { break foo }
                    if (j.minY...(j.maxY + j.velocity.dy)).contains(i.minY) {
                        print(i, j)
                        i.bumpedFromTop.forEach { $0(j) }
                    }
                    
                // Both are moving downwards
                } else if j.velocity.dy < 0, i.velocity.dy < 0 {
                    if i.previousPosition.y < j.previousPosition.y {
                        if (i.position.y...i.previousPosition.y+i.frame.y).overlaps(j.position.y...j.previousPosition.y+i.frame.y) {
                            if j.velocity.dy < i.velocity.dy {
                                i.bumpedFromBottom.forEach { $0(j) }
                            }
                        }
                    }
                    
                // If both are moving upwards
                } else if j.velocity.dy > 0, i.velocity.dy > 0 {
                    
                    // If i was lower than j.
                    if i.previousPosition.y < j.previousPosition.y {
                        if i.maxY > j.minY {
                            i.bumpedFromBottom.forEach {$0(j) }
                        }
                    }
                }
            }
                
            if i.midX > j.midX {
                if j.midY > i.midY {
                    if j.minY >= i.maxY { continue }
                } else {
                    if j.maxY <= i.minY { continue }
                }
                
                // Only Runs When Side by Side
                if i.maxX > j.minX, i.minX < j.maxX {
                    if i.velocity.dx == -j.velocity.dx {
                        //i.position.x = i.previousPosition.x // Do Noy Delete these yet.
                        //j.position.x = j.previousPosition.x
                    } else if -i.velocity.dx < j.velocity.dx {
                        if let j = j as? MovableSprite {
                            i.bumpedFromRight.forEach { $0(j) }
                            // Recursively Push
                            if let _ = recursiveRightPush(i, velX: i.velocity.dx) {
                                j.stopMoving(i, .right)
                            }
                        }
                    } else {
                        if let i = i as? MovableSprite {
                            j.bumpedFromLeft.forEach { $0(i) }
                            // Recursively Push
                            if let _ = recursiveLeftPush(j, velX: j.velocity.dx) {
                                i.stopMoving(j, .left)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func recursiveRightPush(_ j: BasicSprite, velX: Int) -> (BasicSprite, Int)? {
        
        for i in sprites {
            if i === j { continue }
            
            if i.midX > j.midX {
                if j.midY > i.midY {
                    if j.minY >= i.maxY { continue }
                } else {
                    if j.maxY <= i.minY { continue }
                }
                
                // Only Runs When Side by Side
                if i.maxX > j.minX, i.minX < j.maxX {
                    if i.velocity.dx == -j.velocity.dx {
                    } else if -i.velocity.dx < j.velocity.dx {
                        return recursiveMiniGeneralPush(i, j, velX: velX, dir: .right, recur: recursiveRightPush)
                    } else {
                    }
                }
            }
        }
        return nil
    }
    
    func recursiveLeftPush(_ i: BasicSprite, velX: Int) -> (BasicSprite, Int)? {
        
        for j in sprites {
            if i === j { continue }
            
            if i.midX > j.midX {
                if j.midY > i.midY {
                    if j.minY >= i.maxY { continue }
                } else {
                    if j.maxY <= i.minY { continue }
                }
                
                // Only Runs When Side by Side
                if i.maxX > j.minX, i.minX < j.maxX {
                    if i.velocity.dx == -j.velocity.dx {
                    } else if -i.velocity.dx < j.velocity.dx {
                    } else {
                        return recursiveMiniGeneralPush(j, i, velX: velX, dir: .left, recur: recursiveLeftPush)
                    }
                }
            }
        }
        return nil
        
    }
    
    func recursiveMiniGeneralPush(_ i: BasicSprite, _ j: BasicSprite, velX: Int, dir: Direction, recur: (BasicSprite,Int) -> (BasicSprite, Int)?) -> (BasicSprite, Int)? {
        if let j = j as? MovableSprite {
            if dir == .left {
                i.bumpedFromLeft.forEach { $0(j) }
            } else if dir == .right {
                i.bumpedFromRight.forEach { $0(j) }
            }
            if i.velocity.dx == 0 {
                return (j, 0)
            }
            if let _ = recur(i, velX) {
                j.stopMoving(i, dir)
                return (j, 0)
            }
        }
        return nil
    }
    
}


//if !(i.minX..<i.maxX).overlaps(j.minX..<j.maxX) { break foo }
//if i.velocity.dy == 0, j.velocity.dy == 0 { break foo }
//
//if j.onGround.contains(where: { $0 === i }) { break foo }
//if (i as? MovableSprite)?.onGround.contains(where: { $0 === j }) == true { break foo }
//
//
//
//if j.velocity.dy < 0, i.velocity.dy == 0 {
//    // This line is needed, Otherwise bad bugs when pushing -> then jumping
//    if j.maxX - j.velocity.dx <= i.minX { break foo }
//    if j.minX - j.velocity.dx >= i.minX { break foo }
//    if (j.minY...(j.maxY + j.velocity.dy)).contains(i.maxY) {
//        i.bumpedFromBottom.forEach { $0(j) }
//    }
//
//} else if j.velocity.dy > 0, i.velocity.dy == 0 {
//    // This line is needed, Otherwise bad bugs when pushing -> then jumping
//    if j.maxX - j.velocity.dx <= i.minX { break foo }
//    if j.minX - j.velocity.dx >= i.minX { break foo }
//    if (j.minY...(j.maxY + j.velocity.dy)).contains(i.maxY) {
//        i.bumpedFromBottom.forEach { $0(j) }
//    }
//
//} else if j.velocity.dy == 0, i.velocity.dy == 0 {
//
//
//// ROUND 2
//} else if j.velocity.dy < 0, i.velocity.dy < 0 {
//
//} else if j.velocity.dy > 0, i.velocity.dy < 0 {
//
//} else if j.velocity.dy == 0, i.velocity.dy < 0 {
//
//// ROUND 3
//} else if j.velocity.dy < 0, i.velocity.dy > 0 {
//
//} else if j.velocity.dy > 0, i.velocity.dy > 0 {
//
//} else if j.velocity.dy == 0, i.velocity.dy > 0 {
//
//}
//
//break foo
