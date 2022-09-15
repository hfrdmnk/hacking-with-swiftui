//
//  DetailView.swift
//  Connector
//
//  Created by Dominik Hofer on 15.09.22.
//

import SwiftUI

struct DetailView: View {
    let contact: Contact
    let vm: ContentView.ViewModel
    
    @State private var showingConfirmAlert = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { metrics in
                contact.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: metrics.size.width, height: metrics.size.width)
                    .clipped()
                    .overlay(alignment: .bottomLeading) {
                            Text(contact.company)
                                .font(.title2.bold())
                                .foregroundColor(.white)
                            .padding()
                            .background {
                                Color.black
                                    .opacity(0.3)
                                    .cornerRadius(8, corners: [.topRight])
                        }
                    }
            }
            .mask(RoundedRectangle(cornerRadius: 16))
            
        }
        .padding()
        .navigationTitle(contact.name)
        .toolbar {
            ToolbarItem {
                Button(role: .destructive) {
                    showingConfirmAlert = true
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
        }
        .alert("Warning…", isPresented: $showingConfirmAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Yes", role: .destructive) {
                vm.deleteContact(contact)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this connection?")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(contact: Contact.example, vm: ContentView.ViewModel())
        }
    }
}
