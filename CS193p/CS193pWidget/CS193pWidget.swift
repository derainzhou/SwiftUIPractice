//
//  CS193pWidget.swift
//  CS193pWidget
//
//  Created by WisidomCleanMaster on 2023/7/19.
//

import WidgetKit
import SwiftUI

// MARK: - TimelineProvider
struct Provider: TimelineProvider {
    // 用于占位视图与快照
    let sampleEpisode = Episode(
      id: "5117655",
      uri: "rw://betamax/videos/3021",
      name: "SwiftUI vs. UIKit",
      parentName: nil,
      released: "Sept 2019",
      difficulty: "beginner",
      description: "Learn about the differences between SwiftUI and"
        + "UIKit, and whether you should learn SwiftUI, UIKit, or "
        + "both.\n" ,
      domain: "iOS & Swift")
    
    // 实时数据, fetchContent()
    let store = EpisodeStore()
    
    /// 占位视图
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), episode: sampleEpisode)
    }

    /// 快照
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), episode: sampleEpisode)
        completion(entry)
    }

    /// Timeline, 提供entries
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let interval = 3
        for index in 0 ..< store.episodes.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: index * interval, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, episode: store.episodes[index])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK:- Entry 与 EntryView (模型与视图层)
struct SimpleEntry: TimelineEntry {
    let date: Date
    let episode: Episode
}

struct CS193pWidgetEntryView : View {
    // 获取小组件尺寸, 不同尺寸展示不同视图
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                PlayButtonIcon(width: 50, height: 50, radius: 10)
                    .unredacted()
                VStack(alignment: .leading) {
                    Text(entry.episode.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    if family != .systemSmall {
                        HStack {
                            Text(entry.episode.released + " ")
                            Text(entry.episode.domain + " ")
                            Text(entry.episode.difficulty?.capitalized ?? "")
                        }
                    } else {
                        Text(entry.episode.released + " ")
                    }
                }
                .foregroundColor(Color(.label))
            }
            
            if family != .systemSmall {
                Text(entry.episode.description)
                    .lineLimit(2)
            }
        }
        .padding(.horizontal)
        .background(Color("item-bkgd"))
        .font(.footnote)
        .foregroundColor(Color(.systemGray))
    }
}
struct CS193pWidget: Widget {
    let kind: String = "CS193pWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CS193pWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
        
    }
}

struct CS193pWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = CS193pWidgetEntryView(entry: SimpleEntry(date: Date(), episode: Provider().sampleEpisode))
        
        view.previewContext(WidgetPreviewContext(family: .systemSmall))
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
        view.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
