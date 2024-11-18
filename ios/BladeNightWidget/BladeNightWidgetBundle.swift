//
//  BladeNightWidgetBundle.swift
//  BladeNightWidget
//
//  Created by Lars Huth on 29.10.24.
//

import WidgetKit
import SwiftUI

@main
struct BladeNightWidgetBundle: WidgetBundle {
    var body: some Widget {
        BladeNightWidget()
        BladeNightWidgetControl()
        BladeNightWidgetLiveActivity()
    }
}
