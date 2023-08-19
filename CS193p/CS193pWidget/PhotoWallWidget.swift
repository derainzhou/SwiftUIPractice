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
        // 1.0 初始旋转矩阵(假设)
        let size = CGSize(width: 120, height: 120)
        // 10s内转动360度, 单次角度36
        let radians = CGFloat(Angle.degrees(30).radians)
//        let rMatrix = CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0)
//            .rotated(by: radians)
//            .translatedBy(x: -size.width / 2.0, y: -size.height / 2.0)
        
        let rMatrix = CGAffineTransform(rotationAngle: radians)
        // let rMatrix = CGAffineTransformMakeRotation(radians)
        
        // 2.0 目标矩阵, 每次向右平移10px
        let targetMatrix = CGAffineTransform(a: 0, b: -1, c: 1, d: 0, tx: 0, ty: 0)
        
        // 3.0 转换矩阵 = rMatrix^-1 * targetMatrix
        // let transform = rMatrix.inverted().concatenating(targetMatrix)
    
        return VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(entry.imgName, bundle: nil)
                    .resizable()
                    .frame(width: 120, height: 120, alignment: .center)
                    .background(Color.yellow)
                    ._clockHandRotationEffect(.custom(10), in: .current, anchor: .center)
                    .transformEffect(targetMatrix)
                    
                /*
                 ._clockHandRotationEffect(.custom(10), in: .current, anchor: .center)
                 .scaleEffect(x:1, y: 2, anchor: .trailing)
                 */
                
                Spacer()
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

        
        /*
        let size = CGSize(width: 150, height: 150)
        let radians = CGFloat(Angle.degrees(-6.0).radians)
        let transform = CGAffineTransform(translationX: size.width / 2.0, y: size.height / 2.0)
        .rotated(by: radians)
        .translatedBy(x: -size.width / 2.0, y: -size.height / 2.0)
        
        return VStack(alignment: .leading) {
            HStack {
                Spacer()
                Text("测试文本测试文本!")
                    .background(.red)
                    ._clockHandRotationEffect(.secondHand, in: .current, anchor: .center)
                    .scaleEffect(CGSize(width: 2.0, height: 1.0))
                Spacer()
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }*/
}

struct PhotoWallWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PhotoWallWidget", provider: PhotoWallProvider()) { entry in
            PhotoWallWidgetEntryView(entry: entry)
        }
        .contentMarginsDisabled()
    }
}
    
/*
#Preview(as: .systemLarge, widget: {
    PhotoWallWidget()
}, timeline: {
    PhotoWallEntry(imgName: "IMG_6987")
})
 */

struct PhotoWallWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = PhotoWallWidgetEntryView(entry: PhotoWallEntry(imgName: "IMG_6987"))
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

