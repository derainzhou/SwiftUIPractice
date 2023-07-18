//
//  Profile.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/17.
//

import Foundation

struct Profile {
    var username: String
    var prefersNotifications = true
    var seasonalPhoto: Season = .winter
    var goalDate = Date()
    
    static let `default` = Profile(username: "derain zhou")
    
    enum Season: String, Codable, Identifiable, CaseIterable {
        case spring = "🌷"
        case summer = "🌞"
        case autumn = "🍂"
        case winter = "☃️"
        
        var id: String { rawValue }
    }
    
}
