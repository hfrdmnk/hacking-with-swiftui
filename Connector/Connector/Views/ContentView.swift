//
//  ContentView.swift
//  Connector
//
//  Created by Dominik Hofer on 12.09.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            ZStack {
                List(viewModel.contacts) { contact in
                    NavigationLink {
                        DetailView(contact: contact, vm: viewModel)
                    } label: {
                        HStack {
                            contact.image?
                                .resizable()
                                .scaledToFill()
                                .frame(width: 48, height: 48)
                                .mask(RoundedRectangle(cornerRadius: 4))
                            
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                if let company = contact.company {
                                    Text(company)
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            locationFetcher.start()
                            viewModel.showAddContactSheet = true
                            // viewModel.addContact(Contact.example)
                        } label: {
                            Image(systemName: "person.fill.badge.plus")
                            Text("Add new connection")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Connector")
            .sheet(isPresented: $viewModel.showAddContactSheet) {
                AddView(vm: viewModel, locationFetcher: locationFetcher)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
