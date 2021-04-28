//
//  main.swift
//  FunctionalOrientedProgramming
//
//  Created by Jonathan Pappas on 4/26/21.
//

import Foundation

//// let - immutable
//func foo() {
//    print("I am a function!")
//}
//
//// var - changable
//var foo2: () -> () = {
//    print("I am a function! 2222")
//}
//
//foo2()
//
//foo2 = {
//    print("I am different now!")
//}
//
//foo2()
//
//foo2 = foo
//
//foo2()



//func add(_ number: Int, _ number2: Int) {
//    print(number + number2)
//}
//
//add(1, 1)
//
//
//var closureAdd: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> () = {
//    print($0 + $1 + $2 + $3 + $4 + $5 + $6 + $7 + $8 + $9 + $10)
//}
//
//closureAdd(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)




//var addByOne1: (Int) -> () = { number in
//    print(number + 1)
//}
//
//addByOne1(0)



//func add(_ number: Int, _ number2: Int) -> Int {
//    return number + number2
//}
//
//print(add(1, 1))
//
//
//var closureAdd: (Int, Int) -> Int = {
//    return $0 + $1
//}
//
//print(closureAdd(2, 2))
//


//func runThisFunction(this: () -> () ) {
//    print("Run:")
//    this()
//}
//
//runThisFunction(this: { print("I am the function. I was ran!") })
//runThisFunction(this: { print("I am a different function") })
//runThisFunction(this: { print("Wow!") })
//
//runThisFunction {
//    print("I am the function. I was ran!")
//}
//
//[1, 2, 3, 4].map {
//    print($0)
//}








//struct Person {
//    var name = "Jonathan"
//
//    mutating func changeName() {
//        name = "Wow!"
//    }
//
//    var changeName2: () -> () {
//        name = "Wow!"
//    }
//}
//
//var this = Person()
//print(this.name)
//
//this.name = "Zyus"
//print(this.name)













//print(type(of: foo))
//fatalError()


//foo2()
//foo2()
//foo2()
//foo2()



//let myArray = [1, 2, 3, 4, 5, 6]
//
//for i in myArray {
//    print(i)
//}
//
//myArray.forEach { i in
//    print(i)
//}
//
//extension Array where Element == Int {
//    func forEach2(_ this: (Int) -> () ) {
//        for i in self {
//            this(i)
//        }
//    }
//}
//
//myArray.forEach2 { i in
//    print(i)
//}






enum RockPaperScissorsEnum: CaseIterable {
    case rock, paper, scissors
    static func chooseRandom() -> Self {
        return allCases.randomElement()!
    }
}

struct RockPaperScissors {
    static var numberOfChosenObjects = 0
    
    var chosen: RockPaperScissorsEnum
    
    init(_ chosen: RockPaperScissorsEnum) {
        self.chosen = chosen
        Self.numberOfChosenObjects += 1
    }
    
    func biggerThan(_ another: RockPaperScissors) -> Bool {
        if self.chosen == .rock, another.chosen == .scissors {
            return true
        }
        if self.chosen == .paper, another.chosen == .rock {
            return true
        }
        if self.chosen == .scissors, another.chosen == .paper {
            return true
        }
        return false
    }
    
    func equalTo(_ another: RockPaperScissors) -> Bool {
        return self.chosen == another.chosen
    }
    
}

let me = RockPaperScissors(.rock)
let opponent = RockPaperScissors(.chooseRandom())
print(opponent)

RockPaperScissors(.rock)
RockPaperScissors(.rock)
RockPaperScissors(.rock)
RockPaperScissors(.rock)
print(RockPaperScissors.numberOfChosenObjects)

print(me.biggerThan(opponent))
print(opponent.biggerThan(me))
