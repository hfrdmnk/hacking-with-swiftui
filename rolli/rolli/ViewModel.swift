//
//  ViewModel.swift
//  rolli
//
//  Created by Dominik Hofer on 16.10.22.
//

import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var dice: Dice
        @Published var showingConfirmationDialog = false
        
        init(dice: Dice) {
            self.dice = dice
        }
        
        func rollDice() {
            let number = dice.values.randomElement()
            
            addThrow(value: number ?? 0)
            dice.currentValue = String(number ?? 0)
        }
        
        fileprivate func addThrow(value: Int) {
            dice.results.insert(value, at: 0)
        }
    }
}
