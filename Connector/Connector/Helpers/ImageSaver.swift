//
//  ImageSaver.swift
//  Connector
//
//  Created by Dominik Hofer on 12.09.22.
//

import UIKit

class ImageSaver: NSObject {
    func writeToSecureDirectory(uiImage: UIImage, name: String) -> URL? {
        if let jpegData = uiImage.jpegData(compressionQuality: 0.8) {
            let url = FileManager.documentsDirectory.appendingPathComponent("\(name).jpg")
            try? jpegData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            return url
            // What do we do about the save error?
        }
        return nil
    }
    
    func deleteFromSecureDirectory(name: String) -> Bool {
        let fileUrl = FileManager.documentsDirectory.appendingPathComponent("\(name).jpg")
        let filePath = fileUrl.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            try? fileManager.removeItem(atPath: filePath)
            // This doesn't look right
            return true
        } else {
            print("File at path \(filePath) does not exist")
            return false
        }
    }
}
