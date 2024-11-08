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
import Photos
 
 
// MARK: - PhotoWallProvider
struct PhotoWallProvider: TimelineProvider {
    public typealias Entry = PhotoWallEntry
    
    func placeholder(in context: Context) -> PhotoWallEntry {
        PhotoWallEntry(date: Date.now, photoIdentifiers: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PhotoWallEntry) -> Void) {
        let entry = PhotoWallEntry(date: Date.now, photoIdentifiers: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoWallEntry>) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var identifiers: [String] = []
        
        // 只存储标识符
        assets.enumerateObjects { asset, _, _ in
            identifiers.append(asset.localIdentifier)
        }
        
        let entry = PhotoWallEntry(
            date: Date(),
            photoIdentifiers: identifiers
        )
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}


// MARK: - CaffeineTrackerWidget

struct PhotoWallEntry: TimelineEntry {
    let date: Date
    let photoIdentifiers: [String]  // 存储照片标识符
}

struct PhotoWallWidgetEntryView: View {
    @Environment(\.widgetFamily) var family // 获取 widget 尺寸
    var entry: PhotoWallEntry
    
    func loadImage(identifier: String) -> UIImage? {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        guard let asset = result.firstObject else { return nil }
        
        var resultImage: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic  // 改用高质量图片
        
        // 根据 widget 尺寸请求合适大小的图片
        // let targetSize = family == .systemSmall ? CGSize(width: 158, height: 158) : CGSize(width: 338, height: 158)
        let targetSize = CGSize(width: 300, height: 300)
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            resultImage = image
        }
        
        return resultImage
    }
    
    var body: some View {
        let firstIdentifier = entry.photoIdentifiers.first
        if let firstIdentifier = firstIdentifier,
           let image = loadImage(identifier: firstIdentifier) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit) // 填充模式
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 填充整个空间
                .clipped() // 裁剪超出部分
                .containerBackground(.fill.tertiary, for: .widget)
        } else {
            Text(firstIdentifier ?? "no image")
                .containerBackground(.fill.tertiary, for: .widget)
        }
        
    }
}

struct PhotoWallWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "PhotoWallWidget", provider: PhotoWallProvider()) { entry in
            PhotoWallWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("照片墙")
        .description("显示最新照片")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge]) // 支持的尺寸
        .contentMarginsDisabled()
    }
}
    
/*
#Preview(as: .systemLarge, widget: {
    PhotoWallWidget()
}, timeline: {
    PhotoWallEntry(photoIdentifiers: [])
})
 */

struct PhotoWallWidget_Previews: PreviewProvider {
    static var previews: some View {
        let view = PhotoWallWidgetEntryView(entry: PhotoWallEntry(date: .now, photoIdentifiers: []))
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

