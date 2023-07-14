//
//  LandmarkList.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/14.
//

import Foundation
import SwiftUI

struct LandmarkList: View {
    // LandmarkList订阅ModelData
    @EnvironmentObject var modelData: ModelData
    
    @State private var showFavoritesOnly = false
    
    var filteredLandmarks: [Landmark]  {
        modelData.landmarks.filter { landmark in
            !showFavoritesOnly || landmark.isFavorite
        }
    }
    
    var body: some View {
        // 添加NavigationView, 赋予当前视图导航跳转能力
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
        
                ForEach(filteredLandmarks) { landmark in
                    // 将每个条目包装成具有导航视图
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                            .environmentObject(modelData)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                }
    
                // 给列表添加导航标题
                .navigationTitle("Landmarks")
            }
        }
        .debugPrint("调用LandmarkList body")
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        // Preview与需要做对应更改才不报错
        LandmarkList()
            .environmentObject(ModelData())
    }
}
