//
//  Landmark.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/13.
//

import SwiftUI
import Foundation
import CoreLocation

// Codable方便模型转文件, 文件转模型
struct Landmark: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var park: String
    var state: String
    var description: String
    var isFavorite: Bool
    
    // 外界无法访问imageName, 而是Image
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    
    // 定位坐标
    private var coordinates: Coordinates
    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    struct Coordinates: Hashable, Codable {
        var latitude: Double
        var longitude: Double
    }
}
