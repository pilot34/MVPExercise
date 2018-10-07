//
//  MockAPIClient.swift
//  MVVMTests
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import PromiseKit
import XCTest
@testable import MVP

class MockAPIClient: APIClientProtocol {

    enum MockAPIClientError: Error {
        case error
    }
    
    private let data: Data
    init(file: String) {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: file, withExtension: "json") else {
            fatalError("no file \(file)")
        }
        data = try! Data(contentsOf: url)
    }

    func requestData(method: RequestMethod, path: String, parameters: [String : CustomStringConvertible]) -> Promise<Data> {
        return deferred.promise
    }
    private let deferred = Promise<Data>.pending()

    func fulfill() {
        deferred.resolver.fulfill(data)
    }

    func reject() {
        deferred.resolver.reject(MockAPIClientError.error)
    }
}
