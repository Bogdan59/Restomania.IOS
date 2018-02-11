//
//  User.swift
//  FindMe
//
//  Created by Алексей on 18.10.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class User: Account {

    public struct Keys {

        public static let image = "Image"
        public static let city = "City"
        public static let sex = "Sex"
        public static let age = "Age"
        public static let status = "Status"
    }

    public let image: String
    public let city: String
    public let sex: UserSex
    public let age: Int
    public let status: UserStatus

    public override init() {

        self.image = String.empty
        self.city = String.empty
        self.sex = .unknown
        self.age = 21
        self.status = .readyForAcquaintance

        super.init()
    }

    //Glossy
    public required init(json: JSON) {

        self.image = (Keys.image <~~ json)!
        self.city = (Keys.city <~~ json)!
        self.sex = (Keys.sex <~~ json)!
        self.age = (Keys.age <~~ json)!
        self.status = (Keys.status <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([
            super.toJSON(),

            Keys.image ~~> self.image,
            Keys.city ~~> self.city,
            Keys.sex ~~> self.sex,
            Keys.age ~~> self.age,
            Keys.status ~~> self.status,
            ])
    }
}
