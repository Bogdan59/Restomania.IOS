//
//  TabBarController.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 21.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import UIKit

public class TabBarController: UITabBarController {
    public override func viewDidLoad() {
        super.viewDidLoad()

        print(String.init(describing: self.navigationController))
    }
}
