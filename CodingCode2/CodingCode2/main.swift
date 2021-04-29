//
//  main.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

enum MagicTypes: Hashable, Equatable {
    
    //indirect case array(MagicTypes), dict(MagicTypes:MagicTypes)
    case int, float, str, bool, any, void
    
    indirect case tuple([MagicTypes])
    // indirect case function([MagicTypes], MagicTypes)
}


indirect enum StackCode {
    case run([StackCode])
    case program(() -> ())
    
    case goToVoidFunction(name: String)
    case goToFunction(name: String, parameters: [(MagicTypes, Any)])
    case function(name: String, code: [StackCode])
    
    case functionWithParams(name: String, parameters: MagicTypes, code: ([Any]) -> [StackCode])
}

extension Array where Element == StackCode {
    func run(_ stack: SuperStack = SuperStack()) {
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
                    
                    let givenParamType = MagicTypes.tuple(param.map { $0.0 })
                    if givenParamType != found.parameters {
                        print("Expected Parameters \(found.parameters). Instead, recieved: \(givenParamType)")
                    } else {
                        let params = param.map { $0.1 }
                        found.code(params).run(stack.subStack())
                    }
                } else {
                    print("Couldn't find function: \(nam)")
                }
                
                
            case let .function(name: nam, code: code):
                stack.functions[nam] = (.tuple([]), {_ in code})
                
            case let .functionWithParams(name: nam, parameters: param, code: code):
                stack.functions[nam] = (param, code)
                
            }
        }
    }
}

class SuperStack {
    var functions: [String:(parameters: MagicTypes, code: ([Any]) -> [StackCode])] = [:]
    
    var aboveStack: SuperStack?
    init(higherStack: SuperStack? = nil) { aboveStack = higherStack }
    
    func findFunction(name: String) -> (parameters: MagicTypes, code: ([Any]) -> [StackCode])? {
        return functions[name] ?? aboveStack?.findFunction(name: name)
    }
    func subStack() -> SuperStack {
        return SuperStack(higherStack: self)
    }
}

//extension String { var int: Int { return Int(self)! } }
func int(_ n: Any) -> Int {
    return Int("\(n)")!
}


let shortProgram: [StackCode] = [
    .functionWithParams(name: "magicPrint", parameters: .tuple([.int, .int]), code: { param in
        [.program({ print("It was too harsh \(int(param[0]) + int(param[1]))") })]
    }),
    
    
    .function(name: "foo", code: [
        .program({ print("Foo was ran! Start") }),
    ]),
    
    .program({ print("Starting Program...") }),
    .goToVoidFunction(name: "foo"),
    
    .run([
        
        .function(name: "bar", code: [
            .program({ print("BAR was ran!") }),
            .goToVoidFunction(name: "foo"),
        ]),
        .goToVoidFunction(name: "bar"),
    
    ]),
    
    .goToVoidFunction(name: "bar"),
    .program({ print("End of Program...") }),
    
    .goToFunction(name: "magicPrint", parameters: [(.int, 5), (.int, 6)])
    
]

shortProgram.run()
