//
//  FileSystemImageListStoreTests.swift
//  PhotoRandCoreTests
//
//  Created by Jing Yu on 2020-05-29.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import XCTest
@testable import PhotoRandCore

class FileSystemImageListStoreTests: XCTestCase {

    private let endecoder = JSONImageListEndecoder()
    
    override func setUpWithError() throws {
        cleanUpFileSavingDirectory()
    }
    
    private func cleanUpFileSavingDirectory() {
        if let filePath = try? FileSystemImageListStore.imageListFileURL() {
            try? FileManager.default.removeItem(at: filePath)
        }
    }

    override func tearDownWithError() throws {
        cleanUpFileSavingDirectory()
    }
    
    func testFileSavingDirectoryExists() throws {
        guard let directory = try? FileSystemImageListStore.fileSavingDirectory() else {
            XCTFail("Can't access file saving directory")
            return
        }
        
        var isDirectory = ObjCBool(false)
        let exists = FileManager.default.fileExists(atPath: directory, isDirectory: &isDirectory)
        XCTAssertTrue(exists)
        XCTAssertTrue(isDirectory.boolValue)
    }
    
    func testFailToReadImageListFromLocalFileSystemIfNoImageListHasBeenSavedBefore() throws {
        let store = FileSystemImageListStore(imageListEndecoder: endecoder)
        
        let expect = expectation(description: "Saved image list is read from local file system")
        store.images(in: 1, limit: 10) { result in
            switch result {
            case .success:
                XCTFail("Should not read images if nothing has been saved before")
            case .failure(let error):
                XCTAssertTrue(error == .requiredRangeNotAvailable)
                expect.fulfill()
            }
        }
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testReadImagesAfterSaving() throws {
        let store = FileSystemImageListStore(imageListEndecoder: endecoder)
        
        let imagesToSave = [
            Image(index: 1, id: "1", author: "Jack", width: 100, height: 200, downloadURL: "http://www.images.com/1", dataStatus: .notDownloaded),
            Image(index: 2, id: "2", author: "Kate", width: 200, height: 300, downloadURL: "http://www.images.com/2", dataStatus: .downloaded)
        ]
        
        let expectSavingSuccess = expectation(description: "Image list is saved to local file system")
        let expectReadingSuccess = expectation(description: "Saved image list is read from local file system")
        
        store.saveImages(imagesToSave) { error in
            guard error == nil else {
                return
            }
            
            store.images(in: 0, limit: 2) { result in
                switch result {
                case .failure:
                    break
                case .success(let savedImages):
                    XCTAssertEqual(imagesToSave, savedImages)
                    expectReadingSuccess.fulfill()
                }
            }
            
            expectSavingSuccess.fulfill()
        }
        
        wait(for: [expectSavingSuccess, expectReadingSuccess], timeout: 1.0)
    }
    
    func testFailToReadImagesOutsideTheRangeOfAvailableImages() throws {
        let store = FileSystemImageListStore(imageListEndecoder: endecoder)
        
        let imagesToSave = [
            Image(index: 1, id: "1", author: "Jack", width: 100, height: 200, downloadURL: "http://www.images.com/1", dataStatus: .notDownloaded),
            Image(index: 2, id: "2", author: "Kate", width: 200, height: 300, downloadURL: "http://www.images.com/2", dataStatus: .downloaded)
        ]
        
        let expectSavingSuccess = expectation(description: "Image list is saved to local file system")
        let expectReadingSuccess = expectation(description: "Saved image list is read from local file system")
        
        store.saveImages(imagesToSave) { error in
            guard error == nil else {
                return
            }
            
            store.images(in: 12, limit: 2) { result in
                switch result {
                case .failure(let error):
                    XCTAssertTrue(error == .requiredRangeNotAvailable)
                    expectReadingSuccess.fulfill()
                case .success:
                    break
                }
            }
            
            expectSavingSuccess.fulfill()
        }
        
        wait(for: [expectSavingSuccess, expectReadingSuccess], timeout: 1.0)
    }
    
    
    func testImageIndexRangeMapping() throws {
        let range0 = FileSystemImageListStore.imageIndexRange(for: 0, limit: 2)
        XCTAssertTrue(range0.lowerBound == 0 && range0.upperBound == 1)
        
        let range1 = FileSystemImageListStore.imageIndexRange(for: 0, limit: 0)
        XCTAssertTrue(range1.lowerBound == 0 && range1.upperBound == FileSystemImageListStore.defaultPageSize - 1)
        
        let range2 = FileSystemImageListStore.imageIndexRange(for: 3, limit: 5)
        XCTAssertTrue(range2.lowerBound == 15 && range2.upperBound == 19)
        
        let range3 = FileSystemImageListStore.imageIndexRange(for: 2, limit: 4)
        XCTAssertTrue(range3.lowerBound == 8 && range3.upperBound == 11)
    }
}
