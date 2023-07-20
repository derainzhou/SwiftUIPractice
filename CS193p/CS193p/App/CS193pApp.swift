//
//  CS193pApp.swift
//  CS193p
//
//  Created by DerainZhou on 2023/3/7.
//

import SwiftUI

// main函数是应用程序入口
@main
// 默认创建的Appdelegate将CS193pApp作为主界面展示
struct CS193pApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ModelData())
        }
    }
}
