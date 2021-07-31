//
//  main.swift
//  DonQuixote
//
//  Created by Jonathan Pappas on 3/1/21.
//

import Foundation
import AppKit
import NaturalLanguage

//let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/HP.txt"
// let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/996es.txt"
//let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/996es.txt"
let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/Hobbit.txt"
let path2 = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/LOTR.txt"
//let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/user_archive.csv"
let paragraph2 = try! String(contentsOfFile: path, encoding: String.Encoding.utf8) + String(contentsOfFile: path2, encoding: String.Encoding.utf8)

let paragraph = """
    In a hole in the ground there lived a hobbit. Not a nasty, dirty, wet hole, filled with the ends of worms and an oozy smell, nor yet a dry, bare, sandy hole with nothing in it to sit down on or to eat: it was a hobbit-hole, and that means comfort.

    It had a perfectly round door like a porthole, painted green, with a shiny yellow brass knob in the exact middle. The door opened on to a tube-shaped hall like a tunnel: a very comfortable tunnel without smoke, with panelled walls, and floors tiled and carpeted, provided with polished chairs, and lots and lots of pegs for hats and coats—the hobbit was fond of visitors. The tunnel wound on and on, going fairly but not quite straight into the side of the hill—The Hill, as all the people for many miles round called it—and many little round doors opened out of it, first on one side and then on another. No going upstairs for the hobbit: bedrooms, bathrooms, cellars, pantries (lots of these), wardrobes (he had whole rooms devoted to clothes), kitchens, dining-rooms, all were on the same floor, and indeed on the same passage. The best rooms were all on the left-hand side (going in), for these were the only ones to have windows, deep-set round windows looking over his garden, and meadows beyond, sloping down to the river.
"""

print("Yay beginning")
SIMPLETOLKIEN(paragraph)











//let paragraph = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
//var seto: Set<String> = []
//for i in paragraph.split(separator: "\n") {
//    for j in i.split(separator: ",") {
//        let o = String(j)
//        if o.contains("https") { continue }
//        if o.contains("2015-") { continue }
//        if o.contains("2016-") { continue }
//        if o.contains("2017-") { continue }
//        if o.contains("2018-") { continue }
//        if o.contains("2019-") { continue }
//        if o.contains("2020-") { continue }
//        if o.contains("2021-") { continue }
//        if o.contains("-1"), !seto.contains(o) {
//            seto.insert(o)
//            print(o)
//        }
//    }
//}
//print(seto.count)
//fatalError()

//for i in paragraph.split(whereSeparator: { $0 == "\n" || $0 == "." }) {
//    for jj in i.split(separator: "\"") {
//        var j = jj
//        while j.hasPrefix(" ") { j.removeFirst() }
//        print(j)
//    }
//}
//fatalError()


let www = NSSpellChecker.init()
extension String {
    func isWord() -> Bool {
        return www.checkSpelling(of: self, startingAt: 0).location != 0
    }

}

var wc = 0
var tried: Set<String> = []
var seto: [String:Int] = [:]
for i in paragraph.split(separator: "\n") {
    for k in i.split(whereSeparator: { $0 == " " || $0 == "—" }) {
        var a = ""
        var prevLetter = Character(".")
        for j in k.lowercased() {
            if j.isLetter || j.isNumber || (j == "-" && !a.isEmpty) || (j == "'" && (prevLetter.isLetter || prevLetter.isNumber)) {
                a.append(j)
            }
            prevLetter = j
        }
        while a.hasSuffix("'") || a.hasSuffix("-") { a.removeLast() }
        if a.isEmpty { continue }
        
        if a.contains("-") {
            wc += 1
            seto[a] = (seto[a] ?? 0) + 1
        }
        
//        if !tried.contains(a) {
//            tried.insert(a)
//            if !a.isWord() {
//                wc += 1
//                seto[a] = (seto[a] ?? 0) + 1
//            }
//        } else {
//            if seto[a] != nil {
//                wc += 1
//                seto[a] = (seto[a] ?? 0) + 1
//            }
//        }
    }
}

