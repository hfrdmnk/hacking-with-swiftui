//
//  User.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [Friend]
}
