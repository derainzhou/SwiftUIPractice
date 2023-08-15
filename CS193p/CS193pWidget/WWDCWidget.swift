//
//  CS193pWidget.swift
//  CS193pWidget
//
//  Created by WisidomCleanMaster on 2023/7/19.
//

///
/// 测试AppIntent发起网络

import WidgetKit
import SwiftUI
import AppIntents

// MARK: - FetchDataManager
class FetchDataManager {
    static let shared = FetchDataManager()
    var episodes: [MiniEpisode]?
    
    var domainFilters: [String: Bool] = [
      "1": true,
      "2": false,
      "3": false,
      "5": false,
      "8": false,
      "9": false
    ]
    var difficultyFilters: [String: Bool] = [
      "advanced": false,
      "beginner": true,
      "intermediate": false
    ]

    func queryDomain(_ id: String) -> URLQueryItem {
      URLQueryItem(name: "filter[domain_ids][]", value: id)
    }

    func queryDifficulty(_ label: String) -> URLQueryItem {
      URLQueryItem(name: "filter[difficulties][]", value: label)
    }

    func clearQueryFilters() {
      domainFilters.keys.forEach { domainFilters[$0] = false }
      difficultyFilters.keys.forEach { difficultyFilters[$0] = false }
    }

    let filtersDictionary = [
      "1": "iOS & Swift",
      "2": "Android & Kotlin",
      "3": "Unity",
      "5": "macOS",
      "8": "Server-Side Swift",
      "9": "Flutter",
      "advanced": "Advanced",
      "beginner": "Beginner",
      "intermediate": "Intermediate"
    ]

    // 1
    let baseURLString = "https://api.raywenderlich.com/api/contents"
    // use baseParams dictionary for free, episode, sort, page size, search term
    var baseParams = [
      "filter[subscription_types][]": "free",
      "filter[content_types][]": "episode",
      "sort": "-popularity",
      "page[size]": "20",
      "filter[q]": ""
    ]
    // 2
    func fetchContents(_ completion: @escaping ([MiniEpisode]?) -> Void) {
      guard var urlComponents = URLComponents(string: baseURLString) else {
          completion(nil)
          return
      }
      urlComponents.setQueryItems(with: baseParams)
      let selectedDomains = domainFilters.filter {
        $0.value
      }
      .keys
      let domainQueryItems = selectedDomains.map {
        queryDomain($0)
      }

      let selectedDifficulties = difficultyFilters.filter {
        $0.value
      }
      .keys
      let difficultyQueryItems = selectedDifficulties.map {
        queryDifficulty($0)
      }

      // swiftlint:disable:next force_unwrapping
      urlComponents.queryItems! += domainQueryItems
      // swiftlint:disable:next force_unwrapping
      urlComponents.queryItems! += difficultyQueryItems
      guard let contentsURL = urlComponents.url else {
          completion(nil)
          return
      }
      print(contentsURL)

        URLSession.shared.dataTask(with: contentsURL) { data, response, error in
            if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)
                if let decodedResponse = try? JSONDecoder().decode(  // 1
                    EpisodeStore.self, from: data) {
                    DispatchQueue.main.async {
                        let episodes = decodedResponse.episodes.map {
                            MiniEpisode(
                                id: $0.id,
                                name: $0.name,
                                released: $0.released,
                                domain: $0.domain,
                                difficulty: $0.difficulty ?? "",
                                description: $0.description)
                        }
                        completion(episodes)
                    }
                    return
                }
            }
            completion(nil)
        }
        .resume()
    }
    func fetchEpisodes() async {
       await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                self.fetchContents { episodes in
                    self.episodes = episodes
                    continuation.resume()
                }
            }
        }
    }
}


// MARK: - AppIntents

struct FetchDataIntent: AppIntent {
    static var title: LocalizedStringResource = "Fetch Data Intent"

    init() {}
    func perform() async throws -> some IntentResult {
        await FetchDataManager.shared.fetchEpisodes()
        return .result()
    }
}


// MARK: - TimelineProvider
struct WWDCWidgetProvider: TimelineProvider {
    typealias Entry = SmallWidgetSimpleEntry
    
    let sampleEpisode = MiniEpisode(
      id: "5117655",
      name: "SwiftUI vs. UIKit",
      released: "Sept 2019",
      domain: "iOS & Swift",
      difficulty: "beginner",
      description: "Learn about the differences between SwiftUI and UIKit, " +
        "and whether you should learn SwiftUI, UIKit, or both.\n")
    
    /// 占位视图
    func placeholder(in context: Context) -> SmallWidgetSimpleEntry {
        SmallWidgetSimpleEntry(date: Date(), episode: sampleEpisode)
    }

    /// 快照
    func getSnapshot(in context: Context, completion: @escaping (SmallWidgetSimpleEntry) -> Void) {
        let entry = SmallWidgetSimpleEntry(date: Date(), episode: sampleEpisode)
        completion(entry)
    }

    /// Timeline, 提供entries
    func getTimeline(in context: Context, completion: @escaping (Timeline<SmallWidgetSimpleEntry>) -> Void) {
        
        // 创建timeline
        var entries: [SmallWidgetSimpleEntry] = []
        guard let episodes = FetchDataManager.shared.episodes else {
            let entry = SmallWidgetSimpleEntry(date: Date(), episode: sampleEpisode)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .never)
            completion(timeline)
            return
        }
        
        print("episodes: \(episodes.count)")
        let currentDate = Date()
        let interval = 3
        for index in 0 ..< episodes.count {
            let entryDate = Calendar.current.date(byAdding: .second, value: index * interval, to: currentDate)!
            let entry = SmallWidgetSimpleEntry(date: entryDate, episode: episodes[index])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}


struct WWDCWidgetEntryView : View {
    // 获取小组件尺寸, 不同尺寸展示不同视图
    @Environment(\.widgetFamily) var family
    
    var entry: CS193pSmallWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 6.0) {
            HStack() {
                Spacer()
                Button(intent: FetchDataIntent()) {
                    Text("刷新数据")
                        .font(.system(size: 14))
                        .padding(.init(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(5)
                }
                .buttonStyle(.plain)
            }

            HStack {
                PlayButtonIcon(width: 50, height: 50, radius: 10)
                    .unredacted()
                VStack(alignment: .leading) {
                    Text(entry.episode.name)
                        .font(.headline)
                        .fontWeight(.bold)
                    HStack {
                        Text(entry.episode.released + " ")
                        Text(entry.episode.domain + " ")
                        Text(entry.episode.difficulty.capitalized)
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
struct WWDCWidget: Widget {
    let kind: String = "WWDCWidget"

    var body: some WidgetConfiguration {        
        StaticConfiguration(kind: kind, provider: WWDCWidgetProvider()) { entry in
            WWDCWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies(supportedFamilies)
    }
    
    private var supportedFamilies: [WidgetFamily] {
        [.systemMedium, .systemLarge]
    }
    
}

struct WWDCWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = WWDCWidgetEntryView(entry: SmallWidgetSimpleEntry(date: Date(), episode: WWDCWidgetProvider().sampleEpisode))
        
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
