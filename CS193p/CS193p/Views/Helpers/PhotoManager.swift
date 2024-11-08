//
//  PhotoManager.swift
//  CS193p
//
//  Created by DerainZhou on 2024/11/7.
//



import Photos
import SwiftUI

class PhotoLibraryManager: ObservableObject {
    @Published var photos: [UIImage] = []
    @Published var authorizationStatus: PHAuthorizationStatus = .notDetermined
    
    init() {
        DispatchQueue.global().async {
            self.checkPermission()
        }
    }
    
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        authorizationStatus = status
        
        switch status {
        case .authorized:
            fetchPhotos()
        case .notDetermined:
            requestPermission()
        default:
            // 未授权的情况
            break
        }
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            self?.authorizationStatus = status
            if status == .authorized {
                self?.fetchPhotos()
            }
        }
    }
    
    func fetchPhotos() {
        var fetchedImages: [UIImage] = []
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        assets.enumerateObjects { asset, _, _ in
            let imageManager = PHImageManager.default()
            let targetSize = CGSize(width: 100, height: 100)  // 自定义照片大小
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                if let image = image {
                    fetchedImages.append(image)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.photos = fetchedImages
        }
    }
}
