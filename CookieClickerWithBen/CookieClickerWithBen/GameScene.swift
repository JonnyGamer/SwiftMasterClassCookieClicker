//
//  GameScene.swift
//  CookieClickerWithBen
//
//  Created by Jonathan Pappas on 5/5/21.
//

import SpriteKit
import GameplayKit

var totalCookies: Int {
    get { return UserDefaults.standard.integer(forKey: "COOKIES") }
    set(to) { UserDefaults.standard.set(to, forKey: "COOKIES") }
}

class GameScene: SKScene {
    
    let cookie = SKSpriteNode.init(imageNamed: "Cookie")
    let numberOfCookies = SKLabelNode.init(text: "Cookies: \(totalCookies)")
    
    override func didMove(to view: SKView) {
        backgroundColor = .init(red: 100/255, green: 100/255, blue: 200/255, alpha: 1)
        
        let screenWidth = frame.width
        let screenHeight = frame.height
        
        addChild(cookie)
        cookie.setScale((screenWidth / 2) / cookie.frame.width)
        
        addChild(numberOfCookies)
        numberOfCookies.position.y = (screenHeight/2) - 100
        numberOfCookies.fontColor = .black
        numberOfCookies.fontName = ""
    }
    
    
    var tappedCookie = false
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self) // CGPoint
        if nodes(at: location).contains(cookie) {
            cookie.setScale(cookie.xScale * 0.9)
            tappedCookie = true
            
            totalCookies += 1
            numberOfCookies.text = "Cookies: \(totalCookies)"
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        if tappedCookie {
            tappedCookie = false
            cookie.setScale(cookie.xScale / 0.9)
        }
    }
    
}
