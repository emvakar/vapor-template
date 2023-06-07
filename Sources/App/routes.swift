//
//  routes.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {

    let controllers: [RouteCollection] =
    [
        UserController(),
    ]

    for controller in controllers {
        try app.routes.register(collection: controller)
    }
    
}
