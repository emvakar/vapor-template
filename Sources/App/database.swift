//
//  database.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor
import FluentPostgresDriver
import PostgresKit

func database(_ app: Application) throws {

    let dbCofig = SQLPostgresConfiguration(hostname: Environment.get(.DATABASE_HOSTNAME) ?? "localhost",
                                           port: Environment.get(.DATABASE_PORT).flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
                                           username: Environment.get(.DATABASE_USERNAME) ?? "template",
                                           password: Environment.get(.DATABASE_PASSWORD) ?? "template",
                                           database: Environment.get(.DATABASE_NAME) ?? "template",
                                           tls: .disable)

    let factory = DatabaseConfigurationFactory.postgres(configuration: dbCofig, sqlLogLevel: .error)

    app.databases.use(factory, as: .psql, isDefault: true)

}
