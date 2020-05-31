//
//  ImageListProvider.swift
//  PhotoRand
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 jingyu. All rights reserved.
//

import Foundation

public enum ImageListProviderError: Error {
    case failToFetchFromServer
    case failToDecodeData
    case failToReadSavedFileFromLocalFileSystem
    case requiredRangeNotAvailable
    case other(Error)
}

extension ImageListProviderError: Equatable {
    public static func == (lhs: ImageListProviderError, rhs: ImageListProviderError) -> Bool {
        switch (lhs, rhs) {
        case (.failToFetchFromServer, .failToFetchFromServer),
             (.failToDecodeData, .failToDecodeData),
             (.failToReadSavedFileFromLocalFileSystem, .failToReadSavedFileFromLocalFileSystem),
             (.requiredRangeNotAvailable, .requiredRangeNotAvailable):
            return true
        case (.other(let leftError), .other(let rightError)):
            return type(of: leftError) == type(of: rightError)
        case (_, _):
            return false
        }
    }
}

public protocol ImageListProvider {
    func images(in page: UInt, limit: UInt, completionHandler: @escaping ((Result<[Image], ImageListProviderError>) -> Void))
    static var defaultPageSize: UInt { get }
}
