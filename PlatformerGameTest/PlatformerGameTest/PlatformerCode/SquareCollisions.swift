//
//  SquareCollisions.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit

extension BasicSprite {
    var minX: Int { return position.x }
    var minY: Int { return position.y }
    var maxX: Int { return position.x + frame.x }
    var maxY: Int { return position.y + frame.y }
    var midX: Int { return (position.x + frame.x)/2 }
    var midY: Int { return (position.y + frame.y)/2 }
}

func collide(_ a: BasicSprite,_ b: BasicSprite) -> Direction? {
    
    if (a.maxX - a.velocity.dx) < (b.minX - a.velocity.dx) {
        
    }
    
    return .down
    
}

//extension BasicSprite {
//
//    // Collision with Box Code
//    func collision(with: BasicSprite) -> Direction? {
//        if let col = collide(with) {
//            return col.1
//        }; return nil
//    }
//
//    func collide(_ with: BasicSprite) -> (Direction, Direction)? {
//        let y = (velocity.dy + with.velocity.dy), x = (velocity.dx + with.velocity.dx) - digg(dx)
//
//        if y != 0 {
//            let tup: (Direction, Direction) = y < 0 ? (.down, .up) : (.up, .down)
//
//            if x == 0 {
//                return tup
//            } else {
//                let xx = Line(x > 0 ? position.x : position.x+Int(skNode.frame.width), d: -x)
//                let bottomLeft = Box(xx, Line(digg(minY), dy))
//                let topLeft = Box(xx, Line(digg(maxY), dy))
//                let choose = x > 0 ? with.maxX : with.minX
//                let side = Box(Line(choose, choose), Line(with.minY, with.maxY))
//
//                if bottomLeft.regOverlaps(side) || topLeft.regOverlaps(side) {
//                    return x < 0 ? (.l(), .r()) : (.r(), .l())
//                }
//                return tup
//            }
//        }
//        if x == 0 && y == 0 { return nil }// fatalError() }
//        return x < 0 ? (.l(), .r()) : (.r(), .l())
//    }
//
//}


