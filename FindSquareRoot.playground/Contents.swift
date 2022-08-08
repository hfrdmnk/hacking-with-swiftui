import Cocoa

enum NumberError: Error {
    case outOfBounds, noRoot
}

func findSquareRoot(of number: Int) throws -> Int {
    if(number < 1 || number > 10_000) { throw NumberError.outOfBounds }
    
    var total = 0
    var multiplier = 1
    
    while total <= 10_000 {
        total = multiplier * multiplier
        
        if(total == number) {
            return multiplier
        }
        
        multiplier += 1
    }
    
    throw NumberError.noRoot
}

let number = 196

do {
    let result = try findSquareRoot(of: number)
    print("The square root of \(number) is: \(result)")
} catch NumberError.outOfBounds {
    print("Please use a number between 1 and 10000 (including)")
} catch {
    print("Sorry, no square root found!")
}

