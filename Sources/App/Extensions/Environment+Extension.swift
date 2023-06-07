//
//  Environment+Extension.swift
//  Template
//
//  Created by Emil Karimov on 7.06.2023
//  Copyright © 2023 Emil Karimov. All rights reserved.
//

import Vapor

enum EnvKeys: String {
    case USED_ENV
    case SERVER_NAME
    case HTTP_PORT
    case HTTP_HOSTNAME
    case DATABASE_HOSTNAME
    case DATABASE_PORT
    case DATABASE_USERNAME
    case DATABASE_NAME
    case DATABASE_PASSWORD
    case WORKING_DIRECTORY
    case FCM_EMAIL
    case FCM_PROJECT_ID
    case FCM_PRIVATE_KEY
}

extension Environment {
    
    static func get(_ key: EnvKeys) -> String? {
        return Environment.get(key.rawValue)
    }
    
}
