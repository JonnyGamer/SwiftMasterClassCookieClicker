//
//  Extensions.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import SpriteKit

extension String.SubSequence { var s: String { String(self) } }
extension Character { var s: String { String(self) } }

extension CGPoint {
    static var midScreen: Self { .init(x: 500, y: 500) }
    static var half: Self { .init(x: 0.5, y: 0.5) }
}
extension CGSize {
    static var hundred: Self { .init(width: 100, height: 100) }
    var doubled: Self { .init(width: width*2, height: height*2) }
    var halved: Self { .init(width: width/2, height: height/2) }
    func padding(_ with: CGFloat) -> Self {
        return .init(width: self.width + with, height: self.height + with)
    }
}
extension CGVector {
    func times(_ some: CGFloat) -> CGVector {
        return .init(dx: dx * some, dy: dy * some)
    }
}
extension CGFloat {
    var half: Self { self / 2 }
}


#if os(iOS)
extension UITouch {
    //static var thirdPrevious: [UITouch:CGPoint] = [:]
    // didn't work///
//    func releaseVelocity(_ node: SKNode) -> CGVector {
//        let loc = location(in: node)
//        let loc2 = previousLocation(in: node)
//
//        let theVel = velocityIn(node)
//        if abs(theVel.dx) < 2, abs(theVel.dy) < 2 {
//            let loc3 = UITouch.thirdPrevious[self] ?? loc2
//            let vel2 = CGVector(dx: loc.x - loc3.x, dy: loc.y - loc3.y)
//            if abs(vel2.dx) > 2 || abs(vel2.dy) > 2 {
//                return vel2
//            }
//        }
//        return theVel
//    }
    
    func velocityIn(_ node: SKNode) -> CGVector {
        let loc = location(in: node)
        let loc2 = previousLocation(in: node)
        return .init(dx: loc.x - loc2.x, dy: loc.y - loc2.y)
    }
}
#endif
