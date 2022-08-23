//
//  DetailView.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import SwiftUI

struct DetailView: View {
    let user: CachedUser
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(user.wrappedName)
                    .font(.largeTitle.bold())
                
                HStack(spacing: 16) {
                    ActiveView(state: user.isActive)
                    
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        
                        Text(formatDate(date: user.wrappedRegistered))
                            .font(.caption.bold())
                            .opacity(0.7)
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
            
            List {
                Section("Infos") {
                    Label("Age: \(user.wrappedAge)", systemImage: "person.badge.clock")
                    Label("Company: \(user.wrappedCompany)", systemImage: "building.2")
                    Label("Email: \(user.wrappedEmail)", systemImage: "mail")
                    Label("Address: \n\(user.wrappedAddress)", systemImage: "mappin.and.ellipse")
                }
                
                Section("Friends") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(user.friendsArray) { friend in
                                ZStack {
                                    Capsule()
                                        .fill(.secondary)
                                        .opacity(0.3)
                                                                            
                                    HStack {
                                        Label(friend.wrappedName, systemImage: "person")
                                            .padding(8)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Section("Tags") {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(user.wrappedTags, id: \.self) { tag in
                                ZStack {
                                    Capsule()
                                        .fill(.secondary)
                                        .opacity(0.3)
                                                                            
                                    Text(tag)
                                        .padding(8)
                                }
                            }
                        }
                    }
                }
                
                Section("About") {
                    Text(user.wrappedAbout)
                        .padding(.vertical)
                }
                
            }
            .listStyle(.sidebar)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func formatDate(date: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        let formattedDate = isoFormatter.date(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        let returnDate = dateFormatter.string(from: formattedDate ?? Date.now)
        
        return returnDate
    }
}
