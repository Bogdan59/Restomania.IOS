//
//  PlaceMenuMenuContainer.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class PlaceMenuMenuContainer: UITableViewCell {

    private static let nibName = "PlaceMenuMenuContainerView"
    public static func create(with controller: PlaceMenuController) -> PlaceMenuMenuContainer {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuMenuContainer

        instance._menu = nil
        instance._delegate = controller
        instance._controller = controller
        instance._cart = instance._delegate.cart

        instance._categoriesAdapter = CategoriesCollection(for: instance.categoriesStack, with: instance)
        instance._dishesAdapter = DishesAdapter(for: instance.dishesTable, with: instance)

        instance.setupMarkup()

        return instance
    }

    //UI elements
    @IBOutlet private weak var categoriesStack: UICollectionView!
    @IBOutlet private weak var dishesTable: UITableView!
    private var _categoriesAdapter: CategoriesCollection!
    private var _dishesAdapter: DishesAdapter!

    //Data & services
    private var _menu: MenuSummary? {
        didSet {
            if let menu = _menu {
                apply(menu)
            }
        }
    }
    private let _tag = String.tag(PlaceMenuMenuContainer.self)
    private let _guid = Guid.new
    private var _delegate: PlaceMenuDelegate!
    private var _controller: UIViewController!
    private var _cart: Cart!

    private func apply(_ menu: MenuSummary) {

        let allCategory = MenuCategory()
        allCategory.name = "Всё"
        allCategory.ID = -1
        allCategory.orderNumber = -1

        _categoriesAdapter.update(range: [allCategory] + menu.categories)
        _dishesAdapter.update(range: menu.dishes, currency: menu.currency)
    }
    private func setupMarkup() {

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: BottomActions.height, right: 0.0)
        dishesTable.contentInset = contentInsets
        dishesTable.scrollIndicatorInsets = contentInsets
    }

    // MARK: Methods
    public func setScroll(_ offset: CGFloat, animated: Bool = false) {
        dishesTable.setContentOffset(CGPoint(x: 0, y: offset), animated: animated)
    }
    public func disableScroll() {
        dishesTable.bounces = false
        dishesTable.alwaysBounceVertical = false
        dishesTable.isScrollEnabled = false

        setScroll(0)
    }
    public func enableScroll() {
        dishesTable.bounces = true
        dishesTable.alwaysBounceVertical = true
        dishesTable.isScrollEnabled = true
    }
}

// MARK: Protocols
extension PlaceMenuMenuContainer: PlaceMenuDelegate {
    public var summary: PlaceSummary? {
        return _delegate.summary
    }
    public var menu: MenuSummary? {
        return _delegate.menu
    }
    public var cart: Cart {
        return _cart
    }

    public func add(dish: Long) {
        _delegate.add(dish: dish)
    }

