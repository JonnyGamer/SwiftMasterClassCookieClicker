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


//for i in 1...1000 {
//    //print(i, String(i, radix: 2), (String(i, radix: 2).reversed().reduce("") { $0 + String($1) }))
//
//    print(i, Int((String(i, radix: 2).reversed().reduce("") { $0 + String($1) }), radix: 2)! )
//}
//fatalError()



// YE
//bin = lambda x: format(x, 'b')

func pow2pow2(_ b: Int,_ pow2: Int, mod: Int) -> Int {
    var o = b
    for _ in 0..<(pow2) { o *= o; o %= mod }
    return o
}

func opow(_ b: Int,_ p: Int, mod: Int) -> Int {
    var o = 1
    //print(String(p, radix: 2))

    for (index,bi) in String(p, radix: 2).reversed().enumerated() {
        if bi == "1" {
            o *= pow2pow2(b%mod, index, mod: mod)
            o %= mod
            if o == 0 { return 0 }
        }
    }
    return o
}
//
//let foo = 11
//let last2 = foo%100
//var last = 0
//for i in 2...10000000_00 {
//
//    print(opow(2, i, mod: 10000))
    
    
    //print("\(i)^\(i) ends in", opow(i, i, mod: 1_000_000_000))
//    if opow(2,11111, mod: i) == 11111 {
//        print("\(2)^\(11111) mod", i, "=", 11111)
//        last = i
//    }
//}
// 285,311,670,611

// 11^1111 mod 18,19,20,21,22 = 11
// 11^1111 mod 35,36,37,38 = 11
// 11^1111 mod 74,75,76,77 = 11

// 11111111111^11111111111
//11^1111 mod 12 = 11
//11^1111 mod 14 = 11
//11^1111 mod 15 = 11
//11^1111 mod 20 = 11
//11^1111 mod 21 = 11
//11^1111 mod 25 = 11
//11^1111 mod 28 = 11
//11^1111 mod 30 = 11
//11^1111 mod 35 = 11
//11^1111 mod 42 = 11
//11^1111 mod 50 = 11
//11^1111 mod 60 = 11
//11^1111 mod 70 = 11
//11^1111 mod 75 = 11
//11^1111 mod 84 = 11
//11^1111 mod 100 = 11
//11^1111 mod 105 = 11
//11^1111 mod 140 = 11
//11^1111 mod 150 = 11
//11^1111 mod 175 = 11
//11^1111 mod 210 = 11
//11^1111 mod 300 = 11
//11^1111 mod 350 = 11
//11^1111 mod 420 = 11
//11^1111 mod 525 = 11
//11^1111 mod 700 = 11
//11^1111 mod 967 = 11
//11^1111 mod 1050 = 11
//11^1111 mod 1934 = 11
//11^1111 mod 2100 = 11
//11^1111 mod 2901 = 11
//11^1111 mod 3868 = 11
//11^1111 mod 4835 = 11
//11^1111 mod 5802 = 11
//11^1111 mod 6769 = 11
//11^1111 mod 9670 = 11
//11^1111 mod 11604 = 11
//11^1111 mod 13538 = 11
//11^1111 mod 14505 = 11
//11^1111 mod 19340 = 11
//11^1111 mod 20307 = 11
//11^1111 mod 24175 = 11
//11^1111 mod 27076 = 11
//11^1111 mod 29010 = 11
//11^1111 mod 33845 = 11
//11^1111 mod 40614 = 11
//11^1111 mod 48350 = 11
//11^1111 mod 58020 = 11
//11^1111 mod 67690 = 11
//11^1111 mod 72525 = 11
//11^1111 mod 81228 = 11
//11^1111 mod 96700 = 11
//11^1111 mod 101535 = 11
//11^1111 mod 135380 = 11
//11^1111 mod 145050 = 11
//11^1111 mod 169225 = 11
//11^1111 mod 203070 = 11
//11^1111 mod 290100 = 11
//11^1111 mod 338450 = 11
//11^1111 mod 406140 = 11
//11^1111 mod 507675 = 11
//11^1111 mod 676900 = 11
//11^1111 mod 1015350 = 11
//11^1111 mod 2030700 = 11


//1111^1111 mod 20 = 11
//1111^1111 mod 22 = 11
//1111^1111 mod 25 = 11
//1111^1111 mod 44 = 11
//1111^1111 mod 50 = 11
//1111^1111 mod 55 = 11
//1111^1111 mod 100 = 11
//1111^1111 mod 110 = 11
//1111^1111 mod 220 = 11
//1111^1111 mod 275 = 11
//1111^1111 mod 550 = 11
//1111^1111 mod 1100 = 11


