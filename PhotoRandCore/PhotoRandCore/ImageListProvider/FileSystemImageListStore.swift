//
//  FileSystemImageListStore.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

class FileSystemImageListStore: LocalImageListStore {
    static let defaultPageSize: UInt = 30
    
    private let imageListEndecoder: ImageListCodable
    private let workingQueue = DispatchQueue(label: "queue.FileSystemImageListStore")
    
    init(imageListEndecoder: ImageListCodable) {
        self.imageListEndecoder = imageListEndecoder
    }
    
    func images(in page: UInt, limit: UInt, completionHandler: @escaping ((Result<[Image], ImageListProviderError>) -> Void)) {
        workingQueue.async {
            do {
                let images = try self.savedImageList()
                let sortedImages = self.sortImageListByID(images)
                
                let pagedImages = try self.images(in: page, limit: limit, in: sortedImages)
                completionHandler(.success(pagedImages))
            } catch {
                completionHandler(.failure(.requiredRangeNotAvailable))
            }
        }
    }
    
    func saveImages(_ images: [Image], completionHandler: @escaping ((LocalImageListStoreError?) -> Void)) {
        workingQueue.async {
            do {
                let sortedImages = self.sortImageListByID(images)
                let data = try self.imageListEndecoder.encodeImages(sortedImages)
                try self.saveImageListData(data)
                completionHandler(nil)
            } catch {
                completionHandler(.other(error))
            }
        }
    }
    
}

extension FileSystemImageListStore {
    func images(in page: UInt, limit: UInt, in imageList: [Image]) throws -> [Image] {
        let range = Self.imageIndexRange(for: page, limit: limit)
        let upperBound = Int(range.upperBound)
        let lowerBound = Int(range.lowerBound)
        
        guard
            lowerBound <= upperBound,
            upperBound <= imageList.count - 1
        else {
            throw ImageListProviderError.requiredRangeNotAvailable
        }
        
        let clippedRange = ClosedRange<Int>(uncheckedBounds: (lowerBound, upperBound))
        
        let result = imageList[clippedRange]
        return Array(result)
    }
    
    func sortImageListByID(_ images: [Image]) -> [Image] {
        let sortedImages = images.sorted { (left, right) -> Bool in
            return left.id.compare(right.id, options: .numeric) == .orderedAscending
        }
        return sortedImages
    }
    
    func savedImageList() throws -> [Image] {
        let url = try Self.imageListFileURL()
        let data = try Data(contentsOf: url)
        let images = try imageListEndecoder.decodeImages(from: data)
        
        return images
    }
    
    func saveImageListData(_ data: Data) throws {
        let url = try Self.imageListFileURL()
        try data.write(to: url)
    }
    
    static func imageIndexRange(for page: UInt, limit: UInt) -> ClosedRange<UInt> {
        let pageSize = (limit == 0) ? FileSystemImageListStore.defaultPageSize : limit
        let range = ClosedRange<UInt>(uncheckedBounds: (page * pageSize, (page + 1) * pageSize - 1))
        return range
    }
    
    static func imageListFileURL() throws -> URL {
        let fileName = "imageList.dat"
        let path = (try fileSavingDirectory() as NSString).appendingPathComponent(fileName)
        let url = URL(fileURLWithPath: path)
        return url
    }
    
    static func fileSavingDirectory() throws -> String {
        guard let libraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else {
            throw LocalImageListStoreError.localFileDirectoryUnavailable
        }
        
        let directoryName = "PhotoRandCore"
        let directory = (libraryDirectory as NSString).appendingPathComponent(directoryName)
        
        var isDirectory = ObjCBool(false)
        let fileManager = FileManager.default
        
        if
            fileManager.fileExists(atPath: directory, isDirectory: &isDirectory),
            isDirectory.boolValue {
            return directory
        }
        
        let url = URL(fileURLWithPath: directory)
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        
        return directory
    }
}
