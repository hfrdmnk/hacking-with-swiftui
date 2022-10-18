//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Dominik Hofer on 18.10.22.
//

import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Searching for \(searchText)")
            
            .searchable(text: $searchText, prompt: "Look for something")
            .navigationTitle("Searching")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
