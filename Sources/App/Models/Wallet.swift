//
//  Wallet.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor
import Fluent

final class Wallet: Model, Content {

    static let schema = "wallet"

    @ID()
    var id: UUID?
    
    @Parent(key: .userId)
    var user: User
    
    @Field(key: .value)
    var value: Int
    
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    init() { }
    
    init(id: Wallet.IDValue? = nil, userId: User.IDValue, value: Int) {
        self.$user.id = userId
        self.value = value
    }
    
}
