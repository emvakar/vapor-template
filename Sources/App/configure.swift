//
//  configure.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent
import FluentPostgresDriver
import Vapor
import FJWTMiddleware

// configures your application
public func configure(_ app: Application) throws {

    defer {
        if let serverName = app.http.server.configuration.serverName {
            app.logger.notice("\(serverName) started")
        } else {
            app.logger.notice("UNKNOWN started")
        }
    }

    app.routes.defaultMaxBodySize = "1mb"
    app.http.server.configuration.serverName = Environment.get(.SERVER_NAME)
    app.http.server.configuration.address = .hostname("0.0.0.0", port: Environment.get(.HTTP_PORT).flatMap(Int.init(_:)))
    app.http.server.configuration.port = Environment.get(.HTTP_PORT).flatMap(Int.init(_:)) ?? 8080
    app.firebaseJwt.applicationIdentifier = Environment.get(.FCM_PROJECT_ID)

    try fcm(app)
    try database(app)
    try migrations(app)
    try routes(app)
    

    let fileMiddleware = FileMiddleware(publicDirectory: app.directory.publicDirectory)
    app.middleware.use(fileMiddleware)


}
