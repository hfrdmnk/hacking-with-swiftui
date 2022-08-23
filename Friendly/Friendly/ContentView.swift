//
//  ContentView.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.name)
    ]) var users: FetchedResults<CachedUser>
    //    @FetchRequest(sortDescriptors: [
    //        SortDescriptor(\.name)
    //    ]) var friends: FetchedResults<CachedFriend>
    
    @State private var tempUsers = [User]()
    @State private var searchText = ""
    @State private var filter = "Everyone"
    @State private var showFilter = false
    @State private var showSearch = false
    
    @State private var searchPredicate = NSPredicate(format: "name.length > 0")
    @State private var filterPredicate = NSPredicate(format: "name.length > 0")
    
    let filters = ["Everyone", "Active", "Inactive"]
    let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    //    var filteredUsers: [CachedUser] {
    //        switch filter {
    //        case "Active":
    //            return users.filter { $0.isActive }
    //        case "Inactive":
    //            return users.filter { !$0.isActive }
    //        default:
    //            return users
    //        }
    //    }
    
    //    var searchUsers: [CachedUser] {
    //        if searchText.isEmpty {
    //            return filteredUsers
    //        } else {
    //            return filteredUsers.filter { $0.wrappedName.contains(searchText) }
    //        }
    //    }
    
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
                List {
                    ForEach(alphabet, id: \.self) { letter in
                        if users.contains(where: { user in
                            user.wrappedName.prefix(1) == letter
                        }) {
                            Section(letter) {
                                ForEach(users.filter { user in
                                    user.wrappedName.prefix(1) == letter
                                }) { user in
                                    NavigationLink {
                                        DetailView(user: user)
                                    } label: {
                                        VStack(alignment: .leading) {
                                            Text(user.wrappedName)
                                            
                                            ActiveView(state: user.isActive)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, prompt: "Enter a name")
                .onChange(of: searchText) { newValue in
                    if !newValue.isEmpty {
                        searchPredicate = NSPredicate(format: "name CONTAINS %@", newValue)
                    } else {
                        searchPredicate = NSPredicate(format: "name.length > 0")
                    }
                }
                .onChange(of: filter) { newValue in
                    if newValue == "Active" {
                        filterPredicate = NSPredicate(format: "isActive == true")
                    } else if newValue == "Inactive" {
                        filterPredicate = NSPredicate(format: "isActive == false")
                    } else {
                        filterPredicate = NSPredicate(format: "name.length > 0")
                    }
                }
                .onChange(of: [searchText, filter]) { _ in
                    users.nsPredicate = NSCompoundPredicate(type: .and, subpredicates: [searchPredicate, filterPredicate])
                }
            }
            .task {
                
                
                if(users.isEmpty) {
                    //                    await loadData()
                    
                    await MainActor.run {
                        writeToCoreData()
                    }
                }
            }
            .navigationTitle("Friendly")
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
            
            tempUsers = sortedUsers
        } catch {
            print("Download error: \(String(describing: error))")
        }
    }
    
    func writeToCoreData() {
        for user in tempUsers {
            let newUser = CachedUser(context: moc)
            
            newUser.id = user.id
            newUser.isActive = user.isActive
            newUser.name = user.name
            newUser.age = Int16(user.age)
            newUser.company = user.company
            newUser.email = user.email
            newUser.address = user.address
            newUser.about = user.about
            newUser.registered = user.registered
            
            newUser.tags = user.tags.joined(separator: ",")
            
            for friend in user.friends {
                let newFriend = CachedFriend(context: moc)
                
                newFriend.id = friend.id
                newFriend.name = friend.name
                
                newUser.addToFriends(newFriend)
            }
            
            try? moc.save()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
