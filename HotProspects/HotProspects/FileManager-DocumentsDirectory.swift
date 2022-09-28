//
//  FileManager-DocumentsDirectory.swift
//  HotProspects
//
//  Created by Dominik Hofer on 27.09.22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
