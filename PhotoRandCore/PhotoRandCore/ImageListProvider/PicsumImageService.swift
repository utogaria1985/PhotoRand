//
//  PicsumImageService.swift
//  PhotoRand
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 jingyu. All rights reserved.
//

import Foundation

class PicsumImageService: ImageListProvider {
    private let api: APIProvider
    
    init(api: APIProvider) {
        self.api = api
    }
    
    func images(in page: UInt, limit: UInt, completionHandler: @escaping ((Result<[Image], ImageListProviderError>) -> Void)) {
        let urlString = "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)"
        
        api.get(requestURL: urlString) { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let images = try? self?.decodeImages(from: data) else {
                    completionHandler(.failure(.failToDecodeData))
                    return
                }
                
                completionHandler(.success(images))
                
            case .failure:
                completionHandler(.failure(.failToFetchFromServer))
            }
        }
    }
    
    func decodeImages(from data: Data) throws -> [Image] {
        let decoder = JSONDecoder()
        let images = try decoder.decode([Image].self, from: data)
        
        return images
    }
    
}
