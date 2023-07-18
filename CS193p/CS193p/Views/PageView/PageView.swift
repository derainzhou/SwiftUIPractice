//
//  PageView.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/17.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 1
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPage: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count) * 18)
                .padding(.trailing)
        }
        
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(
            pages: ModelData().features.map{FeatureCard(lanmark: $0)})
                .aspectRatio(3 / 2, contentMode: .fit)
    }
}
