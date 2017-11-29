//
//  RefreshDataManager.swift
//  FindMe
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import UIKit
import IOSLibrary

public class RefreshDataManager {

    private static var _instance: RefreshDataManager?
    public static var shared: RefreshDataManager {

        if (nil == _instance) {

            _instance = RefreshDataManager();
        }

        return _instance!
    }


    private let _tag = String.tag(RefreshDataManager.self)
    private let _application = UIApplication.shared

    private let _cards: SearchPlaceCardsCacheService
    private let _places: PlacesCacheService

    private init() {

        self._cards = CacheServices.searchCards
        self._places = CacheServices.places
    }


    //#MARK: Methods
    public func launch() {

        registerHooks()
        refreshUserData()
    }
    private func registerHooks() {

        _application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    }
    private func refreshUserData() {

        LogicServices.shared.likes.takeFromRemote()
    }


    public func refreshData(with completeHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        let completer = Completer.init(limit: 1, complete: { results in

            var success = false

            for (_, result) in results {
                success = success || result
            }

            if (success) {
                completeHandler(.newData)
            }
            else {
                completeHandler(.failed)
            }
        });

        let cards = _cards.refresh()
        cards.async(.background, completion: completer.ender())

    }
}
private class Completer {

    private let limit: Int
    private var completeCount: Int
    private var results: [Int: Bool]
    private let complete: (([Int: Bool]) -> Void)

    public init(limit: Int, complete: @escaping (([Int: Bool]) -> Void)) {

        self.limit = limit
        self.completeCount = 0
        self.results = [:]
        self.complete = complete
    }

    public func ender() -> ((Bool) -> Void) {
        return { result in

            self.completeCount += 1
            self.results[self.completeCount] = result

            if (self.completeCount == self.limit) {
                self.complete(self.results)
            }
        }
    }
}
