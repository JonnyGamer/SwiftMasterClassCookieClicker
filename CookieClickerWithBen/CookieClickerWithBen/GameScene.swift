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
    
    func resetGame() {
        totalCookies = 0
        gainCookies(0)
    }
    
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
        
        // Cookies Rain!
        for _ in 1...250 {
            // Making The Cookie
            let smallerCookie = SKSpriteNode(imageNamed: "Cookie")
            addChild(smallerCookie)
            smallerCookie.zPosition = -1
            smallerCookie.setScale(0.05)
            smallerCookie.alpha = 0.5
            smallerCookie.position.x = CGFloat.random(in: -500...500)
            smallerCookie.position.y = 600
            
            let moveDown = SKAction.moveBy(x: 0, y: -1200, duration: 5.0)
            let moveBackUp = SKAction.moveBy(x: 0, y: 1200, duration: 0.0)
            let waitCookie = SKAction.wait(forDuration: Double.random(in: 0...500) / 100)
            
            let superSequence = SKAction.sequence([waitCookie, moveDown, moveBackUp])
            let superRepeat = SKAction.repeatForever(superSequence)
            smallerCookie.run(superRepeat)
        }
        
        
    }
    
    
    var tappedCookie = false
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self) // CGPoint
        if nodes(at: location).contains(cookie) {
            cookie.setScale(cookie.xScale * 0.9)
            tappedCookie = true
            
            gainCookies(1)
            numberOfCookies.text = "Cookies: \(totalCookies)"
        }
        // savedCookies.append(Date().timeIntervalSince1970)
    }
    
    override func mouseUp(with event: NSEvent) {
        if tappedCookie {
            tappedCookie = false
            cookie.setScale(cookie.xScale / 0.9)
        }
    }
    
    override func keyDown(with event: NSEvent) {
        gainCookies(1)
        if Int.random(in: 1...1_000_000) == 1 {
            resetGame()
        }
        if event.keyCode == 51 {
            resetGame()
        }
    }
    
    func gainCookies(_ n: Int) {
        totalCookies += n
        numberOfCookies.text = "Cookies: \(totalCookies)"
        savedCookies += n
    }
    
    var savedCookies = 0
    
    var previousTime: Int = 0
    
    override func update(_ currentTime: TimeInterval) {
        let time = Int(currentTime)
        
        if time > previousTime {
            previousTime = time
            print(savedCookies)
            // Update Text Here //
            savedCookies = 0
        }
    }
    
    
}
