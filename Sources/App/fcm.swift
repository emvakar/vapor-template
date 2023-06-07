//
//  fcm.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import FCM
import Vapor

func fcm(_ app: Application) throws {
    guard app.environment != .testing else { return }
    app.fcm.configuration = .envServiceAccountKeyFields
    app.fcm.configuration?.apnsDefaultConfig = FCMApnsConfig(headers: [:], aps: FCMApnsApsObject(sound: "default"))
    app.fcm.configuration?.androidDefaultConfig = FCMAndroidConfig(ttl: "86400s", restricted_package_name: "com.example.myapp", notification: FCMAndroidNotification(sound: "default"))
    app.fcm.configuration?.webpushDefaultConfig = FCMWebpushConfig(headers: [:], data: [:], notification: [:])
}
