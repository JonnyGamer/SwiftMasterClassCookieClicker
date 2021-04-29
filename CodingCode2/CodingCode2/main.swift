//
//  main.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation



indirect enum StackCode {
    case run([StackCode])
    case program(() -> ())
    
    case goToFunction(name: String)
    case function(name: String, code: [StackCode])
}

extension Array where Element == StackCode {
    func run(_ stack: SuperStack = SuperStack()) {
        for line in self {
            switch line {
            case let .run(code):
                code.run(stack.subStack())
                
            case let .program(code):
                code()
                
            case let .goToFunction(name: nam):
                if let found = stack.findFunction(name: nam) {
                    found.run(stack.subStack())
                } else {
                    print("Couldn't find function: \(nam)")
                }
                
            case let .function(name: nam, code: code):
                stack.functions[nam] = code
                
            }
        }
    }
}

class SuperStack {
    var functions: [String:[StackCode]] = [:]
    
    var aboveStack: SuperStack?
    init(higherStack: SuperStack? = nil) { aboveStack = higherStack }
    
    func findFunction(name: String) -> [StackCode]? {
        return functions[name] ?? aboveStack?.findFunction(name: name)
    }
    func subStack() -> SuperStack {
        return SuperStack(higherStack: self)
    }
}


let shortProgram: [StackCode] = [
    .function(name: "foo", code: [
        .program({ print("Foo was ran! Start") }),
    ]),
    
    .program({ print("Starting Program...") }),
    .goToFunction(name: "foo"),
    
    .run([
        
        .function(name: "bar", code: [
            .program({ print("BAR was ran!") }),
            .goToFunction(name: "foo"),
        ]),
        .goToFunction(name: "bar"),
    
    ]),
    
    .goToFunction(name: "bar"),
    .program({ print("End of Program...") }),
    
]

shortProgram.run()
