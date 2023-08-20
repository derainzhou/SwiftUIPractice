//
//  CS193pApp.swift
//  CS193p
//
//  Created by DerainZhou on 2023/3/7.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("didFinishLaunchingWithOptions")
        return true
    }
}

// main函数是应用程序入口
@main
// 默认创建的Appdelegate将CS193pApp作为主界面展示
struct CS193pApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    private static let BgTaskName = "com.cs193p.AppRunInBackground";
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ModelData())
                .debugPrint(self)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                BackgroundTask.shared.willEnterForeground()
            case .inactive:
              print("应用休眠")
            case .background:
                BackgroundTask.shared.didEnterBackground()
            @unknown default:
              print("default")
            }
        }
    }
}
