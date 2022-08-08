import Cocoa

func randomInt(numbers: [Int]?) -> Int { numbers?.randomElement() ?? Int.random(in: 1...100) }
