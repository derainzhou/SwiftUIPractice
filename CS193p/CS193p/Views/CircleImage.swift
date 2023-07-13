//
//  CircleImage.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/13.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("test")
            .frame(width: 300, height: 300)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4.0)
            }
            .shadow(radius: 7.0)
            
    }
}
