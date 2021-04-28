//
//  main.swift
//  Swift5-4
//
//  Created by Jonathan Pappas on 4/28/21.
//

import Foundation

print("Hello, World!")

@propertyWrapper struct NonNegative<T: Numeric & Comparable> {
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

func foo() {
    @NonNegative var score = 0
}
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
