//
//  CreateUserRoles.swift
//  Market
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent

struct CreateUserRoles: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        var enumBuilder = database.enum(Role.schema)
        for option in Role.allCases {
            enumBuilder = enumBuilder.case(option.rawValue)
        }
        _ = try await enumBuilder.create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Role.schema).delete()
    }

}
