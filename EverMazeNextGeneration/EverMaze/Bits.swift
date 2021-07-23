//
//  BitMap.swift
//  EverMaze2
//
//  Created by Jonathan Pappas on 1/26/21.
//

import Foundation
import SpriteKit

extension UIColor {
    static func currentColor(_ brightness: CGFloat) -> UIColor { UIColor(hue: CGFloat(SaveData.level) / 50, saturation: 0.7, brightness: brightness, alpha: 1) }
}

struct Color: Equatable {
    var red:UInt8
    var green:UInt8
    var blue:UInt8
    var alpha:UInt8
    static var black: Color { .init() }
    static var white: Color { .init(red: .max, green: .max, blue: .max) }
    static var red: Color { .init(red: .max) }
    static var green: Color { .init(green: .max) }
    static var blue: Color { .init(blue: .max) }
    static var clear: Color { .init(alpha: .zero) }
    static func currentColor(_ brightness: CGFloat) -> Color { Color(h: CGFloat(SaveData.level) / 50, s: 0.7, v: brightness, a: 1) }
    var uiColor: UIColor {
        UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    // You can omit the parameters that have default values.
    init(red:UInt8=0, green:UInt8=0, blue:UInt8=0, alpha:UInt8=UInt8.max) {
        let alphaValue:Float = Float(alpha) / 255
        self.red = UInt8(round(Float(red) * alphaValue))
        self.green = UInt8(round(Float(blue) * alphaValue))
        self.blue = UInt8(round(Float(green) * alphaValue))
        self.alpha = alpha
    }
    
    init(h:CGFloat,s:CGFloat,v:CGFloat,a:CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        let i = floor(h * 6), f = h * 6 - i, p = v * (1 - s), q = v * (1 - f * s), t = v * (1 - (1 - f) * s)
        switch (Int(i) % 6) {
            case 0: r = v; g = t; b = p
            case 1: r = q; g = v; b = p
            case 2: r = p; g = v; b = t
            case 3: r = p; g = q; b = v
            case 4: r = t; g = p; b = v
            case 5: r = v; g = p; b = q
            default: fatalError()
        }
        red = UInt8(round(r * 255))
        green = UInt8(round(g * 255))
        blue = UInt8(round(b * 255))
        alpha = UInt8(round(a * 255))
    }
    
}

class Sprite: SKSpriteNode {//, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
}

enum ImageNames: String {
    case logo = "EverLogo"
    case everMaze = "EverMaze"
    case play = "Play"
    case forward = "Forward"
    
    case howToPlay = "HowToEverMaze"
    case lock = "lock"
    case helpButton = "helpButton"
    case backButton = "backButton"
    case musicOn = "musicOn"
    case musicOff = "musicOff"
    
    case darkNext = "DarkNext"
    case darkReplay = "DarkReplay"
    case darkMenu = "DarkMenu"
    case darkBack = "DarkBack"
    
    case inky = "InkyBoy"
    case inky_1_2 = "TallInkyBoy"
    case inky_2_1 = "Tall2InkyBoy"
    case stretchInkyLong = "StretchInky1"
    case stretchInkyTall = "StretchInky2"
    
    case storyButton = "storyButton"
    case xpButton = "xpButton"
    case inkysStaring = "InkysStaring"
    
