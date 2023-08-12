//
//  CS193pWidget.swift
//  CS193pWidget
//
//  Created by WisidomCleanMaster on 2023/7/19.
//

import WidgetKit
import SwiftUI
import Intents

// MARK: - TimelineProvider
struct CS193pSmallWidgetProvider: IntentTimelineProvider {

    typealias Entry = SmallWidgetSimpleEntry
    
    typealias Intent = SmallWidgetConfigurationIntent
    
    
    let sampleEpisode = MiniEpisode(
      id: "5117655",
      name: "SwiftUI vs. UIKit",
      released: "Sept 2019",
      domain: "iOS & Swift",
      difficulty: "beginner",
      description: "Learn about the differences between SwiftUI and UIKit, " +
        "and whether you should learn SwiftUI, UIKit, or both.\n")

    func readEpisodes() -> [MiniEpisode] {
      var episodes: [MiniEpisode] = []
      let archiveURL =
        FileManager.sharedContainerURL()
        .appendingPathComponent("episodes.json")
      print(">>> \(archiveURL)")

      if let codeData = try? Data(contentsOf: archiveURL) {
        do {
          episodes = try JSONDecoder().decode(
            [MiniEpisode].self,
            from: codeData)
        } catch {
          print("Error: Can't decode contents")
        }
      }
      return episodes
    }
    
    /// 占位视图
    func placeholder(in context: Context) -> SmallWidgetSimpleEntry {
        SmallWidgetSimpleEntry(date: Date(), episode: sampleEpisode)
    }

    /// 快照
    func getSnapshot(for configuration: SmallWidgetConfigurationIntent, in context: Context, completion: @escaping (SmallWidgetSimpleEntry) -> Void) {
        let entry = SmallWidgetSimpleEntry(date: Date(), episode: sampleEpisode)
        completion(entry)
    }

    /// Timeline, 提供entries
    func getTimeline(for configuration: SmallWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<SmallWidgetSimpleEntry>) -> Void) {
        
        // 创建timeline
         let episodes = readEpisodes()
        var entries: [SmallWidgetSimpleEntry] = []
        let currentDate = Date()
        let interval = 3
        for index in 0 ..< episodes.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: index * interval, to: currentDate)!
            let entry = SmallWidgetSimpleEntry(date: entryDate, episode: episodes[index])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

// MARK:- Entry 与 EntryView (模型与视图层)
struct SmallWidgetSimpleEntry: TimelineEntry {
    let date: Date
    let episode: MiniEpisode
}

extension View {
     func widgetBackground() -> some View {
         let color = Color(red: 255, green: 247, blue: 227)
         if #available(iOSApplicationExtension 17.0, *) {
             return containerBackground(for: .widget) {
                 Color("item-bkgd")
             }
         } else {
             return background {
                 Color("item-bkgd")
             }
         }
    }
}

struct CS193pWidgetSmallEntryView : View {
    // 获取小组件尺寸, 不同尺寸展示不同视图
    @Environment(\.widgetFamily) var family
    
    var entry: CS193pSmallWidgetProvider.Entry

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
                            Text(entry.episode.difficulty.capitalized)
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
        .widgetBackground()
        .font(.footnote)
        .foregroundColor(Color(.systemGray))
        .widgetURL(URL(string: "CS193p://\(entry.episode.id)"))
    }
}
struct CS193pSmallWidget: Widget {
    let kind: String = "CS193pWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SmallWidgetConfigurationIntent.self, provider: CS193pSmallWidgetProvider()) { entry in
            CS193pWidgetSmallEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct CS193pWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = CS193pWidgetSmallEntryView(entry: SmallWidgetSimpleEntry(date: Date(), episode: CS193pSmallWidgetProvider().sampleEpisode))
        
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
