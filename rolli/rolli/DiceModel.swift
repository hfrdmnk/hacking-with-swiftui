//
//  dice.swift
//  rolli
//
//  Created by Dominik Hofer on 16.10.22.
//

import Foundation

struct Dice {
    enum diceTypeOptions {
        case four, six, eight, ten, twelve, twenty, hundred
    }
    
    var diceType: diceTypeOptions = .six
    
    var currentValue = "…"
    
    var values: [Int] {
        switch diceType {
        case .four:
            return Array(1...4)
        case .six:
            return Array(1...6)
        case .eight:
            return Array(1...8)
        case .ten:
            return Array(1...10)
        case .twelve:
            return Array(1...12)
        case .twenty:
            return Array(1...20)
        case .hundred:
            return Array(1...100)
        }
    }
    
    var results = [Int]()
}
