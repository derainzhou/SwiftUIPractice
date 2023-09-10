//
//  CaffeineTrackerWidget.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/11.
//

///
/// Button样式可交互小组件

import WidgetKit
import SwiftUI
import AppIntents


// MARK: - Moment Publish
@available(iOS 16, *)
struct Moment {
    let feeling: String
    let doing: String
}

enum MomentType: String {
    
    // feeling
    case happy = "happy",       good = "good",       delighted = "delighted",    energetic = "energetic"
    case grin = "grin",         excited = "excited", infatuated = "infatuated",  starStruck = "starStruck"
    case unhappy = "unhappy",   sad = "sad",          tired = "tired",           dizzy = "dizzy"
    
    // doing
    case working = "working",   relaxing = "relaxing"
    case Active = "Active",     dating = "dating"
    case sleeping = "sleeping",  shoping = "shoping"
    
    
    static var feelingCases: [String] {
        return [
            "happy", "good", "delighted", "energetic",
            "grin", "excited", "infatuated", "starStruck",
            "unhappy", "sad", "tired", "dizzy"
        ]
    }
    
    static var doingCases: [String] {
        return [
            "working", "relaxing",
            "Active", "dating",
            "sleeping", "shoping",
        ]
    }
    
    var moment: Moment {
        Moment(feeling: self.rawValue, doing: "--")
    }
}

struct MomentPublishedBtn: View {
    private let momentType: MomentType
    
    init(momentType: MomentType) {
        self.momentType = momentType
    }
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            // Button
            Button(intent: MomentPublishedIntent(momentType: momentType.rawValue)) {
                Text(momentType.rawValue)
                    .font(.system(size: 14))
                    .frame(width: 70, height: 50)
                    .foregroundColor(.white)
                    .background(.red)
            }
        }
    }
}

struct MomentPublishedIntent: AppIntent {
    static var title: LocalizedStringResource = "MomentPublished"
    static var description = IntentDescription("MomentPublished")
    
    @Parameter(title: "Moment")
    var momentType: String

    init() {}

    init(momentType: String) {
        self.momentType = momentType
    }
    
    func perform() async throws -> some IntentResult {
        /// 发布朋友圈
        let type = MomentType(rawValue: momentType)
        MomentOpStore.shared.currentMomentType = type!
        
        // 刷新界面
        MomentOpStore.shared.currentEntryType = .moment
        return .result()
    }
}


// MARK: - PanelButton
enum IntentType: String {
    case doing = "doing"
    case feeling = "feeling"
}
struct PanelButton: View {
    private let type: IntentType
    
    init(type: IntentType) {
        self.type = type
    }
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            // Button
            Button(intent: PanelButtonIntent(type: type.rawValue)) {
                Text(type.rawValue)
                    .font(.system(size: 14))
                    .frame(width: 50, height: 50)
                    .padding(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(5)
            }
        }
    }
}


// MARK: - AppIntentsProvider
class MomentOpStore {
    public static let shared = MomentOpStore()
    public var currentEntryType: MomentEntryType = .moment
    public var currentMomentType: MomentType = .happy
}

struct PanelButtonIntent: AppIntent {
    static var title: LocalizedStringResource = "PanelButtonIntent"
    static var description = IntentDescription("PanelButtonIntent.")
    
    @Parameter(title: "Moment type")
    var type: String

    init() {}

    init(type: String) {
        self.type = type
    }
    
    func perform() async throws -> some IntentResult {
        /// 更新数据
        let type = IntentType(rawValue: type)
        switch type {
        case .doing: MomentOpStore.shared.currentEntryType = .doing
        case .feeling: MomentOpStore.shared.currentEntryType = .feeling
        default: break
        }
        return .result()
    }
}

// MARK: - CaffeineIntentProvider
struct MomentIntentProvider: TimelineProvider {
    
    public typealias Entry = MomentEntry
    
    func placeholder(in context: Context) -> Entry {
        let type: MomentEntryType = .moment
        return MomentEntry(date: Date(), type: type, moment: .happy)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let type: MomentEntryType = .moment
        let entry = MomentEntry(date: Date(), type: type, moment: .happy)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let type: MomentEntryType = MomentOpStore.shared.currentEntryType
        let moment: MomentType = MomentOpStore.shared.currentMomentType
        let entry = MomentEntry(date: Date(), type: type, moment: moment)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}


// MARK: - CaffeineTrackerWidget
enum MomentEntryType: String {
    case moment         = "moment"
    case doing          = "doing"
    case feeling        = "feeling"
}

struct MomentEntry: TimelineEntry {
    static let WidgetKind: String = "MomentWidget"
    let date: Date
    let type: MomentEntryType
    let moment: MomentType
}


extension View {
     func momentWidgetBackground() -> some View {
         let color = Color(red: 255, green: 247, blue: 227)
         if #available(iOSApplicationExtension 17.0, *) {
             return containerBackground(for: .widget) {
                 color
             }
         } else {
             return background {
                 color
             }
         }
    }
}

