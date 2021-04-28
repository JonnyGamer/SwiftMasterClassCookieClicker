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
    
    init(_ playersIn: Int) {
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
        let numberOfPlayers = playersIn
        for i in 1...numberOfPlayers {
            players[i] = []
        }
        
        // Deal the cards!
        deal: while true {
            for i in 1...numberOfPlayers {
                if deck.isEmpty { break deal }
                players[i]!.append(deck.removeFirst())
            }
        }
    }
    
    var numberOfRounds = 0
    mutating func round() {
        //print(players.reduce(into: 0) { $0 += $1.value.count })
        numberOfRounds += 1
        reveal(players.map { $0.key }, [])
        gameOver()
        if players.count == 1 {
            print("Player", players.first!.key, "won the game!")
            print("The game lasted", numberOfRounds, "rounds.")
            print("There were", amountOfTies, "ties.")
            print(players.first!.value.count)
        }
    }
    
    mutating func play() {
        while players.count > 1 {
            round()
        }
    }
    
    mutating func gameOver() {
        for player in players {
            if player.value.isEmpty {
                players[player.key] = nil
            }
        }
    }
    
    mutating func reveal(_ playerToReveal: [Int],_ oldPot: [Card]) {
        
        // Everyone reveals a card
        var revealedCards : [Int:Card] = [:]
        for i in players {
            // BUGFIX
            if players[i.key]?.isEmpty == false {
                revealedCards[i.key] = players[i.key]!.removeFirst()
            }
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
            players[playerThatWon]! += oldPot
            
        } else {
            // More than 1
            tie(highestCards, oldPot)
        }
    }
    
    var amountOfTies = 0
    mutating func tie(_ tiedPlayers: [(Int, Card)],_ oldPot: [Card]) {
        amountOfTies += 1
        
        var playersStillIn: [Int] = []
        var pot: [Card] = oldPot
        
        for (player, _) in tiedPlayers {
            if players[player]!.count >= 4 {
                // Recursion Time
                pot.append(players[player]!.removeFirst())
                pot.append(players[player]!.removeFirst())
                pot.append(players[player]!.removeFirst())
                playersStillIn.append(player)
                
            } else {
                // Game Over
                pot += players[player]!
                players[player] = nil
                print("Forgetting", players[player], "cards")
            }
        }
        
        if !playersStillIn.isEmpty {
            reveal(playersStillIn, pot + tiedPlayers.map { $0.1 })
        }
        
    }
    
    
    
    
}


var averageRounds = 0
var averageTies = 0
var mostRounds = 0
var mostTies = 0
let games = 1_000

for i in 1...games {
    print(i)
    
    var war = War(7)
    war.play()
    
    averageRounds += war.numberOfRounds
    averageTies += war.amountOfTies
    
    if mostRounds < war.numberOfRounds {
        mostRounds = war.numberOfRounds
    }
    
    if mostTies < war.amountOfTies {
        mostTies = war.amountOfTies
    }
    
}

print("Average Round Length", Double(averageRounds) / Double(games))
print("Average Number of Ties", Double(averageTies) / Double(games))
print("Record Game Length:", mostRounds)
print("Record Number of Ties:", mostTies)




// Arena 10 has my finished project

// RECORD: 7799
// 16_232

// Round: 17718
// Ties: 165

// Record: 90,006
