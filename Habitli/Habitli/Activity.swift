//
//  Activity.swift
//  Habitli
//
//  Created by Dominik Hofer on 08.08.22.
//

import Foundation

struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var emoji: String
    var completionCount: Int = 0
}
