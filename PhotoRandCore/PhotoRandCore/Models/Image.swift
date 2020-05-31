//
//  Image.swift
//  PhotoRand
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 jingyu. All rights reserved.
//

import Foundation

public class Image: Codable {
    public enum DataStatus: Int, Codable {
        case notDownloaded
        case downloading
        case downloaded
    }
    
    enum CodingKeys: String, CodingKey {
        case index = "index"
        case id = "id"
        case author = "author"
        case width = "width"
        case height = "height"
        case downloadURL = "download_url"
        case dataStatus = "dataStatus"
    }
    
    var index: UInt64? = nil
    public let id: String
    public let author: String
    public let width: Int
    public let height: Int
    public let downloadURL: String
    public var dataStatus: DataStatus? = .notDownloaded
    
    init(
        index: UInt64?,
        id: String,
        author: String,
        width: Int,
        height: Int,
        downloadURL: String,
        dataStatus: DataStatus
    ) {
        self.index = index
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.downloadURL = downloadURL
        self.dataStatus = dataStatus
    }
}

extension Image: Equatable {
    public static func == (lhs: Image, rhs: Image) -> Bool {
        if
            lhs.index == rhs.index,
            lhs.id == rhs.id,
            lhs.author == rhs.author,
            lhs.width == rhs.width,
            lhs.height == rhs.height,
            lhs.downloadURL == rhs.downloadURL,
            lhs.dataStatus == rhs.dataStatus {
            return true
        }
        
        return false
    }
}
