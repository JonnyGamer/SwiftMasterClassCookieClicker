//
//  HelloArray.swift
//  EverSleek
//
//  Created by Jonathan Pappas on 1/9/21.
//

import Foundation

struct Regex {
    var this: String
    init(_ this: String) { self.this = this }
    func matches(_ the: String) -> Bool {
        return the.replacingAll(matching: this, with: "") != the
    }
}
extension String {
    func replacingAll(matching: Regex, with: String) -> Self {
        return replacingOccurrences(of: matching.this, with: with, options: .regularExpression)
    }
    func replacingAll(matching: String, with: String) -> Self {
        return replacingOccurrences(of: matching, with: with, options: .regularExpression)
    }
}



extension Array: LosslessStringConvertible where Element: LosslessStringConvertible {
    public init?(_ description: String) {
        let regex1 = Regex.init(#"^ *\[(.*)\] *$"#)
        //if !regex1.matches(description) { return nil }
        let newValue = description.replacingAll(matching: regex1, with: "$1")
        
        if newValue.contains("[") {
            var elementals = [""]
            var count = 0
            for i in newValue {
                if i == "[" { count += 1 }
                if count == 0, i == " " {
                    elementals.append("")
                } else if count != 0 {
                    elementals[elementals.count - 1].append(String(i))
                }
                if i == "]" { count -= 1 }
            }
            //print(elementals)
            self = elementals.map { Element($0)! }
            return
        } else {
            let arr = newValue.split(separator: ",").compactMap {Element($0.trimmingCharacters(in: .whitespacesAndNewlines))}
            if Element.self == String.self {
                self = (arr as! [String]).map {
                    String($0[$0.index(after: $0.startIndex)..<$0.index(before: $0.endIndex)])
                    } as! [Element]
            } else {
                self = arr
            }
        }
    }
}

// Array Raw Value
extension Array: ExpressibleByUnicodeScalarLiteral where Element: LosslessStringConvertible {
    public typealias UnicodeScalarLiteralType = String
}
extension Array: ExpressibleByExtendedGraphemeClusterLiteral where Element: LosslessStringConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = String
}
extension Array: ExpressibleByStringLiteral where Element: LosslessStringConvertible {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self = Array(value)!
    }
}


// Set Raw Value
extension Set: ExpressibleByUnicodeScalarLiteral where Element: LosslessStringConvertible {
    public typealias UnicodeScalarLiteralType = String
}
extension Set: ExpressibleByExtendedGraphemeClusterLiteral where Element: LosslessStringConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = String
}
extension Set: ExpressibleByStringLiteral where Element: LosslessStringConvertible {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self = Set(Array(value)!)
    }
}




// Recursive Dictionary Raw Value
extension Dictionary: LosslessStringConvertible where Key: LosslessStringConvertible, Value: LosslessStringConvertible {
    public init?(_ description: String) {
        let regex1 = Regex.init(#"^ *\[(.*)\] *$"#)
        //if !regex1.matches(description) { return nil }
        let newValue = description.replacingAll(matching: regex1, with: "$1")
        
        if newValue.contains("[") {
            var keys = [""]
            var values = [""]
            var count = 0
            var keysTurn = true
            for i in newValue {
                if i == "[" { count += 1 }
                if count == 0, i == ":" { keysTurn.toggle(); values.append(""); continue }
                if count == 0, i == " " { continue }
                if count == 0, i == "," { keysTurn.toggle(); keys.append(""); continue }
                if keysTurn {
                    keys[keys.count - 1].append(String(i))
                } else {
                    values[values.count - 1].append(String(i))
                }
                if i == "]" { count -= 1 }
            }
            let allKeys = keys.map { Key($0)! }
            if values.count > 1 {
                values = values.filter { $0 != "" }
                //values = values.dropFirst().map { String($0) }
            }
            let allVals = values.map { Value($0)! }
            
            var newDict: [Key:Value] = [:]
            for i in 0..<allKeys.count {
                if let _ = newDict[allKeys[i]] { fatalError("Dict has duplicate Keys") }
                newDict[allKeys[i]] = allVals[i]
            }
            self = newDict
        } else {
            let arr = newValue.split(separator: ",").map { String($0) }
            if arr == [":"] { self = [Key:Value](); return }
            
            var dict: [Key:Value] = [:]
            for i in arr {
                let keyValue = i.split(separator: ":").map { String($0.trimmingCharacters(in: .whitespacesAndNewlines)) }
                let thisKey = Key(keyValue[0])!
                let thisVal = Value(keyValue[1])!
                if let _ = dict[thisKey] { fatalError("Dictionary has multiple of the same KEYS") }
                dict[thisKey] = thisVal
            }
            self = dict
        }
    }
}

// Dictionary Raw Value
extension Dictionary: ExpressibleByUnicodeScalarLiteral where Key: LosslessStringConvertible, Value: LosslessStringConvertible {
    public typealias UnicodeScalarLiteralType = String
}
extension Dictionary: ExpressibleByExtendedGraphemeClusterLiteral where Key: LosslessStringConvertible, Value: LosslessStringConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = String
}
extension Dictionary: ExpressibleByStringLiteral where Key: LosslessStringConvertible, Value: LosslessStringConvertible {
    public typealias StringLiteralType = String
    public init(stringLiteral value: String) {
        self = Dictionary(value)!
    }
}
