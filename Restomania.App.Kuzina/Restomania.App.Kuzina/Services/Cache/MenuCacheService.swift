//
//  MenuCacheService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 26.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class MenuCacheService {

    public let tag = String.tag(MenuCacheService.self)

    private let api = ApiServices.Menu.summaries
    private let apiQueue: AsyncQueue
    private let adapter: CacheAdapter<MenuSummary>

    public init() {
        apiQueue = AsyncQueue.createForApi(for: tag)
        adapter = CacheAdapter<MenuSummary>(tag: tag,
                                            filename: "menues-summaries.json",
                                            livetime: 24 * 60 * 60,
                                           freshtime: 10 * 60,
                                   needSaveFreshDate: true)
    }
    public func load() {
        adapter.loadCached()
    }

    //Local
    public var cache: CacheAdapterExtender<MenuSummary> {
        return adapter.extender
    }
    public func findLocal(by placeId: Long, summary: PlaceSummary?) -> MenuSummary? {

        if let summary = summary {
            return cache.find(summary.menuId)
        } else {
            return cache.find({ $0.placeID == placeId })
        }
    }

    //Remote
    public func find(_ placeId: Long) -> RequestResult<MenuSummary> {

        return RequestResult<MenuSummary> { handler in

            let request = self.api.find(placeID: placeId)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                }

                handler(response)
            }
        }
    }
    public func range(_ placeIds: [Long]) -> RequestResult<[MenuSummary]> {

        return RequestResult<[MenuSummary]> { handler in

            let request = self.api.range(placeIDs: placeIds)
            request.async(self.apiQueue) { response in

                if (response.isSuccess) {
                    self.adapter.addOrUpdate(response.data!)
                    self.adapter.clearOldCached()
                }

                handler(response)
            }
        }
    }
}