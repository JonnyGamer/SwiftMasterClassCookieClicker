//
//  TheStack.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

typealias FunctionType = (parameters: MagicTypes, returnType: MagicTypes, code: ([Any]) -> [StackCode] )

class SuperStack {
    var functions: [String:[FunctionType]] = [:]
    
    var aboveStack: SuperStack?
    init(higherStack: SuperStack? = nil) { aboveStack = higherStack }
    
    func findFunction(name: String, paramType: MagicTypes) -> FunctionType? {
        return functions[name]?.first(where: { $0.parameters == paramType }) ?? aboveStack?.findFunction(name: name, paramType: paramType)
    }
    func subStack() -> SuperStack {
        return SuperStack(higherStack: self)
    }
}
