//
//  Hike.swift
//  CS193p
//
//  Created by DerainZhou on 2023/7/15.
//

import Foundation

// Identifiable主要用于视图更新
// Codale, Hashable主要用于编解码模型
struct Hike: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var distance: Double
    var difficulty: Int
    var observations: [Observation]
    
    static let formatter = LengthFormatter()
    var distanceText: String {
        Self.formatter
            .string(fromValue: distance, unit: .kilometer)
    }
    
    struct Observation: Codable, Hashable {
        // 距离
        var distanceFromStart: Double
        // 高度
        var elevation: Range<Double>
        // 步频
        var pace: Range<Double>
        // 心率
        var heartRate: Range<Double>
    }
}
