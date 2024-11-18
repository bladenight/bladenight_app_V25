//
//  BladeNightWidgetLiveActivity.swift
//  BladeNightWidget
//
//  Created by Lars Huth on 29.10.24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BladeNightWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BladeNightWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BladeNightWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BladeNightWidgetAttributes {
    fileprivate static var preview: BladeNightWidgetAttributes {
        BladeNightWidgetAttributes(name: "World")
    }
}

extension BladeNightWidgetAttributes.ContentState {
    fileprivate static var smiley: BladeNightWidgetAttributes.ContentState {
        BladeNightWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BladeNightWidgetAttributes.ContentState {
         BladeNightWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BladeNightWidgetAttributes.preview) {
   BladeNightWidgetLiveActivity()
} contentStates: {
    BladeNightWidgetAttributes.ContentState.smiley
    BladeNightWidgetAttributes.ContentState.starEyes
}
