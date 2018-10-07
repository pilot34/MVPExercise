//
//  APIClient.swift
//  MVVM
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import PromiseKit

enum RequestMethod {
    case get
}

protocol APIClientProtocol {
    func requestData(method: RequestMethod,
                     path: String,
                     parameters: [String: CustomStringConvertible]) -> Promise<Data>
}

enum APIError: Error {
    case wrongURL
}

class APIClient: APIClientProtocol {
    func requestData(method: RequestMethod,
                     path: String,
                     parameters: [String: CustomStringConvertible]) -> Promise<Data> {
        return firstly(execute: { () -> Promise<Data> in
            let url = baseURL.appendingPathComponent(path)
            guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw APIError.wrongURL
            }
            comps.queryItems = parameters.map { (key, value) in
                URLQueryItem(name: key, value: value.description)
            }
            guard let resultURL = comps.url else {
                throw APIError.wrongURL
            }
            let request = URLRequest(url: resultURL)
            return session.dataTask(.promise, with: request).map { data, _ in
                return data
            }
        })
    }

    private let session = URLSession.shared
    private let baseURL: URL

    init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

extension APIClientProtocol {
    func request<T: Decodable>(method: RequestMethod,
                               path: String,
                               parameters: [String: CustomStringConvertible]) -> Promise<T> {
        return requestData(method: method,
                           path: path,
                           parameters: parameters)
            .compactMap(on: DispatchQueue.global(qos: .background)) {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let result = try decoder.decode(T.self, from: $0)
                    return result
                } catch let e {
                    debugPrint("Error: \(e)")
                    throw e
                }
            }
    }
}
