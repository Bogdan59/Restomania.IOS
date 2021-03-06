//
//  DishModalSelectAddings.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalSelectAddings: UITableViewCell {

    public static func create(for addings: [Adding], from menu: ParsedMenu, with delegate: DishModalDelegate) -> DishModalSelectAddings {

        let nibname = String.tag(DishModalSelectAddings.self)
        let cell: DishModalSelectAddings = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.setup(for: addings, from: menu)
        cell.delegate = delegate
        cell.initialize()

        return cell
    }

    //UI
    @IBOutlet private weak var addingsTable: UITableView!
    private var countTableHeight: Bool = false

    //Data
    private var addings: [ParsedDish] = []
    private var menu: ParsedMenu!
    private var delegate: DishModalDelegate?
    private var refreshTrigger: Trigger?

    public override func awakeFromNib() {
        super.awakeFromNib()

        addingsTable.delegate = self
        addingsTable.dataSource = self
        addingsTable.rowHeight = UITableViewAutomaticDimension
        addingsTable.estimatedRowHeight = 45.0

        DishModalSelectAddingsCell.register(in: addingsTable)
    }

    private func setup(for addings: [Adding], from menu: ParsedMenu) {

        let orderedDishes = menu.dishes.ordered
        for adding in addings.ordered {

            if let dishId = adding.addedDishId,
                let dish = orderedDishes.find({ $0.id == dishId }) {
                    self.addings.append(dish)

            } else if let categoryId = adding.addedCategoryId {
                for dish in orderedDishes.filter({ $0.categoryId == categoryId }) {
                    self.addings.append(dish)
                }
            }
        }

        self.menu = menu
        addingsTable.reloadData()
    }
    private func initialize() {

        for addingId in delegate?.selectedAddingsIds ?? [] {
            if let index = addings.index(where: { $0.id == addingId }) {

                let position = IndexPath(row: index, section: 0)
                if let _ = addingsTable.cellForRow(at: position) {
                    addingsTable.selectRow(at: position, animated: true, scrollPosition: .top)
                }
            }
        }

    }
}

extension DishModalSelectAddings: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.add(adding: addings[indexPath.row])
    }
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        delegate?.remove(adding: addings[indexPath.row])
    }
}
extension DishModalSelectAddings: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addings.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let dish = addings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: DishModalSelectAddingsCell.identifier, for: indexPath) as! DishModalSelectAddingsCell
        cell.setup(dish: dish, with: dish.currency)

        return cell
    }
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if (indexPath.row == (addings.count - 1) && !countTableHeight) {
            refreshTrigger?()
            countTableHeight = true
        }
    }
}
extension DishModalSelectAddings: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(addingsTable.contentSize.height)
    }
    public func addToContainer(handler: @escaping Trigger) {
        self.refreshTrigger = handler
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
