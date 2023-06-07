//
//  CreateWallet.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent

struct CreateWallet: AsyncMigration {
    
    func prepare(on database: Database) async throws {
        try await database.schema(Wallet.schema)
            .id()
            .field(.userId, .int64, .required, .references(User.schema, .id, onDelete: .cascade, onUpdate: .noAction))
            .field(.value, .int, .required)
            .field(.createdAt, .datetime)
            .field(.updatedAt, .datetime)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(Wallet.schema).delete()
    }

}
