//
//  Habits.swift
//  Habitli
//
//  Created by Dominik Hofer on 08.08.22.
//

import Foundation

class Habits: ObservableObject {
    @Published var activities = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "activities")
            }
        }
    }
    
    init() {
        if let savedActivities = UserDefaults.standard.data(forKey: "activities") {
            if let decodedActivities = try? JSONDecoder().decode([Activity].self, from: savedActivities) {
                activities = decodedActivities
                return
            }
        }
        
        activities = []
    }
}