for i in seto.sorted(by: { $0.value < $1.value }) {
    //if i.key.contains(where: { !$0.isASCII }) {
    print(i.key, i.value)
    //}
}
print(wc)
print(seto.count)


fatalError()





var wordCount = 0
var wordFrequency = [String:Int]()




var biggestWord = ""
var saveWord = ""
//let brother = ["\n"", "" "", ""•"", "":"", "")"", ""("", ""."", "","", """", ""-"", "" "", ""/"", ""\""", ""!"", ""?"", ""*"", ""\\"", ""_"", ""{"", ""}"]

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

yes()

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

//print(otherwise(3).filter({ $0.value > 1 }).sorted(by: { $0.value < $1.value }).map { "\($0.key) \($0.value)" })

////var couplet = 50
//wordFrequency = otherwise(18)
//wordFrequency = wordFrequency.filter { $0.value > 1 }//.keys.joined(separator: " ")
////wordFrequency = [:]
//
//// broken
//for i in [17", "16", "15", "14", "13", "12", "11", "10", "9", "8", "7] {
//    print("Working on: \(i)")
//    var newFreq = otherwise(i)
//    let sho = newFreq.filter { $0.value > 1 }
//    newFreq = [:]
//    print(sho.count)
//    for i in sho {
//        //print(i.value)
//        if i.value > 2 {
//            var good = false
//            for oof in wordFrequency.filter({ $0.key.contains(i.key) }) {
////                if i.value < oof.value {
////                    continue this
////                }
//                if i.value > oof.value {
//                    wordFrequency[oof.key] = i.value
//                    print(i.value", "oof.value", "oof.key)
//                    good = true
//                }
//            }
//            if !good { continue }
//
////            if let oof = wordFrequency.first(where: { $0.key.contains(i.key) }) {
////                if i.value <= oof.value {
////                    continue
////                }
////                wordFrequency[oof.key] = i.value
////            }
////
//            //if !fatKeys.contains(i.key) || i.value > 2 {
//                //if i.key.hasPrefix("chapter") { continue }
//            //fatKeys += " " + i.key
//            //wordFrequency[i.key] = i.value
//            print("•"", "i.key", ""-"", "i.value)
//            //}
//        }
//    }
//}



//fatalError()

//yes()


wordFrequency[""] = nil
wordFrequency["'"] = nil

//for i in wordFrequency.sorted(by: <) {
//    print(i.key", ""-"", "i.value) // i.key", ""-"", "i.value
//}


let commonWords = ["the", "be", "to", "of", "and", "a", "in", "that", "have", "i", "it", "for", "not", "on", "with", "he", "as", "you", "do", "at", "this", "but", "his", "by", "from", "they", "we", "say", "her", "she", "or", "an", "will my", "one all", "would", "there", "their", "what", "so", "up", "out", "if", "about", "who", "get", "which", "go", "me", "when", "make", "can", "like", "time", "no", "just", "him", "know", "take", "people", "into", "year", "your", "good", "some", "could", "them", "see", "other", "than", "then", "now", "look", "only", "come", "its", "over", "think", "also", "back", "after", "use", "two", "how", "our", "work", "first", "well", "way", "even", "new", "want", "because", "any", "these", "give", "day", "most", "us"]


var usedWords = 0
var a = wordFrequency.sorted(by: <)
//a = a.sorted { $0.value > $1.value }
a = a.sorted { $0.key.count > $1.key.count }.filter { $0.value >= 10 }
//a = a.sorted { $0.value > $1.value }.sorted { ($0.key.count > $1.key.count) }.filter { $0.value > 1 }
for i in a {
    //if i.value > 100 {
    usedWords += 1
    if i.value > 0 { // use only for couplets
        
        //if !commonWords.contains(i.key) {
            print(i.value, "-", i.key)
        //}
    }
    //print(String(i.value) + ": " + String(i.key))
    //}
    if i.value < 2 {
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




