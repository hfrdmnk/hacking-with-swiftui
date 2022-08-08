//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Dominik Hofer on 11.07.22.
//

import SwiftUI

struct ContentView: View {
    let moves = ["🪨", "🧻", "✂️"]
    let winningMoves = ["🪨": "🧻", "🧻": "✂️", "✂️": "🪨"]
    
    @State private var userChoice = ""
    @State private var computerChoice = ""
    @State private var shouldWin = Bool.random()
    @State private var correct = true
    @State private var score = 0
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.mint, .white]), center: .bottom, startRadius: 4, endRadius: 400)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Text("The computer chose \(computerChoice)")
                            .font(.title.bold())
                        Text("Try to \(shouldWin ? "win" : "loose") this round!")
                            .font(.body.bold())
                    }
                    
                    HStack(spacing: 20) {
                        ForEach(moves, id: \.self) { move in
                            Button(move) {
                                userChoice = move
                                checkWinner()
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.mint, lineWidth: 1)
                            )
                        }
                    }
                    
                    Text("Score: \(score)")
                        .font(.title3.bold())
                }
                .navigationTitle("Rock, Paper, Scissors")
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 1, green: 1, blue: 1, opacity: 0.5))
                .cornerRadius(20)
                .shadow(color: Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.05), radius: 10, x: 0, y: 10)
            .padding()
            }
        }.onAppear {
            computerChoice = selectRandomMove()
        }
        .alert("\(correct ? "Right!" : "Wrong…")", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                newRound()
            }
        }
    }
    
    func selectRandomMove() -> String {
        moves[Int.random(in: 0..<moves.count)]
    }
    
    func checkWinner() {
        let winningMove = winningMoves[computerChoice] ?? "not found"
        let hasWon: Bool
        
        if userChoice == winningMove {
            hasWon = true
        } else {
            hasWon = false
        }
        
        if(hasWon == shouldWin) {
            score += 1
            correct = true
        } else {
            correct = false
        }
        
        showAlert = true
    }
    
    func newRound() {
        computerChoice = selectRandomMove()
        shouldWin.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