// MARK: MomentWidgetEntryView

struct MomentView: View {
    private let entry: MomentEntry
    private let moment: Moment
    
    init(entry: MomentEntry) {
        self.entry = entry
        self.moment = entry.moment.moment
    }
    
    var body: some View {
        VStack(alignment: .center, content: {
            Spacer()
            HStack {
                Spacer()
                Text("Derain")
                Spacer()
                Text(Date(), style: .time)
                Spacer()
            }
            Spacer()
            Text("今天天气真的好!").padding(10)
            HStack(alignment: .center, spacing: 20) {
                Text("status: \(moment.doing)")
                Text("feeling: \(moment.feeling)")
            }
            Spacer()
            HStack{
                Spacer()
                 PanelButton(type: .doing)
                Spacer()
                 PanelButton(type: .feeling)
                Spacer()
            }
            Spacer()
        })
    }
}

struct PanelMask: View {
    let gradientSurface = LinearGradient(colors: [.white.opacity(0.1), .clear], startPoint: .topLeading, endPoint: .bottomTrailing)
    let gradientBorder = LinearGradient(colors: [.white.opacity(0.5), .white.opacity(0.0), .white.opacity(0.0), .green.opacity(0.0), .green.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15, style: .continuous)
            .foregroundStyle(gradientSurface)
            .background(.ultraThinMaterial)
            .mask( RoundedRectangle(cornerRadius: 15, style: .circular).foregroundColor(.black) )
            .overlay(
                RoundedRectangle(cornerRadius: 15, style: .circular)
                    .stroke(lineWidth: 1.5)
                    .foregroundStyle(gradientBorder)
                    .opacity(0.8)
            )
            .frame(minWidth: .infinity, minHeight: .infinity)
            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 8)
    }
}

struct DoingPanel: View {
    let data = MomentType.doingCases
    
    let columns = [
           GridItem(.adaptive(minimum: 80))
       ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    MomentPublishedBtn(momentType: MomentType(rawValue: item)!)
                }
            }
        }
        .listRowInsets(EdgeInsets())
    }
}

struct FeelingPanel: View {
    let data = MomentType.feelingCases
    
    let columns = [
           GridItem(.adaptive(minimum: 70))
       ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(data, id: \.self) { item in
                    MomentPublishedBtn(momentType: MomentType(rawValue: item)!)
                }
            }
        }
        .listRowInsets(EdgeInsets())
    }
}

struct MomentWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: MomentEntry
    var body: some View {
        ZStack {
            MomentView(entry: entry)
            if entry.type == .doing {
                DoingPanel()
            } else if entry.type == .feeling {
                FeelingPanel()
            }
        }.momentWidgetBackground()
    }
}

struct MomentWidget: Widget {
    
    func makeWidgetConfiguration() -> some WidgetConfiguration {
        return StaticConfiguration(kind: MomentEntry.WidgetKind,
                                   provider: MomentIntentProvider()) { entry in
            MomentWidgetEntryView(entry: entry)
        }
        .supportedFamilies(supportedFamilies)

    }
    
    private var supportedFamilies: [WidgetFamily] {
        // [.systemSmall, .systemMedium, .systemLarge]
        [.systemLarge]
    }
    
    public var body: some WidgetConfiguration {
        if #available(iOS 17.0, macOS 14.0, *) {
            return makeWidgetConfiguration()
                .configurationDisplayName("Caffeine Tracker")
                .description("See your total caffeine in one day.")
                .disfavoredLocations([.standBy], for: [.systemSmall])
        } else {
           return makeWidgetConfiguration()
                .configurationDisplayName("Caffeine Tracker")
                .description("See your total caffeine in one day.")
        }
    }
}

#Preview(as: .systemLarge, widget: {
    return MomentWidget()
}, timeline: {
    let type: MomentEntryType = .moment
    return [MomentEntry(date: Date(), type: type, moment: .happy)]
})
