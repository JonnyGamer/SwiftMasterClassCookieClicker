//
//  main.swift
//  Zillion
//
//  Created by Jonathan Pappas on 4/5/21.
//

import Foundation

var largeNumberNames: [String] = ["","thousand","million","billion","trillion","quadrillion","quintillion","hextillion","septillion","nonillion","decillion"]

struct Zillion {
    var number: String
    
    init(_ number: String) { self.number = String(Int(number) ?? 0) }
    init(_ number: Int) { self.number = String(number) }
    
    func name() -> String {
        if number == "0" { return "zero" }
        
        // Split into groups of three!
        let groupsOfThree = number.splitIntroGroupsOf(3)
        print(groupsOfThree)
        
        print(groupsOfThree.map { $0.threeDigitNumberName() })
        
        // Gather Thousands
        var trueName: [String] = []
        var massiveCount = groupsOfThree.count
        
        for i in groupsOfThree {
            let newName = i.threeDigitNumberName()
            if !newName.isEmpty {
                trueName += newName
                if massiveCount > 0 {
                    trueName.append(largeNumberNames[massiveCount-1])
                }
            }
            massiveCount -= 1
        }
        
        print(trueName)
        
        
        return trueName.joined(separator: " ")
    }
}

extension String {
    func splitIntroGroupsOf(_ n: Int) -> [String] {
        var addZeroes = self
        
        if count % n != 0 {
            addZeroes = String.init(repeating: "0", count: n - (count % n)) + addZeroes
        }
        
        var groupsOfThree: [String] = [""]
        var o = 0
        for i in addZeroes {
            if o == n {
                groupsOfThree.append("")
                o = 0
            }
            
            groupsOfThree[groupsOfThree.count - 1].append(i)
            
            o += 1
        }
        
        return groupsOfThree
    }
    
    var singleDigitName: [String] { ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"] }
    
    func threeDigitNumberName() -> [String] {
        if self == "000" { return [] }
        
        var name = [String]()
        var on = 0
        let singleDigitName = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        let twenties = ["","","twenty","thirty","fourty","fifty","sixty","seventy","eighty","nintety"]
        let teen = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
        
        for i in self {
            
            if on == 0 {
                if i != "0" {
                    name.append(singleDigitName[Int(String(i))!])
                    name.append("hundred")
                }
            } else if on == 1 {
                if i == "0" {
                    
                } else if i == "1" {
                    name.append(teen[Int(String(last!))!])
                    break
                } else {
                    name.append(twenties[Int(String(i))!])
                }
            } else if on == 2 {
                name.append(singleDigitName[Int(String(i))!])
            }
            
            
            on += 1
        }
        return name
    }
}


print(Zillion(100).name())


print(Zillion(123456789001).name())










