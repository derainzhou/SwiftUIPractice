//
//  PhotoLibraryView.swift
//  CS193p
//
//  Created by DerainZhou on 2024/11/7.
//

import SwiftUI

struct PhotoLibraryView: View {
    @StateObject private var photoManager = PhotoLibraryManager()
    
    var body: some View {
        VStack {
            if photoManager.authorizationStatus == .authorized {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(photoManager.photos, id: \.self) { photo in
                            Image(uiImage: photo)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                }
            } else if photoManager.authorizationStatus == .denied {
                Text("请在设置中开启相册权限")
            } else {
                Text("请求相册权限中...")
            }
        }
    }
}
