import Foundation
import SpriteKit

var buttonSize: CGFloat = 0

enum YPositions {
    case top, fullTop, below(SKNode), above(SKNode), almostDirectlyBelow(SKNode), directlyBelow(SKNode), directlyAbove(SKNode)
    case bottom, fullBottom, center, aboveCenter, belowCenter, sameAs(SKNode), maxY(SKNode), minY(SKNode)
}
enum XPositions {
    case left, fullLeft, leftOf(SKNode), rightOf(SKNode), directlyLeftOf(SKNode), directlyRightOf(SKNode)
    case right, fullRight, center, leftCenter, rightCenter, sameAs(SKNode), maxX(SKNode), minX(SKNode)
}

class Shape: SKShapeNode{//, SuperTouchable {
    var beforeTouchBegan: () -> () = {}
    var touchBegan: () -> () = {}
    var touchEndedOn: () -> () = {}
    var touchEnd: () -> () = {}
    var stopAnimating = false
}
extension Shape {
    static func circle(_ radius: CGFloat, parent: SKNode? = nil) -> Shape {
        let wow = Shape.init(circleOfRadius: radius)
        parent?.addChild(wow)
        wow.strokeColor = .clear
        return wow
    }
    static func rectangle(_ sizo: CGSize, parent: SKNode? = nil) -> Shape {
        let wow = Shape.init(rectOf: sizo, cornerRadius: 0)
        parent?.addChild(wow)
        wow.strokeColor = .clear
        return wow
    }
    //func setFillColor(_ to: UIColor) -> Shape { fillColor = to; return self }
    //func setStrokeColor(_ to: UIColor) -> Shape { strokeColor = to; return self }
    func setColor(_ to: UIColor) -> Shape { fillColor = to; return self }
}

enum Links: String {
    case mazeJamShop = "https://unusuallybrilliant.com/product-category/matted-artwork/"
    case home = "https://unusuallybrilliant.com/"
}
extension Sprite {
//    func becomeButton(_ from: Hostable,_ to: Hostable.Type?, beforePresenting: @escaping () -> () = {}) -> Self {
//        touchBegan = { self.alpha = 0.5 }
//        touchEnd = { self.alpha = 1 }
//        touchEndedOn = { beforePresenting(); from.present(to ?? resolveScene()) }
//        return self
//    }
    func becomeExternalLink(_ to: Links) -> Self {
        touchBegan = { self.alpha = 0.5 }
        touchEnd = { self.alpha = 1 }
        touchEndedOn = { self.link(to.rawValue) }
        return self
    }
    func becomeButtonGeneral(_ thisaction: @escaping () -> ()) -> Self {
        touchBegan = { self.alpha = 0.5 }
        touchEnd = { self.alpha = 1 }
        touchEndedOn = { thisaction() }
        return self
    }
}


extension EverLabel {
    var getTrueWidth: CGFloat {
        return EverLabel(text: text!.split(separator: "\n")[0].s).frame.width
    }
    static func text(_ yourString: String, color: UIColor = .black, parent: SKNode? = nil) -> EverLabel {
        let attrString = NSMutableAttributedString(string: yourString)
        
        let wow = EverLabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        //paragraphStyle.maximumLineHeight = -10
        //paragraphStyle.minimumLineHeight = 20
        //paragraphStyle.
        paragraphStyle.lineSpacing = -270
        let range = NSRange(location: 0, length: yourString.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : color, NSAttributedString.Key.font : UIFont.init(name: "Hand", size: 250)], range: range)
        wow.attributedText = attrString
        wow.horizontalAlignmentMode = .left
        wow.verticalAlignmentMode = .bottom
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.minimumLineHeight = 20
//        paragraphStyle.maximumLineHeight = 20
//        paragraphStyle.lineSpacing = 20
//        paragraphStyle.alignment = .center
        
        //wow.fontName = "Hand"
        //wow.text = wow.attributedText?.string
        //let wow = Label.init(text: nameddd)
        //wow.fontName = "Hand"
        //wow.fontColor = .black
        //wow.verticalAlignmentMode = .center
        //wow.fontSize = 500
        wow.numberOfLines = yourString.split(separator: "\n").count
        parent?.addChild(wow)
        return wow
    }
}

