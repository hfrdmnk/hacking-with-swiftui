//
//  ContentView.swift
//  Habitli
//
//  Created by Dominik Hofer on 08.08.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habits = Habits()
    @State private var showAddHabit = false
    
    let emojis = ["💪", "📖", "✍️", "🧘‍♂️", "🍳", "🏃‍♂️", "👨‍💻"]
    
    var body: some View {
        NavigationView {
            Group {
                if !habits.activities.isEmpty {
                    List {
                        ForEach(habits.activities) { habit in
                            ListItem(habit: habit)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    changeCount(activity: habit)
                                }
                                .onLongPressGesture {
                                changeCount(activity: habit, increase: false)
                                }
                        }        
                        
                        HStack {
                            Spacer()
                            
                            VStack(alignment: .center) {
                                Text("\(habits.activities.count) total habits.")
                                Text("Tap to increase, long tap to decrease.")
                            }
                            .font(.caption)
                            .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                } else {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(.cream)
                                .frame(width: 100, height: 100)
                            
                            Text(emojis.randomElement() ?? "💪")
                                .font(.largeTitle)
                        }
                        Text("Add your first habit.")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Habitli")
            .toolbar {
                Button {
                    showAddHabit = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.primaryGreen)
                }
                .tint(.cream)
                .buttonStyle(.bordered)
            }
            .sheet(isPresented: $showAddHabit) {
                AddView(habits: habits)
            }
        }
    }
    
    func changeCount(activity: Activity, increase: Bool = true) {
        var newActivity = activity
        
        if increase {
            newActivity.completionCount += 1
        } else {
            if newActivity.completionCount > 0 {
                newActivity.completionCount -= 1
            }
        }
        
        let index = habits.activities.firstIndex(of: activity)
        
        habits.activities[index ?? 0] = newActivity
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ListItem: View {
    let habit: Activity
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.cream)
                    .frame(width: 64, height: 64)
                
                Text(habit.emoji)
                    .font(.title2)
            }
            
            VStack(alignment: .leading) {
                Text(habit.name)
                    .font(.headline)
                Text("Completed \(habit.completionCount) \(habit.completionCount == 1 ? "time" : "times")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical)
    }
}
