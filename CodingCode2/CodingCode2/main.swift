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
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        // When the type is any, auto downcast
        case (.any, _):
            return true
        // Check indices of tuples to check for `any` downcasts. Because it is indirect.
        case let (.tuple(t1), .tuple(t2)):
            return t1 == t2
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

indirect enum StackCode {
    case run([StackCode])
    case program(() -> ())
    case returnValue([(MagicTypes, Any)])
    
    case goToVoidFunction(name: String)
    case goToFunction(name: String, parameters: [(MagicTypes, StackCode)])
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
                    
                    let givenParamType = MagicTypes.tuple(param.map { $0.0 })
                    if found.parameters != givenParamType {
                        print("Expected Parameters \(found.parameters). Instead, recieved: \(givenParamType)")
                    } else {
                        let params = param.map { i in [i.1].run(stack.subStack())[0].1 }
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

typealias FunctionType = (parameters: MagicTypes, returnType: MagicTypes, code: ([Any]) -> [StackCode] )

class SuperStack {
    var functions: [String:FunctionType] = [:]
    
    var aboveStack: SuperStack?
    init(higherStack: SuperStack? = nil) { aboveStack = higherStack }
    
    func findFunction(name: String) -> FunctionType? {
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

// Extremely Magical Printing
func magicPrint(_ this: [Any], testing: Bool = true) {
    if testing { print(" - TEST PRINT -", terminator: " ") }
    this.forEach { print($0, separator: "", terminator: " ") }
    print("\n", terminator: "")
}
magicPrint([1, 2, 3])
magicPrint([1, 2, 3, 4])
magicPrint([1, 2, 3, 4, 5])


let shortProgram: [StackCode] = [
    
    .functionWithParams(name: "add", parameters: .tuple([.int, .int]), returnType: .int, code: { param in [
        .program({ print("It was too harsh \(int(param[0]) + int(param[1]))") }),
        .returnValue([ (.int, (int(param[0]) + int(param[1]))) ])
    ]}),
    
    .functionWithParams(name: "print", parameters: .any, returnType: .void, code: { param in
        [
            .program({ magicPrint(param) }),
            .returnValue([(.void, ())]),
            .program({ magicPrint(param) }),
            .program({ magicPrint(param) }),
        ]
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
    
    .goToFunction(name: "print", parameters: [(.int, .literal(.int, 5)), (.int, .literal(.int, 6))]),
    
    // print(add(5, 6))
    .goToFunction(name: "print", parameters: [(.int, .goToFunction(name: "add", parameters: [(.int, .literal(.int, 5)), (.int, .literal(.int, 6))]))]),
    
    
]

shortProgram.run()
