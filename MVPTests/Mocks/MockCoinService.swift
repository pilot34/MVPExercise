//
//  MockCoinService.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 08/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import PromiseKit
@testable import MVP

class MockCoinService: CoinServiceProtocol {

    enum TestError: LocalizedError {
        case error
        var errorDescription: String? {
            return "TestError"
        }
    }

    var lastLoadedTickerId: Int? = nil
    let deferredCoins = Promise<[Coin]>.pending()
    let deferredTicker = Promise<Ticker>.pending()

    func list() -> Promise<[Coin]> {
        return deferredCoins.promise
    }

    func ticker(id: Int) -> Promise<Ticker> {
        lastLoadedTickerId = id
        return deferredTicker.promise
    }
}
