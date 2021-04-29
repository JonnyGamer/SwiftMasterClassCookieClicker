//
//  main.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

let mindShield = """
var foo: int = 1
foo = add(foo, 1)

"""

let masterStack = SuperStack()

let preProgram: [StackCode] = [
    
    // Int Function
    .functionWithParams(name: "int", parameters: .any, returnType: .int, code: { param in [
        .literal(.int, Int("\(param[0])") ?? 0),
    ]}),
    // Str Function
    .functionWithParams(name: "str", parameters: .any, returnType: .str, code: { param in [
        .literal(.str, "\(param[0])"),
    ]}),
    
    // Add Function
    .functionWithParams(name: "add", parameters: .tuple([.int, .int]), returnType: .int, code: { param in [
        .literal(.int, (int(param[0]) + int(param[1]))),
    ]}),
    
    // Sum Function
    .functionWithParams(name: "sum", parameters: .array(.int), returnType: .int, code: { param in [
        .literal(.int, (param[0] as! [Int]).reduce(0, { $0 + int($1) }) ),
    ]}),
    
    // Len Function
    .functionWithParams(name: "len", parameters: .array(.int), returnType: .int, code: { param in [
        .literal(.int, (param[0] as! [Int]).count ),
    ]}),
    // Len Function
    .functionWithParams(name: "len", parameters: .str, returnType: .int, code: { param in [
        .literal(.int, (param[0] as! String).count ),
    ]}),
    
    
    // Triangle Number Function
    .functionWithParams(name: "triangle", parameters: .int, returnType: .array(.int), code: { param in [
        .literal(.array(.int), Array(1...int(param[0])))
    ]}),
    
    // Print Function
    .functionWithParams(name: "print", parameters: .any, returnType: .void, code: { param in [
        .program({ magicPrint(param) }),
    ]}),
    
]
preProgram.run(masterStack)




let shortProgram: [StackCode] = [

    
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
    .goToFunction(name: "print", parameters: [.literal(.str, "End of Program...")]),
    
    .goToFunction(name: "print", parameters: [.literal(.int, 5), .literal(.int, 6)]),
    
    // print(add(5, 6))
    .goToFunction(name: "print", parameters: [.goToFunction(name: "add", parameters: [.literal(.int, 5), .literal(.int, 6)])]),
    
    .goToFunction(name: "print", parameters: [.literal(.int, 5)]),
    
    ._run(.print, [._run(.add, [.literal(.int, 5), .literal(.int, 5)])]),
    // print((5 + 5) + (5 + 5))
    ._run(.print, [._run(.add, [._run(.add, [.literal(.int, 5), .literal(.int, 5)]), ._run(.add, [.literal(.int, 5), .literal(.int, 5)])])]),
    
    ._run(.print, [._run(.sum, [.literal(.array(.int), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])])]),
    ._run(.print, [._run(.triangle, [.literal(.int, 100)])]),
    
    // print(len(triangle(100)))
    ._run(.print, [._run(.len, [._run(.triangle, [.literal(.int, 100)])])]),
    ._run(.print, [._run(.len, [.literal(.str, "12345")])]),
    
]

shortProgram.run(masterStack)
