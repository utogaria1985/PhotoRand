//
//  ImageListProvider.swift
//  PhotoRand
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 jingyu. All rights reserved.
//

import Foundation

enum ImageListProviderError: Error {
    case failToFetchFromServer
    case failToDecodeData
}

protocol ImageListProvider {
    func images(in page: UInt, limit: UInt, completionHandler: @escaping ((Result<[Image], ImageListProviderError>) -> Void))
}
