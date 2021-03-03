//
//  main.swift
//  DonQuixote
//
//  Created by Jonathan Pappas on 3/1/21.
//

import Foundation


//let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/HP.txt"
let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/996.txt"
//let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/996es.txt"
let paragraph = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)






var wordCount = 0
var wordFrequency = [String:Int]()




var biggestWord = ""
var saveWord = ""
//let brother = ["\n", " ", "•", ":", ")", "(", ".", ",", "", "-", " ", "/", "\"", "!", "?", "*", "\\", "_", "{", "}"]

func yes() {
    for i in paragraph.split(whereSeparator: { !($0.isLetter || $0 == "'") }) {
        var save = i.lowercased()// String(i)
        if save.hasPrefix("'") {
            save.removeFirst()
        } else if save.hasSuffix("'") {
            save.removeLast()
        }
        if save.isEmpty { continue }
        
        let newSave = String(save.split(separator: "'").first ?? "")
        
        wordFrequency[newSave] = (wordFrequency[newSave] ?? 0) + 1
        wordCount += 1
        
        if newSave.count > biggestWord.count {
            biggestWord = newSave
        }
    }
}

func otherwise(_ coupletLength: Int = 2) -> [String:Int] {
    var wordFrequency2 = [String:Int]()
    
    var previousWord: [String] = [String].init(repeating: "", count: coupletLength - 1)
    for i in paragraph.split(whereSeparator: { !($0.isLetter || $0 == "'") }) {
        var save = i.lowercased()// String(i)
        if save.hasPrefix("'") {
            save.removeFirst()
        } else if save.hasSuffix("'") {
            save.removeLast()
        }
        if save.isEmpty { continue }
        
        let newSave = String(save.split(separator: "'").first ?? "")
        
        if !previousWord.isEmpty {
            let thiso = previousWord.joined(separator: " ") + " " + newSave
            wordFrequency2[thiso] = (wordFrequency2[thiso] ?? 0) + 1
            wordCount += 1
        }
        
        previousWord.append(newSave)
        previousWord.removeFirst()
        //previousWord = newSave
        
        if newSave.count > biggestWord.count {
            biggestWord = newSave
        }
    }
    return wordFrequency2
}

//var couplet = 50
wordFrequency = otherwise(18)
wordFrequency = wordFrequency.filter { $0.value > 1 }//.keys.joined(separator: " ")
//wordFrequency = [:]

// broken
for i in [17, 16, 15, 14, 13, 12, 11, 10, 9, 8, 7] {
    print("Working on: \(i)")
    var newFreq = otherwise(i)
    let sho = newFreq.filter { $0.value > 1 }
    newFreq = [:]
    print(sho.count)
    for i in sho {
        //print(i.value)
        if i.value > 2 {
            var good = false
            for oof in wordFrequency.filter({ $0.key.contains(i.key) }) {
//                if i.value < oof.value {
//                    continue this
//                }
                if i.value > oof.value {
                    wordFrequency[oof.key] = i.value
                    print(i.value, oof.value, oof.key)
                    good = true
                }
            }
            if !good { continue }
            
//            if let oof = wordFrequency.first(where: { $0.key.contains(i.key) }) {
//                if i.value <= oof.value {
//                    continue
//                }
//                wordFrequency[oof.key] = i.value
//            }
//            
            //if !fatKeys.contains(i.key) || i.value > 2 {
                //if i.key.hasPrefix("chapter") { continue }
            //fatKeys += " " + i.key
            //wordFrequency[i.key] = i.value
            print("•", i.key, "-", i.value)
            //}
        }
    }
}



fatalError()

//yes()


wordFrequency[""] = nil
wordFrequency["'"] = nil

//for i in wordFrequency.sorted(by: <) {
//    print(i.key, "-", i.value) // i.key, "-", i.value
//}

var usedWords = 0
var a = wordFrequency.sorted(by: <)
a = a.sorted { ($0.value > $1.value) }
for i in a {
    //if i.value > 100 {
    usedWords += 1
    if i.value > 1 { // use only for couplets
        print(i.value, "-", i.key)
    }
    //print(String(i.value) + ": " + String(i.key))
    //}
    if i.value < 3 {
        usedWords += 1
    }
}

print("")
print("Don Quixote de la Mancha!")
print("Word Count: " + String(wordCount))
print("Different Words: " + String(wordFrequency.count))
print("Character Count: \(paragraph.count)")
print("Biggest Word: \(biggestWord)")
print("Words used less than 3 times: \(usedWords) which is \(Double(wordFrequency.keys.count)) / \(Double(usedWords)))")

var totalChars = 0
for i in wordFrequency {
    totalChars += i.value
}
