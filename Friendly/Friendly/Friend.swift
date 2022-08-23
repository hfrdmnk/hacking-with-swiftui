//
//  Friend.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import Foundation

struct Friend: Codable, Identifiable, Hashable {
    let id: String
    var name: String
}
