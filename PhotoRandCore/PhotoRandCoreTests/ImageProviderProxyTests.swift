//
//  ImageProviderProxyTests.swift
//  PhotoRandCoreTests
//
//  Created by Jing Yu on 2020-05-31.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import XCTest
@testable import PhotoRandCore

class ImageProviderProxyTests: XCTestCase {

    private let imageEndecoder = JSONImageListEndecoder()
    private let api = MockAPI()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        
    }

    func testGetImageList() throws {
        let localImageStore = FileSystemImageListStore(imageListEndecoder: imageEndecoder)
        let remoteImageProvider = PicsumImageService(api: api)
        
        let proxy = ImageProviderProxy(localImageStore: localImageStore, remoteImageProvider: remoteImageProvider)
        
        let expect = expectation(description: "Get images from proxy object")
        proxy.images(in: 0, limit: 3) { result in
            switch result {
            case .failure:
                break
            case .success(let images):
                XCTAssert(images.count == 3)
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1.0)
    }


}

private class MockAPI: APIProvider {
    
    func get(requestURL: String, completionHandler: @escaping ((Result<Data, APIError>) -> Void)) {
        completionHandler(.success(validData))
    }
    
    private var validData: Data {
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
        }]
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        return jsonData
    }
}
