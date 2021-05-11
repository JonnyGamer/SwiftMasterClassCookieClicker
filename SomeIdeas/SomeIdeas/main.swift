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


//protocol Trackable {
//    static var leftovers: Int { get set }
//}
//extension Trackable {
//    func create() { Self.leftovers += 1 }
//    func destroy() { Self.leftovers -= 1 }
//}
//
//class Foo: Trackable {
//    static var leftovers: Int = 0
//
//    init() { create() }
//
//    deinit { destroy() }
//}
//
//
//do { let foo = Foo() }
//if true { let foo = Foo() }
//var wow = [Foo()]; wow = []
//var abc = [Foo()]; abc.removeLast()
//var aa1: Foo? = Foo(); aa1 = Foo(); aa1 = Foo(); aa1 = nil
//
//
//
//print(Foo.leftovers)


// 1. Original Example:
//@propertyWrapper struct Reference<T> {
//    var foo: T
//    var wrappedValue: T {
//        get { return foo }
//        set { foo = newValue }
//    }
//    init(_ this: inout T) {
//        fatalError()
//    }
//}
//
//var wow: Int = 1
//do {
//    @Reference(&wow) var this: Int
//    this += 1
//    assert(wow == 2)
//}


// Expected Result:
//class Reference<T> {
//    var this: UnsafeMutablePointer<T>
//    init(_ to: inout T) {
//        this = assign(&to)
//    }
//}
//func assign<T>(_ this: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> { this }
//
//var wow: Int = 1
//do {
//    let this = Reference(&wow)
//    this.this.pointee += 1
//    assert(wow == 2)
//}


// 2. Less Minimal
// Minimal Reproducable Glitch:
//@propertyWrapper class Copy2<T> {
//    var foo: T
//    var wrappedValue: T {
//        get { return foo }
//        set { foo = newValue }
//    }
//    init(wrappedValue: inout T) { foo = wrappedValue }
//}
//func assign<T>(_ this: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> { this }
//do {
//    var wow: Int = 1
//    @Copy2 var this = &wow
//    this += 1
//    print(wow)
//}

// 3. Almost Minimal:
//@propertyWrapper class Copy2<T> {
//    var foo: UnsafeMutablePointer<T>
//    var wrappedValue: UnsafeMutablePointer<T> {
//        get {
//            print("a", foo.pointee)
//            return foo
//        }
//        set(to) {
//            //print(foo.pointee, to.pointee , to)
//            print(foo.pointee, to, to.pointee)
//            foo = to
//            //print("ok"); foo.pointee = to.pointee
//        }
//    }
//    init(wrappedValue: UnsafeMutablePointer<T>) { foo = wrappedValue }
//}
////func assign<T>(_ this: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> { this }
//do {
//    var wow: Int = 2
//    @Copy2 var this = &wow
//    //this.pointee += 1
//    this += 1
//    this += 10
//    print(wow)
//}


// 4. Minimal Reproducable Example:
//@propertyWrapper struct Copy<T> {
//    var wrappedValue: UnsafeMutablePointer<T>
//}
//do {
//    var wow: Int = 1
//    @Copy var this = &wow
//    this.pointee += 1
//    this += 100
//    print(wow)
//    print(this)
//}

// 5. Even More Minimal, Solved the Problem!
//func assign<T>(_ this: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> { this }
//var a1 = 1
//var a2: UnsafeMutablePointer = assign(&a1)
//a2.pointee += 1
//print(a1, a2, a2.pointee)
//a2 += 100
//print(a1, a2, a2.pointee)
//
//extension UnsafeMutablePointer where Pointee: AdditiveArithmetic {
//    static func += (lhs: Self, rhs: Pointee) {
//        lhs.pointee += rhs
//    }
//}






extension UnsafeMutablePointer where Pointee: AdditiveArithmetic {
    static func += (lhs: Self, rhs: Pointee) { lhs.pointee += rhs }
    static func += (lhs: Self, rhs: Self) { lhs.pointee += rhs.pointee }
    static func -= (lhs: Self, rhs: Pointee) { lhs.pointee -= rhs }
    static func -= (lhs: Self, rhs: Self) { lhs.pointee -= rhs.pointee }
}
extension UnsafeMutablePointer where Pointee: Numeric {
    static func *= (lhs: Self, rhs: Pointee) { lhs.pointee *= rhs }
    static func *= (lhs: Self, rhs: Self) { lhs.pointee *= rhs.pointee }
}
extension UnsafeMutablePointer where Pointee: FixedWidthInteger {
    static func /= (lhs: Self, rhs: Pointee) { lhs.pointee /= rhs }
    static func /= (lhs: Self, rhs: Self) { lhs.pointee /= rhs.pointee }
}
extension UnsafeMutablePointer where Pointee: FloatingPoint {
    static func += (lhs: Self, rhs: Pointee) { lhs.pointee += rhs }
    static func -= (lhs: Self, rhs: Pointee) { lhs.pointee -= rhs }
    static func *= (lhs: Self, rhs: Pointee) { lhs.pointee *= rhs }
    static func /= (lhs: Self, rhs: Pointee) { lhs.pointee /= rhs }
    static func += (lhs: Self, rhs: Self) { lhs.pointee += rhs.pointee }
    static func -= (lhs: Self, rhs: Self) { lhs.pointee -= rhs.pointee }
    static func *= (lhs: Self, rhs: Self) { lhs.pointee *= rhs.pointee }
    static func /= (lhs: Self, rhs: Self) { lhs.pointee /= rhs.pointee }
}
extension UnsafeMutablePointer where Pointee == String {
    static func += (lhs: Self, rhs: Pointee) { lhs.pointee += rhs }
    static func += (lhs: Self, rhs: Self) { lhs.pointee += rhs.pointee }
    static func *= (lhs: Self, rhs: Int) { lhs.pointee *= rhs }
}
extension String {
    static func *= (lhs: inout Self, rhs: Int) { lhs = String.init(repeating: lhs, count: rhs) }
}

extension UnsafeMutablePointer: CustomStringConvertible {
    public var description: String { return "\(pointee)" }
}
@propertyWrapper struct Reference<T> {
    var foo: UnsafeMutablePointer<T>
    var wrappedValue: UnsafeMutablePointer<T> {
        get { foo }
        set { foo = newValue }
    }
    init(wrappedValue: UnsafeMutablePointer<T>) { foo = wrappedValue }
}


do {
    var wow: Int = 2
    @Reference var this = &wow
    this += this
    this += 10
    this *= 1000
    print(wow)
}

//do {
//    var wow = "a"
//    @Copy var w = &wow
//    w *= 100
//    print(wow)
//}








