//
//  AddView.swift
//  Connector
//
//  Created by Dominik Hofer on 12.09.22.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    let vm: ContentView.ViewModel
    let locationFetcher: LocationFetcher
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var name: String = ""
    @State private var company: String = ""
    @State private var longitude: Double?
    @State private var latitude: Double?
    
    @State private var showingErrorAlert = false
    @State private var errorAlertTitle = ""
    @State private var errorAlertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        if let imageData, let uiImage = UIImage(data: imageData) {
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .mask(RoundedRectangle(cornerRadius: 4))
                        }
                        
                        PhotosPicker(selection: $selectedImage, matching: .images, photoLibrary: .shared()) {
                            Text("Select a photo")
                        }
                        .onChange(of: selectedImage) { newImage in
                            Task {
                                if let data = try? await newImage?.loadTransferable(type: Data.self) {
                                    imageData = data
                                }
                            }
                        }
                    }
                }
                
                Section("Infos") {
                    TextField("Name", text: $name)
                    TextField("Company", text: $company)
                }
            }
            .navigationTitle("Add new connection")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem {
                    Button("Save") {
                        guard let imageData else { return }
                        
                        if let saveImage = UIImage(data: imageData) {
                            if !name.isEmpty && !company.isEmpty {
                                let id = UUID().uuidString
                                
                                if let location = locationFetcher.lastKnownLocation {
                                    latitude = location.latitude
                                    longitude = location.longitude
                                } else {
                                    print("Failed to access location :(")
                                }
                                
                                let newContact = Contact(id: id, name: name, company: company, latitude: latitude, longitude: longitude)
                                
                                newContact.writeToSecureDirectory(uiImage: saveImage)
                                
                                vm.addContact(newContact)
                                
                                dismiss()
                            } else {
                                errorAlertTitle = "Oops…"
                                errorAlertMessage = "Please provide a photo, name and company!"
                                showingErrorAlert = true
                            }
                        }
                    }
                    .buttonStyle(.bordered)
                    .alert(errorAlertTitle, isPresented: $showingErrorAlert) {
                        Button("Ok", role: .cancel) { }
                    } message: {
                        Text(errorAlertMessage)
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(vm: ContentView.ViewModel(), locationFetcher: LocationFetcher())
    }
}