extension SKNode {
    func setZPosition(_ to: CGFloat) -> Self { zPosition = to; return self }
    func setPosition(_ to: CGPoint) -> Self { position = to; return self }
    func setName(_ to: String) -> Self { name = to; return self }
}
extension SKNode {
    var minY: CGFloat { frame.minY }
    var midY: CGFloat { frame.midY }
    var maxY: CGFloat { frame.maxY }
    var minX: CGFloat { frame.minX }
    var midX: CGFloat { frame.midX }
    var maxX: CGFloat { frame.maxX }
    
    func link(_ url: String) { openURL(urlStr: url) }
    #if os(iOS)
    func openURL(urlStr : String!) { if let url = NSURL(string: urlStr) { UIApplication.shared.open(url as URL, options: [:]) }}
    #else
    func openURL(urlStr : String!) { print("Implement me") }
    #endif
    
    @discardableResult
    func addTo(_ the: SKNode) -> Self { the.addChild(self); return self }
    
    func setButtonSize() -> Self {
        setSize(maxWidth: buttonSize)
    }
    
//    func setSize(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> Self {
//        if let www = maxWidth {
//            setScale(min(www, maxHeight ?? www) / width)
//        } else if let hhh = maxHeight {
//            setScale(min(hhh, maxWidth ?? hhh) / height)
//        } else {
//            fatalError()
//        }
//        return self
//    }
    
    func setSize(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> Self {
        var calc = calculateAccumulatedFrame()
        
        if let www = maxWidth {
            if let hhh = maxHeight {
                setScale(min(www / calc.width, hhh / calc.height))
            } else {
                setScale(www / calc.width)
            }
        } else if let hhh = maxHeight {
            if let www = maxWidth {
                setScale(min(www / calc.width, hhh / calc.height))
            } else {
                setScale(hhh / calc.height)
            }
        } else {
            fatalError()
        }
        return self
    }
}

//extension ChatBox {
//    func setChatBoxSize(maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> Self {
//        if let www = maxWidth {
//            setScale(min(www, maxHeight ?? www) / (width * 2))
//        } else if let hhh = maxHeight {
//            setScale(min(hhh, maxWidth ?? hhh) / (height * 2))
//        } else {
//            fatalError()
//        }
//        return self
//    }
//
//}
//
//extension Speaker {
//    func setChatBoxPosition(_ x: XPositions,_ y: YPositions) -> Self {
//        switch x {
//        case .right: anythingElse = { $0.position.x = w - $0.width - 20 }
//        case .fullRight: anythingElse = { $0.position.x = w - $0.width }
//        case .leftOf(let node): anythingElse = { $0.position.x = node.frame.minX - $0.width - 20 }
//        case .rightOf(let node): anythingElse = { $0.position.x = node.frame.maxX + 20 }
//        case .directlyLeftOf(let node): anythingElse = { $0.position.x = node.frame.minX - $0.width }
//        case .directlyRightOf(let node): anythingElse = { $0.position.x = node.frame.maxX }
//        case .left: anythingElse = { $0.position.x = 20 }
//        case .fullLeft: anythingElse = { $0.position.x = 0 }
//        case .center: anythingElse = { $0.position.x = (w/2) - $0.halfWidth }
//        case .rightCenter: anythingElse = { $0.position.x = (w/2) }
//        case .leftCenter: anythingElse = { $0.position.x = (w/2) - $0.width }
//        case .sameAs(let node): anythingElse = { $0.position.x = node.frame.midX - $0.halfWidth }
//        case .maxX(let node): anythingElse = { $0.position.x = node.frame.maxX - $0.width }
//        case .minX(let node): anythingElse = { $0.position.x = node.frame.minY }
//        }
//        switch y {
//        case .top: anythingElse = {
//            $0.position.y = h - $0.height - 20 - safeAreaTop
//        }
//        case .fullTop: anythingElse = { $0.position.y = h - $0.height - safeAreaTop }
//        case .below(let node): anythingElse = { $0.position.y = node.frame.minY - $0.height - 20 }
//        case .above(let node): anythingElse = { $0.position.y = node.frame.maxY + 20 }
//        case .directlyBelow(let node): anythingElse = { $0.position.y = node.frame.minY - $0.height }
//        case .directlyAbove(let node): anythingElse = { $0.position.y = node.frame.maxY }
//        case .almostDirectlyBelow(let node): anythingElse = { $0.position.y = node.frame.minY - $0.height - 5 }
//        case .bottom: anythingElse = { $0.position.y = 20 }
//        case .fullBottom: anythingElse = { $0.position.y = 0 }
//        case .center: anythingElse = { $0.position.y = (h/2) - $0.halfHeight }
//        case .aboveCenter: anythingElse = { $0.position.y = (h/2) }
//        case .belowCenter: anythingElse = { $0.position.y = (h/2) - $0.height }
//        case .sameAs(let node): anythingElse = { $0.position.y = node.frame.midY - $0.halfHeight }
//        case .maxY(let node): anythingElse = { $0.position.y = node.frame.maxY - $0.height }
//        case .minY(let node): anythingElse = { $0.position.y = node.frame.minY }
//
//        }
//        return self
//    }
//}


extension SKSpriteNode {
    
