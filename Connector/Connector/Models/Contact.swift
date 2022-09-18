//
//  Contact.swift
//  Connector
//
//  Created by Dominik Hofer on 12.09.22.
//

import SwiftUI
import CoreLocation

struct Contact: Identifiable, Codable, Comparable {
    var id = UUID().uuidString
    var name: String
    var company: String
    let latitude: Double?
    let longitude: Double?
    
    var location: CLLocationCoordinate2D? {
        if let latitude = latitude, let longitude = longitude {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
    
    var image: Image? {
        if id == "portrait" {
            return Image(id)
        }
        
        let url = self.getDocumentsDirectory().appendingPathComponent("\(id)-photo.jpg")
        
        guard let uiImage = try? UIImage(data: Data(contentsOf: url)) else {
            print("Error creating UIImage from url \(url)")
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
    
    static let example = Contact(id: "portrait", name: "Dominik Hofer", company: "BTW", latitude: 46.94678, longitude: 7.44428)
    
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
