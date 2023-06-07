//
//  Role.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor
import Fluent

enum Role: String, Content, Codable, CaseIterable {

    static let schema = "roles"

    case user
    case premium_user
    case seller
    case premium_seller
    case moderator
    case admin

}
