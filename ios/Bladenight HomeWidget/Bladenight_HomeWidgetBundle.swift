//
//  Bladenight_HomeWidgetBundle.swift
//  Bladenight HomeWidget
//
//  Created by Lars Huth on 16.01.25.
//

import WidgetKit
import SwiftUI

@main
struct Bladenight_HomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        Bladenight_HomeWidget()
        Bladenight_HomeWidgetControl()
        Bladenight_HomeWidgetLiveActivity()
    }
}
