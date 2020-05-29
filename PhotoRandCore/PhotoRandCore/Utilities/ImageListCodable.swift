//
//  ImageListCodable.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-29.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

protocol ImageListCodable {
    func encodeImages(_ images: [Image]) throws -> Data
    func decodeImages(from data: Data) throws -> [Image]
}
