//
//  CircleImage.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/13.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4.0)
            }
            .shadow(radius: 7.0)
            
    }
}
