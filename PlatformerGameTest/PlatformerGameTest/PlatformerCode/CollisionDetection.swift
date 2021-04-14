//
//  Collision.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/13/21.
//

import Foundation
import SpriteKit

extension Scene {
    func checkForCollision(_ i: BasicSprite,_ curry: [Int] = []) {
        
        for j in sprites.shuffled() {
            if i === j { continue }
            
            // Falling Down
            foo: if let j = j as? MovableSprite {
                //if !(i.minX..<i.maxX).overlaps(j.minX..<j.maxX) { break foo }
                
                if i.velocity.dy == 0, j.velocity.dy == 0 { break foo }
                
                do {
                    
                    var jRange: ClosedRange<Int> = j.minX...j.maxX
                    if j.velocity.dx < 0 {
                        jRange = ((j.minX)...(j.previousPosition.x + j.frame.x))
                    } else if j.velocity.dx > 0 {
                        jRange = ((j.previousPosition.x)...(j.maxX))
                    }
                    
                    var iRange: ClosedRange<Int> = i.minX...i.maxX
                    if i.velocity.dx < 0 {
                        iRange = ((i.minX)...(i.previousPosition.x + i.frame.x))
                    } else if i.velocity.dx > 0 {
                        iRange = ((i.previousPosition.x)...(i.maxX))
                    }
                    
                    if jRange.overlaps(iRange) {
                        if jRange.upperBound == iRange.lowerBound {
                            if ("\(i)".contains("C") || "\(j)".contains("C")) && ("\(i)".contains("y") || "\(j)".contains("y")) {
                                //print("AUGH")
                            }
                            continue
                        }
                        if jRange.lowerBound == iRange.upperBound {
                            if ("\(i)".contains("C") || "\(j)".contains("C")) && ("\(i)".contains("y") || "\(j)".contains("y")) {
                                //print("AUGH")
                            }
                            continue
                        }
                    } else {
                        if ("\(i)".contains("C") || "\(j)".contains("C")) && ("\(i)".contains("y") || "\(j)".contains("y")) {
                            //print("AUGH")
                        }
                        continue
                    }
                }
                
                
                
                if j.onGround.contains(where: { $0 === i }) { break foo }
                if (i as? MovableSprite)?.onGround.contains(where: { $0 === j }) == true { break foo }
                
                if j.velocity.dy < 0, i.velocity.dy >= 0 {
                    // This line is needed, Otherwise bad bugs when pushing -> then jumping
                    //if j.maxX - j.velocity.dx <= i.minX { break foo }
                    //if j.minX - j.velocity.dx >= i.minX { break foo }
                    
                    if ((j.minY + (j.velocity.dy-1))...(j.maxY)).contains(i.maxY) {
                        i.bumpedFromBottom.forEach { $0(j) }
                    }
                
                } else if j.velocity.dy > 0, i.velocity.dy <= 0 {
                    // This line is needed, Otherwise bad bugs when pushing -> then jumping
                    //if j.maxX - j.velocity.dx <= i.minX { break foo }
                    //if j.minX - j.velocity.dx >= i.minX { break foo }
                    if ((j.minY-j.velocity.dy-1)...(j.maxY)).contains(i.minY) {
                        print(i, j)
                        //if curry.contains(0) { break foo }
                        i.bumpedFromTop.forEach { $0(j) }
                        //checkForCollision(i, curry + [0])
                    } else if ((j.minY)...(j.maxY+j.velocity.dy+1)).contains(i.minY) {
                        print(i, j)
                        //if curry.contains(1) { break foo }
                        i.bumpedFromTop.forEach { $0(j) }
                        //checkForCollision(i, curry + [1])
                    }
                    
                // Both are moving downwards
                } else if j.velocity.dy < 0, i.velocity.dy < 0 {
                    if i.previousPosition.y < j.previousPosition.y {
                        if (i.position.y...i.previousPosition.y+i.frame.y).overlaps(j.position.y...j.previousPosition.y+i.frame.y) {
                            if j.velocity.dy < i.velocity.dy {
                                i.bumpedFromBottom.forEach { $0(j) }
                            }
                        }
                    } else if i.previousPosition.y > j.previousPosition.y {
                        
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
            
            
            foo: if let j = j as? MovableSprite, false {
                if !(i.minX..<i.maxX).overlaps(j.minX..<j.maxX) { break foo }
                if i.velocity.dy == 0, j.velocity.dy == 0 { break foo }
                
                if j.onGround.contains(where: { $0 === i }) { break foo }
                if (i as? MovableSprite)?.onGround.contains(where: { $0 === j }) == true { break foo }
                
                if j.velocity.dy < 0 {
                    if ((j.minY + (j.velocity.dy-1))...(j.maxY)).contains(i.maxY) {
                        i.bumpedFromBottom.forEach { $0(j) }
                        print("-", j)
                    }
                    
                    
                } else if j.velocity.dy > 0, let i = i as? MovableSprite {
                    if (j.minY...(j.maxY + j.velocity.dy)).contains(i.maxY) {
                        if i.velocity.dy < j.velocity.dy {
                            
                            // This line is needed, Otherwise bad bugs when pushing -> then jumping
                            if j.maxX - j.velocity.dx <= i.minX { break foo }
                            if j.minX - j.velocity.dx >= i.minX { break foo }

                            j.bumpedFromBottom.forEach { $0(i) }
                            print("-", i)
                        }
                    }
                }
   
            }
            
            if i.velocity.dx == 0, j.velocity.dx == 0 {
                continue
            }
            newCheckX(i, j)
            
            continue
            if i.velocity.dx == 0, j.velocity.dx == 0 { continue }
            if i.midX > j.midX {
                if j.midY > i.midY {
                    if j.minY >= i.maxY { continue }
                } else {
                    if j.maxY <= i.minY { continue }
                }
                
                // Only Runs When Side by Side
                if i.maxX > j.minX, i.minX < j.maxX {
                    if i.velocity.dx == -j.velocity.dx {
                        print("Ohno")
                        i.position.x = i.previousPosition.x // Do Noy Delete these yet.
                        j.position.x = j.previousPosition.x
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
                            
                            if j.velocity.dx >= 0, i.velocity.dx < 0 {
                                
                                j.bumpedFromLeft.forEach { $0(i) }
                                if let j = j as? MovableSprite, j.velocity.dx > 0 {
                                    i.bumpedFromRight.forEach { $0(j) }
                                }
                                
                                // Recursively Push
                                if let _ = recursiveLeftPush(j, velX: j.velocity.dx) {
                                    i.stopMoving(j, .left)
                                }
                                
                            } else {
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
        print("NOSIR")
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
    
    
    func newCheckX(_ i: BasicSprite,_ j: BasicSprite) {
        foo: if j.midX < i.midX {
            
            do {
                
                var jRange: ClosedRange<Int> = j.minY...j.maxY
                if j.velocity.dy < 0 {
                    jRange = ((j.minY)...(j.previousPosition.y + j.frame.y))
                } else if j.velocity.dy > 0 {
                    jRange = ((j.previousPosition.y)...(j.maxY))
                }
                
                var iRange: ClosedRange<Int> = i.minY...i.maxY
                if i.velocity.dy < 0 {
                    iRange = ((i.minY)...(i.previousPosition.y + i.frame.y))
                } else if i.velocity.dy > 0 {
                    iRange = ((i.previousPosition.y)...(i.maxY))
                }
                
                if jRange.overlaps(iRange) {
                    if jRange.upperBound == iRange.lowerBound {
                        if ("\(i)".contains("C") || "\(j)".contains("C")) && ("\(i)".contains("y") || "\(j)".contains("y")) {
                            //print("AUGH")
                        }
                        if "\(i)".contains("Chaser"), "\(j)".contains("GROUND") {
                            print("UHHHH")
                        }
                        return
                        //continue
                    }
                    if jRange.lowerBound == iRange.upperBound {
                        if ("\(i)".contains("C") || "\(j)".contains("C")) && ("\(i)".contains("y") || "\(j)".contains("y")) {
                            //print("AUGH")
                        }
                        if "\(i)".contains("Chaser"), "\(j)".contains("GROUND") {
                            print("UHHHH")
                        }
                        return
                        //continue
                    }
                    print("HMMM")
                } else {
                    if ("\(i)".contains("C") || "\(j)".contains("C")) && ("\(i)".contains("y") || "\(j)".contains("y")) {
                        //print("AUGH")
                    }
                    if "\(i)".contains("Chaser"), "\(j)".contains("GROUND") {
                        print("UHHHH")
                    }
                    return
                    //continue
                }
            }
            

            
            if i.maxX > j.minX, i.minX < j.maxX {
                
                
                if i.velocity.dx == 0, let j = j as? MovableSprite {
                    // j -> |i|
                    if j.previousPosition.x - j.velocity.dx + j.frame.x > i.minX { break foo }
                    i.bumpedFromRight.forEach { $0(j) }
                    if let _ = recursiveRightPush(i, velX: i.velocity.dx) {
                        j.stopMoving(i, .right)
                    }
                    
                } else if let i = i as? MovableSprite {
                    if j.velocity.dx == 0 {
                        // |j| <- i
                        if i.previousPosition.x - i.velocity.dx < j.maxX { break foo }
                        j.bumpedFromLeft.forEach { $0(i) }
                        if let _ = recursiveLeftPush(j, velX: j.velocity.dx) {
                            i.stopMoving(j, .left)
                        }
                        
                    } else if let j = j as? MovableSprite {
                        if i.velocity.dx < 0 {
                            if j.velocity.dx < 0 {
                                
                                if j.velocity.dx == i.velocity.dx {
                                    // <- j <- i
                                    // do nothing
                                } else {
                                    
                                    // <- j <-<- i
                                    if !(j.minX...(j.previousPosition.x + j.frame.x)).overlaps((i.minX...i.previousPosition.x)) { break foo }
                                    j.bumpedFromLeft.forEach { $0(i) }
                                    if let _ = recursiveLeftPush(j, velX: j.velocity.dx) {
                                        i.stopMoving(j, .left)
                                    }
                                    
                                }
                                
                            } else {
                                if j.velocity.dx == -i.velocity.dx {
                                    // Unfinished
                                    // j -> <- i
                                    i.position.x = i.previousPosition.x // Do Noy Delete these yet.
                                    j.position.x = j.previousPosition.x
                                    
                                } else {
                                    
                                    if !((j.previousPosition.x + j.frame.x)...j.maxX).overlaps((i.minX...i.previousPosition.x)) { break foo }
                                    
                                    if j.velocity.dx > -i.velocity.dx {
                                        
                                        // j ->-> <- |i|
                                        i.bumpedFromRight.forEach { $0(j) }
                                        if let _ = recursiveRightPush(i, velX: i.velocity.dx) {
                                            j.stopMoving(i, .right)
                                        }
                                        
                                    } else {
                                        // j -> <-<- i
                                        j.bumpedFromLeft.forEach { $0(i) }
                                        if let _ = recursiveLeftPush(j, velX: j.velocity.dx) {
                                            i.stopMoving(j, .left)
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                        } else {
                            // THIS ACTUALLY NEVER HAPPENS
                        }
                    }
                }
                
            }
        }
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
