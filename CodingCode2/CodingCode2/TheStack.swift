//
//  TheStack.swift
//  CodingCode2
//
//  Created by Jonathan Pappas on 4/29/21.
//

import Foundation

typealias FunctionType = (parameters: MagicTypes, returnType: MagicTypes, code: ([Any]) -> [StackCode] )
typealias ValueType = (typeOf: MagicTypes, constant: Bool, value: Any)

class SuperStack {
    var functions: [String:[FunctionType]] = [:]
    var values: [String:ValueType] = [:]
    
    var aboveStack: SuperStack?
    init(higherStack: SuperStack? = nil) { aboveStack = higherStack }
    
    func subStack() -> SuperStack {
        return SuperStack(higherStack: self)
    }
    
    // Find a given function
    func findFunction(name: String, paramType: MagicTypes) -> FunctionType? {
        return functions[name]?.first(where: { $0.parameters == paramType }) ?? aboveStack?.findFunction(name: name, paramType: paramType)
    }
    
    func getValue(name: String) -> ValueType? {
        return values[name] ?? aboveStack?.getValue(name: name)
    }
    func editValue(name: String, setTo: Any) {
        if values[name] != nil {
            values[name]?.value = setTo
        } else {
            aboveStack?.editValue(name: name, setTo: setTo)
        }
    }
    
    
}
