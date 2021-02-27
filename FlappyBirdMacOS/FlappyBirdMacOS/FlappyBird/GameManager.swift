//
//  GameManager.swift
//  FlappyBirdMacOS
//
//  Created by Jonathan Pappas on 2/27/21.
//

import Foundation

struct GameManager {
    
    static var birdIndex = 0
    static var birds = [
        "Blue", "Green", "Red", "Purple",
        "Tiny", "2Tiny", "3Tiny", "4Tiny",
        "Mega", "2Mega", "3Mega", "4Mega"
    ]
    static func birdIsNormal() -> Bool { (0...3).contains(birdIndex) }
    static func birdIsTiny() -> Bool { (4...7).contains(birdIndex) }
    static func birdIsMega() -> Bool { (8...11).contains(birdIndex) }
    
    static func getBird() -> String {
        return birds[birdIndex]
    }
    static func getDifficulty() -> Int {
        return birdIndex % (birds.count / 3)
    }
    static func changeDifficulty() {
        birdIndex += 1
        birdIndex %= birds.count
    }
    
    static var levels = [
        "Easy", "Medium", "Hard", "Purple",
        "Tiny Easy", "Tiny Medium", "Tiny Hard", "Tiny Purple",
        "Huge Easy", "Huge Medium", "Huge Hard", "Huge Purple"
    ]
    static func getLevel() -> String {
        return levels[birdIndex]
    }
    
    static var night = false
    static var gravity = true
    static func backgroundImageName() -> String { return night ? "BG Night" : "BG Day" }
    static func pipeImageName() -> String { return night ? "2" : "1" }
    
    static var invisi = false
    static func getHighscore(_ Bird: String = getBird()) -> Int {
        if night {
            if invisi {
                return UserDefaults.standard.integer(forKey: "Invisi Dark Highscore \(Bird)")
            } else {
                return UserDefaults.standard.integer(forKey: "Dark Highscore \(Bird)")
            }
        } else {
            // set my own highscores for fun
            // UserDefaults.standard.set(100, forKey: "Highscore Blue")
            if invisi {
                return UserDefaults.standard.integer(forKey: "Invisi Highscore \(Bird)")
            } else {
                return UserDefaults.standard.integer(forKey: "Highscore \(Bird)")
            }
        }
    }
    
    static func setHighscore(highscore: Int, Bird: String) {
        if night {
            
            if invisi {
                UserDefaults.standard.set(highscore, forKey: "Invisi Dark Highscore \(Bird)")
            } else {
                UserDefaults.standard.set(highscore, forKey: "Dark Highscore \(Bird)")
            }
        } else {
            if invisi {
                UserDefaults.standard.set(highscore, forKey: "Invisi Highscore \(Bird)")
            } else {
                UserDefaults.standard.set(highscore, forKey: "Highscore \(Bird)")
            }
        }
    }
    
}
