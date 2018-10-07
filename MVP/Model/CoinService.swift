//
//  CoinListService.swift
//  MVP
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import PromiseKit

struct CoinListResponse: Codable {
    let data: [Coin]
}

struct TickerResponse: Codable {
    let data: Ticker
}

struct Coin: Codable {
    let id: Int
    let name: String
    let symbol: String
}

struct Ticker: Codable {
    let id: Int
    let name: String
    let symbol: String
    let rank: Int
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
}

protocol CoinServiceProtocol {
    func list() -> Promise<[Coin]>
    func ticker(id: Int) -> Promise<Ticker>
}

class CoinService: CoinServiceProtocol {
    private let client: APIClientProtocol
    init(client: APIClientProtocol) {
        self.client = client
    }

    func list() -> Promise<[Coin]> {
        let request: Promise<CoinListResponse> = client.request(method: .get,
                                                                path: "/v2/listings",
                                                                parameters: [:])
        return request.map { $0.data }
    }

    func ticker(id: Int) -> Promise<Ticker> {
        let request: Promise<TickerResponse> = client.request(method: .get,
                                                              path: "/v2/ticker/\(id)",
                                                              parameters: [:])
        return request.map { $0.data }
    }
}
