//
//  main.swift
//  DavidForStructs
//
//  Created by Jonathan Pappas on 5/27/21.
//

import Foundation
import SpriteKit

// SUBCLASS INTRO
//class Goomba: SKSpriteNode {
//    var point3D: (x: CGFloat, y: CGFloat, z: CGFloat) = (0,0,0) {
//        didSet {
//            print("I was changed")
//            position.x = point3D.x
//            position.y = point3D.y + point3D.z
//            zPosition = -point3D.z
//        }
//    }
//}
//
//var enemy = Goomba()
//enemy.point3D.x = 100
//print(enemy.position.x)



// PROTOCOL INTRO
//protocol Magical {
//    func whoAmI()
//}
//extension Magical {
//    func hello() {
//        print("Hello!")
//    }
//}
//
//
//struct David: Magical {
//    func whoAmI() {
//        print("I'm David")
//    }
//}
//
//struct Jonny: Magical {
//    func whoAmI() {
//        print("I'm Jonny")
//    }
//}
//
//
//let arr: [Magical] = [David(), Jonny(), Jonny(), David()]
//for i in arr {
//    i.whoAmI()
//    i.hello()
//}


// Switch Code
//let foo = 500_000
//if foo == 1 {
//    print("It's one")
//} else if foo == 2 {
//    print("It's two")
//} else if foo == 5 {
//    print("It's five")
//} else {
//    print("It's something else")
//}
//
//switch foo {
//    case 1: print("It's one")
//    case 2: print("It's two")
//    case 5: print("It's five")
//    default: print("It's something else")
//}
//
//for i in 1...foo {
//
//    if foo == i {
//        print("It's \(foo)")
//    }
//}
//


// Enum Raw Values
//
//enum character: String {
//    case mario = "Mario"
//    case luigi = "Luigi"
//    case blueToad = "Blue Toad"
//    case yellowToad = "Yellow Toad"
//    case nabbit = "Nabbit"
//    case peach = "Princes Peach"
//    case wario = "Wario"
//    case waluigi = "Waluigi"
//    case bowserJR = "Bowser Jr."
//}
//
//enum Power: String {
//    case small = "Small"
//    case `super` = "Super"
//    case fire = "Fire"
//    case ice = "Ice"
//    case propeller = "Propeller"
//    case penguin = "Penguin"
//    case mini = "Mini"
//    case hammer = "Hammer"
//    case megaMushroom = "Mega"
//}
//
//struct Player: CustomStringConvertible {
//    var description: String {
//        return power.rawValue + " " + char.rawValue
//    }
//
//    var char: character
//    var power: Power
//}
//
//let player1 = Player(char: .mario, power: .small)
//print(player1)
//
//let player2 = Player(char: .luigi, power: .super)
//print(player2)
//
//let player3 = Player(char: .waluigi, power: .hammer)
//print(player3)
//
//let player4 = Player(char: .bowserJR, power: .ice)
//print(player4)
//let superPower: Power = .megaMushroom
//print(superPower.rawValue)


// OVerriding and Super Methods
//class Car {
//    func drive() {
//        print("Vroom Vroom")
//    }
//}
//
//class SportsCar: Car {
//    override func drive() {
//        super.drive()
//        super.drive()
//        super.drive()
//        print("MEGA VROOM VROOOOM")
//    }
//}
//
//
//let arr: [Car] = [SportsCar()]
//for i in arr {
//    i.drive()
//}
