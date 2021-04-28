//
//  main.swift
//  Swift5-4GeekingOut
//
//  Created by Jonathan Pappas on 4/28/21.
//

import Foundation

func variadic(_ n: Int..., m: Int..., om: Int..., pm: Int..., qm: Int..., mm: Int...) {
    print(n, m)
}
print(type(of: variadic))

variadic(1, 2, 3, 1, 1, 1, 12, 2,2, 2,2, m: 1, 1, 1, 1)

var foo: (Int...)
