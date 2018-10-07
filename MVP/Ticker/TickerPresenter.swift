//
//  TickerPresenter.swift
//  MVP
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation

struct TickerAttribute: Equatable {
    let name: String
    let value: String
}

struct TickerViewModel: Equatable {
    let attributes: [TickerAttribute]
}

protocol TickerPresenterProtocol {
    func onViewDidLoad()
}

class TickerPresenter: TickerPresenterProtocol {

    weak var viewController: TickerViewControllerProtocol?

    enum State: Equatable {
        case loading
        case error(String)
        case ticker(TickerViewModel)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case let (.error(lhs), .error(rhs)):
                return lhs == rhs
            case let (.ticker(lhs), .ticker(rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }

    private let service: CoinServiceProtocol
    private let id: Int

    init(service: CoinServiceProtocol, id: Int) {
        self.service = service
        self.id = id
    }

    func onViewDidLoad() {
        loadData()
    }

    private func loadData() {
        viewController?.update(.loading, animated: false)
        service.ticker(id: id)
            .get(on: DispatchQueue.main) { [weak self] data in
                if let vm = self?.viewModel(for: data) {
                    self?.viewController?.update(.ticker(vm), animated: true)
                }
            }
            .catch(on: DispatchQueue.main) { [weak self] error in
                self?.viewController?.update(.error(error.localizedDescription), animated: true)
        }
    }

    private func viewModel(for ticker: Ticker) -> TickerViewModel {
        var attrs: [TickerAttribute] = [
            .init(name: "Name", value: ticker.name),
            .init(name: "Symbol", value: ticker.symbol),
            .init(name: "Rank", value: "\(ticker.rank)")
        ]

        if let circulatingSupply = ticker.circulatingSupply {
            attrs.append(.init(name: "Circulating Supply", value: String(format: "%0.2f", circulatingSupply)))
        }

        if let totalSupply = ticker.totalSupply {
            attrs.append(.init(name: "Total Supply", value: String(format: "%0.2f", totalSupply)))
        }

        if let maxSupply = ticker.maxSupply {
            attrs.append(.init(name: "Max Supply", value: String(format: "%0.2f", maxSupply)))
        }

        return TickerViewModel(attributes: attrs)
    }
}
