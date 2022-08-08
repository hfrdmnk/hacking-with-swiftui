//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Dominik Hofer on 29.07.22.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
