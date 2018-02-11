//
//  SourceChatMessage.swift
//  FindMe
//
//  Created by Алексей on 23.01.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit
import Gloss

public class SourceChatMessage: BaseDataType {

    private struct Keys {
        fileprivate static let senderId = "SenderId"
        fileprivate static let dialogId = "DialogId"
        fileprivate static let content = "Content"
        fileprivate static let attachments = "Attachments"
    }

    public var senderId: Long
    public var dialogId: Long
    public var content: String
    public var attachments: [String]

    public override init() {

        self.senderId = 0
        self.dialogId = 0
        self.content = String.empty
        self.attachments = []

        super.init()
    }
    public init(source: SourceChatMessage) {

        self.senderId = source.senderId
        self.dialogId = source.dialogId
        self.content = source.content
        self.attachments = source.attachments.map{ $0 }

        super.init(source: source)
    }

    //MARK: Glossy
    public required init(json: JSON) {

        self.senderId = (Keys.senderId <~~ json)!
        self.dialogId = (Keys.dialogId <~~ json)!
        self.content = (Keys.content <~~ json)!
        self.attachments = (Keys.attachments <~~ json)!

        super.init(json: json)
    }
    public override func toJSON() -> JSON? {
        return jsonify([

            Keys.senderId ~~> self.senderId,
            Keys.dialogId ~~> self.dialogId,
            Keys.content ~~> self.content,
            Keys.attachments ~~> self.attachments,

            super.toJSON()
            ])
    }
}
