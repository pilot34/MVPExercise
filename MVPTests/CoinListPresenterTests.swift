//
//  CoinListPresenterTests.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import XCTest
import PromiseKit
@testable import MVP

class CoinListPresenterTests: XCTestCase {
    func testError() {
        let service = MockCoinService()
        let presenter = CoinListPresenter(service: service, router: MockRouter())
        let viewController = MockCoinListViewController()
        presenter.viewController = viewController
        XCTAssertEqual(viewController.changes, 0)

        presenter.onViewDidLoad()
        XCTAssertEqual(viewController.changes, 1)
        XCTAssertEqual(viewController.state!, .loading)

        service.deferredCoins.resolver.reject(MockCoinService.TestError.error)
        let predicate = NSPredicate(format: "changes > 1")
        let e = expectation(for: predicate, evaluatedWith: viewController, handler: nil)
        wait(for: [e], timeout: 1)
        XCTAssertEqual(viewController.changes, 2)
        XCTAssertEqual(viewController.state!, .error("TestError"))
    }

    func testSearch() {
        let service = MockCoinService()
        let presenter = CoinListPresenter(service: service, router: MockRouter())
        let viewController = MockCoinListViewController()
        presenter.viewController = viewController
        XCTAssertEqual(viewController.changes, 0)

        presenter.onViewDidLoad()
        XCTAssertEqual(viewController.changes, 1)
        XCTAssertEqual(viewController.state!, .loading)

        service.deferredCoins.resolver.fulfill([
            Coin(id: 1, name: "Test1", symbol: "s1"),
            Coin(id: 2, name: "Test2", symbol: "s2"),
            Coin(id: 3, name: "Test3", symbol: "s3"),
        ])

        let predicate = NSPredicate(format: "changes > 1")
        let e = expectation(for: predicate, evaluatedWith: viewController, handler: nil)
        wait(for: [e], timeout: 1)
        XCTAssertEqual(viewController.changes, 2)
        XCTAssertEqual(viewController.state!, .rows([
            CoinListCellViewModel(id: 1, title: "Test1", subtitle: "s1"),
            CoinListCellViewModel(id: 2, title: "Test2", subtitle: "s2"),
            CoinListCellViewModel(id: 3, title: "Test3", subtitle: "s3"),
        ]))
    }

    func testDidSelect() {
        let service = MockCoinService()
        let router = MockRouter()
        let presenter = CoinListPresenter(service: service, router: router)
        XCTAssertNil(router.lastPresentedTickerId)
        presenter.didSelect(coin: CoinListCellViewModel(id: 10, title: "10", subtitle: "10"))
        XCTAssertEqual(10, router.lastPresentedTickerId)
    }
}
