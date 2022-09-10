//
//  ContentView.swift
//  iExpense
//
//  Created by Dominik Hofer on 28.07.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var showingCategory = "Personal"
    
    let types = ["Personal", "Business", "Show All"]
    
    var body: some View {
        NavigationView {
            List {
                Picker("Category", selection: $showingCategory) {
                    ForEach(types, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                
                ForEach(expenses.items) { item in
                    
                    if item.type == showingCategory || showingCategory == "Show All" {
                        ListItem(item: item)
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ListItem: View {
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            
            Spacer()
            
            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                .foregroundColor(item.amount < 10 ? .mint : item.amount < 100 ? .orange : .red)
        }
        .accessibilityElement()
        .accessibilityLabel("Paid \(item.amount) for \(item.name)")
        .accessibilityHint("Category: \(item.type)")
    }
}
