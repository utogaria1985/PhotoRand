//
//  PicsumImageServiceTests.swift
//  PhotoRandCoreTests
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import XCTest
@testable import PhotoRandCore

class PicsumImageServiceTests: XCTestCase {
    private let api = MockAPI()
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetThreeImagesFromServer() throws {
        let service = PicsumImageService(api: api)
        
        api.resultType = .validData
        
        let expect = expectation(description: "Get images from API")
        service.images(in: 1, limit: 3) { (result) in
            guard let images = try? result.get() else {
                XCTFail()
                return
            }
            
            XCTAssertTrue(images.count == 3)
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testGetInvalidDataFromServer() throws {
        let service = PicsumImageService(api: api)
        
        api.resultType = .emptyData
        
        let expect = expectation(description: "Get images from API")
        service.images(in: 1, limit: 3) { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssert(error == .failToDecodeData)
            }
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testFailDueToNetworkIssue() throws {
        let service = PicsumImageService(api: api)
        
        api.resultType = .networkFailure
        
        let expect = expectation(description: "Get images from API")
        service.images(in: 1, limit: 3) { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssert(error == .failToFetchFromServer)
            }
            
            expect.fulfill()
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
}


fileprivate class MockAPI: APIProvider {
    enum ResultType {
        case validData
        case emptyData
        case networkFailure
    }
    
    var resultType = ResultType.validData
    
    func get(requestURL: String, completionHandler: @escaping ((Result<Data, APIError>) -> Void)) {
        switch resultType {
        case .validData:
            completionHandler(.success(validData))
        case .emptyData:
            completionHandler(.success(invalidData))
        case .networkFailure:
            completionHandler(.failure(.other(NSError(domain: NSURLErrorDomain, code: 403, userInfo: nil))))
        }
        
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
    
    private var invalidData: Data {
        return Data()
    }
}
