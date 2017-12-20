//
//  DevicesOpenApiService.swift
//  Restomania.App.Kuzina
//
//  Created by Алексей on 18.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask

public class NotificationsDevicesApiService: BaseApiService {

    public init(configs: ConfigsStorage, keys: KeysStorage) {
        super.init(area: "Notifications/Devices", type: NotificationsDevicesApiService.self, configs: configs, keys: keys)
    }

    public func Register(role: ApiRole, token: String, locale: String) -> RequestResult<Device> {
        let parameters = CollectParameters(for: role, [
                "token": token,
                "platform": NotificationPlatformType.apple.rawValue,
                "locale": locale
            ])

        return client.Post(action: "Register", type: Device.self, parameters: parameters)
    }
}
