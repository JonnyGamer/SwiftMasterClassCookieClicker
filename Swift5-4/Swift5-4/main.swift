//
//  main.swift
//  Swift5-4
//
//  Created by Jonathan Pappas on 4/28/21.
//

import Foundation

print("Hello, World!")
@propertyWrapper
struct NonNegative<T: Numeric & Comparable> {
    var value: T
    
    var wrappedValue: T {
        get { value }
        set {
            self.value = max(0, newValue)
        }
    }
    
    init(wrappedValue: T) {
        self.value = max(0, wrappedValue)
    }
}

struct Foo {
    init(hi: inout Int) {}
}
var yo = 0
Foo.init(hi: &yo)


class Reference<T> {
    private var value: UnsafeMutablePointer<T>!

    var wrappedValue: T {
        get { value.pointee }
        set { value.pointee = newValue }
    }
    init(_ this: inout T) {
        self.assign(&this)
    }
    func assign(_ to: UnsafeMutablePointer<T>) {
        value = to
    }
}
extension Reference where T: Numeric {
    static func += (lhs: Reference, rhs: T) { lhs.wrappedValue += rhs }
    static func -= (lhs: Reference, rhs: T) { lhs.wrappedValue -= rhs }
    static func *= (lhs: Reference, rhs: T) { lhs.wrappedValue *= rhs }
}


@propertyWrapper
struct WOWOW<T> {
    var value: Reference<T>
    var wrappedValue: Reference<T> {
        get { value }
        set { value = newValue }
    }
    init(wrappedValue: Reference<T>) {
        self.value = wrappedValue
    }
}

extension WOWOW {
    static func YES(_ this: inout T) -> Self {
        return self.init(wrappedValue: Reference(&this))
    }
}





do {
    var foo = 0
    @WOWOW var bar = .init(&foo)
    bar += 1
    print(foo)
    
    let baro = Reference(&foo)
    baro += 111
    print(foo)
    
    @WOWOW.Type.YES(&foo) var bart
    
    //@WOWOW(yes: &foo) var bas
}








//func foo() {
//    @NonNegative var score = 0
//}







struct Wow {
    @NonNegative static var score = 0
    @NonNegative var score2 = 0
}

do {
    @NonNegative var score = 0
}
if true {
    @NonNegative var score = 0
}
while .random() {
    @NonNegative var score = 0
}
repeat {
    @NonNegative var score = 0
} while .random()
let foobar: () -> () = {
    @NonNegative var score = 0
}

// Still Errors
//let foots: [(Int, Int):Int] = [:]

@propertyWrapper struct Nothing<T> {
    var value: T
    var wrappedValue: T {
        get { value }
        set { value = newValue }
    }
    init(wrappedValue: T) { value = wrappedValue }
}

do {
    @Nothing var scor: () -> () = {}
}


func yessir(_ n: Int..., m: Int..., o: String..., a: Int,_ foo: Int...) {}
yessir(5, 5, 5, 5, 5, m: 5, 5, 5,5, 5, o: "", a: 0, 0,0,0)
