//
//  SearchViewPresenter.swift
//  MVP
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation

struct CoinListCellViewModel: Equatable {
    let id: Int
    let title: String
    let subtitle: String
}

protocol CoinListPresenterProtocol {
    func onViewDidLoad()
    func didSelect(coin: CoinListCellViewModel)
}

class CoinListPresenter: CoinListPresenterProtocol {

    weak var viewController: CoinListViewControllerProtocol?
    private let router: RouterProtocol

    enum State: Equatable {
        case loading
        case error(String)
        case rows([CoinListCellViewModel])

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
            case let (.error(lhs), .error(rhs)):
                return lhs == rhs
            case let (.rows(lhs), .rows(rhs)):
                return lhs == rhs
            default:
                return false
            }
        }
    }

    private let service: CoinServiceProtocol

    init(service: CoinServiceProtocol, router: RouterProtocol) {
        self.service = service
        self.router = router
    }

    func onViewDidLoad() {
        loadData()
    }

    func didSelect(coin: CoinListCellViewModel) {
        router.presentTicker(id: coin.id)
    }

    private func loadData() {
        viewController?.update(.loading, animated: false)
        service.list()
            .get(on: DispatchQueue.main) { [weak self] data in
                let rows = data.compactMap { self?.viewModel(for: $0) }
                if rows.count > 0 {
                    self?.viewController?.update(.rows(rows), animated: true)
                } else {
                    self?.viewController?.update(.error("No data found"), animated: true)
                }
            }
            .catch(on: DispatchQueue.main) { [weak self] error in
                self?.viewController?.update(.error(error.localizedDescription), animated: true)
            }
    }

    private func viewModel(for coin: Coin) -> CoinListCellViewModel {
        return CoinListCellViewModel(id: coin.id,
                                     title: coin.name,
                                     subtitle: coin.symbol)
    }
}
