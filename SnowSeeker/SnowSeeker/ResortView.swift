//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Dominik Hofer on 20.10.22.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort
    
    @State private var selectedFacility: Facility?
    @State private var showingFacility = false
    
    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize
    
    @EnvironmentObject var favorites: Favorites
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                
                HStack {
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10) { ResortDetailView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        ResortDetailView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .foregroundColor(.indigo)
                .background(Color.indigo.opacity(0.1))
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                    selectedFacility = facility
                                    showingFacility = true
                                } label: {
                                    facility.icon
                                        .font(.title)
                                }
                        }
                    }
                    
                    Button(favorites.contains(resort) ? "Remove from favorites" : "Add to favorites") {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .navigationTitle("\(resort.name), \(resort.country)")
            .navigationBarTitleDisplayMode(.inline)
            .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in } message: { facility in
                Text(facility.description)
            }
        }
    }
    
    struct ResortView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                ResortView(resort: Resort.example)
            }
            .environmentObject(Favorites())
        }
    }
}
