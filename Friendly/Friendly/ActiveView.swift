//
//  ActiveView.swift
//  Friendly
//
//  Created by Dominik Hofer on 21.08.22.
//

import SwiftUI

struct ActiveView: View {
    let state: Bool
    
    var body: some View {
        HStack {
            Circle()
                .strokeBorder(state ? .green : .red, lineWidth: 2)
                .background(Circle().fill(state ? .green.opacity(0.4) : .red.opacity(0.4)))
                .frame(width: 16, height: 16)
            
            Text(state ? "is Online" : "is Offline")
                .foregroundColor(state ? .green : .red)
                .font(.caption.bold())
                .opacity(0.7)
        }
    }
}

struct ActiveView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveView(state: true)
    }
}
