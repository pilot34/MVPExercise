//
//  MockCoinListViewController.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
@testable import MVP

class MockCoinListViewController: NSObject, CoinListViewControllerProtocol {
    func update(_ state: CoinListPresenter.State, animated: Bool) {
        self.state = state
        changes += 1
    }

    @objc var changes: Int = 0
    var state: CoinListPresenter.State?
}
