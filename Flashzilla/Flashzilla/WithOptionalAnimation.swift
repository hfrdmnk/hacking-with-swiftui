//
//  WithOptionalAnimation.swift
//  Flashzilla
//
//  Created by Dominik Hofer on 29.09.22.
//

import SwiftUI

func withOptionalAnimation<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    if UIAccessibility.isReduceMotionEnabled {
        return try body()
    } else {
        return try withAnimation(animation, body)
    }
}
