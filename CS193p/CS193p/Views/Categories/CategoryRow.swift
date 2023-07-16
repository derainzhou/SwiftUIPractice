//
//  CategoryRow.swift
//  CS193p
//
//  Created by DerainZhou on 2023/7/16.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Landmark]
    
    var body: some View {
        VStack(alignment: .leading) {
            // 添加分类标题
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15.0)
                .padding(.top, 5.0)
            
            // 添加具体items
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { landmark in
                        NavigationLink {
                            LandmarkDetail(landmark: landmark)
                        } label: {
                            CategoryItem(landmark: landmark)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    static var previews: some View {
        CategoryRow(
            categoryName: landmarks[0].category.rawValue,
            items: Array(landmarks.prefix(3)))
        .background(.red)
    }
}
