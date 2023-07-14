//
//  Badge.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/14.
//

import SwiftUI

struct Badge: View {
    var badgeSymbols: some View {
        ForEach(0..<8) { index in
            RotatedBadgeSymbol(angle: .degrees(Double(index) / Double(8)) * 360.0)
        }
        .opacity(0.5)
    }
    
    var body: some View {
        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                badgeSymbols
                    .scaleEffect(1.0/4.0, anchor: .top)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * (3.0 / 4.0))
            }
        }
        .scaledToFit()
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
