//
//  SearchCardsCacheService.swift
//  FindMe
//
//  Created by Алексей on 27.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class SearchPlaceCardsCacheService {

    private let tag = String.tag(SearchPlaceCardsCacheService.self)
    private let client = ApiServices.Places.searchCards
    private let properties: PropertiesStorage<PropertiesKey>
    private let adapter: CacheAdapter<SearchPlaceCard>
    private let apiQueue: AsyncQueue

    //MARK: Cached processing
    public var cache: CacheAdapterExtender<SearchPlaceCard> {
        return adapter.extender
    }


    public init(properties: PropertiesStorage<PropertiesKey>) {

        self.properties = properties
        self.adapter = CacheAdapter<SearchPlaceCard>(tag: tag, filename: "places-search-cards.json", livetime: 24 * 60 * 60)
        self.apiQueue = AsyncQueue.createForApi(for: tag)

        Log.debug(tag, "Complete load service.")
    }

    public func load() {
        adapter.loadCached()
    }


    //MARK: Remote
    public func all(with parameters: SelectParameters, in towns: [Long]? = nil) -> Task<ApiResponse<[SearchPlaceCard]>> {

        return Task { (handler: @escaping (ApiResponse<[SearchPlaceCard]>) -> Void) in

            Log.debug(self.tag, "Request all places' cards.")

            let request = self.client.all(with: parameters, towns: towns)
            request.async(self.apiQueue, completion: { response in

                if response.isFail {
                    handler(response)
                    Log.warning(self.tag, "Problem with request all search cards.")

                }
                else if let update = response.data {

                    self.adapter.addOrUpdate(update)
                    self.adapter.clearOldCached()
                    handler(response)
                    Log.debug(self.tag, "Complete request all.")
                }
            })
        }
    }
    public func refresh() -> Task<Bool> {

        return Task<Bool>.init(action: { handler in

            Log.debug(self.tag, "Try refresh data.")

            let places = self.cache.all.map{ $0.ID }
            if (places.isEmpty) {
                handler(true)
                return
            }

            let request = self.client.range(for: places)
            request.async(self.apiQueue, completion: { response in

                if (response.isFail) {
                    if (response.statusCode != .ConnectionError) {

                        Log.warning(self.tag, "Problem with refresh data.")
                        handler(false)
                    }

                }
                else if let update = response.data {
                    
                    Log.info(self.tag, "Complete refresh data.")

                    self.adapter.clear()
                    self.adapter.addOrUpdate(update)
                }

                handler(true)
            })

        })
    }
}
