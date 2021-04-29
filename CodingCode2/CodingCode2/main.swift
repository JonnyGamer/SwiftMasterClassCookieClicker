//
//  main.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation


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
