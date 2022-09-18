//
//  ContentView-ViewModel.swift
//  Connector
//
//  Created by Dominik Hofer on 12.09.22.
//

import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var contacts = [Contact]()
        
        @Published var showAddContactSheet = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedContacts")
        
        func addContact(_ newContact: Contact) {
            contacts.append(newContact)
            
            save()
        }
        
        func deleteContact(_ contact: Contact) {
            if let index = contacts.firstIndex(of: contact) {
                contact.deleteFromSecureDirectory()
                contacts.remove(at: index)
            }
            
            save()
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(contacts)
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
                load()
            } catch {
                print("Unable to save data.")
            }
        }
        
        func load() {
            do {
                let data = try Data(contentsOf: savePath)
                contacts = try JSONDecoder().decode([Contact].self, from: data).sorted()
            } catch {
                contacts = []
            }
        }
        
        init() {
            load()
        }
    }
}
