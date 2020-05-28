//
//  APIService.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

class APIService: APIProvider {
    private let urlSession = URLSession.shared
    
    func get(requestURL: String, completionHandler: @escaping ((Result<Data, APIError>) -> Void)) {
        guard let url = URL(string: requestURL) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let task = urlSession.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completionHandler(.failure(.other(error)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.emptyResponseData))
                return
            }
            
            completionHandler(.success(data))
        }
        
        task.resume()
    }
    
}
