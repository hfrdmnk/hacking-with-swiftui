//
//  AddView.swift
//  Habitli
//
//  Created by Dominik Hofer on 08.08.22.
//

import SwiftUI
import Combine

struct AddView: View {
    @ObservedObject var habits: Habits
    
    @State private var emoji = ""
    @State private var isEmoji = true
    @State private var name = ""
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Pick an emoji") {
                    EmojiTextField(text: $emoji, placeholder: "Emoji", isEmoji: $isEmoji)
                        .onReceive(Just(emoji)) { _ in
                            self.emoji = String(self.emoji.onlyEmoji().prefix(1))
                        }
                }   
                
                Section("Name your habit") {
                    TextField("Name", text: $name)
                }
            }
            .onSubmit {
                addHabit(name: name, emoji: emoji)
            }
            .navigationTitle("Add new habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    addHabit(name: name, emoji: emoji)
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(.primaryGreen)
                }
                .tint(.cream)
                .buttonStyle(.bordered)
            }
        }
    }
    
    func addHabit(name: String, emoji: String) {
        let habit = Activity(name: name, emoji: emoji)
        
        habits.activities.append(habit)
        
        dismiss()
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(habits: Habits())
    }
}
