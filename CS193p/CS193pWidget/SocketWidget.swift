//
//  CaffeineTrackerWidget.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/11.
//

///
/// Socket通信小组件测试

import WidgetKit
import SwiftUI
 

// MARK: - CaffeineIntentProvider
struct SocketWidgetProvider: TimelineProvider {
    public typealias Entry = SocketWidgetEntry
    
    func placeholder(in context: Context) -> SocketWidgetEntry {
        SocketWidgetEntry(title: "Hello World")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SocketWidgetEntry) -> Void) {
        let entry = SocketWidgetEntry(title: "Hello World")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SocketWidgetEntry>) -> Void) {
        let entry = SocketWidgetEntry(title: UUID().uuidString)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}


// MARK: - CaffeineTrackerWidget

struct SocketWidgetEntry: TimelineEntry {
    let date: Date = Date()
    let title: String
}

struct SocketWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SocketWidgetEntry

    var body: some View {
        return VStack(alignment: .leading) {
            Text(entry.title)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct SocketWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "SocketWidget", provider: SocketWidgetProvider()) { entry in
            SocketWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
    }
}

/*
#Preview(as: .systemLarge, widget: {
    SocketWidget()
}, timeline: {
    SocketWidgetEntry(title: "Hello World")
})
 */

struct WWDCWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = SocketWidgetEntryView(entry: SocketWidgetEntry(title: "Hello World"))
        
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


