//
//  Contact.swift
//  Connector
//
//  Created by Dominik Hofer on 12.09.22.
//

import Foundation
import SwiftUI

struct Contact: Identifiable, Codable, Comparable {
    var id = UUID().uuidString
    var name: String
    var company: String
    
    var image: Image? {
        let url = self.getDocumentsDirectory().appendingPathComponent("\(id)-photo.jpg")
        
        guard let uiImage = try? UIImage(data: Data(contentsOf: url)) else {
            print("Error creating UIImage from url \(url)")
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
    
    static let example = Contact(name: "Dominik Hofer", company: "BTW")
    
    func writeToSecureDirectory(uiImage: UIImage) {
        let imageSaver = ImageSaver()
        let _ = imageSaver.writeToSecureDirectory(uiImage: uiImage, name: "\(id)-photo")
    }
    
    func deleteFromSecureDirectory() {
        let imageSaver = ImageSaver()
        let _ = imageSaver.deleteFromSecureDirectory(name: "\(id)-photo")
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    static func < (lhs: Contact, rhs: Contact) -> Bool {
        lhs.name < rhs.name
    }
}
