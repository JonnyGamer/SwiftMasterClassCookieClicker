//
//  main.swift
//  SomeIdeas
//
//  Created by Jonathan Pappas on 5/5/21.
//

import Foundation

// COPY did not work
//print("Hello, World!")
//
//func copy<T>(_ some: T) -> T {
//    return (some as AnyObject).copy() as! T
//}
//
//let foo = Wow()
//let bar = foo
//
//print(foo === bar)
//
//let abc = copy(foo)
//print(abc === foo)


protocol Trackable {
    static var leftovers: Int { get set }
}
extension Trackable {
    func create() { Self.leftovers += 1 }
    func destroy() { Self.leftovers -= 1 }
}

class Foo: Trackable {
    static var leftovers: Int = 0
    
    init() { create() }
    
    deinit { destroy() }
}


do { let foo = Foo() }
if true { let foo = Foo() }
var wow = [Foo()]; wow = []
var abc = [Foo()]; abc.removeLast()
var aa1: Foo? = Foo(); aa1 = Foo(); aa1 = Foo(); aa1 = nil



print(Foo.leftovers)