    case theGliderButton = "TheGliderButton"
    case theAbsorberButton = "TheAbsorberButton"
    case theBouncerButton = "TheBouncerButton"
    case theGalaxyButton = "TheGalaxyButton"
    case theMiniSpaceshipsButton = "TheMiniSpaceshipsButton"
    case theLongExplosionButton = "TheLongExplosionButton"
    case theEverMazeButton = "TheEverMazeButton"
    case rocket = "Rocket"
    case rocketButton = "RocketButton"
    case darkRocketButton = "DarkRocketButton"
}
extension Sprite {
    static func image(_ nameddd: ImageNames, parent: SKNode? = nil) -> Sprite {
        let wow = Sprite.init(imageNamed: nameddd.rawValue)
        wow.anchorPoint = .zero
        parent?.addChild(wow)
        return wow
    }
//    static func story(parent: SKNode? = nil) -> Sprite {
//        let wow = Sprite.init(imageNamed: "EverMazeStory\(currentStory)")
//        wow.anchorPoint = .zero
//        parent?.addChild(wow)
//        return wow
//    }
    func newImage(_ nameddd: ImageNames) {
        texture = SKTexture.init(imageNamed: nameddd.rawValue)
    }
}


class EverLabel: SKLabelNode {//}, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
}

class Group: SKNode {//}, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
}



class BitMap: Sprite {
    static func Create(size: (Int, Int), from: [Color]...) -> BitMap {
        var pixelData: [Color] = []
        for i in from {
            pixelData = i + pixelData
        }
        let nsData = NSData(bytes: pixelData, length: (size.0 * size.1 * 4))// pixelData.count * UInt32.bitWidth)
        return FromData(size: size, nsData: nsData)
    }
    
    static func BlackAndWhite(size: (Int, Int), from: [Bool]) -> BitMap {
        var pixelData: [Color] = []
        var currentPixelData: [Color] = []
        var sizeX = 0
        for i in from {
            currentPixelData.append(i ? .black : .clear)
            sizeX += 1
            if sizeX == size.0 {
                sizeX = 0
                pixelData = currentPixelData + pixelData
                currentPixelData = []
            }
        }
        let nsData = NSData(bytes: pixelData, length: (size.0 * size.1 * 4))// pixelData.count * UInt32.bitWidth) // size.0 = 4?
        return FromData(size: size, nsData: nsData)
    }
    
    static func CellularAutomata(square: Int, color: Color = .black, from: [Int : Set<Int>]) -> BitMap {
        let size = (square, square)
        let maxSquare = square/2
        let minSquare = -square + (square / 2) + 1
        
        var pixelData: [Color] = []
        var currentPixelData: [Color] = []
        for i in minSquare...maxSquare {
            if let currentSet = from[i] {
                for i in minSquare...maxSquare {
                    currentPixelData.append(currentSet.contains(i) ? color : .clear)
                }
            } else {
                // append 256 clears
                currentPixelData = [Color](repeating: .clear, count: square)
            }
            if color != .black {
                pixelData += currentPixelData
            } else {
                pixelData = currentPixelData + pixelData
            }
            currentPixelData = []
        }
        let nsData = NSData(bytes: pixelData, length: (size.0 * size.1 * 4))
        return FromData(size: size, nsData: nsData)
    }
    
    static func EverMaze(size: (Int, Int), from: [Bool]) -> BitMap {
        FromData(size: size, nsData: EverMazeData(size: size, from: from))
    }
    
    static func EverMazeData(size: (Int, Int), from: [Bool]) -> NSData {
        var pixelData: [Color] = []
        var currentPixelData: [Color] = []
        var sizeX = 0
        for i in from {
            currentPixelData.append(i ? .clear : .white)
            sizeX += 1
            if sizeX == size.0 {
                sizeX = 0
                pixelData += currentPixelData
                currentPixelData = []
            }
        }
        if !currentPixelData.isEmpty { fatalError() }
        let nsData = NSData(bytes: pixelData, length: (size.0 * size.1 * 4))// pixelData.count * UInt32.bitWidth)
        return nsData
    }
    
    static func FromData(size: (Int, Int), nsData: NSData) -> BitMap {
        let data = Data.init(referencing: nsData)
        let texture = SKTexture(data: data, size: CGSize(width: CGFloat(size.0), height: CGFloat(size.1)))
        texture.filteringMode = .nearest
        let node = BitMap(texture: texture, size: CGSize(width: CGFloat(size.0), height: CGFloat(size.1)))
        return node
    }
}
