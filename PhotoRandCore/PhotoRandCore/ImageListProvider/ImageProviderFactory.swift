//
//  ImageProviderFactory.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-31.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

final public class ImageProviderFactory {
    public static func imageProvider() -> ImageListProvider {
        let imageEndecoder = JSONImageListEndecoder()
        let localImageStore = FileSystemImageListStore(imageListEndecoder: imageEndecoder)
        
        let api = APIService()
        let remoteImageProvider = PicsumImageService(api: api)
        
        let proxy = ImageProviderProxy(localImageStore: localImageStore, remoteImageProvider: remoteImageProvider)
        return proxy
    }
}
