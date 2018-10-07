//
//  SearchServiceTests.swift
//  MVVMTests
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import XCTest
import PromiseKit
@testable import MVP

class CoinServiceTests: XCTestCase {

    func testParsingListings() {
        let client = MockAPIClient(file: "listings")
        let service = CoinService(client: client)
        let e = expectation(description: "test")
        service.list()
            .done { coins in
                XCTAssertTrue(coins.count > 0)
                let coin = coins.first!
                XCTAssertEqual(coin.id,  1)
                XCTAssertEqual(coin.name,  "Bitcoin")
                XCTAssertEqual(coin.symbol,  "BTC")
                e.fulfill()
            }
            .catch { _ in
                XCTFail("should be error")
            }

        client.fulfill()
        waitForExpectations(timeout: 1)
    }

    func testError() {
        let client = MockAPIClient(file: "listings")
        let service = CoinService(client: client)
        let e = expectation(description: "test")
        service.list()
            .done(on: DispatchQueue.main) { places in
                XCTFail("should be error")
            }
            .catch { _ in
                e.fulfill()
            }

        client.reject()
        waitForExpectations(timeout: 1)
    }
}

