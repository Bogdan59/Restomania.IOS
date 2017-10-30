//
//  SearchPlaceCard.swift
//  FindMe
//
//  Created by Алексей on 25.09.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import Gloss

public class SearchPlaceCard: ICached {
    
    public struct Keys {
        
        public static let id = "ID"
        public static let name = "Name"
        public static let type = "Type"
        public static let description = "Description"
        
        public static let image = "Image"
        public static let location = "Location"
        public static let peopleCount = "PeopleCount"
    }
    
    public var ID: Long
    public var name: String
    public var type: String
    public var description: String
    public var image: String
    public var location: Location
    public var peopleCount: Long
    
    public init() {
        
        ID = 0
        name = String.empty
        type = String.empty
        description = String.empty
        image = String.empty
        location = Location()
        peopleCount = 0
    }
    public init(source: Place) {

        ID = source.ID
        name = source.name
        type = source.type
        description = source.description
        image = source.images.first?.link ?? String.empty
        location = source.location
        peopleCount = source.clientsData.people
    }
    
    //MARK: ICopyng
    public required init(source: SearchPlaceCard) {
        
        ID = source.ID
        name = source.name
        type = source.type
        description = source.description
        image = source.image
        location = Location(source: source.location)
        peopleCount = source.peopleCount
    }
    
    //MARK: Glossy
    public required init?(json: JSON) {
        
        self.ID = (Keys.id <~~ json)!
        self.name = (Keys.name <~~ json)!
        self.type = (Keys.type <~~ json)!
        self.description = (Keys.description <~~ json)!
        self.image = (Keys.image <~~ json)!
        self.location = (Keys.location <~~ json)!
        self.peopleCount = (Keys.peopleCount <~~ json)!
    }
    public func toJSON() -> JSON? {
    
        return jsonify([
            
            Keys.id ~~> self.ID,
            Keys.name ~~> self.name,
            Keys.type ~~> self.type,
            Keys.description ~~> self.description,
            Keys.image ~~> self.image,
            Keys.location ~~> self.location,
            Keys.peopleCount ~~> self.peopleCount,
            ])
    }
}
