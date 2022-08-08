//
//  Colors.swift
//  Habitli
//
//  Created by Dominik Hofer on 08.08.22.
//

import Foundation
import SwiftUI

extension ShapeStyle where Self == Color {
    static var primaryGreen: Color {
        Color(red: 17 / 255, green: 255 / 255, blue: 123 / 255)
    }
    
    static var darkGreen: Color {
        Color(red: 89 / 255, green: 132 / 255, blue: 108 / 255)
    }
    
    static var lightGreen: Color {
        Color(red: 212 / 255, green: 255 / 255, blue: 231 / 255)
    }
    
    static var cream: Color {
        Color(red: 238 / 255, green: 248 / 255, blue: 243 / 255)
    }
    
    static var darkestGreen: Color {
        Color(red: 3 / 255, green: 44 / 255, blue: 21 / 255)
    }
}
