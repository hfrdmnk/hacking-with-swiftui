//
//  ContentView.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    @State private var searchText = ""
    @State private var filter = "Everyone"
    @State private var showFilter = false
    @State private var showSearch = false
    
    let filters = ["Everyone", "Active", "Inactive"]
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var filteredUsers: [User] {
        switch filter {
        case "Active":
            return users.filter { $0.isActive }
        case "Inactive":
            return users.filter { !$0.isActive }
        default:
            return users
        }
    }
    
    var searchUsers: [User] {
        if searchText.isEmpty {
            return filteredUsers
        } else {
            return filteredUsers.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                if showFilter {
                    Picker("Filter list", selection: $filter) {
                        ForEach(filters, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding([.horizontal, .bottom])
                }
                
//                List(searchUsers) { user in
//                    NavigationLink {
//                        DetailView(user: user)
//                    } label: {
//                        VStack(alignment: .leading) {
//                            Text(user.name)
//
//                            ActiveView(state: user.isActive)
//                        }
//                    }
//                }
                List {
                    ForEach(alphabet, id: \.self) { letter in
                        Section(letter) {
                            ForEach(searchUsers.filter { user in
                                user.name.prefix(1) == letter
                            }) { user in
                                NavigationLink {
                                    DetailView(user: user)
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                        
                                        ActiveView(state: user.isActive)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "Enter a name")
//                .if(showSearch) { view in
//                    view.searchable(text: $searchText, prompt: "Enter a name")
//                }
            }
            .task {
                if users.isEmpty {
                    await loadData()
                }
            }
            .navigationTitle("Friendly")
//            .toolbar {
//                ToolbarItem {
//                    Button {
//                        withAnimation {
//                            showSearch.toggle()
//                        }
//                    } label: {
//                        Label("Show search", systemImage: "magnifyingglass.circle")
//                    }
//                }
//            }
            .toolbar {
                ToolbarItem {
                    Button {
                        withAnimation {
                            showFilter.toggle()
                        }
                    } label: {
                        Label("Show filters", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
    }
    
    func loadData() async {
        do {
            let fetchURL = URL(string: "https://www.hackingwithswift.com/samples/friendface.json")!
            let downloadedUsers: [User] = try await URLSession.shared.decode(from: fetchURL)
            let sortedUsers = downloadedUsers.sorted {
                $0.name < $1.name
            }
            
            users = sortedUsers
        } catch {
            print("Download error: \(String(describing: error))")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
