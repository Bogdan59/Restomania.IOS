//
//  InterfaceLoader.swift
//  IOS Library
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit

public class InterfaceLoader {

    private let _parent: UIView
    private let _overlay: UIView
    private let _indicator: UIActivityIndicatorView

    public init(for parent: UIView) {

        _parent = parent
        _overlay = UIView(frame: UIScreen.main.bounds)
        _overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.55)

        _indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        _indicator.center = _overlay.center

        _overlay.addSubview(_indicator)
    }

    public func show() {

        _indicator.startAnimating()
        _parent.addSubview(_overlay)
    }
    public func hide() {

        _indicator.stopAnimating()
        _overlay.removeFromSuperview()
    }
}