    public func select(category: Long) {

        if (-1 == category) {
            _dishesAdapter.filter(by: nil)
        } else {

            _dishesAdapter.filter(by: category)
        }

        if (!dishesTable.visibleCells.isEmpty) {
            dishesTable.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    public func select(dish: Long) {}
    public func scrollTo(offset: CGFloat) {
        _delegate.scrollTo(offset: offset)
    }

    public func goToCart() {
        _delegate.goToCart()
    }
}
extension PlaceMenuMenuContainer: PlaceMenuCellsProtocol {
    public func viewDidAppear() {
        _cart.subscribe(guid: _guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        _dishesAdapter.clear()
        _cart.unsubscribe(guid: _guid)
    }
    public func dataDidLoad(delegate: PlaceMenuDelegate) {
        _menu = delegate.menu
    }
}
extension PlaceMenuMenuContainer: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        return Int(self._controller.view.frame.height) - 64 //44 - UINavigationBar.height, 20 - statusBarOffset
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
extension PlaceMenuMenuContainer: CartUpdateProtocol {
    public func cart(_ cart: Cart, changedDish dishId: Long, newCount: Int) {
        updateButtonOffset()
    }
    public func cart(_ cart: Cart, removedDish dishId: Long) {
        updateButtonOffset()
    }
    private func updateButtonOffset() {

        var offset = BottomActions.height

        if (_cart.isEmpty) {
            offset = CGFloat(0)
        }

        dishesTable.setParentContraint(.bottom, to: offset)
    }
}

// MARK: Adapters
// MARK: Categories
extension PlaceMenuMenuContainer {
    private class CategoriesCollection: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

        private let _collection: UICollectionView
        private let _delegate: PlaceMenuDelegate
        private var _categories: [MenuCategory]
        private var _selectedCategory: Long = -1

        public init(for collection: UICollectionView, with delegate: PlaceMenuDelegate) {

            _collection = collection
            _delegate = delegate
            _categories = [MenuCategory]()

            super.init()

            PlaceMenuCategoryCell.register(in: _collection)
            _collection.dataSource = self
            _collection.delegate = self
        }

        // MARK: Interface
        public func select(category: Long) {

            selectAndNotify(about: category)
            reload()
        }
        public func update(range: [MenuCategory]) {

            _categories = range.sorted(by: { $0.orderNumber < $1.orderNumber })
            if (!_categories.isEmpty) {
                _selectedCategory = _categories.first!.ID
            }

            selectAndNotify(about: _selectedCategory)
            reload()
        }
        private func reload() {
            _collection.reloadData()
        }

        // MARK: UICollectionViewDataSource
        public func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return _categories.count
        }
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let category = _categories[indexPath.row]
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: PlaceMenuCategoryCell.identifier, for: indexPath) as! PlaceMenuCategoryCell
            cell.update(by: category)

            if (_selectedCategory == category.ID) {
                cell.select()
            } else {
                cell.deselect()
            }

            return cell
        }

        // MARK: UICollectionViewDelegateFlowLayout
        public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return PlaceMenuCategoryCell.sizeOfCell(category: _categories[indexPath.row])
        }
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

            for cell in _collection.visibleCells {
                if let cell = cell as? PlaceMenuCategoryCell {
                    cell.deselect()
                }
            }

            let cell = collectionView.cellForItem(at: indexPath) as! PlaceMenuCategoryCell
            cell.select()

            let category = _categories[indexPath.row]
            selectAndNotify(about: category.ID)
        }
        private func selectAndNotify(about category: Long) {

            _selectedCategory = category
            _delegate.select(category: category)

            if (!_collection.visibleCells.isEmpty) {
                let index = _categories.index(where: { $0.ID == category }) ?? 0
                _collection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
}
// MARK: Dishes
extension PlaceMenuMenuContainer {
    private class DishesAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {

        private let _table: UITableView
        private let _delegate: PlaceMenuDelegate

        private var _dishes: [Dish]
        private var _filtered: [Dish]
        private var _categoryId: Long?

        private var _cells: [Long : PlaceMenuDishCell]
        private var _currency: CurrencyType

        public init(for table: UITableView, with delegate: PlaceMenuDelegate) {

            _table = table
            _delegate = delegate

            _dishes = [Dish]()
            _filtered = [Dish]()
            _categoryId = nil

            _cells = [Long: PlaceMenuDishCell]()
            _currency = .All

            super.init()

            _table.delegate = self
            _table.dataSource = self
        }

        // MARK: Interface
        public func update(range: [Dish], currency: CurrencyType) {

            _dishes = range.sorted(by: { $0.orderNumber < $1.orderNumber  })
            _currency = currency

            reload()
        }
        public func filter(by categoryId: Long?) {

            _categoryId = categoryId
            reload()
        }
        public func reload() {

            if let categoryId = _categoryId {
                _filtered = _dishes.filter({ categoryId == $0.categoryId })
            } else {
                _filtered = _dishes
            }

            _table.reloadData()
        }
        public func clear() {
            _cells.removeAll()
        }

        // MARK: UITableViewDataSource
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return _filtered.count
        }
        public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return PlaceMenuDishCell.height
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let dish = _filtered[indexPath.row]
            if nil == _cells[dish.ID] {
                _cells[dish.ID] = PlaceMenuDishCell.instance(for: dish, with: _currency, delegate: _delegate)
            }

            return _cells[dish.ID]!
        }

        // MARK: UITableViewDelegate
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)

            _delegate.select(dish: _filtered[indexPath.row].ID)
        }

        // MARK: UIScrroolViewDelegate
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            _delegate.scrollTo(offset: scrollView.contentOffset.y )
        }
    }
}