//
//  main.swift
//  ZillionWithZyus
//
//  Created by Jonathan Pappas on 4/5/21.
//


var (f1,f2) = (0,1)
for _ in 1...10 {
    (f1,f2) = (f2,f1+f2)
    print(f1)
}





fatalError()

import Foundation


var largeNumberNames: [String] = ["","thousand","million","billion","trillion","quadrillion","quintillion","hextillion","septillion","nonillion","decillion"]


Zillion(1).name()
name(Zillion(1))


func name(_ n: Zillion) {
    
}


struct Zillion {
    var number: String
    
    init(_ number: String) {
        self.number = number
    }
    init(_ integer: Int) {
        self.number = String(integer)
    }
    
    func name() -> String {
        var negative = false
        var number = self.number
        
        if number.first == "-" {
            number.removeFirst()
            negative = true
        }
        
        
        if number == "0" { return "zero" }
        
        let groupsOfThree = number.splitIntroGroupsOf(3)
        
        var officialName: [[String]] = []
        
        for i in groupsOfThree {
            officialName.append(i.threeDigitNumberNames())
        }
        
        var largestName = officialName.count
        
        for i in 0..<officialName.count {
            if largestName > 1 {
                if !officialName[i].isEmpty {
                    officialName[i].append(largeNumberNames[largestName-1])
                }
            }
            largestName -= 1
        }
        
        if negative {
            officialName = [["negative"]] + officialName
        }
        
        return officialName.flatMap { $0 }.joined(separator: " ")
    }
    
}




extension String {
    func threeDigitNumberNames() -> [String] {
        
        var ones = ["", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
        let twenties = ["","","twenty","thirty","forty","fifty","sixty","seventy","eighty","ninety"]
        let teen = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
        
        // 000
        
        var threeDigit: [String] = []
        
        var o = 0
        loop: for i in self {
            
            switch o {
            case 0:
                if i != "0" {
                    threeDigit.append(ones[Int(String(i))!])
                    threeDigit.append("hundred")
                }
            case 1:
                switch i {
                case "0": do{}
                case "1": threeDigit.append(teen[Int(String(last!))!]); break loop
                default: threeDigit.append(twenties[Int(String(i))!])
                }
            case 2:
                if i != "0" {
                    threeDigit.append(ones[Int(String(i))!])
                }
            default: do{}
            }
            
            
            o += 1
        }
        
        return threeDigit
    }
    
    
    
    
    func splitIntroGroupsOf(_ n: Int) -> [String] {
        var addZeroes = self
        
        if self.count % n != 0 {
            addZeroes = String(repeating: "0", count: n - (self.count % n)) + addZeroes
        }
        
        var groupsOfN = [""]
        var o = 0
        for i in addZeroes {
            if o == n {
                groupsOfN.append("")
                o = 0
            }
            
            groupsOfN[groupsOfN.count - 1].append(i)
            
            o += 1
        }
        
        return groupsOfN
    }
}

print(Zillion(0).name())

print(Zillion(101).name())

print(Zillion(1234).name())

print(Zillion("3287237324783278923892389").name())

print(Zillion("100000000").name())
print(Zillion("-100000000").name())


// 4 = four
// 24 = twenty four
//       6  *   4 = 24


var solution: [Int] = []

for i in 1...1000000 {
    
    var i = i
    var saved = [i]
    
    while true {
        let productOfWordLengths = Zillion(i).name().split(separator: " ").reduce(1) { $0 * $1.count }
        
        if saved.contains(productOfWordLengths) {
            
            if !solution.contains(productOfWordLengths) {
                if saved.last == productOfWordLengths {
                    print("New Solution:", saved + [productOfWordLengths])
                }
                solution.append(productOfWordLengths)
            }
            break
        } else {
            saved.append(productOfWordLengths)
            i = productOfWordLengths
        }
    }
}


