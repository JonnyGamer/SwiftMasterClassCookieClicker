//
//  MagicTypes.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

enum MagicTypes: Hashable, Equatable {
    
    indirect case array(MagicTypes)//, dict(MagicTypes:MagicTypes)
    case int, float, str, bool, any, void
    
    indirect case tuple([MagicTypes])
    // indirect case function([MagicTypes], MagicTypes)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        
        // When the type is any, auto downcast
        case (.any, _): return true
        
        // Check indices of tuples to check for `any` downcasts. Because it is indirect.
        case let (.tuple(t1), .tuple(t2)): return t1 == t2
        case let (.array(t1), .array(t2)): return t1 == t2
            
        default: break
        }
        return "\(lhs)" == "\(rhs)"
    }
}
// Tests should all print true
//print("Start Tests")
//print(MagicTypes.any == .int)
//print(MagicTypes.tuple([.any, .int]) == .tuple([.int, .int]))
//print(MagicTypes.tuple([.int, .int]) != .tuple([.any, .int]))
//print("End Tests")
