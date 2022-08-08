//
//  Arrow.swift
//  Drawing
//
//  Created by Dominik Hofer on 07.08.22.
//

import SwiftUI

struct Arrow: Shape {
//    let strokeWidth: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.width / 2, y: rect.minY)
        
        path.move(to: CGPoint(x: rect.width / 2, y: rect.maxY))
        path.addLine(to: start)
        path.move(to: CGPoint(x: rect.minX, y: rect.height * 0.2))
        path.addLine(to: start)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * 0.2))
        
        return path
    }
}

struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100.0
    
    var body: some View {
        ZStack {
            ForEach(0..<Int(steps), id: \.self) { value in
                Rectangle()
                    .inset(by: Double(value))
                    .strokeBorder(color(for: value, brightness: 1), lineWidth: 2)
            }
        }
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(steps) + amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

struct ArrowView: View {
    @State private var hasBolderLine = false
    @State private var colorCycle = 0.0
    @State private var steps = 100.0
    
    var body: some View {
        VStack {
            Arrow()
                .stroke(.black, lineWidth: hasBolderLine ? 20.0 : 10.0 )
                .frame(width: 75, height: 200)
                .onTapGesture {
                    withAnimation {
                        hasBolderLine.toggle()
                    }
                }
                .padding()
            
            Spacer()
            
            ColorCyclingRectangle(amount: colorCycle, steps: steps)
                .frame(width: 300, height: 300)
            
            Form {
                HStack {
                    Text("Color")
                    Slider(value: $colorCycle)
                }
                
                HStack {
                    Text("Steps")
                    Slider(value: $steps, in: 50...200)
                }
            }
        }
        .padding()
    }
}

struct ArrowView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowView()
    }
}
