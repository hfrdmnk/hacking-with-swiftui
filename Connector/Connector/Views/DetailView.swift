//
//  DetailView.swift
//  Connector
//
//  Created by Dominik Hofer on 15.09.22.
//

import MapKit
import SwiftUI

struct LocationPin: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct DetailView: View {
    let contact: Contact
    let vm: ContentView.ViewModel
    
    @State private var showingConfirmAlert = false
    
    var markers: [LocationPin] {
        if let location = contact.location {
            return [LocationPin(coordinate: location)]
        }
        
        return []
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { metrics in
                    TabView {
                        contact.image?
                            .resizable()
                            .scaledToFill()
                            .overlay(alignment: .bottomLeading) {
                                    Label(contact.company, systemImage: "building.2.fill")
                                        .font(.title2.bold())
                                        .foregroundColor(.white)
                                    .padding()
                                    .background {
                                        Color.black
                                            .opacity(0.3)
                                            .cornerRadius(8, corners: [.topRight])
                                }
                            }
                        
                        if let location = contact.location {
                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))), annotationItems: markers) { location in
                                MapMarker(coordinate: location.coordinate)
                            }
                            .disabled(true)
                            .overlay(alignment: .bottomLeading) {
                                Label("Location", systemImage: "mappin.and.ellipse")
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
                    }
                    .tabViewStyle(.page)
                    .frame(width: metrics.size.width, height: metrics.size.width)
                .mask(RoundedRectangle(cornerRadius: 16))
            }
            
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
