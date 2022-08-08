//
//  MissionView.swift
//  Moonshot
//
//  Created by Dominik Hofer on 02.08.22.
//

import SwiftUI

struct MissionView: View {    
    let mission: Mission
    let crew: [CrewMember]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width * 0.8)
                        .padding(.top)
                    
                    Text(mission.formattedLaunchDate)
                        .font(.headline)
                        .padding(.top)
                    
                    VStack(alignment: .leading) {
                        CustomDivider()
                        
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                        
                        CustomDivider()
                        
                        Text("Crew")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                    
                    AstronautsScrollView(crew: crew)
                }
                .padding(.bottom)
            }
            .navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
        }
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        self.mission = mission
        
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[1], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(.lightBackground)
            .padding(.vertical)
    }
}

struct AstronautsScrollView: View {
    let crew: [CrewMember]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            
            HStack {
                ForEach(crew, id: \.role) { member in
                    NavigationLink {
                        AstronautView(astronaut: member.astronaut)
                    } label: {
                        HStack {
                            Image(member.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .strokeBorder(isCommander(role: member.role) ? .mint : .white, lineWidth: isCommander(role: member.role) ? 3 : 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(member.astronaut.name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                
                                Text(member.role)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
    
    
    
    func isCommander(role: String) -> Bool {
        role == "Commander" || role == "Command Pilot"
    }
}
