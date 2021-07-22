//
//  Random.swift
//  EverMaze2
//
//  Created by Jonathan Pappas on 4/8/21.
//

import Foundation
import GameplayKit

class SeededGenerator: RandomNumberGenerator {
    let seed: UInt64
    private let generator: GKMersenneTwisterRandomSource
    convenience init() {
        self.init(seed: 0)
    }
    static func Build(seed: Int) -> SeededGenerator { return SeededGenerator(seed: UInt64(seed)) }
    init(seed: UInt64) {
        self.seed = seed
        generator = GKMersenneTwisterRandomSource(seed: seed)
    }
    func next<T>(upperBound: T) -> T where T : FixedWidthInteger, T : UnsignedInteger {
        return T(abs(generator.nextInt(upperBound: Int(upperBound))))
    }
    func next<T>() -> T where T : FixedWidthInteger, T : UnsignedInteger {
        return T(abs(generator.nextInt()))
    }
}

var g = SeededGenerator.init(seed: 111)

var seed = 1 {
    didSet {
        print("NEW SEED \(seed)")
        g = SeededGenerator(seed: UInt64(seed))
    }
}

func fiftyFifty() -> Bool {
    return oneIn(2)
}
func oneIn(_ n: Int) -> Bool {
    return Bool.random(using: &g) && Bool.random(using: &g)
    
    //let foo = Int.random(in: 1...4, using: &g) == 1
    //print(foo)
    //return foo//Int.random(in: 1...4, using: &g) == 1
}




