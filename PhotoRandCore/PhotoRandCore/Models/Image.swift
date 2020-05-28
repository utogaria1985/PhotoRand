//
//  Image.swift
//  PhotoRand
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 jingyu. All rights reserved.
//

import Foundation

public class Image: Codable {
    public enum DataStatus {
        case notDownloaded
        case downloading
        case downloaded
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case width = "width"
        case height = "height"
        case downloadURL = "download_url"
    }
    
    public let id: String
    public let author: String
    public let width: Int
    public let height: Int
    public let downloadURL: String
    public var dataStatus = DataStatus.notDownloaded
    
    init(
        id: String,
        author: String,
        width: Int,
        height: Int,
        downloadURL: String,
        dataStatus: DataStatus
    ) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.downloadURL = downloadURL
        self.dataStatus = dataStatus
    }
}
