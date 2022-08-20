//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Dominik Hofer on 18.08.22.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var countries: FetchedResults<Country>
    @FetchRequest(sortDescriptors: []) var candies: FetchedResults<Candy>
    
    @State private var originFilter = "UK"
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(countries, id: \.self) { country in
                        Section(country.wrappedFullName) {
                            ForEach(country.candyArray, id: \.self) { candy in
                                Text(candy.wrappedName)
                            }
                        }
                    }
                }
                
                FilteredList(filterKey: "origin.shortName", filterValue: originFilter, predicate: .beginsWith, sortDescriptor: SortDescriptor(\.name, order: .reverse)) { (candy: Candy) in
                    Text("\(candy.wrappedName) is from \(candy.origin?.fullName ?? "Unkown")")
                }
                
                VStack {
                    Button("Add Candy") {
                        let candy1 = Candy(context: moc)
                        candy1.name = "Mars"
                        candy1.origin = Country(context: moc)
                        candy1.origin?.shortName = "UK"
                        candy1.origin?.fullName = "United Kingdom"
                        
                        let candy2 = Candy(context: moc)
                        candy2.name = "KitKat"
                        candy2.origin = Country(context: moc)
                        candy2.origin?.shortName = "UK"
                        candy2.origin?.fullName = "United Kingdom"
                        
                        let candy3 = Candy(context: moc)
                        candy3.name = "Twix"
                        candy3.origin = Country(context: moc)
                        candy3.origin?.shortName = "UK"
                        candy3.origin?.fullName = "United Kingdom"
                        
                        let candy4 = Candy(context: moc)
                        candy4.name = "Toblerone"
                        candy4.origin = Country(context: moc)
                        candy4.origin?.shortName = "CH"
                        candy4.origin?.fullName = "Switzerland"
                        
                        try? moc.save()
                    }
                    
                    HStack {
                        Button("Show UK candies") {
                            originFilter = "UK"
                        }
                        
                        Button("Show CH candies") {
                            originFilter = "CH"
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .navigationTitle("CandyLand")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
