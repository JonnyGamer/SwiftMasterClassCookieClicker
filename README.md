# SwiftMasterClassCookieClicker
Cookie Clicker Demo

# ViewController

```swift
class ViewController: NSViewController {

    @IBOutlet var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.skView {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene.init(size: .init(width: 1000, height: 1000))
            //if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFit
                
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
```

# GameScene

```swift
class GameScene: SKScene {
    
    // Step 13 - Move the cookie sprite up here. Delete the other `let cookie` from Step 3.
    let cookie = SKSpriteNode(imageNamed: "Cookie")
    
    // Step 18 - Tell the scene to remember that we've tapped a cookie.
    var tappedCookie = false
    
    // Step 22 - Move the label up here. Delete the other `let cookiesTapped` from Step 5.
    let cookiesTapped = SKLabelNode(text: "Cookies: 0")
    
    override func didMove(to view: SKView) {
        
        // Step 1 - Save the screen size
        let screenWidth = view.bounds.size.width
        let screenHeight = view.bounds.size.height
        
        // Step 2 - Set the background color to white
        scene?.backgroundColor = .white
        
        // Step 3 - Add our cookie to the scene
        //let cookie = SKSpriteNode(imageNamed: "Cookie")
        addChild(cookie)
        
        // Step 4 - Change the cookie in ways that would make it look nice on the screen
        // Setting the cookie size to exactly half the screen width
        cookie.setScale((screenWidth / 2) / cookie.size.width)
        // Setting the cookie position to the exact center of the screen
        cookie.position = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
        
        // Step 5 - Add our 'Cookies Clicked' label
        //let cookiesTapped = SKLabelNode(text: "Cookies: 0")
        addChild(cookiesTapped)
        // Step 6 - Change the font to black (because it is white by default)
        cookiesTapped.fontColor = .black
        // Step 7 - Put it at the top of the screen
        cookiesTapped.verticalAlignmentMode = .top
        cookiesTapped.position = CGPoint(x: screenWidth / 2, y: screenHeight - 20)
        // Step 8 - Change the font to be more bold
        cookiesTapped.fontName = "HelveticaNeue-Heavy"
    }
    
    // Step 9 - Add our touchesBegan function!
    override func mouseDown(with event: NSEvent) {
        // Step 10 - Iterate through all your fingers currently touching the screen
        for nodesAt in nodes(at: event.location(in: self)) {
            // Step 11 - Skip all fingers that started touching the screen a while back
            // Not Needed in MACOS
            // if touch.phase != .began { continue }
            
            // Step 12 - Check if the current touch tapped the cookie!
            // We will need to use the cookie object.
            // Go to the top of the class
            
            // Step 14
            // We will check if the list of nodes contains `cookie`
            if nodesAt == cookie {
                // Step 15 - Call the click cookie method! (Let's create it)
                clickCookie()
            }
        }
    }
    
    // Step 16 - This is the code that takes places when we click a cookie
    var clicks = 0
    func clickCookie() {
        // Step 17 - Once cookie is tapped, make it smaller
        cookie.setScale(cookie.xScale * 0.9)
        
        // Step 19 - Tell the scene that we've tapped our cookie
        tappedCookie = true
        
        // Step 21 - Increase number of clicks
        clicks += 1
        
        // Step 23 - Set the text to the new amount of clicks
        cookiesTapped.text = "Cookies: \(clicks)"
    }
    
    // Step 24 - Now we need to 'unclick' the cookie\
    override func mouseUp(with event: NSEvent) {
        // Step 25 - If you tapped a cookie, let's unclick it (and make it bigger)
        if tappedCookie {
            tappedCookie = false
            cookie.setScale(cookie.xScale / 0.9)
        }
    }
    
}
```