    func setColor(_ to: UIColor) -> Self {
        color = to
        colorBlendFactor = 1
        return self
    }
    
    func setPosition(_ x: XPositions,_ y: YPositions) -> Self {
        let (width, height) = (frame.width, frame.height)
        if anchorPoint == .zero {
            switch x {
            case .right: position.x = w - width - 20
            case .fullRight: position.x = w - width
            case .leftOf(let node): position.x = node.frame.minX - width - 20
            case .rightOf(let node): position.x = node.frame.maxX + 20
            case .directlyLeftOf(let node): position.x = node.frame.minX - width
            case .directlyRightOf(let node): position.x = node.frame.maxX
            case .left: position.x = 20
            case .fullLeft: position.x = 0
            case .center: position.x = (w/2) - halfWidth
            case .rightCenter: position.x = (w/2)
            case .leftCenter: position.x = (w/2) - width
            case .sameAs(let node): position.x = node.frame.midX - halfWidth
            case .maxX(let node): position.x = node.frame.maxX - width
            case .minX(let node): position.x = node.frame.minY
            }
            switch y {
            case .top: position.y = h - height - 20// - safeAreaTop
            case .fullTop: position.y = h - height// - safeAreaTop
            case .below(let node): position.y = node.frame.minY - height - 20
            case .above(let node): position.y = node.frame.maxY + 20
            case .directlyBelow(let node): position.y = node.frame.minY - height
            case .directlyAbove(let node): position.y = node.frame.maxY
            case.almostDirectlyBelow(let node): position.y = node.frame.minY - height - 5
            case .bottom: position.y = 20
            case .fullBottom: position.y = 0
            case .center: position.y = (h/2) - halfHeight
            case .aboveCenter: position.y = (h/2)
            case .belowCenter: position.y = (h/2) - height
            case .sameAs(let node): position.y = node.frame.midY - halfHeight
            case .maxY(let node): position.y = node.frame.maxY - height
            case .minY(let node): position.y = node.frame.minY
            }
        } else if anchorPoint == .half {
            switch x {
            case .right: position.x = w - halfWidth - 20
            case .fullRight: position.x = w - halfWidth
            case .leftOf(let node): position.x = node.frame.minX - halfWidth - 20
            case .rightOf(let node): position.x = node.frame.maxX + halfWidth + 20
            case .directlyLeftOf(let node): position.x = node.frame.minX - halfWidth
            case .directlyRightOf(let node): position.x = node.frame.minX - halfWidth
            case .left: position.x = halfWidth + 20
            case .fullLeft: position.x = halfWidth
            case .center: position.x = (w/2)
            case .rightCenter: position.x = (w/2) + halfWidth
            case .leftCenter: position.x = (w/2) - halfWidth
            case .sameAs(let node): position.x = node.frame.midY
            case .maxX(let node): position.x = node.frame.maxX - halfWidth
            case .minX(let node): position.x = node.frame.minX + halfWidth
            }
            switch y {
            case .top: position.y = h - halfHeight - 20
            case .fullTop: position.y = h - halfHeight
            case .below(let node): position.y = node.frame.minY - halfHeight - 20
            case .above(let node): position.y = node.frame.maxY + halfHeight + 20
            case .directlyBelow(let node): position.y = node.frame.minY - halfHeight
            case .almostDirectlyBelow(let node): position.y = node.frame.minY - halfHeight - 5
            case .directlyAbove(let node): position.y = node.frame.minY - halfHeight
            case .bottom: position.y = halfHeight + 20
            case .fullBottom: position.y = halfHeight
            case .center: position.y = (h/2)
            case .aboveCenter: position.y = (h/2) + halfHeight
            case .belowCenter: position.y = (h/2) - halfHeight
            case .sameAs(let node): position.y = node.frame.midY
            case .maxY(let node): position.y = node.frame.maxY - halfHeight
            case .minY(let node): position.y = node.frame.minY + halfHeight
            }
        }
        return self
    }
}

extension SKLabelNode {
    
