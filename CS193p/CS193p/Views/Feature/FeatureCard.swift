//
//  FeatureCard.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/17.
//

import SwiftUI

struct FeatureCard: View {
    var lanmark: Landmark
    
    var body: some View {
        lanmark.featureImage?
            .resizable()
            .aspectRatio(3.0/2.0, contentMode: .fit)
            .overlay(TextOverlay(landmark: lanmark))
    }
}

struct TextOverlay: View {
    var landmark: Landmark
    
    var gradient: LinearGradient {
        .linearGradient(
            Gradient(colors: [.black.opacity(0.6), .black.opacity(0)]),
            startPoint: .bottom,
            endPoint: .center)
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            gradient
            VStack(alignment: .leading) {
                Text(landmark.name)
                    .font(.title)
                    .bold()
                Text(landmark.park)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}

struct FeatureCard_Previews: PreviewProvider {
    static var previews: some View {
        FeatureCard(lanmark: ModelData().features[0])
    }
}
