//
//  CaffeineTrackerWidget.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/11.
//

///
/// 照片墙小组件

import WidgetKit
import SwiftUI
 
// MARK: - RotationEffect
struct RotationEffect: GeometryEffect {
    var angle: Double
    
    var animatableData: Double {
        get {
            angle
        }
        set {
            angle = newValue
        }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let radians = CGFloat(Angle.degrees(angle).radians)
        let transform = CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0)
            .rotated(by: radians)
            .translatedBy(x: -size.width / 2.0, y: -size.height / 2.0)
        print("angle: \(angle)")
        return ProjectionTransform(transform)
    }
}
 
// MARK: - CaffeineIntentProvider
struct PhotoWallProvider: TimelineProvider {
    public typealias Entry = PhotoWallEntry
    
    func placeholder(in context: Context) -> PhotoWallEntry {
        PhotoWallEntry(imgName: "IMG_6987")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PhotoWallEntry) -> Void) {
        let entry = PhotoWallEntry(imgName: "IMG_6987")
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoWallEntry>) -> Void) {
        let entry = PhotoWallEntry(imgName: "IMG_6987")
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}


// MARK: - CaffeineTrackerWidget

struct PhotoWallEntry: TimelineEntry {
    let date: Date = Date()
    let imgName: String
}

struct PhotoWallWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: PhotoWallEntry

    var body: some View {
        return VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(entry.imgName, bundle: nil)
                    .resizable()
                    .scaledToFill()
                    ._clockHandRotationEffect(.secondHand, in: .current, anchor: .center)
                    .modifier(RotationEffect(angle: 90))
                   // .animation(.default)
                Spacer()
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct PhotoWallWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PhotoWallWidget", provider: PhotoWallProvider()) { entry in
            PhotoWallWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemMedium, widget: {
    PhotoWallWidget()
}, timeline: {
    PhotoWallEntry(imgName: "IMG_6987")
})

