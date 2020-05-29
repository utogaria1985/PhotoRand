//
//  JSONImageListEndecoderTests.swift
//  PhotoRandCoreTests
//
//  Created by Jing Yu on 2020-05-29.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import XCTest
@testable import PhotoRandCore

class JSONImageListEndecoderTests: XCTestCase {

    func testEncodingImages() throws {
        let images = [
            Image(index: 1, id: "1", author: "Jack", width: 100, height: 200, downloadURL: "http://www.images.com/1", dataStatus: .notDownloaded),
            Image(index: 2, id: "2", author: "Kate", width: 200, height: 300, downloadURL: "http://www.images.com/2", dataStatus: .downloaded)
        ]
        
        let encoder = JSONImageListEndecoder()
        do {
            let data = try encoder.encodeImages(images)
            XCTAssertFalse(data.isEmpty)
        } catch {
            XCTFail("Can't encode images, reason: \(error.localizedDescription)")
        }
    }
    
    func testDecodingImages() throws {
        let jsonString =
        """
        [{
            "id": "1004",
            "author": "Greg Rakozy",
            "width": 5616,
            "height": 3744,
            "url": "https://unsplash.com/photos/SSxIGsySh8o",
            "download_url": "https://picsum.photos/id/1004/5616/3744"
        }, {
            "id": "1005",
            "author": "Matthew Wiebe",
            "width": 5760,
            "height": 3840,
            "url": "https://unsplash.com/photos/tBtuxtLvAZs",
            "download_url": "https://picsum.photos/id/1005/5760/3840"
        }]
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        guard let images = try? JSONImageListEndecoder().decodeImages(from: jsonData) else {
            XCTFail("Can't initialize Image from a given json payload")
            return
        }
        
        XCTAssertTrue(images.count == 2)
    }
}
