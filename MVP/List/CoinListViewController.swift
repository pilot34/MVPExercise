//
//  CoinListViewController.swift
//  MVP
//
//  Created by  Gleb Tarasov on 09/08/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit

class CoinListCell: UITableViewCell, Cell {
    typealias Data = CoinListCellViewModel

    func update(data: CoinListCellViewModel) {
        textLabel?.text = data.title
        detailTextLabel?.text = data.subtitle
    }
}

protocol CoinListViewControllerProtocol: class {
    func update(_ state: CoinListPresenter.State, animated: Bool)
}

class CoinListViewController: UIViewController,
                              CoinListViewControllerProtocol {

    var presenter: CoinListPresenterProtocol!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil)
        presenter.onViewDidLoad()
    }

    func update(_ state: CoinListPresenter.State, animated: Bool) {
        let action = {
            switch state {
            case let .error(error):
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 1
                self.errorLabel.text = error
                self.tableView.alpha = 0
            case .loading:
                self.activityIndicator.startAnimating()
                self.errorLabel.alpha = 0
                self.tableView.alpha = 0
            case let .rows(rows):
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 0
                self.tableView.alpha = 1
                self.displayRows(rows)
            }
        }

        if animated {
            UIView.animate(withDuration: 0.3, animations: action)
        } else {
            action()
        }
    }

    private func displayRows(_ rows: [CoinListCellViewModel]) {
        dataSource = TableDataSource(tableView: tableView, data: rows)
        dataSource?.didSelect = { [weak self] indexPath, vm in
            self?.presenter.didSelect(coin: vm)
            self?.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    private var dataSource: TableDataSource<CoinListCell, CoinListCellViewModel>?
}
