//
//  PlaceCartTotalContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 08.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceCartTotalContainer: UITableViewCell {

    private static let nibName = "PlaceCartTotalContainerView"
    public static func create(with delegate: PlaceCartDelegate) -> PlaceCartTotalContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let cell = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceCartTotalContainer

        cell.delegate = delegate
        cell.cells = loadRows(delegate)
        cell.setupMarkup()

        return cell
    }
    private static func loadRows(_ delegate: PlaceCartDelegate) -> [PlaceCartContainerCell] {

        var result = [InterfaceTableCellProtocol]()

//        result.append()
        result.append(PlaceCartTotalContainerCell.create(for: "Итого", with: delegate))

        return result
    }

    //UI hooks
    @IBOutlet private weak var rowsTable: UITableView!

    //Service
    private var contentAdapter: InterfaceTable?

    //Data
    private let _tag = String.tag(PlaceCartTotalContainer.self)
    private let guid = Guid.new
    private var delegate: PlaceCartDelegate!  {
        didSet {
            reload()
        }
    }
    private var cart: Cart {
        return delegate.takeCart()
    }
    private var menu: MenuSummary? {
        return delegate.takeMenu()
    }
    private var cells: [PlaceCartContainerCell] = []

    private func reload() {

    }
    private func setupMarkup() {

        contentAdapter = InterfaceTable(source: rowsTable, navigator: UINavigationController(), rows: cells)
    }
}
extension PlaceCartTotalContainer: CartUpdateProtocol {
    public func cart(_ cart: Cart, changedDish: Dish, newCount: Int) {
        reload()
    }
    public func cart(_ cart: Cart, removedDish: Long) {
        reload()
    }
    
}
extension PlaceCartTotalContainer: PlaceCartContainerCell {

    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func updateData(with: PlaceCartDelegate) {
        reload()
    }

    private func trigger(_ action: ((PlaceCartContainerCell) -> Void)) {

        for cell in cells {
            action(cell)
        }
    }
}
extension PlaceCartTotalContainer: InterfaceTableCellProtocol {

    public var viewHeight: Int {
        return 200
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
