//
//  CreateUser.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent
import SQLKit

struct CreateUser: AsyncMigration {

    func prepare(on database: Database) async throws {

        let roleType = try await database.enum(Role.schema).read()
        let defaultValue = SQLColumnConstraintAlgorithm.default(Role.user.rawValue)

        try await database.schema(User.schema)
            .field(.id, .int64, .identifier(auto: true))
            .field(.firebaseId, .string, .required).unique(on: .firebaseId)
            .field(.email, .string, .required)
            .field(.username, .string)
            .field(.avatarUrl, .string)
            .field(.role, roleType, .required, .sql(defaultValue))
            .field(.createdAt, .datetime)
            .field(.updatedAt, .datetime)
            .field(.deletedAt, .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(User.schema).delete()
    }

}
