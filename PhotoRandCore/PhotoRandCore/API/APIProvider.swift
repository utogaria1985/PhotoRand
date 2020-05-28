//
//  APIProvider.swift
//  PhotoRandCore
//
//  Created by Jing Yu on 2020-05-28.
//  Copyright © 2020 Jing Yu. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case emptyResponseData
    case other(Error)
}

protocol APIProvider {
    func get(requestURL: String, completionHandler: @escaping ((Result<Data, APIError>) -> Void))
}
