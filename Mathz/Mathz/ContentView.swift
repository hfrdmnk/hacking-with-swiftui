//
//  ContentView.swift
//  Mathz
//
//  Created by Dominik Hofer on 25.07.22.
//

import SwiftUI

struct Question {
    var questionLabel: String
    var answer: Int
}

struct ContentView: View {
    @State private var gameStarted = false
    @State private var upTo = 8
    @State private var numQuestions = 10
    @State private var currentQuestion = 0
    @State private var score = 0
    @State private var questions = [Question]()
    @State private var answerInput = ""
    @State private var correctAnswer = true
    var answerMessage: String {
        if correctAnswer {
            return "Right 👏"
        } else {
            return "Wrong 👎"
        }
    }
    var gameFinished: Bool {
        if currentQuestion == numQuestions {
            return true
        } else {
            return false
        }
    }
    
    
    @State private var cardFlipped = false
    @State private var cardRotation = 0.0
    @State private var contentRotation = 0.0
    
    let numQuestionsSelection = [5, 10, 20]
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Mathz")
                    .font(.largeTitle.bold())
                
                Spacer()
                
                if gameStarted {
                    VStack {
                        Text("\(score)/\(numQuestions)")
                            .font(.title2.bold())
                        Text("Score")
                    }
                }
            }
            .padding()
            
            if !gameStarted {
                VStack {
                    Form {
                        Section("I want to train multiplications up to:") {
                            HStack {
                                Text("Maximum is \(upTo) x \(upTo)")
                                
                                Spacer()
                                
                                Stepper("Generate questions up to", value: $upTo, in: 2...12)
                                    .labelsHidden()
                            }
                        }
                        
                        Section("I want to answer this many questions:") {
                            Picker("Tip percentage", selection: $numQuestions) {
                                ForEach(numQuestionsSelection, id: \.self) {
                                    Text(String($0))
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                    .onAppear {
                        UITableView.appearance().backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03)
                    }
                    .onDisappear {
                        UITableView.appearance().backgroundColor = .systemGroupedBackground
                    }
                    
                    Spacer()
                    
                    Group {
                        Button("Let's gooo 🤓") {
                            startGame()
                        }
                        .font(.body.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.875, green: 1, blue: 0))
                        .foregroundColor(.primary)
                        .cornerRadius(5)
                    }
                    .padding()
                }
                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.03))
            } else {
                VStack(spacing: 48) {
                    ZStack {
                        if !cardFlipped {
                            VStack {
                                Text(!gameFinished ? "\(questions[currentQuestion].questionLabel) =" : "Game finished")
                                    .font(.caption)
                                    .opacity(0.7)
                                
                                Spacer()
                                
                                Text(!gameFinished ? answerInput : "You scored \(score) out of \(numQuestions), congrats 🥳")
                                    .font(.title.bold())
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(gameFinished ? Color(red: 0.875, green: 1, blue: 0) : .clear)
                        } else {
                            VStack {
                                Spacer()
                                
                                Text(answerMessage)
                                    .font(.largeTitle.bold())
                                
                                Spacer()
                                
                                Text("\(questions[currentQuestion].questionLabel) = \(questions[currentQuestion].answer)")
                                    .font(.caption)
                                    .opacity(0.7)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(correctAnswer ? Color(red: 0.875, green: 1, blue: 0) : Color(red: 1, green: 0.012, blue: 0.243))
                            .foregroundColor(correctAnswer ? .black : .white)
                        }
                    }
                    .rotation3DEffect(.degrees(contentRotation), axis: (x: 0, y: 1, z: 0))
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0, green: 0, blue: 0, opacity: 0.05))
                    .cornerRadius(16)
                    .rotation3DEffect(.degrees(cardRotation), axis: (x: 0, y: 1, z: 0))
                    
                    Spacer()
                    
                    if !cardFlipped && !gameFinished {
                        VStack(spacing: 16) {
                            ForEach(1..<4, id: \.self) { index in
                                let outerNum = 4 - index
                                
                                HStack(spacing: 32) {
                                    let startingRange = 3 * outerNum - 2
                                    
                                    ForEach(0..<3, id: \.self) { index in
                                        //                                    let innerNum = startingRange + index
                                        
                                        Button(String(index + startingRange)) {
                                            buttonTapped(num: index + startingRange)
                                        }
                                        .frame(maxWidth: 36, maxHeight: 36)
                                        .padding()
                                        .background(Color(red: 0, green: 0, blue: 0, opacity: 0.05))
                                        .foregroundColor(.black)
                                        .clipShape(Circle())
                                    }
                                    
                                }
                            }
                            
                            HStack(spacing: 32) {
                                Button("Del") {
                                    buttonTapped(isDelete: true)
                                }
                                .frame(maxWidth: 36, maxHeight: 36)
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.05))
                                .foregroundColor(.black)
                                .clipShape(Circle())
                                
                                Button("0") {
                                    buttonTapped(num: 0)
                                }
                                .frame(maxWidth: 36, maxHeight: 36)
                                .padding()
                                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.05))
                                .foregroundColor(.black)
                                .clipShape(Circle())
                                
                                Button("=") {
                                    buttonTapped(isEnter: true)
                                }
                                .frame(maxWidth: 36, maxHeight: 36)
                                .padding()
                                .background(Color(red: 0.875, green: 1, blue: 0))
                                .foregroundColor(.black)
                                .clipShape(Circle())
                            }
                            
                        }
                        .transition(.asymmetric(insertion: .opacity.animation(.easeInOut(duration: 0.25).delay(0.25)), removal: .opacity.animation(.easeInOut(duration: 0.25))))
                    } else {
                        if !gameFinished {
                            Button("Next question 👉") {
                                nextQuestion()
                            }
                            .font(.body.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.875, green: 1, blue: 0))
                            .foregroundColor(.primary)
                            .cornerRadius(5)
                            .transition(.asymmetric(insertion: .scale.animation(.easeInOut(duration: 0.25).delay(0.25)), removal: .scale.animation(.easeInOut(duration: 0.25))))
                        } else {
                            Button("Restart game 🙌") {
                                restart()
                            }
                            .font(.body.bold())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.875, green: 1, blue: 0))
                            .foregroundColor(.primary)
                            .cornerRadius(5)
                            .transition(.scale.animation(.easeInOut(duration: 0.5)))
                        }
                        
                    }
                }
                .padding()
                .frame(maxHeight: .infinity)
                .background(Color(red: 0, green: 0, blue: 0, opacity: 0.03))
            }
        }
    }
    
    func startGame() {
        var num1, num2, result: Int
        var question: Question
        
        for _ in 0..<numQuestions {
            num1 = Int.random(in: 1...upTo)
            num2 = Int.random(in: 1...upTo)
            result = num1 * num2
            
            question = Question(questionLabel: "\(num1) x \(num2)", answer: result)
            
            questions.append(question)
        }
        
        gameStarted = true
    }
    
    func restart() {
        score = 0
        currentQuestion = 0
        questions = [Question]()
        gameStarted = false
    }
    
    func flipCard(nextQuestion: Bool = false) {
        let animationTime = 0.5
        
        withAnimation(.easeInOut(duration: animationTime)) {
            cardRotation += 180
        }
        
        withAnimation(.easeInOut(duration: 0.001).delay(animationTime / 2)) {
            contentRotation += 180
            cardFlipped.toggle()
            
            if nextQuestion {
                currentQuestion += 1
                answerInput = ""
            }
        }
    }
    
    func buttonTapped(num: Int? = nil, isDelete: Bool = false, isEnter: Bool = false) {
        if(isDelete && answerInput.count > 0) {
            answerInput.remove(at: answerInput.index(before: answerInput.endIndex))
            return
        }
        
        if(isEnter && answerInput.count > 0) {
            checkAnswer()
            return
        }
        
        if(answerInput.count < 3) {
            if let input = num {
                answerInput += String(input)
            }
        }
    }
    
    func checkAnswer() {
        if(Int(answerInput) == questions[currentQuestion].answer) {
            correctAnswer = true
            score += 1
        } else {
            correctAnswer = false
        }
        
        flipCard()
    }
    
    func nextQuestion() {
        flipCard(nextQuestion: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
