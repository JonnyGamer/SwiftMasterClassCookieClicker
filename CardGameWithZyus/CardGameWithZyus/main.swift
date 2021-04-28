//
//  main.swift
//  CardGameWithZyus
//
//  Created by Jonathan Pappas on 4/19/21.
//

import Foundation

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
        return number > another.number
    }
    func equalTo(_ another: Card) -> Bool {
        return number == another.number
    }
    
}

enum Suit: CaseIterable {
    case spade, diamond, heart, club
}

//let myCard = Card(number: 13, suit: .heart)
//let myCard2 = Card(number: 8, suit: .heart)
//print(myCard2.biggerThan(myCard))


struct War {
    
    var players: [Int:[Card]] = [:]
    
    init() {
        print("Let's begin!")
        
        // Step 1: Build Card Deck!
        var deck = [Card]()
        for suit in Suit.allCases {
            for number in 1...13 {
                deck.append(Card(number: number, suit: suit))
            }
        }
        
        // Step 2: Shuffle the deck
        deck.shuffle()
        
        // Step 3: How many players are playing?
        let numberOfPlayers = 2
        for i in 1...numberOfPlayers {
            players[i] = []
        }
        
        // Step 4: Dealing Cards!
        deal: while true {
            for i in 1...numberOfPlayers {
                if deck.isEmpty { break deal }
                players[i]!.append(deck.removeFirst())
            }
        }
        
        print(players[1]?.count)
        print(players[2]?.count)
    }
    
    mutating func reveal(_ playersToReveal: [Int],_ oldPot: [Card] = []) {
        
        // All existing players reveal a card
        var revealedCards: [Int:Card] = [:]
        for i in playersToReveal {
            revealedCards[i] = players[i]!.removeFirst()
        }
        
        // Who has the highest card?
        var highestCards: [(Int, Card)] = []
        for (player, card) in revealedCards {
            
            if highestCards.isEmpty {
                highestCards.append((player, card))
            } else if card.equalTo(highestCards[0].1) {
                highestCards.append((player, card))
            } else if card.biggerThan(highestCards[0].1) {
                highestCards = [(player, card)]
            }
        }
        
        //print(revealedCards)
        //print(highestCards)
        
        // If there is one winner, give then cards
        if highestCards.count == 1 {
            let playerThatWon = highestCards[0].0
            for (_, card) in revealedCards {
                players[playerThatWon]?.append(card)
            }
            players[playerThatWon]! += oldPot
        } else {
            // There is a tie
            tie(highestCards, oldPot: oldPot + highestCards.map { $0.1 })
        }
    }
    
    mutating func tie(_ tiedPlayers: [(Int, Card)], oldPot: [Card]) {
        var playersStillIn: [Int] = []
        var pot: [Card] = oldPot
        
        for (player, _) in tiedPlayers {
            
            if players[player]!.count >= 4 {
                // Recurse Code
                pot.append(players[player]!.removeFirst())
                pot.append(players[player]!.removeFirst())
                pot.append(players[player]!.removeFirst())
                playersStillIn.append(player)
                
            } else {
                // Game over
                pot += players[player]!
                players[player] = nil
            }
        }
        
        if !playersStillIn.isEmpty {
            reveal(playersStillIn, pot)
        }
        
    }
    
    mutating func gameOver() {
        for i in players {
            if i.value.isEmpty {
                players[i.key] = nil
            }
        }
    }
    
    var numberOfRounds = 0
    mutating func round() {
        numberOfRounds += 1
        reveal(players.map { $0.key })
        gameOver()
        if players.count == 1 {
            print("Player", players.first!.key, "won the game! (In \(numberOfRounds) rounds)")
        }
    }
    
    mutating func play() {
        while players.count > 1 {
            round()
        }
    }
    
}

//var game = War()
//game.play()

var averageRounds = 0

for i in 1...1000 {
    print(i)
    
    var war = War()
    war.play()
    
    averageRounds += war.numberOfRounds
}
print("Average Number of Rounds:", Double(averageRounds) / 100)
