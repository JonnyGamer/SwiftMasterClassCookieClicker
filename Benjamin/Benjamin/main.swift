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
    
    func equalTo(_ another: Card) -> Bool {
        return self.number == another.number
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


// War Environment

struct War {
    
    var players: [Int:[Card]] = [:]
    
    init() {
        print("Let's begin!")
        
        // Build the deck of 52 Cards
        var deck = [Card]()
        for suit in [Suit.spade, .club, .diamond, .heart] {
            for number in 1...13 {
                deck.append(Card(number: number, suit: suit))
            }
        }
        
        // Shuffle the deck
        deck.shuffle()
        
        // How many players are playing?
        let numberOfPlayers = 2
        for i in 0..<numberOfPlayers {
            players[i] = []
        }
        
        // Deal the cards!
        deal: while true {
            for i in 0..<numberOfPlayers {
                if deck.isEmpty { break deal }
                players[i]!.append(deck.removeFirst())
            }
        }
    }
    
    mutating func round() {
        
    }
    
    
    mutating func reveal() {
        
        // Everyone reveals a card
        var revealedCards : [Int:Card] = [:]
        for i in players {
            revealedCards[i.key] = players[i.key]!.removeFirst()
        }
        
        // Find out who has the highest card
        var highestCards: [(Int, Card)] = []
        for (player, card) in revealedCards {
            if highestCards.isEmpty {
                highestCards.append((player, card))
            } else if card.biggerThan(highestCards[0].1) {
                highestCards = [(player, card)]
            } else if card.equalTo(highestCards[0].1) {
                highestCards.append((player, card))
            }
        }
        
        if highestCards.count == 1 {
            // Somebody won!
            // Give reveal cards to the player than won
            let playerThatWon = highestCards[0].0
            for (_, card) in revealedCards {
                players[playerThatWon]!.append(card)
            }
            
        } else {
            // More than 1
        }
    }
    
    
    mutating func tie(_ tiedPlayers: [(Int, Card)]) {
        
        var playersStillIn: [(Int, Card)] = []
        var pot: [Card] = []
        
        for (player, _) in tiedPlayers {
            if players[player]!.count >= 4 {
                
            } else {
                // Game Over
                pot += players[player]!
                players[player] = nil
            }
            
        }
        
        
    }
    
}

let war = War()





// Arena 10 has my finished project