//// Box Line Types
//func Line<T: FloatingPoint>(_ one: T,_ two: T) -> ClosedRange<T> { return min(one, two)...max(one, two) }
//func Line<T: FloatingPoint>(_ one: T, d: T) -> ClosedRange<T> { return min(one, one - d)...max(one, one - d) }
//enum BlockTypes: Equatable, Hashable { case wall, die, push, jump, pull, grab, sand, water, spring(CGFloat), vine, end }
//
//func +=<T: FloatingPoint>(_ lhs: inout ClosedRange<T>,_ rhs: (T, T)) {
//    lhs = (lhs.lowerBound + rhs.0)...(lhs.upperBound + rhs.1)
//}
//
//protocol Boxable {
//    var x: ClosedRange<CGFloat> { get set }
//    var y: ClosedRange<CGFloat> { get set }
//    var dx: CGFloat { get set }
//    var dy: CGFloat { get set }
//    init(_ x: ClosedRange<CGFloat>,_ y: ClosedRange<CGFloat>)
//    func regOverlaps(_ who: Boxable) -> Bool
//    func overlaps(_ who: Boxable) -> Bool
//    func collision(with: Boxable, jforce: (x: CGFloat, y: CGFloat)) -> (Cardinal, [BlockTypes])?
//}
//
//extension Boxable {
//    mutating func newPoint(_ xx: CGFloat,_ yy: CGFloat) { xPos = xx; yPos = yy }
//    mutating func newPoint(_ to: CGPoint) { newPoint(to.x, to.y) }
//    
//    var xPos: CGFloat {
//        get { return minX }
//        set(to) { let xx = minX; x = Line(to,to + width); dx = to - xx }
//    }
//    var yPos: CGFloat {
//        get { return minY }
//        set(to) { let yy = minY; y = Line(to,to + height); dy = to - yy }
//    }
//    
//    /// Find the direction of the current Velocity
//    var direction: Set<Cardinal> {
//        var sett = Set<Cardinal>()
//        if dx != 0 { sett.insert(dx < 0 ? .l() : .r()) }
//        if dy != 0 { sett.insert(dy < 0 ? .b() : .t()) }
//        return sett
//    }
//    func collide(_ with: Boxable, jforce: (x: CGFloat, y: CGFloat)) -> (Cardinal, Cardinal)? {
//        let y = (with.dy + jforce.y) - digg(dy), x = (with.dx + jforce.x) - digg(dx)
//        
//        if y != 0 {
//            let tup: (Cardinal, Cardinal) = y < 0 ? (.b(), .t()) : (.t(), .b())
//            
//            if x == 0 {
//                return tup
//            } else {
//                let xx = Line(x > 0 ? digg(minX) : digg(maxX), d: -x)
//                let bottomLeft = Box(xx, Line(digg(minY), dy))
//                let topLeft = Box(xx, Line(digg(maxY), dy))
//                let choose = x > 0 ? with.maxX : with.minX
//                let side = Box(Line(choose, choose), Line(with.minY, with.maxY))
//                
//                if bottomLeft.regOverlaps(side) || topLeft.regOverlaps(side) {
//                    return x < 0 ? (.l(), .r()) : (.r(), .l())
//                }
//                return tup
//            }
//        }
//        if x == 0 && y == 0 { return nil }// fatalError() }
//        return x < 0 ? (.l(), .r()) : (.r(), .l())
//    }
//}
//extension Boxable {
//    var width: CGFloat { return x.upperBound - x.lowerBound }
//    var height: CGFloat { return y.upperBound - y.lowerBound }
//    var midX: CGFloat { return (x.lowerBound + x.upperBound) / 2 }
//    var midY: CGFloat { return (y.lowerBound + y.upperBound) / 2 }
//    var minX: CGFloat { return x.lowerBound }
//    var maxX: CGFloat { return x.upperBound }
//    var minY: CGFloat { return y.lowerBound }
//    var maxY: CGFloat { return y.upperBound }
//}
//
//
//struct Box: Hashable, Boxable {
//    
//    var x: ClosedRange<CGFloat>, y: ClosedRange<CGFloat>, dx: CGFloat = 0, dy: CGFloat = 0
//    var jnode = false
//    
//    init(_ x: ClosedRange<CGFloat>,_ y: ClosedRange<CGFloat>) { self.x = x; self.y = y }
//    
////    func regOverlaps(_ who: Boxable) -> Bool {
////        return x.overlaps(who.x) && y.overlaps(who.y)
////    }
////    func overlaps(_ who: Boxable) -> Bool {
////        return x.overlaps(undugg(who.x)) && y.overlaps(undugg(who.y))
////    }
//    
//    // Collision with Box Code
//    func collision(with: Boxable, jforce: CGVector) -> Direction? {
//        if let col = collide(with, jforce: jforce) {
//            return col.1
//        }; return nil
//    }
//}
//
//extension BasicSprite {
//    
//    // Collision with Box Code
//    func collision(with: BasicSprite) -> Direction? {
//        if let col = collide(with) {
//            return col.1
//        }; return nil
//    }
//    
//    func collide(_ with: BasicSprite) -> (Direction, Direction)? {
//        let y = (velocity.dy + with.velocity.dy), x = (velocity.dx + with.velocity.dx) - digg(dx)
//        
//        if y != 0 {
//            let tup: (Direction, Direction) = y < 0 ? (.down, .up) : (.up, .down)
//            
//            if x == 0 {
//                return tup
//            } else {
//                let xx = Line(x > 0 ? position.x : position.x+Int(skNode.frame.width), d: -x)
//                let bottomLeft = Box(xx, Line(digg(minY), dy))
//                let topLeft = Box(xx, Line(digg(maxY), dy))
//                let choose = x > 0 ? with.maxX : with.minX
//                let side = Box(Line(choose, choose), Line(with.minY, with.maxY))
//                
//                if bottomLeft.regOverlaps(side) || topLeft.regOverlaps(side) {
//                    return x < 0 ? (.l(), .r()) : (.r(), .l())
//                }
//                return tup
//            }
//        }
//        if x == 0 && y == 0 { return nil }// fatalError() }
//        return x < 0 ? (.l(), .r()) : (.r(), .l())
//    }
//    
//}
