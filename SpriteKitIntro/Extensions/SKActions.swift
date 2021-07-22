//
//  SKActions.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit

let M_PI_2_f = Float(Double.pi / 2)
let M_PI_f = Float(Double.pi)
public func sinFloat(_ num:Float)->Float {
    return sin(num)
}
public func SineEaseOut(_ p:Float)->Float {
    return sinFloat(p * M_PI_2_f)
}

//
//extension SKAction {
//    static func moveBy(_ velocty: CGVector, duration: Double) -> SKAction {
//        return .moveBy(x: velocty.dx, y: velocty.dy, duration: duration)
//    }
//}
