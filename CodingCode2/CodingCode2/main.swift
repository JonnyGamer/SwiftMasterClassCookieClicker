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






















//class Value {
//    var constant: Bool
//    var name: String
//    var type: String
//    var value: Any
//    init(constant: Bool, name: String, type: String, value: Any) {
//        self.constant = constant; self.name = name; self.type = type; self.value = value
//    }
//}
//
//
////// NOTES
//enum Hello {
//    indirect case literal(value: String, dot: Hello?)
//    indirect case callValue(name: String, dot: Hello?)
//    indirect case runFunction(name: String, param: [Hello], dot: Hello?)
//
//    indirect case value(constant: Bool, name: String, type: String, value: Hello)
//
//    //case function(name: String, type: String, value: String)
//    //case staticValue(constant: Bool, name: String, type: String, value: String)
//    //case staticFunction(constant: Bool, name: String, type: String, value: String)
//    //indirect case structure(name: String, contains: [Hello])
//    //indirect case extensions(extending: String, contains: [Hello])
//
//    func resolveDot(in: SuperStack, onValue: Value) -> Any {
//        switch self {
//        case let .callValue(name: nam, dot: dot):
//
//            let foo = States.things[onValue.type]!.notStatic[nam]!([onValue.value])
//
//            if let d = dot {
//                return d.resolveDot(in: `in`, onValue: foo)
//            } else {
//                return foo.value
//            }
//
//        default: fatalError()
//        }
//    }
//
//    func callSomething(in: SuperStack, expectedType: String) -> Any {
//
//        switch self {
//        case let .literal(value: val, dot: dot):
//
//            if let d = dot {
//                // Determine the literal (slower)
//
//                if let lit = val.determineLiteral() {
//                    // Resolve the dot. i.e. 5.add(1)
//                    return d.resolveDot(in: `in`, onValue: lit)
//
//                } else {
//                    // Couldn't determine the literal
//                    fatalError()
//                }
//
//            } else {
//                // Determine the literal based upon an expected type (faster)
//                return val.determineLiteralBasedOnType(this: expectedType).value
//            }
//
//        case let .callValue(name: nam, dot: dot):
//            if let foundValue = `in`.findValue(nam) {
//
//                if let d = dot {
//                    return d.resolveDot(in: `in`, onValue: foundValue)
//                } else {
//                    return foundValue.value
//                }
//
//            } else {
//                fatalError("couldn't find the value")
//            }
//
//        case let .runFunction(name: nam, param: param, dot: dot):
//            return States.publicFuncs[nam]!(param.map { $0.callSomething(in: `in`, expectedType: "Any") })
//
//        default: fatalError()
//        }
//
//        return 0
//    }
//
//    func resolve(in: SuperStack) {
//        switch self {
//        case let .value(constant: con, name: nam, type: typ, value: val):
//
//            // Found a value with the same name in the same scope
//            if let foo = `in`.values[nam] {
//                if foo.constant { fatalError() } // Trying to mutating a `let`
//                if foo.type != typ { fatalError() } // Trying to mutate the type of a value
//                // Mutate the value in the scope
//                foo.value = val.resolve(in: `in`)
//
//            // Found a value with the same name in a higher scope
//            } else if let foo = `in`.findValue(nam) {
//
//                if !foo.constant, foo.type == typ {
//                    // Mutate the value that was in a higher scope
//                    foo.value = val.resolve(in: `in`)
//                } else {
//                    // Create a new value with the same name in lowest scope
//                    `in`.values[nam] = Value.init(constant: con, name: nam, type: typ, value: val.callSomething(in: `in`, expectedType: typ))
//                }
//
//            // Couldn't find a value name
//            } else {
//                // Create a new value
//                `in`.values[nam] = Value.init(constant: con, name: nam, type: typ, value: val.callSomething(in: `in`, expectedType: typ))
//            }
//
//        case .callValue, .literal, .runFunction:
//            self.callSomething(in: `in`, expectedType: "Any")
//
//        default: fatalError()
//        }
//    }
//}
//extension Array where Element == Hello {
//    func run(in: SuperStack) {
//        for i in self {
//            i.resolve(in: `in`)
//        }
//    }
//}
//
//extension String {
//    func determineLiteral() -> Value? {
//        // Figure out what literal it could be (many choices...)
//        // Determine literal like Int,
//        fatalError()
//    }
//    func determineLiteralBasedOnType(this: String) -> Value {
//        if this == "Int" {
//            return Value(constant: false, name: "", type: this, value: Int(self)!)
//        } else if this == "String" {
//            return Value(constant: false, name: "", type: this, value: self)
//        }
//        fatalError()
//        // Quicker literal finder based upon the type given
//        //return .init(constant: false, name: "", type: this, value: 0)
//    }
//}
//
//class States {
//    static var things: [String:(static: [String:String], notStatic: [String:([Any])->Value])] = [
//        "Int":(static: [:], notStatic: ["addByOne":{ return Value.init(constant: false, name: "", type: "Int", value: ($0[0] as! Int) + 1)  }])
//
//
//    ]
//
//    static var publicFuncs: [String:([Any])->Any] = [
//        "print":{ print($0) }
//    ]
//}
//
//class SuperStack {
//    var values: [String:Value] = [:]
//
//    var aboveStack: SuperStack?
//
//    init(higherStack: SuperStack? = nil) { aboveStack = higherStack }
//
//    func findValue(_ name: String) -> Value? {
//        return values[name] ?? aboveStack?.findValue(name)
//    }
//    func examineCode(_ name: String) {
//        // Check if it is a value name
//        // Check if it is a literal
//    }
//}
//
//// Run the program
//let topStack = SuperStack()
//let code: [Hello] = [
//    .value(constant: false, name: "hello", type: "Int", value: .literal(value: "0", dot: nil)),
//    .runFunction(name: "print", param: [.callValue(name: "hello", dot: .callValue(name: "addByOne", dot: .callValue(name: "addByOne", dot: nil)))], dot: nil)
//]
//code.run(in: topStack)
//
//print("Finished Program")
