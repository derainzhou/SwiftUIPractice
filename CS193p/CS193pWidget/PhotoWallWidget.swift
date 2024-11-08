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
import AppIntents

// MARK: - PhotoOpIntent
enum PhotoOpType: String {
    case save = "save"
    case delete = "delete"
}
struct PhotoPanelButton: View {
    private let type: PhotoOpType
    
    init(type: PhotoOpType) {
        self.type = type
    }
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, *) {
            // Button
            Button(intent: PhotoOpIntent(type: type.rawValue)) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.red)
                        .frame(width: 80, height: 40)
                    
                    Text(type.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

class PhotoWallManager {
    public static let shared = PhotoWallManager()
    public var idx = 0
    private var identifiers = [String]()
    
    init() {
        identifiers = fetchImages()
    }
    
    private func fetchImages() -> [String] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        var identifiers: [String] = []
        assets.enumerateObjects { asset, _, _ in
            identifiers.append(asset.localIdentifier)
        }
        return identifiers
    }
    
    public func loadImage(identifier: String) -> UIImage? {
        let result = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        guard let asset = result.firstObject else { return nil }
        
        var resultImage: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        
        let size = 300
        let targetSize = CGSize(width: size, height: size)
        PHImageManager.default().requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: options
        ) { image, _ in
            resultImage = image?.jpegData(compressionQuality: 0.7)
                            .flatMap(UIImage.init)
        }
        
        return resultImage
    }
    
    public func save() {
        idx += 1
    }
    
    public func delete() {
        // 将照片放到回收站
        // 展示下一张照片
        idx += 1
    }
    
    public func currentPhoto() -> String? {
        guard (0..<identifiers.count).contains(idx) else {
            return nil
        }
        return identifiers[idx]
    }
}

struct PhotoOpIntent: AppIntent {
    static var title: LocalizedStringResource = "PhotoOpIntent"
    static var description = IntentDescription("PhotoOpIntent.")
    
    @Parameter(title: "Photo op type")
    var type: String

    init() {}
    init(type: String) {
        self.type = type
    }
    
    func perform() async throws -> some IntentResult {
        /// 更新数据
        let type = PhotoOpType(rawValue: type)
        switch type {
        case .save: PhotoWallManager.shared.save()
        case .delete: PhotoWallManager.shared.delete()
        default: break
        }
        return .result()
    }
}

// MARK: - PhotoPreviewView 照片预览控件
struct PhotoPreviewView: View {
    let identifier: String?
    @Environment(\.widgetFamily) var family
    
    init(identifier: String?) {
        self.identifier = identifier
    }
    
    var body: some View {
        if let identifier = identifier,
           let image = PhotoWallManager.shared.loadImage(identifier: identifier) {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
        } else {
            Text(identifier ?? "no image")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
}
    
 
// MARK: - PhotoWallWidget
struct PhotoWallProvider: TimelineProvider {
    public typealias Entry = PhotoWallEntry
    
    func placeholder(in context: Context) -> PhotoWallEntry {
        PhotoWallEntry(date: Date.now)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PhotoWallEntry) -> Void) {
        let entry = PhotoWallEntry(date: Date.now)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<PhotoWallEntry>) -> Void) {
        let entry = PhotoWallEntry(date: Date())
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}


struct PhotoWallEntry: TimelineEntry {
    let date: Date
}

struct PhotoWallWidgetEntryView: View {
    @Environment(\.widgetFamily) var family // 获取 widget 尺寸
    var entry: PhotoWallEntry
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PhotoPreviewView(identifier: PhotoWallManager.shared.currentPhoto())
            VStack() {
                Spacer()
                HStack {
                    Spacer()
                    PhotoPanelButton(type: .save)
                    Spacer()
                    PhotoPanelButton(type: .delete)
                    Spacer()
                }
                Spacer()
                    .frame(height: 20)
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
        .configurationDisplayName("照片墙")
        .description("显示最新照片")
        .supportedFamilies([.systemLarge, .systemMedium, .systemSmall]) // 支持的尺寸
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
        let view = PhotoWallWidgetEntryView(entry: PhotoWallEntry(date: .now))
        view.previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

