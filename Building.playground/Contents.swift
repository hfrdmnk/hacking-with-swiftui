import Cocoa

protocol Building {
    var rooms: Int { get }
    var cost: Int { get set }
    var agent: String { get set }
    func summary()
}

struct House: Building {
    let rooms: Int
    var cost: Int
    var agent: String
    
    func summary() {
        print("This House with \(rooms) rooms costs $\(cost) and is sold by \(agent).")
    }
}

struct Office: Building {
    let rooms: Int
    var cost: Int
    var agent: String
    
    func summary() {
        print("This Office with \(rooms) rooms costs $\(cost) and is sold by \(agent).")
    }
}

let dunderMifflin = Office(rooms: 3, cost: 1_000_000, agent: "Michael Scott")
dunderMifflin.summary()
