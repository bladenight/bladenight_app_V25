//
//  Bladenight_HomeWidget.swift
//  Bladenight HomeWidget
//
//  Created by Lars Huth on 16.01.25.
//

private let widgetGroupId = "app.huth.bn.Bladenight-HomeWidget"

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BnDataEntry {
        BnDataEntry(date: Date(),eventStatus:"?", configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async-> BnDataEntry {
            let data = UserDefaults.init(suiteName: widgetGroupId)
            let datas = BnDataEntry(date: Date(), eventStatus:data?.string(forKey: "eventStatus") ?? "No Title Set", configuration: configuration)
            return datas
        }
    
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BnDataEntry> {
        var entries: [BnDataEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = BnDataEntry(date: entryDate,eventStatus:"?", configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

//    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct BnDataEntry: TimelineEntry {
    let date: Date;
    let progress: Double = 0.0;
    let speed = 0.0;
    let odoMeter = 0.0;
    let processionLength = 0.0;
    let eventStatus :String;
    let route :String="" ;
    let eventDate:String="";
    let length:String="";
    let configuration: ConfigurationAppIntent
}

struct Bladenight_HomeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Bladenightstatus:")
            Text(entry.date, style: .time)

            Text(entry.odoMeter.formatted())
            Text(entry.route)
        }
    }
}

struct Bladenight_HomeWidget: Widget {
    let kind: String = "Bladenight_HomeWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Bladenight_HomeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    Bladenight_HomeWidget()
} timeline: {
    BnDataEntry(date: .now,eventStatus: "Started" , configuration: .smiley)
    BnDataEntry(date: .now,eventStatus: "Started" , configuration: .starEyes)
}
