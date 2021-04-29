//
//  StackCode.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

enum BuiltInFunctions: String {
    case print, add, sum, triangle, len, int, str, neg, sub
}

indirect enum StackCode {
    case run([StackCode])
    case program(() -> ())
    case returnValue(StackCode)
    
    case goToVoidFunction(name: String)
    case goToFunction(name: String, parameters: [StackCode]) // case goToFunction(name: String, parameters: [(MagicTypes, StackCode)])
    case function(name: String, code: [StackCode])
    case _run(BuiltInFunctions, [StackCode])
    
    case literal(MagicTypes, Any)
    case functionWithParams(name: String, parameters: MagicTypes, returnType: MagicTypes, code: ([Any]) -> [StackCode])
}

extension Array where Element == StackCode {
    
    @discardableResult
    func run(_ stack: SuperStack = SuperStack()) -> (MagicTypes, [Any])? {
        for line in self {
            
            switch line {
            case let .run(code):
                code.run(stack.subStack())
                
            case let .program(code):
                code()
                
            case let .goToVoidFunction(name: nam):
                if let found = stack.findFunction(name: nam, paramType: .void) {
                    found.code([]).run(stack.subStack())
                } else {
                    print("Couldn't find function: \(nam)")
                }
            
            case let .goToFunction(name: nam, parameters: param):
                
                let realStuff = param.map { [$0].run(stack.subStack())! } // param.run(stack.subStack())!
                
                let willItBeTuple = realStuff.map { $0.0 }
                var givenParamType = MagicTypes.tuple(realStuff.map { $0.0 })
                if willItBeTuple.count == 1 {
                    givenParamType = willItBeTuple[0]
                }
                let results = realStuff.map { $0.1[0] }
                
                if let found = stack.findFunction(name: nam, paramType: givenParamType) {
                    
                    if found.parameters != givenParamType {
                        print("Expected Parameters \(found.parameters). Instead, recieved: \(givenParamType)")
                        fatalError()
                        
                    } else {
                        //let params = param.map { i in [i.1].run(stack.subStack())[0].1 }
                        let params = results
                        
                        let result = found.code(params).run(stack.subStack())
                        //print("---,", result)
                        if let r = result {
                            if stack.aboveStack == nil { continue } // Can't return a result at the top stack. Just ignore
                            return r
                        }
                    }
                } else {
                    print("Couldn't find function: \(nam)")
                }
            case let ._run(b, c):
                if let easy = [StackCode.goToFunction(name: b.rawValue, parameters: c)].run(stack) {
                    return easy
                }
                
            case let .function(name: nam, code: code):
                if stack.functions[nam] == nil {
                    stack.functions[nam] = []
                }
                
                if stack.functions[nam]?.contains(where: { $0.parameters == .void }) == true {
                    fatalError("Oops, There is already a function with that name with matching parameters!")
                }
                
                stack.functions[nam]?.append((.tuple([]), .void, {_ in code}))
                
            case let .functionWithParams(name: nam, parameters: param, returnType: ret, code: code):
                
                if stack.functions[nam] == nil {
                    stack.functions[nam] = []
                }
                
                if stack.functions[nam]?.contains(where: { $0.parameters == param }) == true {
                    fatalError("Oops, There is already a function with that name with matching parameters!")
                }
                
                stack.functions[nam]?.append((param, ret, code))
                
            case let .returnValue(ret):
                return [ret].run(stack)
            case let .literal(typ, lit): return (typ, [lit])
                
            }
        }
        return nil
    }
}
