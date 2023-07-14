//
//  Map.swift
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/7/13.
//

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    // @State将属性标记为可变的状态, 当属性更改后或刷新对应视图
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        // 在状态变量前加上$，表示传递了一个绑定，这就像对基础值的引用
        // 也就是说视图内部也可以更新region的值
        Map(coordinateRegion: $region)
            .onAppear { // Map显示使更新region
                setRegion(coordinate: coordinate)
            }
    }
    
    private func setRegion(coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
    }
}
