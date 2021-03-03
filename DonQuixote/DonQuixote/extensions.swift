//
//  extensions.swift
//  DonQuixote
//
//  Created by Jonathan Pappas on 3/1/21.
//

import Foundation

extension String {

    /// Check if a word contains any of the following Strings
    func contains(_ what: [String]) -> Bool {
        for i in what { if self.contains(i.lowercased()) { return true } }
        return false
    }

    /// Check if a word contains a String
    func contains(_ what: String) -> Bool {
        if self.contains(what.lowercased().first!) {
            var arr: [Character] = []
            for i in what.lowercased() {
                arr.append(i)
            }
            var count = 0
            for i in self {
                if i == arr[count] {
                    count += 1
                } else {
                    count = 0
                }
                if count == arr.count { return true }
            }
        }
        return false
    }
}

