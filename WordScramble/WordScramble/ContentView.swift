//
//  ContentView.swift
//  WordScramble
//
//  Created by Dominik Hofer on 15.07.22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    private var score: Int {
        var letterCount = 0
        
        for word in usedWords {
            letterCount += word.count
        }
        
        return usedWords.count * letterCount
    }
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onSubmit(addNewWord)
                }
                
                Section("Your Score:") {
                    Text("\(score)")
                        .font(.title3.bold())
                        .listRowBackground(score >= 100 ? Color(red: 0.83, green: 1.00, blue: 0.40) : Color.clear)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                                .foregroundColor(Color(red: 0.83, green: 1.00, blue: 0.40))
                            Text(word)
                                .font(.body.bold())
                                .foregroundColor(Color.white)
                        }
                        .listRowBackground(Color.primary.opacity(0.2))
                        .accessibilityElement()
                        .accessibilityLabel("\(word), \(word.count) letters")
                    }
                }
            }
            .navigationTitle(rootWord)
            .onAppear(perform: startGame)
            .toolbar {
                Button("Restart game") {
                    startGame()
                }
                .font(.body.bold())
                .foregroundColor(Color(red: 0.43, green: 0.49, blue: 0.27))
            }
            .alert(errorTitle, isPresented: $showingError) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        newWord = ""
        
        guard isAllowed(word: answer) else {
            wordError(title: "This word is not allowed", message: "Guesses have to be at least 3 letters long and can't be the original word!")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up!")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                
                usedWords.removeAll()
                
                return
            }
            
            fatalError("Could not load start.txt from bundle")
        }
    }
    
    func isAllowed(word: String) -> Bool {
        word.count > 2 && word != rootWord
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
