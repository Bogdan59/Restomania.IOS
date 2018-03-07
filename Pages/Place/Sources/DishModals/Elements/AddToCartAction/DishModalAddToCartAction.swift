//
//  DishModalAddToCartAction.swift
//  RestomaniaAppKuzina
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit
import CoreTools
import CoreDomains
import UITools
import UIElements
import Localization

public class DishModalAddToCartAction: UIView {

    //UI
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var totalLabel: PriceLabel!

    private let themeColors = DependencyResolver.resolve(ThemeColors.self)
    private let themeFonts = DependencyResolver.resolve(ThemeFonts.self)

    //Data
    private var delegate: AddDishToCartModalDelegateProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = themeColors.contentBackground
        Bundle.main.loadNibNamed("\(String.tag(DishModalAddToCartAction.self))View", owner: self, options: nil)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.backgroundColor = themeColors.actionMain
        self.addSubview(contentView)

        actionLabel.font = themeFonts.default(size: .title)
        actionLabel.textColor = themeColors.actionContent
        actionLabel.text = Localization.DishModals.buttonsAddToCart.localized

        totalLabel.font = themeFonts.bold(size: .head)
        totalLabel.textColor = themeColors.actionContent
        totalLabel.isHidden = true
    }

    public func link(with delegate: AddDishToCartModalDelegateProtocol) {
        self.delegate = delegate
    }
    public func refresh(total: Price, with currency: Currency) {

        totalLabel.isHidden = total.minorFormat == 0
        totalLabel.setup(price: total, currency: currency)
    }

    @IBAction private func addToCart() {
        delegate?.addToCart()
    }
}
