//
//  AddDishToCartModalDelegateProtocol.swift
//  CoreFramework
//
//  Created by Алексей on 31.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public protocol AddDishToCartModalDelegateProtocol: DishModalDelegateProtocol {

    var count: Int { get set }
    func add(adding: Dish)
    func remove(adding: Dish)

    func select(variation: Variation)
}