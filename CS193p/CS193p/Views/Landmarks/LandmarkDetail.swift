//
//  LandmarkDetail.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/14.
//

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData: ModelData
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id }) ?? 0
    }
    
    var landmark: Landmark
    
    var body: some View {
        // 可滚动查看超出屏幕的内容
        ScrollView {
            VStack {
                MapView(coordinate: landmark.locationCoordinate)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 300)
                
                CircleImage(image: landmark.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)
                
                // 设置VStack中子视图左对齐
                VStack(alignment: .leading) {
                    HStack {
                        Text(landmark.name)
                            .font(.title)
                        FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)
                    }
   
                    
                    HStack {
                        Text(landmark.park)
                        Spacer()
                        Text(landmark.state)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Divider()
                    Text("About \(landmark.name)")
                        .font(.title2)
                    Text(landmark.description)
                }
                .padding()
                
                Spacer()
            }
        }
        // 设置导航栏标题(NavigationLink跳转过来的才有效)
        .navigationTitle(landmark.name)
        // 设置标题样式
        .navigationBarTitleDisplayMode(.inline)
        .debugPrint("调用LandmarkDetail body")
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkDetail(landmark: ModelData().landmarks[1])
            .environmentObject(ModelData())
    }
}
