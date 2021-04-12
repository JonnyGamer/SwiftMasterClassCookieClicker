//
//  main.swift
//  RandomNumberGeneratorSeeds
//
//  Created by Jonathan Pappas on 4/8/21.
//

import Foundation

print("Hello, World!")

class SeededRandomNumberGenerator : RandomNumberGenerator {
    let range: ClosedRange<Double> = Double(UInt64.min) ... Double(UInt64.max)
    init(seed: Int) { srand48(seed) }
    func next() -> UInt64 { return UInt64(range.lowerBound + (range.upperBound - range.lowerBound) * drand48()) }
}

var g = SeededRandomNumberGenerator.init(seed: 3)


print(Int.random(in: 1...10, using: &g))
print([233, 2, 2, 2].randomElement(using: &g))
print(Bool.random(using: &g))

func oneIn(_ n: Int) -> Bool {
    print(Int.random(in: 1...n, using: &g))
    return Int.random(in: 1...n, using: &g) == 1
}


for i in 1...1000 {
    print(oneIn(4))
    //print(Int.random(in: 1...i, using: &g))
}
