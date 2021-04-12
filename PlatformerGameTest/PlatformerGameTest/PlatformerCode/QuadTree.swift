//
//  QuadTree.swift
//  PlatformerGameTest
//
//  Created by Jonathan Pappas on 4/12/21.
//

import Foundation
import SpriteKit

//typealias Ranger = ClosedRange<CGFloat>

//class Box {
//
//}
//
//class QuadTree {
//    var qBL: QuadTree?
//    var qTL: QuadTree?
//    var qBR: QuadTree?
//    var qTR: QuadTree?
//
//    var elements: Set<Boxen> = []
//    var jnodes: Set<Boxen> = []
//    var size: Box
//    var minSize: CGFloat = 2.0
//    var split = false
//    var level = 0
//
//    init(_ size: Box) { self.size = size }
//    init(_ x: Ranger,_ y: Ranger) { size = Box(x, y) }
//
//    func contains(_ box: Boxen,_ boxboxx: Ranger,_ boxboxy: Ranger) -> Set<Boxen> {
//        var seto: Set<Boxen> = []
//        if level == 0 {
//            for element in jnodes {
//                if element.box.x.overlaps(boxboxx) && element.box.y.overlaps(boxboxy) {
//                    seto.insert(element)
//                }
//            }
//        }
//
//        if !elements.isEmpty {
//            for element in elements {
//                if element.box.x.overlaps(boxboxx) && element.box.y.overlaps(boxboxy) {
//                    seto.insert(element)
//                }
//            }
//            return seto
//        }
//        if boxboxx.overlaps(size.x.lowerHalf) {
//            if boxboxy.overlaps(size.y.lowerHalf) {
//                seto = seto.union(qBL?.contains(box, boxboxx, boxboxy) ?? qBL?.elements ?? [])
//            }
//            if boxboxy.overlaps(size.y.upperHalf) {
//                seto = seto.union(qTL?.contains(box, boxboxx, boxboxy) ?? qTL?.elements ?? [])
//            }
//        }
//        if boxboxx.overlaps(size.x.upperHalf) {
//            if boxboxy.overlaps(size.y.lowerHalf) {
//                seto = seto.union(qBR?.contains(box, boxboxx, boxboxy) ?? qBR?.elements ?? [])
//            }
//            if boxboxy.overlaps(size.y.upperHalf) {
//                seto = seto.union(qTR?.contains(box, boxboxx, boxboxy) ?? qTR?.elements ?? [])
//            }
//        }
//        return seto
//    }
//
//    var total: Int {
//        if !elements.isEmpty { return elements.count }
//        let bl = qBL?.total ?? 0
//        let br = qBR?.total ?? 0
//        let tl = qTL?.total ?? 0
//        let tr = qTR?.total ?? 0
//        return bl + br + tl + tr
//    }
//
//    func insert(_ box: Boxen) {
//
//        let minSquare = (minSize * minSize)
//        elements.insert(box)
//        if size.x.dist < minSquare || size.y.dist < minSquare { return }
//        if elements.count <= 4 && !split { return }
//        split = true
//
//        let ele = elements; elements = []
//
//        for element in ele {
//            if element.box.x.overlaps(size.x.lowerHalf) {
//                if element.box.y.overlaps(size.y.lowerHalf) {
//                    if qBL == nil {
//                        qBL = QuadTree.init(size.x.lowerHalf, size.y.lowerHalf)
//                        qBL?.level = level + 1
//                    }
//                    qBL?.insert(element)
//                }
//                if element.box.y.overlaps(size.y.upperHalf) {
//                    if qTL == nil {
//                        qTL = QuadTree.init(size.x.lowerHalf, size.y.upperHalf)
//                        qTL?.level = level + 1
//                    }
//                    qTL?.insert(element)
//                }
//            }
//            if element.box.x.overlaps(size.x.upperHalf) {
//                if element.box.y.overlaps(size.y.lowerHalf) {
//                    if qBR == nil {
//                        qBR = QuadTree.init(size.x.upperHalf, size.y.lowerHalf)
//                        qBR?.level = level + 1
//                    }
//                    qBR?.insert(element)
//                }
//                if element.box.y.overlaps(size.y.upperHalf) {
//                    if qTR == nil {
//                        qTR = QuadTree.init(size.x.upperHalf, size.y.upperHalf)
//                        qTR?.level = level + 1
//                    }
//                    qTR?.insert(element)
//                }
//            }
//        }
//    }
//}
//
//
//extension ClosedRange where Bound == CGFloat {
//    var dist: CGFloat { return upperBound - lowerBound }
//    var half: CGFloat { return (upperBound + lowerBound) / 2 }
//    var upperHalf: Ranger { return half...upperBound }
//    var lowerHalf: Ranger { return lowerBound...half }
//
//    static func < (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
//        return lhs.upperBound < rhs.lowerBound
//    }
//    static func > (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool {
//        return lhs.lowerBound > rhs.upperBound
//    }
//}
