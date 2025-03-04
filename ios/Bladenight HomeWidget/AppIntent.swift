//
//  AppIntent.swift
//  Bladenight HomeWidget
//
//  Created by Lars Huth on 16.01.25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "Bladenight Widget" }

    // An example configurable parameter.
    @Parameter(title: "BladeNight",default: "BladeNight")
    var favoriteEmoji: String
}
