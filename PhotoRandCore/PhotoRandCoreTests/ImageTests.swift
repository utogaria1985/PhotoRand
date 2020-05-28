//
//  ImageTests.swift
//  PhotoRandCoreTests
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import XCTest
@testable import PhotoRandCore

class ImageTests: XCTestCase {

    func testCanInitializeWithJSONPayloadWithSingleImageFromPicsum() throws {
        let jsonString =
        """
            {
                "id": "1008",
                "author": "Benjamin Combs",
                "width": 5616,
                "height": 3744,
                "url": "https://unsplash.com/photos/5L4XAgMSno0",
                "download_url": "https://picsum.photos/id/1008/5616/3744"
            }
        """
        let jsonData = jsonString.data(using: .utf8)!
        guard let image = try? JSONDecoder().decode(Image.self, from: jsonData) else {
            XCTFail("Can't initialize Image from a given json payload")
            return
        }
        
        XCTAssertEqual(image.id, "1008")
        XCTAssertEqual(image.author, "Benjamin Combs")
        XCTAssertEqual(image.width, 5616)
        XCTAssertEqual(image.height, 3744)
        XCTAssertEqual(image.downloadURL, "https://picsum.photos/id/1008/5616/3744")
    }


    func testFailToIntializeWithUnexpectedJSONPayload() throws {
        // Simulate the case when the "id" key is changed to "ID".
        let jsonString =
        """
            {
                "ID": "1008",
                "author": "Benjamin Combs",
                "width": 5616,
                "height": 3744,
                "url": "https://unsplash.com/photos/5L4XAgMSno0",
                "download_url": "https://picsum.photos/id/1008/5616/3744"
            }
        """
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let _ = try JSONDecoder().decode(Image.self, from: jsonData)
            XCTFail("Should catch DecodingError")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testCanInitializeWithJSONPyaloadWithMultipleImagesFromPicsum() throws {
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
        }, {
            "id": "1006",
            "author": "Vladimir Kudinov",
            "width": 3000,
            "height": 2000,
            "url": "https://unsplash.com/photos/-wWRHIUklxM",
            "download_url": "https://picsum.photos/id/1006/3000/2000"
        }, {
            "id": "1008",
            "author": "Benjamin Combs",
            "width": 5616,
            "height": 3744,
            "url": "https://unsplash.com/photos/5L4XAgMSno0",
            "download_url": "https://picsum.photos/id/1008/5616/3744"
        }]
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        guard let images = try? JSONDecoder().decode([Image].self, from: jsonData) else {
            XCTFail("Can't initialize Image from a given json payload")
            return
        }
        
        XCTAssertTrue(images.count == 4)
    }
}
