//
//  AddBookView.swift
//  Bookworm
//
//  Created by Dominik Hofer on 15.08.22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
    
    private var formFilledOut: Bool {
        title.isEmpty || author.isEmpty || genre.isEmpty
    }
    
    @State private var showErrorAlert = false
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
//                        if title.isEmpty || author.isEmpty || genre.isEmpty {
//                            showErrorAlert = true
//                            return
//                        }
                        
                        let newBook = Book(context: moc)
                        
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.genre = genre
                        newBook.review = review
                        newBook.date = Date.now
                        
                        try? moc.save()
                        
                        dismiss()
                    }
                    .disabled(formFilledOut)
                }
            }
            .navigationTitle("Add Book")
//            .alert("Please fill out all fields!", isPresented: $showErrorAlert) {
//                Button("Ok") { }
//            }
        }
        
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
