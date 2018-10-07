//
//  MockRouter.swift
//  MVPTests
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit
@testable import MVP

class MockRouter: RouterProtocol {
    func rootViewController() -> UIViewController {
        fatalError("not implemented")
    }

    var lastPresentedTickerId: Int? = nil
    func presentTicker(id: Int) {
        lastPresentedTickerId = id
    }
}
