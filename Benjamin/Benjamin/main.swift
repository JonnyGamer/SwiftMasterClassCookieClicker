//
//  main.swift
//  Benjamin
//
//  Created by Jonathan Pappas on 4/7/21.
//

import Foundation

// Card
// - suit
// - number / king



struct Card: CustomStringConvertible {
    
    var description: String {
        var n = String(number)
        if number == 1 { n = "Ace" }
        if number == 11 { n = "Jack" }
        if number == 12 { n = "Queen" }
        if number == 13 { n = "King" }
        return "\(n) of \(suit)s"
    }
    
    var number: Int
    var suit: Suit
    
    func biggerThan(_ another: Card) -> Bool {
        return self.number > another.number
    }
    
}

enum Suit {
    case spade, diamond, heart, club
}


let myFirstCard = Card(number: 11, suit: .spade)
print(myFirstCard)

let mySecondCard = Card(number: 8, suit: .spade)
print(mySecondCard)


print(myFirstCard.biggerThan(mySecondCard))
print(mySecondCard.biggerThan(myFirstCard))


