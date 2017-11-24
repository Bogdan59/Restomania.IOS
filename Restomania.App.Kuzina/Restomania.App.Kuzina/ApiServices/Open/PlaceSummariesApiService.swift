//
//  OpenPlaceSummariesApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 20.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary

public class PlaceSummariesApiService: BaseApiService {

    public init() {
        super.init(area: "Place/Summaries", tag: String.tag(PlaceSummariesApiService.self))
    }

    public func Range(placeIDs: [Long]) -> RequestResult<[PlaceSummary]> {
        let parameters = CollectParameters([
            "placeIDs": placeIDs
            ])

        return _client.GetRange(action: "Range", type: PlaceSummary.self, parameters: parameters)
    }
}