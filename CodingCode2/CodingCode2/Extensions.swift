//
//  Extensions.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

//extension String { var int: Int { return Int(self)! } }
func int(_ n: Any) -> Int {
    return Int("\(n)")!
}

// Extremely Magical Printing
func magicPrint(_ this: [Any], testing: Bool = false) {
    if testing { print(" - TEST PRINT -", terminator: " ") }
    this.forEach { print($0, separator: "", terminator: " ") }
    print("\n", terminator: "")
}
// magicPrint([1, 2, 3])
// magicPrint([1, 2, 3, 4])
// magicPrint([1, 2, 3, 4, 5])
