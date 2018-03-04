//
//  PlaceMenuCartAction.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 07.11.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import CoreDomains
import CoreApiServices
import CoreStorageServices
import UITools
import UIElements

public class PlaceMenuCartAction: UIView {

    private static let nibName = "PlaceMenuCartActionView"
    public static func create(with delegate: PlaceMenuDelegate) -> PlaceMenuCartAction {

        let nib = UINib(nibName: nibName, bundle: Bundle.main)
        let instance = nib.instantiate(withOwner: nil, options: nil).first! as! PlaceMenuCartAction

        instance.delegate = delegate
        instance.menu = delegate.takeMenu()
        instance.cart = delegate.takeCart()

        instance.apply()

        return instance
    }

    //UI elements
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!
    @IBAction private func goToCart() {
        delegate.goToCart()
    }

    private let colorsTheme = DependencyResolver.resolve(ThemeColors.self)
    private let fontsTheme = DependencyResolver.resolve(ThemeFonts.self)

    //Data & services
    private let _tag = String.tag(PlaceMenuCartAction.self)
    private let guid = Guid.new
    private var currency = CurrencyType.All
    private var delegate: PlaceMenuDelegate!
    private var menu: MenuSummary? {
        didSet {
            if let menu = menu {
                currency = menu.currency
            }
        }
    }
    private var cart: CartService!

    public func viewDidAppear() {
        cart.subscribe(guid: guid, handler: self, tag: _tag)
    }
    public func viewDidDisappear() {
        cart.unsubscribe(guid: guid)
    }
    public func update(new menu: MenuSummary) {
        self.menu = menu

        apply()
    }

    private func apply() {

        DispatchQueue.main.async {
            self.countLabel.text = "\(self.cart.dishes.sum({ $0.count }))"

            if let menu = self.menu {
                self.totalLabel.setup(price: self.cart.total(with: menu), currency: self.currency)
            }
        }
    }
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = colorsTheme.actionMain

        countLabel.textColor = colorsTheme.actionContent
        countLabel.font = fontsTheme.default(size: .title)

        titleLabel.text = PlaceMenuController.Keys.ToCart.localized
        titleLabel.textColor = colorsTheme.actionContent
        titleLabel.font = fontsTheme.default(size: .title)

        totalLabel.textColor = colorsTheme.actionContent
        totalLabel.font = fontsTheme.default(size: .head)
    }
}

extension PlaceMenuCartAction: CartServiceDelegate {
    public func cart(_ cart: CartService, change dish: AddedOrderDish) {
        apply()
    }
    public func cart(_ cart: CartService, remove dish: AddedOrderDish) {
        apply()
    }
}
