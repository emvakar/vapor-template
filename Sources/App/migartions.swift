//
//  migrations.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor
import FluentPostgresDriver

func migrations(_ app: Application) throws {

    if (app.environment == .development || app.environment == .testing), let postgres = app.db as? PostgresDatabase {
        try app.autoRevert().wait()
        _ = try postgres.simpleQuery("drop schema public cascade").wait()
        _ = try postgres.simpleQuery("create schema public").wait()
    }

    app.migrations.add(CreateUserRoles())
    app.migrations.add(CreateUser())
    app.migrations.add(CreateWallet())

    try app.autoMigrate().wait()

}

