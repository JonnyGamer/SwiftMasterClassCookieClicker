//
//  main.swift
//  ClassWithJared2
//
//  Created by Jonathan Pappas on 5/26/21.
//

import Foundation

extension String {
    func onlyContainsLetters() -> Bool {
        return !original.contains(where: { !$0.isLetter })
    }
}

let original = readLine()!
if original != "" && original.onlyContainsLetters() {
    print(original)
} else {
    print("Empty")
}













//let array: Array<Int> = [1, 2, 3]
//
//let a2: Array<String> = ["1", "2", "3"]
//
//let a3: Array<Array<Int>> = [
//    [1, 2, 3],
//    [1, 2, 3],
//    [1, 2, 3],
//    [1, 2, 3],
//]
//
//
//let a4: [[[Int]]] = [[[0, 1, 2]]]













let array2: [Int] = [1, 2, 3, 4, 5]

var myNewDictionary: Dictionary<Bool, String> = [
    true: "True is true",
    false: "Fasle is false"
]

var anotherDictionary: [Bool:String] = [
    true: "True is true",
    false: "Fasle is false"
]

var finalDictionary = [
    0: "True is true",
    1: "Fasle is false"
]




























// 2^10 = 1,024
// MB = 2^20 = 1,048,576
// GB = 2^30 = 1,073,741,824
// TB = 2^40 = 1,099,511,627,776
// PB = 2^50 = 1,125,899,906,842,624
// HB = 2^60 = 1,152,921,504,606,846,976
// ZB = 2^70 = 1,180,591,620,717,411,303,424
// Yottabyte
// YB = 2^80 = 1,208,925,819,614,629,174,706,176

// 2^200 = 1,606,0000000
// 2^290 = 1,989,.....
// 2^300 = 2,037,035976334486086268445688409378161051468393665936250636140449354381299763336706183397376



















// Fibonacci
//var fibonacci = [0, 1]
//var number = 2
//
//while true {
//    let sum = fibonacci[fibonacci.count - 1] + fibonacci[fibonacci.count - 2]
//    //print(number, sum)
//
//    let div = Double(fibonacci[fibonacci.count - 1]) / Double(fibonacci[fibonacci.count - 2])
//    print(div)
//
//
//    fibonacci.append(sum)
//    number += 1
//}







