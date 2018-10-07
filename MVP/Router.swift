//
//  Router.swift
//  MVVM
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit

protocol RouterProtocol {
    func rootViewController() -> UIViewController
    func presentTicker(id: Int)
}

class Router: RouterProtocol {
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let dependencies = Dependencies()
    private var root: UIViewController?

    func rootViewController() -> UIViewController {
        assert(root == nil)
        let vc = mainStoryboard.instantiate(type: CoinListViewController.self)
        let presenter = CoinListPresenter(service: dependencies.service, router: self)
        vc.presenter = presenter
        presenter.viewController = vc
        let nav = UINavigationController(rootViewController: vc)
        root = nav
        return nav
    }

    func presentTicker(id: Int) {
        assert(root != nil)
        let vc = mainStoryboard.instantiate(type: TickerViewController.self)
        let presenter = TickerPresenter(service: dependencies.service, id: id)
        vc.presenter = presenter
        presenter.viewController = vc

        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .formSheet
        root?.present(nav, animated: true, completion: nil)
    }
}
