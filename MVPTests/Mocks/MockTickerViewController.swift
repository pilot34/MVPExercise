//
//  MockTickerViewController.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import Foundation
@testable import MVP

class MockTickerViewController: NSObject, TickerViewControllerProtocol {
    func update(_ state: TickerPresenter.State, animated: Bool) {
        self.state = state
        changes += 1
    }

    @objc var changes: Int = 0
    var state: TickerPresenter.State?
}
