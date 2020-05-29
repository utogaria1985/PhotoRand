//
//  JSONImageListEndecoder.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-29.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

class JSONImageListEndecoder: ImageListCodable {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func encodeImages(_ images: [Image]) throws -> Data {
        let data = try encoder.encode(images)
        return data
    }
    
    func decodeImages(from data: Data) throws -> [Image] {
        let images = try decoder.decode([Image].self, from: data)
        return images
    }
}
