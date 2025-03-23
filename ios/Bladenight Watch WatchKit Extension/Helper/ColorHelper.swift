//
//  ColorHelper.swift
//  Bladenight Watch WatchKit Extension
//
//  Created by Lars Huth on 23.03.25.
//

import Foundation
import SwiftUICore

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
