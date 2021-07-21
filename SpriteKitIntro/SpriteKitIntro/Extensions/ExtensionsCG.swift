//
//  Extensions.swift
//  SpriteKitIntro
//
//  Created by Jonathan Pappas on 7/21/21.
//

import Foundation
import SpriteKit

extension CGPoint {
    static var midScreen: Self { .init(x: 500, y: 500) }
}
extension CGSize {
    static var hundred: Self { .init(width: 100, height: 100) }
    var doubled: Self { .init(width: width*2, height: height*2) }
    var halved: Self { .init(width: width/2, height: height/2) }
    func padding(_ with: CGFloat) -> Self {
        return .init(width: self.width + with, height: self.height + with)
    }
}

