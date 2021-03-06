//
//  DishModalShortDivider.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import MdsKit

public class DishModalShortDivider: UITableViewCell {

    public static func create(for content: InterfaceTableCellProtocol) -> DishModalShortDivider {

        let nibname = String.tag(DishModalShortDivider.self)
        let cell: DishModalShortDivider = UINib.instantiate(from: nibname, bundle: Bundle.coreFramework)
        cell.content = content

        return cell
    }

    //UI
    @IBOutlet private var dividerView: UIView!

    private let themeColors = DependencyResolver.get(ThemeColors.self)
    private let themeFonts = DependencyResolver.get(ThemeFonts.self)

    //Data
    private var content: InterfaceTableCellProtocol?

    public override func awakeFromNib() {
        super.awakeFromNib()

        dividerView.backgroundColor = themeColors.divider
    }
}
extension DishModalShortDivider: DishModalElementProtocol {
}
extension DishModalShortDivider: InterfaceTableCellProtocol {
    public var viewHeight: Int {
        if (content?.viewHeight == 0) {
            return 0
        } else {
            return 11
        }
    }
    public func prepareView() -> UITableViewCell {
        return self
    }
}
