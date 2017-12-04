//
//  ServicesManager.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 22.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class ServicesManager: ILoggable {

    public static var shared: ServicesManager!
    public class func initialize() {
        shared = ServicesManager()
        Log.Info(shared.tag, "Complete load manager.")
    }

    public var tag: String {
        return "ServicesManager"
    }

    public let keys: KeysStorage
    public let placeSummariesService: CachePlaceSummariesService
    public let menuSummariesService: CacheMenuSummariesService
    public let paymentCards: CachePaymentCardsService
    public let images: CacheImagesService
    public let cartsService: CartService

    public init() {

        keys = KeysStorage()
        placeSummariesService = CachePlaceSummariesService()
        menuSummariesService = CacheMenuSummariesService()
        paymentCards = CachePaymentCardsService(keys: keys)
        images = CacheImagesService()
        cartsService = CartService()
    }

    public func refreshData() {

    }
}
