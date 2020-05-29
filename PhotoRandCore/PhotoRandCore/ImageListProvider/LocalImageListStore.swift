//
//  LocalImageListStore.swift
//  PhotoRand
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 jingyu. All rights reserved.
//

import Foundation

enum LocalImageListStoreError: Error {
    case localFileDirectoryUnavailable
    case other(Error)
}

protocol LocalImageListStore: ImageListProvider {
    func saveImages(_ images: [Image], completionHandler: @escaping ((LocalImageListStoreError?) -> Void))
}
