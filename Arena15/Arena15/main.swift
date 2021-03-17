//
//  main.swift
//  Arena15
//
//  Created by Jonathan Pappas on 3/1/21.
//

import Foundation
















struct Game {
    var latestGuess: Int
    var maxNumber: Int = 1000000
    var minNumber: Int = 1
    
    init() {
        latestGuess = maxNumber / 2
    }
    
    func guessNumber() {
        print("Is your number higher or lower than \(latestGuess)")
    }
}






















