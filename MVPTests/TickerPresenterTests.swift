//
//  TickerPresenterTests.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
import XCTest
import PromiseKit
@testable import MVP

class TickerPresenterTests: XCTestCase {
    func testError() {
        let service = MockCoinService()
        let presenter = TickerPresenter(service: service, id: 19)
        let viewController = MockTickerViewController()
        presenter.viewController = viewController
        XCTAssertEqual(viewController.changes, 0)

        presenter.onViewDidLoad()
        XCTAssertEqual(viewController.changes, 1)
        XCTAssertEqual(viewController.state!, .loading)

        service.deferredTicker.resolver.reject(MockCoinService.TestError.error)
        let predicate = NSPredicate(format: "changes > 1")
        let e = expectation(for: predicate, evaluatedWith: viewController, handler: nil)
        wait(for: [e], timeout: 1)
        XCTAssertEqual(viewController.changes, 2)
        XCTAssertEqual(viewController.state!, .error("TestError"))
    }

    func testSearch() {
        let service = MockCoinService()
        let presenter = TickerPresenter(service: service, id: 19)
        let viewController = MockTickerViewController()
        presenter.viewController = viewController
        XCTAssertEqual(viewController.changes, 0)

        presenter.onViewDidLoad()
        XCTAssertEqual(viewController.changes, 1)
        XCTAssertEqual(viewController.state!, .loading)

        service.deferredTicker.resolver.fulfill(Ticker(id: 1,
                                                       name: "Na",
                                                       symbol: "Sy",
                                                       rank: 121,
                                                       circulatingSupply: 39,
                                                       totalSupply: nil,
                                                       maxSupply: 124.238344))

        let predicate = NSPredicate(format: "changes > 1")
        let e = expectation(for: predicate, evaluatedWith: viewController, handler: nil)
        wait(for: [e], timeout: 1)
        XCTAssertEqual(viewController.changes, 2)
        XCTAssertEqual(viewController.state!, .ticker(TickerViewModel(attributes: [
            TickerAttribute(name: "Name", value: "Na"),
            TickerAttribute(name: "Symbol", value: "Sy"),
            TickerAttribute(name: "Rank", value: "121"),
            TickerAttribute(name: "Circulating Supply", value: "39.00"),
            TickerAttribute(name: "Max Supply", value: "124.24"),
        ])))
    }
}

