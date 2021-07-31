//
//  quotable.swift
//  DonQuixote
//
//  Created by Jonathan Pappas on 7/24/21.
//

import Foundation
import NaturalLanguage

func SIMPLETOLKIEN(_ path: String) {
    //let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/user_archive.csv"
    let paragraph = path
    
    func sentenceStructureMatches(matches: [NLTag], sentence: String) -> Bool {
        return parseSentence(sentence).0 == matches
    }

    func parseSentence(_ thisSentence: String) -> ([NLTag], [String]) {
        let text = thisSentence
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        let options: NLTagger.Options = [.omitWhitespace, .omitPunctuation] // .omitPunctuation
        var wo: [NLTag] = []
        var wo2: [String] = []
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                wo.append(tag)
                wo2.append(String(text[tokenRange]))
                //print("\(text[tokenRange]): \(tag.rawValue)")
            }
            return true
        }
        return (wo, wo2)
    }

    //print(parseSentence("The ripe taste of cheese improves with age.").0)
    //print(parseSentence("The ripe taste of cheese improves with age.").1)
    //print(parseSentence("The magic nature of deer increases during experience.").1)

    let tokenizer = NLTokenizer(unit: .sentence)
    tokenizer.string = paragraph
    print("Reading.")

    // ["Pronoun", "Verb", "Noun", "Preposition", "Noun"]
    // ["Verb", "Pronoun", "Adverb", "Preposition", "Noun"]

    var remember: [String:[String]] = [:]
    var nsREMEMBER: [[String]:Int] = [:]
    
    tokenizer.enumerateTokens(in: paragraph.startIndex..<paragraph.endIndex) { tokenRange, _ in
        let (woo, sent) = parseSentence(String(paragraph[tokenRange]))
        let wooo = String(woo.map { $0.rawValue }.reduce("") { $0 + " - " + $1 }.dropFirst(3))
        
        var woots: [String] = []
        var boots: [NLTag] = []
        
        print(wooo)
        for (i, j) in zip(woo, sent) {
            if boots.last == .noun, i != .noun {
                var owo = woots.reduce("") { $0 + " " + $1 }; owo.removeFirst()
                if boots.first == .verb || boots.first == .adverb {
                    print("    ", owo)
                } else {
                    print(owo)
                }
                woots = []
            }
            woots.append(j)
            boots.append(i)
        }
        if !woots.isEmpty {
            var owo = woots.reduce("") { $0 + " " + $1 }; owo.removeFirst()
            print(owo)
        }
        print()
        
//        for i in 0..<max(0,woo.count-1) {
//            let wooI = woo[i].rawValue; let wooI1 = woo[i+1].rawValue
//            if nsREMEMBER[[wooI, wooI1]] == nil {
//                nsREMEMBER[[wooI, wooI1]] = 1
//            } else {
//                nsREMEMBER[[wooI, wooI1]]! += 1
//            }
//        }
//        
//        print(wooo)
//        print(sent)
//        print()
        
        
        //print(wooo)
        
    //    if wooo == ["Verb", "Pronoun", "Adverb", "Preposition", "Noun"] {
    //        print(sent.reduce("", { $0 + " " + $1 }), ".")
    //    }
        if sent.contains("Precious") || sent.contains("precious") {
            print(sent.reduce("") { $0 + " " + $1 })
        }
        
        if woo.count > 2 { // wooo.count == 9,
            if remember[wooo] == nil {
                remember[wooo] = [sent.reduce("", { $0 + " " + $1 })]
            } else {
                remember[wooo]?.append(sent.reduce("", { $0 + " " + $1 }))
            }
            //print(wooo, sent)
        }
        
    //    if sentenceStructureMatches(
    //        matches: [.determiner, .adjective, .noun, .preposition, .noun, .verb, .preposition, .noun],
    //        sentence: String(paragraph[tokenRange])) {
    //        print(paragraph[tokenRange])
    //    }
        return true
    }
    
    for i in nsREMEMBER.sorted(by: { $0.value < $1.value }) {
        print(i.value, i.key[0], "-", i.key[1])
    }
    
    //extension Array

    for i in remember.sorted(by: { $0.key < $1.key }) {
        if i.value.count >= 2 { // Copies of 2 or more will be printed
            print(i.key)
            for j in i.value {
                print("   \(j)")
            }
        }
    }
    //print(remember)

//    print(sentenceStructureMatches(
//            matches: [.determiner, .adjective, .noun, .preposition, .noun, .verb, .preposition, .noun],
//            sentence: "The ripe taste of cheese improves with age."
//    ))

    //print(remember)
    fatalError()
}


