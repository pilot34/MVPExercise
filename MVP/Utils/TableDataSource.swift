//
//  TableDataSource.swift
//  MVP
//
//  Created by  Gleb Tarasov on 18/09/2018.
//  Copyright © 2018 Gleb Tarasov. All rights reserved.
//

import UIKit

protocol Cell {
    associatedtype Data
    func update(data: Data)
}

extension Cell {
    static var cellIdentifier: String {
        return String(describing: self)
    }
}

class TableDataSource<CellType, DataType>: NSObject,
                                           UITableViewDelegate,
                                           UITableViewDataSource
                                           where CellType: Cell,
                                                 CellType: UITableViewCell,
                                                 CellType.Data == DataType {
    init(tableView: UITableView, data: [DataType]) {
        self.data = data
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    private let data: [DataType]

    var didSelect: (IndexPath, DataType) -> Void = { _, _ in }

    // MARK: - UITableViewDataSource & UITableViewDelegate

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellType.cellIdentifier,
                                                       for: indexPath) as? CellType else {
            fatalError("wrong cell type")
        }

        cell.update(data: data[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = data[indexPath.row]
        didSelect(indexPath, item)
    }
}
