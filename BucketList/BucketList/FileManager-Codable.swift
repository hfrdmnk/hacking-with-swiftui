//
//  FileManager-Load.swift
//  BucketList
//
//  Created by Dominik Hofer on 31.08.22.
//

import Foundation

extension FileManager {
    func documentsDirectory() -> URL {
       self.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func decode<T: Decodable>(from file: String) -> T {
        let url = documentsDirectory().appendingPathComponent(file)
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(url).")
        }
        
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(url).")
        }
        
        return result
    }
    
    func encode<T: Encodable>(content: T, to file: String) {
        guard let encodedContent = try? JSONEncoder().encode(content) else {
            fatalError("Failed to encode data.")
        }
        
        let url = documentsDirectory().appendingPathComponent(file)
        
        guard let result = try? encodedContent.write(to: url, options: .atomic) else {
            fatalError("Failed to encode data.")
        }
    }
}
