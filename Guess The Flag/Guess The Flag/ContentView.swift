//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Dominik Hofer on 06.07.22.
//

import SwiftUI

struct FlagImage: View {
    var number: Int
    var countries: [String]
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .cornerRadius(10)
            .shadow(radius: 5)
            .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctMessage = ""
    @State private var score = 0
    @State private var questions = 0
    @State private var gameFinished = false
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var selectedFlag: Int?
    @State private var rotationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    @State private var saturationAmount = 1.0
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.mint, .indigo], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(number: number, countries: countries)
                                .opacity(selectedFlag != number ? opacityAmount : 1.0)
                                .scaleEffect(selectedFlag != number ? scaleAmount : 1.0)
                                .saturation(selectedFlag != number ? saturationAmount : 1.0)
                                .rotation3DEffect(.degrees(selectedFlag == number ? rotationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: checkScore)
        } message: {
            Text("\(correctMessage.count > 0 ? correctMessage + "\n" : "")Your score is \(correctMessage.count > 0 ? "still" : "now") \(score)")
        }
        .alert("Game over!", isPresented: $gameFinished) {
            Button("Restart", action: restartGame)
        } message: {
            Text("Congrats, your final score is \(score)!")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        
        withAnimation(.easeInOut(duration: 0.5)) {
            rotationAmount += 360
            opacityAmount = 0.25
            scaleAmount = 0.7
            saturationAmount = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if number == correctAnswer {
                scoreTitle = "Correct"
                correctMessage = ""
                score += 1
            } else {
                scoreTitle = "Wrong"
                correctMessage = "This is the flag of \(countries[number])"
            }
            
            showingScore = true
            questions += 1
        }
    }
    
    func checkScore() {
        if questions > 7 {
            gameFinished = true
        } else {
            askQuestion()
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
        rotationAmount = 0
        opacityAmount = 1
        scaleAmount = 1
        saturationAmount = 1
    }
    
    func restartGame() {
        questions = 0
        score = 0
        gameFinished = false
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
