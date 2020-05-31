//
//  OtherUtilitiesTests.swift
//  PhotoRandCoreTests
//
//  Created by Jing Yu on 2020-05-31.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import XCTest
@testable import PhotoRandCore

class OtherUtilitiesTests: XCTestCase {

    func testSortImageListByIndex() throws {
        let images = [
            Image(index: 8, id: "8", author: "Jack", width: 100, height: 200, downloadURL: "http://www.images.com/8", dataStatus: .notDownloaded),
            Image(index: 1, id: "1", author: "Kate", width: 200, height: 400, downloadURL: "http://www.images.com/1", dataStatus: .downloaded),
            Image(index: 7, id: "7", author: "Steve", width: 100, height: 500, downloadURL: "http://www.images.com/7", dataStatus: .notDownloaded),
            Image(index: 3, id: "3", author: "Louis", width: 200, height: 900, downloadURL: "http://www.images.com/3", dataStatus: .downloaded)
        ]
        
        let sortedImages = sortImageListByIndexOrID(images)
        XCTAssert(sortedImages[0] == images[1])
        XCTAssert(sortedImages[1] == images[3])
        XCTAssert(sortedImages[2] == images[2])
        XCTAssert(sortedImages[3] == images[0])
    }
    
    func testSortImageListByID() throws {
        let images = [
            Image(index: nil, id: "8", author: "Jack", width: 100, height: 200, downloadURL: "http://www.images.com/8", dataStatus: .notDownloaded),
            Image(index: nil, id: "1", author: "Kate", width: 200, height: 400, downloadURL: "http://www.images.com/1", dataStatus: .downloaded),
            Image(index: 7, id: "7", author: "Steve", width: 100, height: 500, downloadURL: "http://www.images.com/7", dataStatus: .notDownloaded),
            Image(index: 3, id: "3", author: "Louis", width: 200, height: 900, downloadURL: "http://www.images.com/3", dataStatus: .downloaded)
        ]
        
        let sortedImages = sortImageListByIndexOrID(images)
        XCTAssert(sortedImages[0] == images[1])
        XCTAssert(sortedImages[1] == images[3])
        XCTAssert(sortedImages[2] == images[2])
        XCTAssert(sortedImages[3] == images[0])
    }
}
