# Birthday Game
What could it be?

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
        
    var cakes: [[String]] = []
    
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        bakeCakes()
        hideCakes()
    }
    
    func bakeCakes() {
        let cakos = (1...8).map { "Cake\($0)" }.reduce([String]()) { $0 + [$1, $1] }.shuffled()
        
        cakes = [
            [cakos[0], cakos[1], cakos[2], cakos[3]],
            [cakos[4], cakos[5], cakos[6], cakos[7]],
            [cakos[8], cakos[9], cakos[10], cakos[11]],
            [cakos[12], cakos[13], cakos[14], cakos[15]],
        ]
    }
    
    func hideCakes() {
        let magicNode = SKNode()
        
        let sceneWidth = scene?.frame.width ?? 0
        let sceneHeight = scene?.frame.height ?? 0
        for iCakeRow in 0..<cakes.count {
            for jCakeColumn in 0..<cakes[iCakeRow].count {
                let hiddenCake = CakeNode.Bake(cakes[iCakeRow][jCakeColumn])
                hiddenCake.setScale(0.5)
                hiddenCake.anchorPoint = .zero
                hiddenCake.position = CGPoint(x: iCakeRow * Int(hiddenCake.size.width * 1.2), y: jCakeColumn * Int(hiddenCake.size.height * 1.2))
                magicNode.addChild(hiddenCake)
            }
        }
        
        let magicFrame = magicNode.calculateAccumulatedFrame()
        magicNode.position = .init(x: (sceneWidth / 2) - (magicFrame.width / 2), y: (sceneHeight / 2) - (magicFrame.height / 2))
        addChild(magicNode)
    }
    
    var cakesRevealed: [CakeNode] = []
    var correctMatch: Bool = false
    var matchesFound: Set<String> = []
    var cakesSeen: [String] = []
    var chances = 0
    var rehideCakes: [CakeNode] = []
    var mistakes = 0
    
    override func mouseDown(with event: NSEvent) {
        
        // Remove wrong choices
        for cakeNode in rehideCakes {
            cakeNode.hideCake()
        }
        rehideCakes.removeAll()
        
        
        // TAP THE CAKE!!!
        for nodesAt in nodes(at: event.location(in: self)) {
            if let cakeNode = nodesAt as? CakeNode {
                
                if matchesFound.contains(cakeNode.cakeNumber) { return }
                
                cakeNode.revealCake()
                cakesSeen.append(cakeNode.cakeNumber)
                cakesRevealed.append(cakeNode)
                
                if cakesRevealed.count == 2 {
                    chances += 1
                    correctMatch = (cakesRevealed[0].cakeNumber == cakesRevealed[1].cakeNumber)
                }
            }
        }
        
        // Check if your cake is a match
        if cakesRevealed.count == 2 {
            if correctMatch {
                matchesFound.insert(cakesRevealed[0].cakeNumber)
                print("YAY")
            } else {
                rehideCakes = cakesRevealed
                
                if cakesSeen.filter({ $0 == cakesRevealed[0].cakeNumber }).count > 1 {
                    print("MISTAKE")
                    mistakes += 1
                }
                if cakesSeen.filter({ $0 == cakesRevealed[1].cakeNumber }).count > 1 {
                    print("MISTAKE")
                    mistakes += 1
                }
                print("–––––")
            }
            cakesRevealed.removeAll()
        }
        
        
        // Win the Game
        if matchesFound.count == 8, childNode(withName: "Winner") == nil {
            let label = SKLabelNode(text: "YOU WON IN \(chances) MOVES! (\(mistakes) mistakes\(mistakes == 1 ? "" : "s")!)")
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .top
            label.fontColor = .black
            label.name = "Winner"
            label.position = .init(x: 500, y: 990)
            addChild(label)
            matchesFound.removeAll()
        }
        
    }
    

}




class CakeNode: SKSpriteNode {
    var cakeNumber: String = ""
    
    static func Bake(_ n: String) -> CakeNode {
        let node = CakeNode(imageNamed: "Cake?")
        node.cakeNumber = n
        return node
    }
    
    func revealCake() {
        texture = SKTexture.init(imageNamed: cakeNumber)
    }
    func hideCake() {
        texture = SKTexture.init(imageNamed: "Cake?")
    }
}
```
