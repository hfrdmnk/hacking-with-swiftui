//
//  FriendlyApp.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import SwiftUI

@main
struct FriendlyApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
