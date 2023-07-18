//
//  CategoryHome.swift
//  CS193p
//
//  Created by DerainZhou on 2023/7/16.
//

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    
    var body: some View {
        NavigationView {
            List {
                // 1.0 添加图片
                PageView(pages: modelData.features.map {FeatureCard(lanmark: $0)})
                    .aspectRatio(3.0/2.0, contentMode: .fit)
                    .listRowInsets(EdgeInsets())
                
                // 2.0 添加分类
                // 将分类排序输出, \.self实际代表的是分类字符串作为视图标识符
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: modelData.categories[key]!)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.inset)
            .navigationTitle("Featured")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfilHost()
                    .environmentObject(modelData)
            }
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(ModelData())
    }
}
