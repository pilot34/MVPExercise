//
//  TickerViewController.swift
//  MVP
//
//  Created by  Gleb Tarasov on 19/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit

protocol TickerViewControllerProtocol: class {
    func update(_ state: TickerPresenter.State, animated: Bool)
}

class TickerViewController: UIViewController, TickerViewControllerProtocol {

    var presenter: TickerPresenterProtocol!

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(close))
        presenter.onViewDidLoad()
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

    func update(_ state: TickerPresenter.State, animated: Bool) {
        let before: () -> Void
        let animation: () -> Void

        switch state {
        case let .error(error):
            before = {
                self.errorLabel.text = error
            }
            animation = {
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 1
                self.textView.alpha = 0
            }
        case .loading:
            before = { }
            animation = {
                self.activityIndicator.startAnimating()
                self.errorLabel.alpha = 0
                self.textView.alpha = 0
            }
        case let .ticker(ticker):
            before = {
                self.displayTicker(ticker)
            }
            animation = {
                self.activityIndicator.stopAnimating()
                self.errorLabel.alpha = 0
                self.textView.alpha = 1
            }
        }

        before()
        if animated {
            UIView.animate(withDuration: 0.3, animations: animation)
        } else {
            animation()
        }
    }

    private func attributedString(forName name: String) -> NSAttributedString {
        return NSAttributedString(string: "\(name):\n", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 17)
            ])
    }

    private func attributedString(forValue value: String) -> NSAttributedString {
        return NSAttributedString(string: "\(value)\n\n", attributes: [
            .font: UIFont.systemFont(ofSize: 17)
            ])
    }

    private func attributedString(for attr: TickerAttribute) -> NSAttributedString {
        let nameStr = attributedString(forName: attr.name)
        let valStr = attributedString(forValue: attr.value)
        let result = NSMutableAttributedString()
        result.append(nameStr)
        result.append(valStr)
        return result
    }

    private func attributedString(for attrs: [TickerAttribute]) -> NSAttributedString {
        let attrStrs = attrs.map { self.attributedString(for: $0) }
        let result = NSMutableAttributedString()
        attrStrs.forEach { result.append($0) }
        return result
    }

    private func displayTicker(_ ticker: TickerViewModel) {
        let attr = attributedString(for: ticker.attributes)
        textView.attributedText = attr
    }
}