    func setPosition(_ x: XPositions,_ y: YPositions) -> Self {
        let (width, height) = (frame.width, frame.height)
        if horizontalAlignmentMode == .left, verticalAlignmentMode == .bottom {
            switch x {
            case .right: position.x = w - width - 20
            case .fullRight: position.x = w - width
            case .leftOf(let node): position.x = node.frame.minX - width - 20
            case .rightOf(let node): position.x = node.frame.maxX + 20
            case .directlyLeftOf(let node): position.x = node.frame.minX - width
            case .directlyRightOf(let node): position.x = node.frame.maxX
            case .left: position.x = 20
            case .fullLeft: position.x = 0
            case .center: position.x = (w/2) - halfWidth
            case .rightCenter: position.x = (w/2)
            case .leftCenter: position.x = (w/2) - width
            case .sameAs(let node): position.x = node.frame.midX - halfWidth
            case .maxX(let node): position.x = node.frame.maxX - width
            case .minX(let node): position.x = node.frame.minY
            }
            switch y {
            case .top: position.y = h - height - 20// - safeAreaTop
            case .fullTop: position.y = h - height// - safeAreaTop
            case .below(let node): position.y = node.frame.minY - height - 20
            case .above(let node): position.y = node.frame.maxY + 20
            case .directlyBelow(let node): position.y = node.frame.minY - height
            case .almostDirectlyBelow(let node): position.y = node.frame.minY - height - 5
            case .directlyAbove(let node): position.y = node.frame.maxY
            case .bottom: position.y = 20
            case .fullBottom: position.y = 0
            case .center: position.y = (h/2) - halfHeight
            case .aboveCenter: position.y = (h/2)
            case .belowCenter: position.y = (h/2) - height
            case .sameAs(let node): position.y = node.frame.midY - halfHeight
            case .maxY(let node): position.y = node.frame.maxY - height
            case .minY(let node): position.y = node.frame.minY
            }
        } else if horizontalAlignmentMode == .center, verticalAlignmentMode == .center {
            switch x {
            case .right: position.x = w - halfWidth - 20
            case .fullRight: position.x = w - halfWidth
            case .leftOf(let node): position.x = node.frame.minX - halfWidth - 20
            case .rightOf(let node): position.x = node.frame.maxX + halfWidth + 20
            case .directlyLeftOf(let node): position.x = node.frame.minX - halfWidth
            case .directlyRightOf(let node): position.x = node.frame.minX - halfWidth
            case .left: position.x = halfWidth + 20
            case .fullLeft: position.x = halfWidth
            case .center: position.x = (w/2)
            case .rightCenter: position.x = (w/2) + halfWidth
            case .leftCenter: position.x = (w/2) - halfWidth
            case .sameAs(let node): position.x = node.frame.midY
            case .maxX(let node): position.x = node.frame.maxX - halfWidth
            case .minX(let node): position.x = node.frame.minX + halfWidth
            }
            switch y {
            case .top: position.y = h - halfHeight - 20// - safeAreaTop
            case .fullTop: position.y = h - halfHeight// - safeAreaTop
            case .below(let node): position.y = node.frame.minY - halfHeight - 20
            case .above(let node): position.y = node.frame.maxY + halfHeight + 20
            case .directlyBelow(let node): position.y = node.frame.minY - halfHeight
            case .almostDirectlyBelow(let node): position.y = node.frame.minY - halfHeight - 5
            case .directlyAbove(let node): position.y = node.frame.minY - halfHeight
            case .bottom: position.y = halfHeight + 20
            case .fullBottom: position.y = halfHeight
            case .center: position.y = (h/2)
            case .aboveCenter: position.y = (h/2) + halfHeight
            case .belowCenter: position.y = (h/2) - halfHeight
            case .sameAs(let node): position.y = node.frame.midY
            case .maxY(let node): position.y = node.frame.maxY - halfHeight
            case .minY(let node): position.y = node.frame.minY + halfHeight
            }
        }
        return self
    }
}

//
//extension Shape {
//
//    func setPosition(_ x: XPositions,_ y: YPositions) -> Self {
//        switch x {
//        case .right: position.x = w - halfWidth - 20
//        case .fullRight: position.x = w - halfWidth
//        case .leftOf(let node): position.x = node.frame.minX - halfWidth - 20
//        case .rightOf(let node): position.x = node.frame.maxX + halfWidth + 20
//        case .directlyLeftOf(let node): position.x = node.frame.minX - halfWidth
//        case .directlyRightOf(let node): position.x = node.frame.minX - halfWidth
//        case .left: position.x = halfWidth + 20
//        case .fullLeft: position.x = halfWidth
//        case .center: position.x = (w/2)
//        case .rightCenter: position.x = (w/2) + halfWidth
//        case .leftCenter: position.x = (w/2) - halfWidth
//        case .sameAs(let node): position.x = node.frame.midY
//        case .maxX(let node): position.x = node.frame.maxX - halfWidth
//        case .minX(let node): position.x = node.frame.minX + halfWidth
//        }
//        switch y {
//        case .top: position.y = h - halfHeight - 20 - safeAreaTop
//        case .fullTop: position.y = h - halfHeight - safeAreaTop
//        case .below(let node): position.y = node.frame.minY - halfHeight - 20
//        case .above(let node): position.y = node.frame.maxY + halfHeight + 20
//        case .directlyBelow(let node): position.y = node.frame.minY - halfHeight
//        case .almostDirectlyBelow(let node): position.y = node.frame.minY - halfHeight - 5
//        case .directlyAbove(let node): position.y = node.frame.maxY + halfHeight
//        case .bottom: position.y = halfHeight + 20
//        case .fullBottom: position.y = halfHeight
//        case .center: position.y = (h/2)
//        case .aboveCenter: position.y = (h/2) + halfHeight
//        case .belowCenter: position.y = (h/2) - halfHeight
//        case .sameAs(let node): position.y = node.frame.midY
//        case .maxY(let node): position.y = node.frame.maxY - halfHeight
//        case .minY(let node): position.y = node.frame.minY + halfHeight
//        }
////        switch x {
////        case .right: position.x = w - (width * 2) - 20
////        case .fullRight: position.x = w - (width * 2)
////        case .leftOf(let node): position.x = node.frame.minX - (width * 2) - 20
////        case .rightOf(let node): position.x = node.frame.maxX + 20
////        case .directlyLeftOf(let node): position.x = node.frame.minX - (width * 2)
////        case .directlyRightOf(let node): position.x = node.frame.maxX
////        case .left: position.x = 20
////        case .fullLeft: position.x = 0
////        case .center: position.x = (w/2) - (halfWidth * 2)
////        case .rightCenter: position.x = (w/2)
////        case .leftCenter: position.x = (w/2) - (width * 2)
////        case .sameAs(let node): position.x = node.frame.midX - (halfWidth * 2)
////        case .maxX(let node): position.x = node.frame.maxX - (width * 2)
////        case .minX(let node): position.x = node.frame.minY
////        }
////        switch y {
////        case .top: position.y = h - (height * 2) - 20
////        case .fullTop: position.y = h - (height * 2)
////        case .below(let node): position.y = node.frame.minY - (height * 2) - 20
////        case .above(let node): position.y = node.frame.maxY + 20
////        case .directlyBelow(let node): position.y = node.frame.minY - (height * 2)
////        case .directlyAbove(let node): position.y = node.frame.maxY
////        case .bottom: position.y = 20
////        case .fullBottom: position.y = 0
////        case .center: position.y = (h/2) - (halfHeight * 2)
////        case .aboveCenter: position.y = (h/2)
////        case .belowCenter: position.y = (h/2) - (height * 2)
////        case .sameAs(let node): position.y = node.frame.midY - (halfHeight * 2)
////        case .maxY(let node): position.y = node.frame.maxY - (height * 2)
////        case .minY(let node): position.y = node.frame.minY
////        }
//        return self
//    }
//}
//
//
////extension ChatBox {
////
////    func setPosition(_ x: XPositions,_ y: YPositions) -> Self {
////        let superFrame = calculateAccumulatedFrame()
////        let superWidth = superFrame.width
////        let superHalfWidth = superWidth / 2
////        let superHeight = superFrame.height
////        let superHalfHeight = superHeight / 2
////
////        switch x {
////        case .right: position.x = w - (superWidth * 2) - 20
////        case .fullRight: position.x = w - (superWidth * 2)
////        case .leftOf(let node): position.x = node.frame.minX - (superWidth * 2) - 20
////        case .rightOf(let node): position.x = node.frame.maxX + 20
////        case .directlyLeftOf(let node): position.x = node.frame.minX - (superWidth * 2)
////        case .directlyRightOf(let node): position.x = node.frame.maxX
////        case .left: position.x = 20
////        case .fullLeft: position.x = 0
////        case .center: position.x = (w/2) - (superHalfWidth * 2)
////        case .rightCenter: position.x = (w/2)
////        case .leftCenter: position.x = (w/2) - (superWidth * 2)
////        case .sameAs(let node): position.x = node.frame.midX - (superHalfWidth * 2)
////        case .maxX(let node): position.x = node.frame.maxX - (superWidth * 2)
////        case .minX(let node): position.x = node.frame.minY
////        }
////        switch y {
////        case .top: position.y = h - (superHeight * 2) - 20
////        case .fullTop: position.y = h - (superHeight * 2)
////        case .below(let node): position.y = node.frame.minY - (superHeight * 2) - 20
////        case .above(let node): position.y = node.frame.maxY + 20
////        case .directlyBelow(let node): position.y = node.frame.minY - (superHeight * 2)
////        case .directlyAbove(let node): position.y = node.frame.maxY
////        case .bottom: position.y = 20
////        case .fullBottom: position.y = 0
////        case .center: position.y = (h/2) - (superHalfHeight * 2)
////        case .aboveCenter: position.y = (h/2)
////        case .belowCenter: position.y = (h/2) - (superHeight * 2)
////        case .sameAs(let node): position.y = node.frame.midY - (superHalfHeight * 2)
////        case .maxY(let node): position.y = node.frame.maxY - (superHeight * 2)
////        case .minY(let node): position.y = node.frame.minY
////        }
////        return self
////    }
////}
//
//
//extension Group {
//
//    @discardableResult
//    func setPosition(_ x: XPositions,_ y: YPositions) -> Self {
//
//        let framo1 = calculateAccumulatedFrame()
//        if framo1.minY != 0, framo1.minX != 0 {
//            for i in children {
//                i.position.x -= framo1.minX
//                i.position.y -= framo1.minY
//            }
//        }
//
//        let framo = calculateAccumulatedFrame()
//        let framohalfWidth = framo.width / 2, framohalfHeight = framo.height / 2
//
//        switch x {
//        case .right: position.x = w - framo.width - 20
//        case .fullRight: position.x = w - framo.width
//        case .leftOf(let node): position.x = node.frame.minX - framo.width - 20
//        case .rightOf(let node): position.x = node.frame.maxX + 20
//        case .directlyLeftOf(let node): position.x = node.frame.minX - framo.width
//        case .directlyRightOf(let node): position.x = node.frame.maxX
//        case .left: position.x = 20
//        case .fullLeft: position.x = 0
//        case .center: position.x = (w/2) - framohalfWidth
//        case .rightCenter: position.x = (w/2)
//        case .leftCenter: position.x = (w/2) - framo.width
//        case .sameAs(let node): position.x = node.frame.midX - framohalfWidth
//        case .maxX(let node): position.x = node.frame.maxX - framo.width
//        case .minX(let node): position.x = node.frame.minY
//        }
//        switch y {
//        case .top: position.y = h - framo.height - 20 - safeAreaTop
//        case .fullTop: position.y = h - framo.height - safeAreaTop
//        case .below(let node): position.y = node.frame.minY - framo.height - 20
//        case .above(let node): position.y = node.frame.maxY + 20
//        case .directlyBelow(let node): position.y = node.frame.minY - framo.height
//        case .almostDirectlyBelow(let node): position.y = node.frame.minY - framo.height - 5
//        case .directlyAbove(let node): position.y = node.frame.maxY
//        case .bottom: position.y = 20
//        case .fullBottom: position.y = 0
//        case .center: position.y = (h/2) - framohalfHeight
//        case .aboveCenter: position.y = (h/2)
//        case .belowCenter: position.y = (h/2) - framo.height
//        case .sameAs(let node): position.y = node.frame.midY - framohalfHeight
//        case .maxY(let node): position.y = node.frame.maxY - framo.height
//        case .minY(let node): position.y = node.frame.minY
//        }
//        return self
//    }
//}
