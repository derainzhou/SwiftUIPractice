//
//  BackgroundTask.swift
//  CS193p
//
//  Created by DerainZhou on 2023/8/20.
//

import Foundation
import UIKit

class BackgroundTask {
    static let shared = BackgroundTask()
    
    private static let BgTaskName = "com.cs193p.AppRunInBackground";
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    public func didEnterBackground() {
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: Self.BgTaskName) { [weak self] in
            guard let self = self else { return }
            AudioPlayer.shared.play()
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
            self.backgroundTaskIdentifier = .invalid
        }
    }
    
    public func willEnterForeground() {
        AudioPlayer.shared.pause()
        UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier)
    }
}
