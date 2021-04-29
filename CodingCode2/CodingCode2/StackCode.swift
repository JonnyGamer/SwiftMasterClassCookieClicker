//
//  StackCode.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

indirect enum StackCode {
    case run([StackCode])
    case program(() -> ())
    case returnValue([(MagicTypes, Any)])
    
    case goToVoidFunction(name: String)
    case goToFunction(name: String, parameters: [StackCode]) // case goToFunction(name: String, parameters: [(MagicTypes, StackCode)])
    case function(name: String, code: [StackCode])
    
    case literal(MagicTypes, Any)
    case functionWithParams(name: String, parameters: MagicTypes, returnType: MagicTypes, code: ([Any]) -> [StackCode])
}

extension Array where Element == StackCode {
    
    @discardableResult
    func run(_ stack: SuperStack = SuperStack()) -> [(MagicTypes, Any)] {
        for line in self {
            switch line {
            case let .run(code):
                code.run(stack.subStack())
                
            case let .program(code):
                code()
                
            case let .goToVoidFunction(name: nam):
                if let found = stack.findFunction(name: nam) {
                    found.code([]).run(stack.subStack())
                } else {
                    print("Couldn't find function: \(nam)")
                }
            
            case let .goToFunction(name: nam, parameters: param):
                if let found = stack.findFunction(name: nam) {
                    
                    let realStuff = param.map { [$0].run(stack.subStack())[0] }
                    let givenParamType = MagicTypes.tuple(realStuff.map { $0.0 })
                    
                    if found.parameters != givenParamType {
                        print("Expected Parameters \(found.parameters). Instead, recieved: \(givenParamType)")
                    } else {
                        //let params = param.map { i in [i.1].run(stack.subStack())[0].1 }
                        let params = realStuff.map { $0.1 }
                        
                        let result = found.code(params).run(stack.subStack())
                        //print("---,", result)
                        if !result.isEmpty {
                            if stack.aboveStack == nil { continue } // Can't return a result at the top stack. Just ignore
                            return result
                        }
                    }
                } else {
                    print("Couldn't find function: \(nam)")
                }
                
                
            case let .function(name: nam, code: code):
                stack.functions[nam] = (.tuple([]), .void, {_ in code})
                
            case let .functionWithParams(name: nam, parameters: param, returnType: ret, code: code):
                stack.functions[nam] = (param, ret, code)
                
            case let .returnValue(ret):
                return ret
            case let .literal(typ, lit): return [(typ, lit)]
                
            }
        }
        return []
    }
}
