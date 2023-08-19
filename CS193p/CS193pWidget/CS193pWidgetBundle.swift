//
//  CS193pWidgetBundle.swift
//  CS193pWidget
//
//  Created by WisidomCleanMaster on 2023/7/19.
//

import WidgetKit
import SwiftUI

@main
struct CS193pWidgetBundle: WidgetBundle {
    
    init() {
        ClientSockets.shared().connect()
    }
    
    var body: some Widget {
       // CS193pSmallWidget()
        /*
        // 动态小组件
        CS193pSmallWidget()
        // Button样式可交互小组件
        CaffeineTrackerWidget()
        // Toggle样式可交互小组件
        TodoListWidget()
        // 可交互小组件发起网络请求
        WWDCWidget()
         */
        // 照片墙小组件
        // PhotoWallWidget()
        SocketWidget()
    }
}
