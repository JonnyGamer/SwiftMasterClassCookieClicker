
// Let's Rock Paper Scissors!

enum Items {
    case rock, paper, scissors, gatorade
    
    static var winRules: [Items:[Items]] = [
        .rock: [.scissors],
        .paper: [.rock],
        .scissors: [.paper],
        .gatorade: [.rock, .paper, .scissors],
    ]
    
    func biggerThan(_ another: Items) -> Bool {
        return Self.winRules[self]?.contains(another) == true
    }
    
    func equalTo(_ another: Items) -> Bool {
        return self == another
    }
    
}

let me = Items.rock
let opponent = Items.paper

// Will keep track of how many times you've chosen something
var chosenItems: [Items:Int] = [.rock:0,.paper:0,.scissors:0,.gatorade:0]

while true {
    
    let chosenLetter = readLine()!.lowercased()
    
    var chosenItem = Items.gatorade
    chosenItem = ["r":Items.rock,"p":.paper,"s":.scissors,"g":.gatorade][chosenLetter] ?? .rock
    
    // Keep track of chosen item
    chosenItems[chosenItem]! += 1 // <- This line
    
    print("You chose \(chosenItem)!")
    var opponentChose = [Items.rock, .paper, .scissors].randomElement()!
    
    // Smart Robot
    let mostLikelyToChoose = chosenItems.sorted(by: { $0.value > $1.value }).first!.key
    if mostLikelyToChoose == .rock { opponentChose = .paper }
    if mostLikelyToChoose == .paper { opponentChose = .scissors }
    if mostLikelyToChoose == .scissors { opponentChose = .rock }
    
    
    print("Opponent chose \(opponentChose)")
    
    if chosenItem.biggerThan(opponentChose) {
        print("You won!")
        
        if chosenItem == .gatorade {
            print("NOTHING BEATS GATORADE")
        }
        
    } else if chosenItem.equalTo(opponentChose) {
        print("It was a tie.")
    } else {
        print("You lost.")
    }
    
}









