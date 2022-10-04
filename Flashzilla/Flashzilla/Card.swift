//
//  Card.swift
//  Flashzilla
//
//  Created by Dominik Hofer on 01.10.22.
//

import Foundation

struct Card: Codable {
    let prompt: String
    let answer: String
    
    static let example = Card(prompt: "Who is the boss of Dunder Mifflin Scranton?", answer: "Michael Scott")
}
