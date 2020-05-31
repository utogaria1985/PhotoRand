//
//  ImageProviderProxy.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-31.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

class ImageProviderProxy: ImageListProvider {
    let localImageStore: LocalImageListStore
    let remoteImageProvider: ImageListProvider
    
    private var cachedImages = [Image]()
    private let workingQueue = DispatchQueue(label: "queue.ImageProviderProxy")
    
    init(localImageStore: LocalImageListStore, remoteImageProvider: ImageListProvider) {
        self.localImageStore = localImageStore
        self.remoteImageProvider = remoteImageProvider
    }
    
    func images(in page: UInt, limit: UInt, completionHandler: @escaping ((Result<[Image], ImageListProviderError>) -> Void)) {
        let cached = cachedImages(in: page, limit: limit, in: cachedImages)
        if !cached.isEmpty {
            completionHandler(.success(cached))
            return
        }
        
        localImageStore.images(in: page, limit: limit) { result in
            switch result {
            case .failure(let error):
                if error == .requiredRangeNotAvailable {
                    self.synchronizeLocalAndRemoteImages(in: page, limit: limit) { syncError in
                        if let syncError = syncError {
                            completionHandler(.failure(.other(syncError)))
                        } else {
                            self.images(in: page, limit: limit, completionHandler: completionHandler)
                        }
                    }
                } else {
                    completionHandler(.failure(error))
                }
            case .success(let images):
                self.workingQueue.async {
                    self.cachedImages = images
                    completionHandler(.success(images))
                }
            }
        }
    }
    
    func synchronizeLocalAndRemoteImages(in page: UInt, limit: UInt, completionHandler: @escaping (ImageListProviderError?) -> Void) {
        let localStore = localImageStore
        
        remoteImageProvider.images(in: page, limit: limit) { result in
            switch result {
            case .failure(let error):
                completionHandler(error)
            case .success(let images):
                let indexedImages = self.index(downloadedImages: images, page: page, limit: limit)
                
                localStore.saveImages(indexedImages) { (error) in
                    if let error = error {
                        completionHandler(.other(error))
                    } else {
                        completionHandler(nil)
                    }
                }
            }
        }
    }
    
    func cachedImages(in page: UInt, limit: UInt, in cache: [Image]) -> [Image] {
        let beginIndex = page * limit
        let endIndex = (page + 1) * limit - 1
        
        let range = UInt64(beginIndex)...UInt64(endIndex)
        let matchedImages = cache.filter { (image) -> Bool in
            guard let index = image.index else {
                return false
            }
            return range.contains(index)
        }
        
        guard matchedImages.count == (endIndex - beginIndex + 1) else {
            return []
        }
        
        return matchedImages
    }
    
    func index(downloadedImages: [Image], page: UInt, limit: UInt) -> [Image] {
        let startIndex = page * limit
        
        let indexedImages = downloadedImages
        for index in 0..<indexedImages.count {
            indexedImages[index].index = UInt64(startIndex) + UInt64(index)
        }
        
        return indexedImages
    }
    
    public static var defaultPageSize: UInt = 60
    
}
