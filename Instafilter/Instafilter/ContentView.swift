//
//  ContentView.swift
//  Instafilter
//
//  Created by Dominik Hofer on 24.08.22.
//

import SwiftUI

struct ContentView: View {
    @State private var showAlert = false
    @State private var showDialog = false
    @State private var tintColor = Color.mint
    
    var body: some View {
        VStack {
            Button("Show alert") {
                showAlert = true
            }
            .buttonStyle(.bordered)
            
            Button("Change button tint") {
                showDialog = true
            }
            .buttonStyle(.borderedProminent)
        }
        .tint(tintColor)
        .alert("That's just a random alert", isPresented: $showAlert) {
            Button("Ok, nevermind") { }
        }
        .confirmationDialog("Choose your color", isPresented: $showDialog) {
            Button("Mint") {
                tintColor = .mint
            }
            
            Button("Indigo") {
                tintColor = .indigo
            }
            
            Button("Purple") {
                tintColor = .purple
            }
        } message: {
            Text("Select your new tint color")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