func TOLKIENIZER() {
    let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/Hobbit.txt"
    let path2 = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/LOTR.txt"
    //let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/user_archive.csv"
    let paragraph = try! String(contentsOfFile: path, encoding: String.Encoding.utf8) + String(contentsOfFile: path2, encoding: String.Encoding.utf8)
    
    func sentenceStructureMatches(matches: [NLTag], sentence: String) -> Bool {
        return parseSentence(sentence).0 == matches
    }

    func parseSentence(_ thisSentence: String) -> ([NLTag], [String]) {
        let text = thisSentence
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
        var wo: [NLTag] = []
        var wo2: [String] = []
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag {
                wo.append(tag)
                wo2.append(String(text[tokenRange]))
                //print("\(text[tokenRange]): \(tag.rawValue)")
            }
            return true
        }
        return (wo, wo2)
    }

    //print(parseSentence("The ripe taste of cheese improves with age.").0)
    //print(parseSentence("The ripe taste of cheese improves with age.").1)
    //print(parseSentence("The magic nature of deer increases during experience.").1)

    let tokenizer = NLTokenizer(unit: .sentence)
    tokenizer.string = paragraph
    print("Reading.")

    // ["Pronoun", "Verb", "Noun", "Preposition", "Noun"]
    // ["Verb", "Pronoun", "Adverb", "Preposition", "Noun"]

    var remember: [String:[String]] = [:]

    tokenizer.enumerateTokens(in: paragraph.startIndex..<paragraph.endIndex) { tokenRange, _ in
        //print(".")
        let (woo, sent) = parseSentence(String(paragraph[tokenRange]))
        let wooo = String(woo.map { $0.rawValue }.reduce("") { $0 + " - " + $1 }.dropFirst(3))
        
    //    if wooo == ["Verb", "Pronoun", "Adverb", "Preposition", "Noun"] {
    //        print(sent.reduce("", { $0 + " " + $1 }), ".")
    //    }
        if sent.contains("Precious") || sent.contains("precious") {
            print(sent.reduce("") { $0 + " " + $1 })
        }
        
        if woo.count > 2 { // wooo.count == 9,
            if remember[wooo] == nil {
                remember[wooo] = [sent.reduce("", { $0 + " " + $1 })]
            } else {
                remember[wooo]?.append(sent.reduce("", { $0 + " " + $1 }))
            }
            //print(wooo, sent)
        }
        
    //    if sentenceStructureMatches(
    //        matches: [.determiner, .adjective, .noun, .preposition, .noun, .verb, .preposition, .noun],
    //        sentence: String(paragraph[tokenRange])) {
    //        print(paragraph[tokenRange])
    //    }
        return true
    }

    //extension Array

    for i in remember.sorted(by: { $0.key < $1.key }) {
        if i.value.count >= 2 { // Copies of 2 or more will be printed
            print(i.key)
            for j in i.value {
                print("   \(j)")
            }
        }
    }
    //print(remember)

    print(sentenceStructureMatches(
            matches: [.determiner, .adjective, .noun, .preposition, .noun, .verb, .preposition, .noun],
            sentence: "The ripe taste of cheese improves with age."
    ))

    print(remember)
    fatalError()
}

func HOPSCOTCH() {
    do {
        var totes = 0
        
        var fullList: [String:[(String, Int, String)]] = [:]
        
        let path = "/Users/jpappas/Code/PappasKit/SwiftMasterClassProjects/DonQuixote/DonQuixote/Hopscotch.txt"
        let paragraph = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
        for oooo in paragraph.split(separator: "\r\n") {
            var i = oooo; i.removeFirst(3)
            
            var woo = i.split(separator: " ")
            var a = true
            var name: [String] = []
            var creator: [String] = []
            var likes = 0
            
            for j in woo {
                if j == "by" {
                    a = false
                } else {
                    if a {
                        name.append(String(j))
                    } else {
                        creator.append(String(j))
                    }
                }
            }
            
            let likeCount = woo.dropFirst(woo.count - 2)
            likes = Int(likeCount.first ?? "") ?? 0
            
            creator.removeLast(2)
            var creatorName = creator.reduce("") { $0 + " " + $1 }; let woot = creatorName.removeFirst()
            var projectName = name.reduce("") { $0 + " " + $1 }; projectName.removeFirst()
            
            var wooot = projectName.split(separator: "]")
            var url = wooot.last ?? ""; url.removeFirst(); url.removeLast()
            wooot.removeLast()
            var projectNameReal = wooot.reduce(into: "") { $0 += $1 + "]" }; projectNameReal.removeLast()
            
            if fullList[creatorName] == nil {
                fullList[creatorName] = [(String(projectNameReal), likes, String(url))]
            } else {
                fullList[creatorName]?.append((String(projectNameReal), likes, String(url)))
            }
            //print((name, creator.dropLast(2), likes))
            
        }
        let sortie = fullList.sorted(by: { oo, mm in
            oo.value.reduce(into: 0) { $0 += $1.1 } > mm.value.reduce(into: 0) { $0 += $1.1 }
        })
        
        var foo = 1
        for (name, stat) in sortie {
            let wow = (stat.reduce(into: 0) { $0 += $1.1 })
            totes += wow
            print("\(foo).", name, "(\(wow) Likes)" )
            for (i, j, k) in stat {
                print(" - [\(i)](\(k)) - \(j)")
            }
            foo += 1
            print(totes)
        }
        
        fatalError() // 36391
    }
}
