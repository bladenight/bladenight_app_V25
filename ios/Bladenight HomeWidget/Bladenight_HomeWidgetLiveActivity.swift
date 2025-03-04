//
//  Bladenight_HomeWidgetLiveActivity.swift
//  Bladenight HomeWidget
//
//  Created by Lars Huth on 16.01.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Bladenight_HomeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Bladenight_HomeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Bladenight_HomeWidgetAttributes.self) { context in
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

extension Bladenight_HomeWidgetAttributes {
    fileprivate static var preview: Bladenight_HomeWidgetAttributes {
        Bladenight_HomeWidgetAttributes(name: "World")
    }
}

extension Bladenight_HomeWidgetAttributes.ContentState {
    fileprivate static var smiley: Bladenight_HomeWidgetAttributes.ContentState {
        Bladenight_HomeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Bladenight_HomeWidgetAttributes.ContentState {
         Bladenight_HomeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Bladenight_HomeWidgetAttributes.preview) {
   Bladenight_HomeWidgetLiveActivity()
} contentStates: {
    Bladenight_HomeWidgetAttributes.ContentState.smiley
    Bladenight_HomeWidgetAttributes.ContentState.starEyes
}
